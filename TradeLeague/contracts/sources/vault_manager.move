module tradeleague::vault_manager {
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
    const E_VAULT_NOT_FOUND: u64 = 2;
    const E_ALREADY_FOLLOWING: u64 = 3;
    const E_NOT_FOLLOWING: u64 = 4;
    const E_INSUFFICIENT_FUNDS: u64 = 5;
    const E_INVALID_AMOUNT: u64 = 6;
    const E_VAULT_CLOSED: u64 = 7;

    struct Vault has key, store {
        id: u64,
        manager: address,
        name: String,
        strategy: String,
        venue: String,
        total_aum: u64,
        performance_fee: u64, // Basis points (e.g., 1500 = 15%)
        followers: vector<address>,
        historical_performance: vector<u64>,
        is_active: bool,
        created_at: u64,
        last_trade_time: u64,
    }

    struct VaultFollowing has key, store {
        vault_id: u64,
        amount: u64,
        entry_price: u64,
        follow_time: u64,
        last_rebalance: u64,
    }

    struct VaultRegistry has key {
        vaults: vector<Vault>,
        next_vault_id: u64,
        total_vaults: u64,
    }

    struct UserVaultFollowings has key {
        followings: vector<VaultFollowing>,
        total_invested: u64,
    }

    struct TradeExecution has store, copy, drop {
        vault_id: u64,
        trade_type: String,
        amount: u64,
        price: u64,
        timestamp: u64,
    }

    /// Events
    struct VaultCreatedEvent has drop, store {
        vault_id: u64,
        manager: address,
        name: String,
        strategy: String,
        venue: String,
    }

    struct VaultFollowedEvent has drop, store {
        vault_id: u64,
        user: address,
        amount: u64,
        timestamp: u64,
    }

    struct VaultUnfollowedEvent has drop, store {
        vault_id: u64,
        user: address,
        amount_withdrawn: u64,
        timestamp: u64,
    }

    struct TradeExecutedEvent has drop, store {
        vault_id: u64,
        manager: address,
        trade_data: TradeExecution,
        new_aum: u64,
    }

    struct PerformanceUpdatedEvent has drop, store {
        vault_id: u64,
        old_performance: u64,
        new_performance: u64,
        timestamp: u64,
    }

    fun init_module(account: &signer) {
        let registry = VaultRegistry {
            vaults: vector::empty<Vault>(),
            next_vault_id: 1,
            total_vaults: 0,
        };
        move_to(account, registry);
    }

    public entry fun create_vault(
        manager: &signer,
        name: String,
        strategy: String,
        venue: String,
        performance_fee: u64,
    ) acquires VaultRegistry {
        let manager_addr = signer::address_of(manager);
        
        // Validate performance fee (max 20% = 2000 basis points)
        assert!(performance_fee <= 2000, E_INVALID_AMOUNT);

        let registry = borrow_global_mut<VaultRegistry>(@tradeleague);
        let vault_id = registry.next_vault_id;
        
        let current_time = timestamp::now_seconds();

        let vault = Vault {
            id: vault_id,
            manager: manager_addr,
            name,
            strategy,
            venue,
            total_aum: 0,
            performance_fee,
            followers: vector::empty<address>(),
            historical_performance: vector::empty<u64>(),
            is_active: true,
            created_at: current_time,
            last_trade_time: current_time,
        };

        vector::push_back(&mut registry.vaults, vault);
        registry.next_vault_id = vault_id + 1;
        registry.total_vaults = registry.total_vaults + 1;

        // Emit event
        event::emit(VaultCreatedEvent {
            vault_id,
            manager: manager_addr,
            name,
            strategy,
            venue,
        });
    }

    public entry fun follow_vault(
        user: &signer,
        vault_id: u64,
        amount: u64,
    ) acquires VaultRegistry, UserVaultFollowings {
        let user_addr = signer::address_of(user);
        
        // Validate amount
        assert!(amount > 0, E_INVALID_AMOUNT);
        assert!(
            coin::balance<AptosCoin>(user_addr) >= amount,
            E_INSUFFICIENT_FUNDS
        );

        let registry = borrow_global_mut<VaultRegistry>(@tradeleague);
        let vault_ref = find_vault_mut(&mut registry.vaults, vault_id);
        assert!(vault_ref.is_active, E_VAULT_CLOSED);

        // Check if user is already following
        assert!(
            !vector::contains(&vault_ref.followers, &user_addr),
            E_ALREADY_FOLLOWING
        );

        // Transfer funds (in real implementation, funds would go to vault treasury)
        let coins = coin::withdraw<AptosCoin>(user, amount);
        coin::deposit(user_addr, coins); // Temporary - should go to vault treasury

        // Add user as follower
        vector::push_back(&mut vault_ref.followers, user_addr);
        vault_ref.total_aum = vault_ref.total_aum + amount;

        // Create following record
        let following = VaultFollowing {
            vault_id,
            amount,
            entry_price: 1000000, // 1.0 in 6 decimal places (should be actual entry price)
            follow_time: timestamp::now_seconds(),
            last_rebalance: timestamp::now_seconds(),
        };

        // Initialize or update user followings
        if (!exists<UserVaultFollowings>(user_addr)) {
            let followings = UserVaultFollowings {
                followings: vector::empty<VaultFollowing>(),
                total_invested: 0,
            };
            move_to(user, followings);
        };

        let user_followings = borrow_global_mut<UserVaultFollowings>(user_addr);
        vector::push_back(&mut user_followings.followings, following);
        user_followings.total_invested = user_followings.total_invested + amount;

        // Emit event
        event::emit(VaultFollowedEvent {
            vault_id,
            user: user_addr,
            amount,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun unfollow_vault(
        user: &signer,
        vault_id: u64,
    ) acquires VaultRegistry, UserVaultFollowings {
        let user_addr = signer::address_of(user);

        let registry = borrow_global_mut<VaultRegistry>(@tradeleague);
        let vault_ref = find_vault_mut(&mut registry.vaults, vault_id);

        // Check if user is following
        let follower_index_opt = vector::index_of(&vault_ref.followers, &user_addr);
        assert!(vector::length(&follower_index_opt) > 0, E_NOT_FOLLOWING);

        // Remove user from followers
        let (_, follower_index) = follower_index_opt;
        vector::remove(&mut vault_ref.followers, follower_index);

        // Find and remove following record
        let user_followings = borrow_global_mut<UserVaultFollowings>(user_addr);
        let following_index = find_following_index(&user_followings.followings, vault_id);
        let following = vector::remove(&mut user_followings.followings, following_index);
        
        // Calculate withdrawal amount (should include performance calculation)
        let withdrawal_amount = following.amount;
        vault_ref.total_aum = vault_ref.total_aum - withdrawal_amount;
        user_followings.total_invested = user_followings.total_invested - withdrawal_amount;

        // Return funds to user (in real implementation, this would come from vault treasury)
        // For now, we mint new coins (this should be proper withdrawal logic)
        let coins = coin::withdraw<AptosCoin>(user, 0); // Placeholder
        coin::deposit(user_addr, coins);

        // Emit event
        event::emit(VaultUnfollowedEvent {
            vault_id,
            user: user_addr,
            amount_withdrawn: withdrawal_amount,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun execute_trade(
        manager: &signer,
        vault_id: u64,
        trade_type: String,
        amount: u64,
        price: u64,
    ) acquires VaultRegistry {
        let manager_addr = signer::address_of(manager);
        
        let registry = borrow_global_mut<VaultRegistry>(@tradeleague);
        let vault_ref = find_vault_mut(&mut registry.vaults, vault_id);
        
        // Verify manager authorization
        assert!(vault_ref.manager == manager_addr, E_NOT_AUTHORIZED);
        assert!(vault_ref.is_active, E_VAULT_CLOSED);

        // Update vault's last trade time
        vault_ref.last_trade_time = timestamp::now_seconds();

        // Create trade execution record
        let trade_execution = TradeExecution {
            vault_id,
            trade_type,
            amount,
            price,
            timestamp: timestamp::now_seconds(),
        };

        // In a real implementation, this would interact with DEX contracts
        // For now, we'll just record the trade and update performance metrics

        // Update historical performance (simplified)
        let current_performance = if (vector::length(&vault_ref.historical_performance) > 0) {
            *vector::borrow(&vault_ref.historical_performance, vector::length(&vault_ref.historical_performance) - 1)
        } else {
            100 // Starting at 100% (no change)
        };
        
        // Simplified performance calculation (in reality, this would be based on actual trade results)
        let new_performance = current_performance + 1; // 1% gain per trade (demo)
        vector::push_back(&mut vault_ref.historical_performance, new_performance);

        // Emit event
        event::emit(TradeExecutedEvent {
            vault_id,
            manager: manager_addr,
            trade_data: trade_execution,
            new_aum: vault_ref.total_aum,
        });

        event::emit(PerformanceUpdatedEvent {
            vault_id,
            old_performance: current_performance,
            new_performance,
            timestamp: timestamp::now_seconds(),
        });
    }

    public entry fun close_vault(
        manager: &signer,
        vault_id: u64,
    ) acquires VaultRegistry {
        let manager_addr = signer::address_of(manager);
        
        let registry = borrow_global_mut<VaultRegistry>(@tradeleague);
        let vault_ref = find_vault_mut(&mut registry.vaults, vault_id);
        
        assert!(vault_ref.manager == manager_addr, E_NOT_AUTHORIZED);
        vault_ref.is_active = false;
    }

    // View functions
    #[view]
    public fun get_vault(vault_id: u64): Vault acquires VaultRegistry {
        let registry = borrow_global<VaultRegistry>(@tradeleague);
        *find_vault(&registry.vaults, vault_id)
    }

    #[view]
    public fun get_user_followings(user: address): vector<VaultFollowing> acquires UserVaultFollowings {
        if (!exists<UserVaultFollowings>(user)) {
            return vector::empty<VaultFollowing>()
        };
        let followings = borrow_global<UserVaultFollowings>(user);
        followings.followings
    }

    #[view]
    public fun get_vault_performance(vault_id: u64): vector<u64> acquires VaultRegistry {
        let registry = borrow_global<VaultRegistry>(@tradeleague);
        let vault_ref = find_vault(&registry.vaults, vault_id);
        vault_ref.historical_performance
    }

    #[view]
    public fun get_all_vaults(): vector<Vault> acquires VaultRegistry {
        let registry = borrow_global<VaultRegistry>(@tradeleague);
        registry.vaults
    }

    // Helper functions
    fun find_vault(vaults: &vector<Vault>, vault_id: u64): &Vault {
        let i = 0;
        let len = vector::length(vaults);
        while (i < len) {
            let vault = vector::borrow(vaults, i);
            if (vault.id == vault_id) {
                return vault
            };
            i = i + 1;
        };
        abort E_VAULT_NOT_FOUND
    }

    fun find_vault_mut(vaults: &mut vector<Vault>, vault_id: u64): &mut Vault {
        let i = 0;
        let len = vector::length(vaults);
        while (i < len) {
            let vault = vector::borrow_mut(vaults, i);
            if (vault.id == vault_id) {
                return vault
            };
            i = i + 1;
        };
        abort E_VAULT_NOT_FOUND
    }

    fun find_following_index(followings: &vector<VaultFollowing>, vault_id: u64): u64 {
        let i = 0;
        let len = vector::length(followings);
        while (i < len) {
            let following = vector::borrow(followings, i);
            if (following.vault_id == vault_id) {
                return i
            };
            i = i + 1;
        };
        abort E_NOT_FOLLOWING
    }
}