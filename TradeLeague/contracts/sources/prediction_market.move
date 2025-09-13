module tradeleague::prediction_market {
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use std::timestamp;
    use aptos_framework::event;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_MARKET_NOT_FOUND: u64 = 2;
    const E_MARKET_EXPIRED: u64 = 3;
    const E_MARKET_RESOLVED: u64 = 4;
    const E_INVALID_OUTCOME: u64 = 5;
    const E_INSUFFICIENT_FUNDS: u64 = 6;
    const E_INVALID_AMOUNT: u64 = 7;
    const E_ALREADY_RESOLVED: u64 = 8;
    const E_NOT_RESOLVED: u64 = 9;

    struct PredictionMarket has key, store {
        id: u64,
        sponsor: address,
        sponsor_name: String,
        question: String,
        outcomes: vector<String>,
        stakes: vector<u64>, // Total staked on each outcome
        resolution_time: u64,
        oracle_source: String,
        resolved: bool,
        winning_outcome: u64,
        total_pool: u64,
        created_at: u64,
    }

    struct UserPrediction has key, store {
        market_id: u64,
        outcome_index: u64,
        stake: u64,
        potential_payout: u64,
        placed_at: u64,
        claimed: bool,
    }

    struct MarketRegistry has key {
        markets: vector<PredictionMarket>,
        next_market_id: u64,
        total_markets: u64,
    }

    struct UserPredictions has key {
        predictions: vector<UserPrediction>,
        total_staked: u64,
        total_winnings: u64,
    }

    /// Events
    struct MarketCreatedEvent has drop, store {
        market_id: u64,
        sponsor: address,
        question: String,
        outcomes: vector<String>,
        resolution_time: u64,
    }

    struct PredictionPlacedEvent has drop, store {
        market_id: u64,
        user: address,
        outcome_index: u64,
        stake: u64,
        timestamp: u64,
    }

    struct MarketResolvedEvent has drop, store {
        market_id: u64,
        winning_outcome: u64,
        total_pool: u64,
        resolution_time: u64,
    }

    struct WinningsClaimedEvent has drop, store {
        market_id: u64,
        user: address,
        payout: u64,
        timestamp: u64,
    }

    fun init_module(account: &signer) {
        let registry = MarketRegistry {
            markets: vector::empty<PredictionMarket>(),
            next_market_id: 1,
            total_markets: 0,
        };
        move_to(account, registry);
    }

    public entry fun create_market(
        sponsor: &signer,
        sponsor_name: String,
        question: String,
        outcomes: vector<String>,
        resolution_time: u64,
        oracle_source: String,
    ) acquires MarketRegistry {
        let sponsor_addr = signer::address_of(sponsor);
        
        // Validate inputs
        assert!(vector::length(&outcomes) >= 2, E_INVALID_OUTCOME);
        assert!(resolution_time > timestamp::now_seconds(), E_MARKET_EXPIRED);

        let registry = borrow_global_mut<MarketRegistry>(@tradeleague);
        let market_id = registry.next_market_id;
        
        // Initialize stakes vector with zeros
        let stakes = vector::empty<u64>();
        let i = 0;
        while (i < vector::length(&outcomes)) {
            vector::push_back(&mut stakes, 0);
            i = i + 1;
        };

        let market = PredictionMarket {
            id: market_id,
            sponsor: sponsor_addr,
            sponsor_name,
            question,
            outcomes,
            stakes,
            resolution_time,
            oracle_source,
            resolved: false,
            winning_outcome: 0,
            total_pool: 0,
            created_at: timestamp::now_seconds(),
        };

        vector::push_back(&mut registry.markets, market);
        registry.next_market_id = market_id + 1;
        registry.total_markets = registry.total_markets + 1;

        // Emit event
        event::emit(MarketCreatedEvent {
            market_id,
            sponsor: sponsor_addr,
            question,
            outcomes,
            resolution_time,
        });
    }

    public entry fun place_prediction(
        user: &signer,
        market_id: u64,
        outcome_index: u64,
        amount: u64,
    ) acquires MarketRegistry, UserPredictions {
        let user_addr = signer::address_of(user);
        
        // Validate amount
        assert!(amount > 0, E_INVALID_AMOUNT);
        assert!(
            coin::balance<AptosCoin>(user_addr) >= amount,
            E_INSUFFICIENT_FUNDS
        );

        let registry = borrow_global_mut<MarketRegistry>(@tradeleague);
        let market_ref = find_market_mut(&mut registry.markets, market_id);
        
        // Validate market state
        assert!(!market_ref.resolved, E_MARKET_RESOLVED);
        assert!(
            timestamp::now_seconds() < market_ref.resolution_time,
            E_MARKET_EXPIRED
        );
        assert!(
            outcome_index < vector::length(&market_ref.outcomes),
            E_INVALID_OUTCOME
        );

        // Transfer stake (in real implementation, this would go to market escrow)
        let coins = coin::withdraw<AptosCoin>(user, amount);
        coin::deposit(user_addr, coins); // Temporary - should go to escrow

        // Update market stakes
        let outcome_stakes = vector::borrow_mut(&mut market_ref.stakes, outcome_index);
        *outcome_stakes = *outcome_stakes + amount;
        market_ref.total_pool = market_ref.total_pool + amount;

        // Calculate potential payout
        let potential_payout = calculate_potential_payout(
            market_ref.total_pool + amount,
            *outcome_stakes + amount,
            amount
        );

        // Create user prediction
        let prediction = UserPrediction {
            market_id,
            outcome_index,
            stake: amount,
            potential_payout,
            placed_at: timestamp::now_seconds(),
            claimed: false,
        };

        // Initialize or update user predictions
        if (!exists<UserPredictions>(user_addr)) {
            let predictions = UserPredictions {
                predictions: vector::empty<UserPrediction>(),
                total_staked: 0,
                total_winnings: 0,
            };
            move_to(user, predictions);
        };

        let user_predictions = borrow_global_mut<UserPredictions>(user_addr);
        vector::push_back(&mut user_predictions.predictions, prediction);
        user_predictions.total_staked = user_predictions.total_staked + amount;

        // Emit event
        event::emit(PredictionPlacedEvent {
            market_id,
            user: user_addr,
            outcome_index,
            stake: amount,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun resolve_market(
        oracle: &signer,
        market_id: u64,
        winning_outcome: u64,
    ) acquires MarketRegistry {
        let oracle_addr = signer::address_of(oracle);
        
        let registry = borrow_global_mut<MarketRegistry>(@tradeleague);
        let market_ref = find_market_mut(&mut registry.markets, market_id);
        
        // In production, this should have proper oracle authorization
        assert!(market_ref.sponsor == oracle_addr, E_NOT_AUTHORIZED);
        assert!(!market_ref.resolved, E_ALREADY_RESOLVED);
        assert!(
            winning_outcome < vector::length(&market_ref.outcomes),
            E_INVALID_OUTCOME
        );

        // Resolve market
        market_ref.resolved = true;
        market_ref.winning_outcome = winning_outcome;

        // Emit event
        event::emit(MarketResolvedEvent {
            market_id,
            winning_outcome,
            total_pool: market_ref.total_pool,
            resolution_time: timestamp::now_seconds(),
        });
    }

    public entry fun claim_winnings(
        user: &signer,
        market_id: u64,
    ) acquires MarketRegistry, UserPredictions {
        let user_addr = signer::address_of(user);
        
        let registry = borrow_global<MarketRegistry>(@tradeleague);
        let market_ref = find_market(&registry.markets, market_id);
        assert!(market_ref.resolved, E_NOT_RESOLVED);

        let user_predictions = borrow_global_mut<UserPredictions>(user_addr);
        
        // Find user's prediction for this market
        let prediction_index = find_prediction_index(&user_predictions.predictions, market_id);
        let prediction = vector::borrow_mut(&mut user_predictions.predictions, prediction_index);
        
        assert!(!prediction.claimed, E_ALREADY_RESOLVED);

        // Check if user won
        if (prediction.outcome_index == market_ref.winning_outcome) {
            // Calculate actual payout
            let winning_stakes = *vector::borrow(&market_ref.stakes, market_ref.winning_outcome);
            let payout = if (winning_stakes > 0) {
                (market_ref.total_pool * prediction.stake) / winning_stakes
            } else {
                prediction.stake // Return original stake if no winners
            };

            // Mark as claimed
            prediction.claimed = true;
            user_predictions.total_winnings = user_predictions.total_winnings + payout;

            // Transfer winnings (in real implementation, this would come from escrow)
            // For now, we mint new coins (this should be proper payout logic)
            let coins = coin::withdraw<AptosCoin>(user, 0); // Placeholder
            coin::deposit(user_addr, coins);

            // Emit event
            event::emit(WinningsClaimedEvent {
                market_id,
                user: user_addr,
                payout,
                timestamp: timestamp::now_seconds(),
            });
        } else {
            // User lost - just mark as claimed
            prediction.claimed = true;
        };
    }

    // View functions
    #[view]
    public fun get_market(market_id: u64): PredictionMarket acquires MarketRegistry {
        let registry = borrow_global<MarketRegistry>(@tradeleague);
        *find_market(&registry.markets, market_id)
    }

    #[view]
    public fun get_user_predictions(user: address): vector<UserPrediction> acquires UserPredictions {
        if (!exists<UserPredictions>(user)) {
            return vector::empty<UserPrediction>()
        };
        let predictions = borrow_global<UserPredictions>(user);
        predictions.predictions
    }

    #[view]
    public fun get_market_odds(market_id: u64): vector<u64> acquires MarketRegistry {
        let registry = borrow_global<MarketRegistry>(@tradeleague);
        let market_ref = find_market(&registry.markets, market_id);
        
        let odds = vector::empty<u64>();
        let i = 0;
        while (i < vector::length(&market_ref.stakes)) {
            let stake = *vector::borrow(&market_ref.stakes, i);
            let probability = if (market_ref.total_pool > 0) {
                (stake * 100) / market_ref.total_pool
            } else {
                100 / vector::length(&market_ref.stakes)
            };
            vector::push_back(&mut odds, probability);
            i = i + 1;
        };
        odds
    }

    #[view]
    public fun get_all_markets(): vector<PredictionMarket> acquires MarketRegistry {
        let registry = borrow_global<MarketRegistry>(@tradeleague);
        registry.markets
    }

    // Helper functions
    fun find_market(markets: &vector<PredictionMarket>, market_id: u64): &PredictionMarket {
        let i = 0;
        let len = vector::length(markets);
        while (i < len) {
            let market = vector::borrow(markets, i);
            if (market.id == market_id) {
                return market
            };
            i = i + 1;
        };
        abort E_MARKET_NOT_FOUND
    }

    fun find_market_mut(markets: &mut vector<PredictionMarket>, market_id: u64): &mut PredictionMarket {
        let i = 0;
        let len = vector::length(markets);
        while (i < len) {
            let market = vector::borrow_mut(markets, i);
            if (market.id == market_id) {
                return market
            };
            i = i + 1;
        };
        abort E_MARKET_NOT_FOUND
    }

    fun find_prediction_index(predictions: &vector<UserPrediction>, market_id: u64): u64 {
        let i = 0;
        let len = vector::length(predictions);
        while (i < len) {
            let prediction = vector::borrow(predictions, i);
            if (prediction.market_id == market_id) {
                return i
            };
            i = i + 1;
        };
        abort E_MARKET_NOT_FOUND
    }

    fun calculate_potential_payout(total_pool: u64, outcome_stakes: u64, user_stake: u64): u64 {
        if (outcome_stakes == 0) {
            return user_stake
        };
        (total_pool * user_stake) / outcome_stakes
    }
}