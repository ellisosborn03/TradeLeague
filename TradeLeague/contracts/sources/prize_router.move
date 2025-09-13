module tradeleague::prize_router {
    use std::signer;
    use std::vector;
    use std::timestamp;
    use aptos_framework::event;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_INVALID_RECIPIENTS: u64 = 2;
    const E_INSUFFICIENT_FUNDS: u64 = 3;
    const E_MISMATCHED_ARRAYS: u64 = 4;
    const E_ZERO_AMOUNT: u64 = 5;

    struct PrizePool has key {
        total_balance: u64,
        distributed_rewards: u64,
        authorized_distributors: vector<address>,
    }

    struct RewardDistribution has store, copy, drop {
        recipient: address,
        amount: u64,
        reason: u8, // 1=League, 2=Prediction, 3=Referral, 4=Achievement
        timestamp: u64,
    }

    /// Events
    struct PrizeDepositedEvent has drop, store {
        depositor: address,
        amount: u64,
        new_balance: u64,
        timestamp: u64,
    }

    struct RewardDistributedEvent has drop, store {
        distributor: address,
        distributions: vector<RewardDistribution>,
        total_amount: u64,
        timestamp: u64,
    }

    struct DistributorAuthorizedEvent has drop, store {
        admin: address,
        new_distributor: address,
        timestamp: u64,
    }

    fun init_module(account: &signer) {
        let admin_addr = signer::address_of(account);
        let prize_pool = PrizePool {
            total_balance: 0,
            distributed_rewards: 0,
            authorized_distributors: vector::singleton(admin_addr),
        };
        move_to(account, prize_pool);
    }

    public entry fun deposit_prize_funds(
        depositor: &signer,
        amount: u64,
    ) acquires PrizePool {
        let depositor_addr = signer::address_of(depositor);
        
        assert!(amount > 0, E_ZERO_AMOUNT);
        assert!(
            coin::balance<AptosCoin>(depositor_addr) >= amount,
            E_INSUFFICIENT_FUNDS
        );

        // Transfer funds to prize pool (in real implementation, this would go to a treasury)
        let coins = coin::withdraw<AptosCoin>(depositor, amount);
        coin::deposit(depositor_addr, coins); // Temporary - should go to treasury

        let prize_pool = borrow_global_mut<PrizePool>(@tradeleague);
        prize_pool.total_balance = prize_pool.total_balance + amount;

        // Emit event
        event::emit(PrizeDepositedEvent {
            depositor: depositor_addr,
            amount,
            new_balance: prize_pool.total_balance,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun distribute_rewards(
        distributor: &signer,
        recipients: vector<address>,
        amounts: vector<u64>,
        reasons: vector<u8>,
    ) acquires PrizePool {
        let distributor_addr = signer::address_of(distributor);
        
        // Validate inputs
        assert!(
            vector::length(&recipients) == vector::length(&amounts),
            E_MISMATCHED_ARRAYS
        );
        assert!(
            vector::length(&recipients) == vector::length(&reasons),
            E_MISMATCHED_ARRAYS
        );
        assert!(vector::length(&recipients) > 0, E_INVALID_RECIPIENTS);

        let prize_pool = borrow_global_mut<PrizePool>(@tradeleague);
        
        // Check if distributor is authorized
        assert!(
            vector::contains(&prize_pool.authorized_distributors, &distributor_addr),
            E_NOT_AUTHORIZED
        );

        // Calculate total distribution amount
        let total_amount = 0;
        let i = 0;
        while (i < vector::length(&amounts)) {
            let amount = *vector::borrow(&amounts, i);
            assert!(amount > 0, E_ZERO_AMOUNT);
            total_amount = total_amount + amount;
            i = i + 1;
        };

        // Check if sufficient funds are available
        assert!(
            prize_pool.total_balance >= total_amount,
            E_INSUFFICIENT_FUNDS
        );

        // Create distribution records and distribute rewards
        let distributions = vector::empty<RewardDistribution>();
        i = 0;
        while (i < vector::length(&recipients)) {
            let recipient = *vector::borrow(&recipients, i);
            let amount = *vector::borrow(&amounts, i);
            let reason = *vector::borrow(&reasons, i);
            
            // Create distribution record
            let distribution = RewardDistribution {
                recipient,
                amount,
                reason,
                timestamp: timestamp::now_seconds(),
            };
            vector::push_back(&mut distributions, distribution);

            // Transfer reward to recipient (in real implementation, this would come from treasury)
            // For now, we mint new coins (this should be proper payout logic)
            let coins = coin::withdraw<AptosCoin>(distributor, 0); // Placeholder
            coin::deposit(recipient, coins);

            i = i + 1;
        };

        // Update prize pool balance
        prize_pool.total_balance = prize_pool.total_balance - total_amount;
        prize_pool.distributed_rewards = prize_pool.distributed_rewards + total_amount;

        // Emit event
        event::emit(RewardDistributedEvent {
            distributor: distributor_addr,
            distributions,
            total_amount,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun distribute_league_rewards(
        distributor: &signer,
        league_id: u64,
        winners: vector<address>,
        amounts: vector<u64>,
    ) acquires PrizePool {
        let reasons = vector::empty<u8>();
        let i = 0;
        while (i < vector::length(&winners)) {
            vector::push_back(&mut reasons, 1); // 1 = League reward
            i = i + 1;
        };
        
        distribute_rewards(distributor, winners, amounts, reasons);
    }

    public entry fun distribute_prediction_rewards(
        distributor: &signer,
        market_id: u64,
        winners: vector<address>,
        amounts: vector<u64>,
    ) acquires PrizePool {
        let reasons = vector::empty<u8>();
        let i = 0;
        while (i < vector::length(&winners)) {
            vector::push_back(&mut reasons, 2); // 2 = Prediction reward
            i = i + 1;
        };
        
        distribute_rewards(distributor, winners, amounts, reasons);
    }

    public entry fun distribute_referral_rewards(
        distributor: &signer,
        referrers: vector<address>,
        amounts: vector<u64>,
    ) acquires PrizePool {
        let reasons = vector::empty<u8>();
        let i = 0;
        while (i < vector::length(&referrers)) {
            vector::push_back(&mut reasons, 3); // 3 = Referral reward
            i = i + 1;
        };
        
        distribute_rewards(distributor, referrers, amounts, reasons);
    }

    public entry fun authorize_distributor(
        admin: &signer,
        new_distributor: address,
    ) acquires PrizePool {
        let admin_addr = signer::address_of(admin);
        let prize_pool = borrow_global_mut<PrizePool>(@tradeleague);
        
        // Check if admin is already authorized
        assert!(
            vector::contains(&prize_pool.authorized_distributors, &admin_addr),
            E_NOT_AUTHORIZED
        );

        // Add new distributor if not already authorized
        if (!vector::contains(&prize_pool.authorized_distributors, &new_distributor)) {
            vector::push_back(&mut prize_pool.authorized_distributors, new_distributor);
            
            // Emit event
            event::emit(DistributorAuthorizedEvent {
                admin: admin_addr,
                new_distributor,
                timestamp: timestamp::now_seconds(),
            });
        };
    }

    public entry fun remove_distributor(
        admin: &signer,
        distributor_to_remove: address,
    ) acquires PrizePool {
        let admin_addr = signer::address_of(admin);
        let prize_pool = borrow_global_mut<PrizePool>(@tradeleague);
        
        // Check if admin is authorized
        assert!(
            vector::contains(&prize_pool.authorized_distributors, &admin_addr),
            E_NOT_AUTHORIZED
        );

        // Remove distributor
        let (found, index) = vector::index_of(&prize_pool.authorized_distributors, &distributor_to_remove);
        if (found) {
            vector::remove(&mut prize_pool.authorized_distributors, index);
        };
    }

    // Emergency withdrawal function (admin only)
    public entry fun emergency_withdraw(
        admin: &signer,
        amount: u64,
    ) acquires PrizePool {
        let admin_addr = signer::address_of(admin);
        let prize_pool = borrow_global_mut<PrizePool>(@tradeleague);
        
        // Check if admin is authorized
        assert!(
            vector::contains(&prize_pool.authorized_distributors, &admin_addr),
            E_NOT_AUTHORIZED
        );
        assert!(prize_pool.total_balance >= amount, E_INSUFFICIENT_FUNDS);

        // Transfer funds back to admin (emergency only)
        let coins = coin::withdraw<AptosCoin>(admin, 0); // Placeholder - should come from treasury
        coin::deposit(admin_addr, coins);

        prize_pool.total_balance = prize_pool.total_balance - amount;
    }

    // View functions
    #[view]
    public fun get_prize_pool_balance(): u64 acquires PrizePool {
        let prize_pool = borrow_global<PrizePool>(@tradeleague);
        prize_pool.total_balance
    }

    #[view]
    public fun get_distributed_rewards(): u64 acquires PrizePool {
        let prize_pool = borrow_global<PrizePool>(@tradeleague);
        prize_pool.distributed_rewards
    }

    #[view]
    public fun is_authorized_distributor(distributor: address): bool acquires PrizePool {
        let prize_pool = borrow_global<PrizePool>(@tradeleague);
        vector::contains(&prize_pool.authorized_distributors, &distributor)
    }

    #[view]
    public fun get_authorized_distributors(): vector<address> acquires PrizePool {
        let prize_pool = borrow_global<PrizePool>(@tradeleague);
        prize_pool.authorized_distributors
    }
}