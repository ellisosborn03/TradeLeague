module tradeleague::league_registry {
    use std::signer;
    use std::string::{Self, String};
    use std::vector;
    use std::timestamp;
    use aptos_framework::guid;
    use aptos_framework::event;
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_LEAGUE_NOT_FOUND: u64 = 2;
    const E_ALREADY_JOINED: u64 = 3;
    const E_LEAGUE_FULL: u64 = 4;
    const E_INSUFFICIENT_FUNDS: u64 = 5;
    const E_LEAGUE_ENDED: u64 = 6;

    struct League has key, store {
        id: u64,
        name: String,
        creator: address,
        participants: vector<address>,
        entry_fee: u64,
        prize_pool: u64,
        start_time: u64,
        end_time: u64,
        is_public: bool,
        max_participants: u64,
        is_active: bool,
    }

    struct LeaderboardEntry has store, copy, drop {
        user: address,
        score: u64,
        percentage_gain: u64,
    }

    struct Leaderboard has key, store {
        league_id: u64,
        entries: vector<LeaderboardEntry>,
        last_updated: u64,
    }

    struct LeagueRegistry has key {
        leagues: vector<League>,
        next_league_id: u64,
        total_leagues: u64,
    }

    struct UserParticipation has key {
        participated_leagues: vector<u64>,
        current_leagues: vector<u64>,
    }

    /// Events
    struct LeagueCreatedEvent has drop, store {
        league_id: u64,
        creator: address,
        name: String,
        entry_fee: u64,
        max_participants: u64,
    }

    struct UserJoinedEvent has drop, store {
        league_id: u64,
        user: address,
        timestamp: u64,
    }

    struct ScoreUpdatedEvent has drop, store {
        league_id: u64,
        user: address,
        new_score: u64,
        rank: u64,
    }

    struct LeagueEndedEvent has drop, store {
        league_id: u64,
        winner: address,
        prize_amount: u64,
    }

    fun init_module(account: &signer) {
        let registry = LeagueRegistry {
            leagues: vector::empty<League>(),
            next_league_id: 1,
            total_leagues: 0,
        };
        move_to(account, registry);
    }

    public entry fun create_league(
        creator: &signer,
        name: String,
        entry_fee: u64,
        duration: u64,
        is_public: bool,
        max_participants: u64,
    ) acquires LeagueRegistry {
        let creator_addr = signer::address_of(creator);
        
        // Check if creator has sufficient funds for entry fee
        if (entry_fee > 0) {
            assert!(
                coin::balance<AptosCoin>(creator_addr) >= entry_fee,
                E_INSUFFICIENT_FUNDS
            );
        };

        let registry = borrow_global_mut<LeagueRegistry>(@tradeleague);
        let league_id = registry.next_league_id;
        
        let current_time = timestamp::now_seconds();
        let end_time = current_time + duration;

        let league = League {
            id: league_id,
            name,
            creator: creator_addr,
            participants: vector::empty<address>(),
            entry_fee,
            prize_pool: 0,
            start_time: current_time,
            end_time,
            is_public,
            max_participants,
            is_active: true,
        };

        vector::push_back(&mut registry.leagues, league);
        registry.next_league_id = league_id + 1;
        registry.total_leagues = registry.total_leagues + 1;

        // Initialize leaderboard
        let leaderboard = Leaderboard {
            league_id,
            entries: vector::empty<LeaderboardEntry>(),
            last_updated: current_time,
        };
        move_to(creator, leaderboard);

        // Initialize user participation if not exists
        if (!exists<UserParticipation>(creator_addr)) {
            let participation = UserParticipation {
                participated_leagues: vector::empty<u64>(),
                current_leagues: vector::empty<u64>(),
            };
            move_to(creator, participation);
        };

        // Creator automatically joins their own league
        join_league_internal(creator, league_id);

        // Emit event
        event::emit(LeagueCreatedEvent {
            league_id,
            creator: creator_addr,
            name,
            entry_fee,
            max_participants,
        });
    }

    public entry fun join_league(
        user: &signer,
        league_id: u64,
    ) acquires LeagueRegistry, UserParticipation {
        join_league_internal(user, league_id);
    }

    fun join_league_internal(
        user: &signer,
        league_id: u64,
    ) acquires LeagueRegistry, UserParticipation {
        let user_addr = signer::address_of(user);
        let registry = borrow_global_mut<LeagueRegistry>(@tradeleague);
        
        // Find league
        let league_ref = find_league_mut(&mut registry.leagues, league_id);
        assert!(league_ref.is_active, E_LEAGUE_ENDED);
        assert!(
            vector::length(&league_ref.participants) < league_ref.max_participants,
            E_LEAGUE_FULL
        );
        assert!(
            !vector::contains(&league_ref.participants, &user_addr),
            E_ALREADY_JOINED
        );

        // Check entry fee payment
        if (league_ref.entry_fee > 0) {
            assert!(
                coin::balance<AptosCoin>(user_addr) >= league_ref.entry_fee,
                E_INSUFFICIENT_FUNDS
            );
            
            // Transfer entry fee to prize pool
            let coins = coin::withdraw<AptosCoin>(user, league_ref.entry_fee);
            league_ref.prize_pool = league_ref.prize_pool + coin::value(&coins);
            
            // In a real implementation, you'd store these coins in an escrow account
            coin::deposit(user_addr, coins); // Temporary - should go to escrow
        };

        // Add user to league
        vector::push_back(&mut league_ref.participants, user_addr);

        // Update user participation
        if (!exists<UserParticipation>(user_addr)) {
            let participation = UserParticipation {
                participated_leagues: vector::empty<u64>(),
                current_leagues: vector::empty<u64>(),
            };
            move_to(user, participation);
        };

        let participation = borrow_global_mut<UserParticipation>(user_addr);
        vector::push_back(&mut participation.current_leagues, league_id);
        vector::push_back(&mut participation.participated_leagues, league_id);

        // Emit event
        event::emit(UserJoinedEvent {
            league_id,
            user: user_addr,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun update_score(
        updater: &signer,
        league_id: u64,
        user: address,
        new_score: u64,
    ) acquires LeagueRegistry, Leaderboard {
        // In production, this should be called by authorized oracle or scoring system
        let updater_addr = signer::address_of(updater);
        
        let registry = borrow_global<LeagueRegistry>(@tradeleague);
        let league_ref = find_league(&registry.leagues, league_id);
        
        // For now, allow league creator to update scores
        assert!(league_ref.creator == updater_addr, E_NOT_AUTHORIZED);
        
        // Update leaderboard
        let leaderboard = borrow_global_mut<Leaderboard>(league_ref.creator);
        
        // Find or create user entry
        let entry_index_opt = find_leaderboard_entry(&leaderboard.entries, user);
        if (vector::length(&entry_index_opt) > 0) {
            let entry_index = *vector::borrow(&entry_index_opt, 0);
            let entry = vector::borrow_mut(&mut leaderboard.entries, entry_index);
            entry.score = new_score;
        } else {
            let new_entry = LeaderboardEntry {
                user,
                score: new_score,
                percentage_gain: new_score, // Simplified - should calculate actual percentage
            };
            vector::push_back(&mut leaderboard.entries, new_entry);
        };
        
        leaderboard.last_updated = timestamp::now_seconds();
        
        // Sort leaderboard (simplified bubble sort for demo)
        sort_leaderboard(&mut leaderboard.entries);
        
        // Calculate rank
        let rank = calculate_rank(&leaderboard.entries, user);
        
        // Emit event
        event::emit(ScoreUpdatedEvent {
            league_id,
            user,
            new_score,
            rank,
        });
    }

    public entry fun end_league(
        ender: &signer,
        league_id: u64,
    ) acquires LeagueRegistry, Leaderboard {
        let ender_addr = signer::address_of(ender);
        let registry = borrow_global_mut<LeagueRegistry>(@tradeleague);
        
        let league_ref = find_league_mut(&mut registry.leagues, league_id);
        assert!(league_ref.creator == ender_addr, E_NOT_AUTHORIZED);
        assert!(league_ref.is_active, E_LEAGUE_ENDED);
        
        league_ref.is_active = false;
        
        // Determine winner from leaderboard
        let leaderboard = borrow_global<Leaderboard>(league_ref.creator);
        if (vector::length(&leaderboard.entries) > 0) {
            let winner_entry = vector::borrow(&leaderboard.entries, 0);
            let winner = winner_entry.user;
            let prize_amount = league_ref.prize_pool;
            
            // Emit event
            event::emit(LeagueEndedEvent {
                league_id,
                winner,
                prize_amount,
            });
        };
    }

    // View functions
    #[view]
    public fun get_league(league_id: u64): League acquires LeagueRegistry {
        let registry = borrow_global<LeagueRegistry>(@tradeleague);
        *find_league(&registry.leagues, league_id)
    }

    #[view]
    public fun get_leaderboard(league_id: u64): vector<LeaderboardEntry> acquires LeagueRegistry, Leaderboard {
        let registry = borrow_global<LeagueRegistry>(@tradeleague);
        let league_ref = find_league(&registry.leagues, league_id);
        let leaderboard = borrow_global<Leaderboard>(league_ref.creator);
        leaderboard.entries
    }

    #[view]
    public fun get_user_leagues(user: address): vector<u64> acquires UserParticipation {
        if (!exists<UserParticipation>(user)) {
            return vector::empty<u64>()
        };
        let participation = borrow_global<UserParticipation>(user);
        participation.current_leagues
    }

    // Helper functions
    fun find_league(leagues: &vector<League>, league_id: u64): &League {
        let i = 0;
        let len = vector::length(leagues);
        while (i < len) {
            let league = vector::borrow(leagues, i);
            if (league.id == league_id) {
                return league
            };
            i = i + 1;
        };
        abort E_LEAGUE_NOT_FOUND
    }

    fun find_league_mut(leagues: &mut vector<League>, league_id: u64): &mut League {
        let i = 0;
        let len = vector::length(leagues);
        while (i < len) {
            let league = vector::borrow_mut(leagues, i);
            if (league.id == league_id) {
                return league
            };
            i = i + 1;
        };
        abort E_LEAGUE_NOT_FOUND
    }

    fun find_leaderboard_entry(entries: &vector<LeaderboardEntry>, user: address): vector<u64> {
        let result = vector::empty<u64>();
        let i = 0;
        let len = vector::length(entries);
        while (i < len) {
            let entry = vector::borrow(entries, i);
            if (entry.user == user) {
                vector::push_back(&mut result, i);
                return result
            };
            i = i + 1;
        };
        result
    }

    fun sort_leaderboard(entries: &mut vector<LeaderboardEntry>) {
        let len = vector::length(entries);
        if (len <= 1) return;
        
        let i = 0;
        while (i < len - 1) {
            let j = 0;
            while (j < len - 1 - i) {
                let entry1 = vector::borrow(entries, j);
                let entry2 = vector::borrow(entries, j + 1);
                if (entry1.score < entry2.score) {
                    vector::swap(entries, j, j + 1);
                };
                j = j + 1;
            };
            i = i + 1;
        };
    }

    fun calculate_rank(entries: &vector<LeaderboardEntry>, user: address): u64 {
        let i = 0;
        let len = vector::length(entries);
        while (i < len) {
            let entry = vector::borrow(entries, i);
            if (entry.user == user) {
                return i + 1
            };
            i = i + 1;
        };
        0 // Not found
    }
}