# CTRL+Move Hackathon: TradeLeague Integration Strategy

**Hackathon Period:** August 4 - October 3, 2025  
**Winners Announced:** October 16, 2025 at Aptos Experience  
**Prize Pool:** $100,000+ USD  
**Registration:** [DoraHacks Platform](https://dorahacks.io/)

---

## Executive Summary

TradeLeague is perfectly positioned for CTRL+Move - the Aptos hackathon focused on real DeFi utility and breakthrough design. Our social trading platform directly addresses the hackathon's core themes:

- **Real Utility**: Transforms complex DeFi into intuitive mobile experiences
- **Breakthrough Design**: Gamified social trading with league competitions  
- **Performance-Driven**: Built on Aptos's parallel execution and sub-second finality

## Hackathon Alignment

### Core Infrastructure Advantages
- ✅ **Parallel Execution**: Multi-vault operations execute simultaneously
- ✅ **Sub-second Finality**: Real-time leaderboard updates and live trading
- ✅ **Atomic Composability**: Complex multi-protocol strategies in single transactions
- ✅ **Low, Predictable Fees**: Sustainable for high-frequency social trading

### Target Tracks

#### 1. Trading & Market Infrastructure
**TradeLeague Features:**
- Real-time social leaderboards with live position tracking
- Copy-trading vaults with automated execution
- Cross-platform strategy aggregation (Merkle Trade, Hyperion, Tapp Exchange)
- Mobile-first trading interface with one-tap execution

#### 2. New Financial Products  
**TradeLeague Innovations:**
- **Social Vault Following**: Copy successful traders with capital allocation controls
- **Prediction Market Leagues**: Sponsored competitions with real prizes
- **Gamified Portfolio Management**: Achievement systems and social sharing
- **Cross-Chain Liquidity Access**: Via Kana Labs integration

#### 3. Payments & Value Transfer
**TradeLeague Solutions:**
- **Circle Wallet Integration**: Seamless USDC management and transfers
- **Instant Reward Distribution**: Automated prize payouts via smart contracts  
- **Social Payment Flows**: League entry fees and reward sharing
- **Mobile-Native UX**: Biometric authentication and one-tap transactions

---

## Forefront Platform Integrations

### 1. Merkle Trade Integration 🏆

**Platform Overview:**
- Leading perpetuals DEX on Aptos
- Advanced order types and leverage management
- Professional trading tools with mobile accessibility

**TradeLeague Integration Strategy:**

#### A. Perpetuals Trading Competitions
```typescript
interface MerkleCompetition {
  name: "Merkle Masters League"
  duration: "Weekly cycles"
  entry_fee: "50 USDC"
  prize_pool: "Sponsored by Merkle Trade"
  
  scoring_metrics: {
    pnl_percentage: 40,      // Profit/Loss as % of starting capital
    volume_traded: 30,       // Total trading volume
    risk_management: 20,     // Max drawdown penalties
    consistency: 10          // Number of profitable days
  }
  
  special_features: {
    leverage_multiplier: "Up to 10x allowed",
    stop_loss_bonus: "5% score bonus for proper risk management",
    funding_rate_optimization: "Extra points for funding rate arbitrage"
  }
}
```

#### B. Advanced Strategy Vaults
```move
module tradeleague::merkle_vault_strategy {
    struct PerpetualStrategy has key, store {
        vault_id: u64,
        merkle_position_ids: vector<u64>,
        leverage_limit: u64,
        stop_loss_percentage: u64,
        take_profit_targets: vector<u64>,
        funding_rate_threshold: u64
    }
    
    public entry fun execute_leveraged_trade(
        manager: &signer,
        vault_id: u64,
        market_id: u64,
        side: bool, // true for long, false for short
        size: u64,
        leverage: u64
    ) acquires PerpetualStrategy {
        // Integrate with Merkle Trade's perpetual contracts
        // Apply vault-specific risk management rules
        // Update follower positions proportionally
    }
    
    public entry fun manage_funding_rates(
        manager: &signer,
        vault_id: u64
    ) acquires PerpetualStrategy {
        // Monitor funding rates across markets
        // Execute arbitrage opportunities
        // Distribute profits to vault followers
    }
}
```

#### C. Mobile Trading Interface
```swift
struct MerkleTradeView: View {
    @StateObject private var merkleService = MerkleTradeService()
    @State private var selectedMarket: Market?
    @State private var leverageSlider: Double = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            // Real-time P&L display
            PnLCard(
                unrealizedPnL: merkleService.totalUnrealizedPnL,
                realizedPnL: merkleService.dailyRealizedPnL,
                isAnimated: true
            )
            
            // Market selection with live funding rates
            MarketSelector(
                markets: merkleService.availableMarkets,
                selection: $selectedMarket
            ) { market in
                VStack(alignment: .leading) {
                    Text(market.symbol)
                        .font(.headline)
                    Text("Funding: \(market.fundingRate, specifier: "%.4f")%")
                        .font(.caption)
                        .foregroundColor(market.fundingRate > 0 ? .green : .red)
                }
            }
            
            // Leverage control with risk visualization
            LeverageSlider(
                value: $leverageSlider,
                range: 1...10,
                riskLevel: calculateRiskLevel(leverage: leverageSlider)
            )
            
            // One-tap execution buttons
            HStack(spacing: 15) {
                TradingButton(
                    title: "LONG",
                    color: .green,
                    action: { executeLongPosition() }
                )
                
                TradingButton(
                    title: "SHORT", 
                    color: .red,
                    action: { executeShortPosition() }
                )
            }
        }
        .padding()
        .background(GlassCard())
    }
}
```

### 2. Hyperion Integration 🌟

**Platform Overview:**
- Concentrated Liquidity Market Maker (CLMM) with 4000x capital efficiency
- Advanced composability solutions and SDK
- Automated range management and strategy optimization

**TradeLeague Integration Strategy:**

#### A. CLMM Strategy Competitions  
```typescript
interface HyperionChallenge {
  name: "Hyperion CLMM Masters"
  duration: "Monthly cycles"
  entry_fee: "100 USDC minimum position size"
  
  competition_categories: {
    capital_efficiency: {
      metric: "Fees earned per dollar of liquidity",
      bonus: "2x multiplier for positions with <5% of total pool TVL"
    },
    range_management: {
      metric: "Time in range percentage", 
      bonus: "Active rebalancing rewards"
    },
    composability_innovation: {
      metric: "Custom strategy complexity",
      bonus: "Extra points for novel hook implementations"
    }
  }
}
```

#### B. Automated CLMM Vaults
```move
module tradeleague::hyperion_clmm_vault {
    struct CLMMStrategy has key, store {
        vault_id: u64,
        pool_address: address,
        position_nft_id: u64,
        lower_tick: i64,
        upper_tick: i64,
        rebalance_threshold: u64, // Price movement % to trigger rebalance
        fee_compound_frequency: u64, // Blocks between fee compounding
        strategy_type: u8 // 1=RangeOrder, 2=Momentum, 3=MeanReversion
    }
    
    public entry fun create_clmm_vault(
        manager: &signer,
        pool_address: address,
        initial_lower_tick: i64,
        initial_upper_tick: i64,
        strategy_type: u8
    ) {
        // Create concentrated liquidity position via Hyperion
        // Set up automated rebalancing parameters
        // Enable follower deposits with proportional allocation
    }
    
    public entry fun auto_rebalance_position(
        vault_id: u64
    ) acquires CLMMStrategy {
        // Monitor current price vs range
        // Calculate optimal new range based on strategy
        // Execute range adjustment if threshold exceeded
        // Compound earned fees back into position
    }
    
    public fun simulate_strategy_performance(
        pool_address: address,
        strategy_params: StrategyParams,
        historical_data: vector<PricePoint>
    ): SimulationResult {
        // Backtest strategy against historical price data
        // Calculate expected APY, max drawdown, Sharpe ratio
        // Return risk-adjusted performance metrics
    }
}
```

#### C. Advanced Composability Features
```swift
struct HyperionStrategyBuilder: View {
    @State private var selectedStrategy: StrategyType = .rangeOrder
    @State private var riskTolerance: Double = 0.5
    @State private var rebalanceFrequency: RebalanceFrequency = .daily
    
    var body: some View {
        VStack(spacing: 25) {
            // Strategy selection with visual previews
            StrategyPicker(
                selection: $selectedStrategy,
                strategies: [
                    .rangeOrder: StrategyInfo(
                        title: "Range Order",
                        description: "Automated buy-low, sell-high within range",
                        riskLevel: .low,
                        expectedAPY: "15-25%"
                    ),
                    .momentum: StrategyInfo(
                        title: "Momentum Following", 
                        description: "Adjust ranges to follow price trends",
                        riskLevel: .medium,
                        expectedAPY: "20-35%"
                    ),
                    .meanReversion: StrategyInfo(
                        title: "Mean Reversion",
                        description: "Wider ranges expecting price return",
                        riskLevel: .high,
                        expectedAPY: "25-50%"
                    )
                ]
            )
            
            // Risk tolerance slider with visual feedback
            RiskToleranceSlider(
                value: $riskTolerance,
                visualization: .liquidityHeatmap
            )
            
            // Rebalancing frequency with cost analysis
            RebalanceFrequencyPicker(
                selection: $rebalanceFrequency,
                costAnalysis: calculateRebalanceCosts()
            )
            
            // Strategy backtest results
            BacktestResults(
                strategy: selectedStrategy,
                riskTolerance: riskTolerance,
                frequency: rebalanceFrequency
            )
            
            // Deploy strategy button
            DeployStrategyButton(
                isEnabled: isValidConfiguration(),
                action: deployHyperionStrategy
            )
        }
        .background(GlassCard())
        .padding()
    }
}
```

### 3. Tapp Exchange Integration ⚡

**Platform Overview:**
- Innovative AMM with composable hooks and dynamic fees
- Programmable liquidity with custom strategy logic
- Tapp Points reward system for liquidity providers

**TradeLeague Integration Strategy:**

#### A. Hook Innovation Competitions
```typescript
interface TappInnovationChallenge {
  name: "Tapp Hook Masters"
  duration: "Bi-weekly sprints"
  entry_fee: "Custom hook deployment (gas only)"
  
  judging_criteria: {
    innovation_score: 30,        // Novelty of hook implementation
    capital_efficiency: 25,      // TVL utilization optimization
    user_experience: 25,         // Mobile interface quality
    tapp_points_generation: 20   // Reward optimization for LPs
  }
  
  hook_categories: {
    il_protection: "Impermanent loss hedging strategies",
    yield_optimization: "Multi-protocol yield farming",
    risk_management: "Automated stop-loss and position limits",
    social_trading: "Copy-trading pool implementations"
  }
}
```

#### B. Custom Hook Development
```move
module tradeleague::tapp_custom_hooks {
    struct SocialTradingHook has key, store {
        pool_id: u64,
        leader_address: address,
        follower_allocations: Table<address, u64>,
        performance_fee: u64,
        max_position_size: u64,
        stop_loss_percentage: u64
    }
    
    // Hook implementation for copy-trading pools
    public fun before_swap(
        pool_id: u64,
        trader: address,
        amount_in: u64,
        token_in: address,
        token_out: address
    ): bool acquires SocialTradingHook {
        let hook = borrow_global<SocialTradingHook>(@tradeleague);
        
        // Only allow swaps from designated leader
        if (trader != hook.leader_address) {
            return false
        };
        
        // Check position size limits
        let current_position = get_trader_position(trader, token_out);
        if (current_position + amount_in > hook.max_position_size) {
            return false
        };
        
        true
    }
    
    public fun after_swap(
        pool_id: u64,
        trader: address,
        amount_in: u64,
        amount_out: u64,
        token_in: address,
        token_out: address
    ) acquires SocialTradingHook {
        let hook = borrow_global_mut<SocialTradingHook>(@tradeleague);
        
        // Execute proportional trades for all followers
        let follower_addresses = table::keys(&hook.follower_allocations);
        let i = 0;
        while (i < vector::length(&follower_addresses)) {
            let follower = *vector::borrow(&follower_addresses, i);
            let allocation = *table::borrow(&hook.follower_allocations, follower);
            
            let follower_amount = (amount_in * allocation) / 10000; // Basis points
            execute_follower_trade(follower, follower_amount, token_in, token_out);
            
            i = i + 1;
        };
        
        // Distribute performance fees
        distribute_performance_fees(trader, amount_out, hook.performance_fee);
    }
}
```

#### C. Dynamic Fee Optimization
```swift
struct TappDynamicFeeView: View {
    @StateObject private var tappService = TappExchangeService()
    @State private var selectedPool: TappPool?
    @State private var feeOptimizationEnabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Real-time fee analysis
            FeeAnalysisCard(
                currentFee: tappService.currentPoolFee,
                optimalFee: tappService.calculatedOptimalFee,
                potentialSavings: tappService.potentialSavings
            )
            
            // Pool selection with fee comparison
            PoolSelector(
                pools: tappService.availablePools,
                selection: $selectedPool
            ) { pool in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(pool.tokenA.symbol)/\(pool.tokenB.symbol)")
                            .font(.headline)
                        Text("Current Fee: \(pool.currentFee, specifier: "%.3f")%")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("TVL: $\(pool.tvl, specifier: "%.0f")K")
                            .font(.caption)
                        Text("24h Volume: $\(pool.volume24h, specifier: "%.0f")K")
                            .font(.caption)
                    }
                }
            }
            
            // Tapp Points display
            TappPointsCard(
                currentPoints: tappService.userTappPoints,
                projectedEarnings: tappService.projectedDailyPoints,
                multiplier: tappService.tradeLeagueMultiplier
            )
            
            // Hook strategy selector
            HookStrategyPicker(
                availableHooks: tappService.availableHooks,
                selectedHook: $tappService.selectedHook
            )
            
            // Liquidity provision interface
            LiquidityProvisionPanel(
                pool: selectedPool,
                optimizedAmounts: tappService.calculateOptimalAmounts(),
                action: provideLiquidity
            )
        }
        .background(GlassCard())
        .padding()
    }
}
```

---

## Trading Competition Specifications

### 1. Cross-Platform Tournament Structure

#### Weekly Competitions
```typescript
interface WeeklyTournament {
  "Merkle Perpetuals Championship": {
    duration: "7 days",
    entry_fee: "100 USDC",
    prize_distribution: {
      first: "40% of prize pool",
      second: "25% of prize pool", 
      third: "15% of prize pool",
      top_10: "20% distributed equally"
    },
    scoring: {
      pnl_percentage: 50,
      volume_multiplier: 30,
      risk_management: 20
    }
  },
  
  "Hyperion CLMM Masters": {
    duration: "7 days",
    entry_fee: "200 USDC minimum position",
    prize_distribution: {
      highest_fees_earned: "35%",
      best_capital_efficiency: "30%",
      most_innovative_strategy: "25%",
      community_choice: "10%"
    },
    scoring: {
      fees_per_dollar: 40,
      time_in_range: 30,
      strategy_complexity: 20,
      follower_count: 10
    }
  },
  
  "Tapp Innovation Sprint": {
    duration: "14 days",
    entry_fee: "Hook deployment + 50 USDC",
    prize_distribution: {
      most_innovative_hook: "50%",
      highest_tapp_points: "30%",
      best_ux_integration: "20%"
    },
    scoring: {
      hook_innovation: 40,
      user_adoption: 30,
      technical_excellence: 20,
      mobile_ux: 10
    }
  }
}
```

#### Monthly Championships
```typescript
interface MonthlyChampionship {
  "Grand Prix Trading League": {
    duration: "30 days",
    entry_fee: "500 USDC",
    qualification: "Top 100 weekly performers",
    
    prize_pool: {
      base: "50,000 USDC",
      sponsor_additions: {
        merkle_trade: "10,000 USDC",
        hyperion: "10,000 USDC", 
        tapp_exchange: "5,000 USDC",
        partner_bonuses: "Variable"
      }
    },
    
    scoring_system: {
      cross_platform_performance: 40,
      risk_adjusted_returns: 30,
      innovation_bonus: 20,
      social_impact: 10
    },
    
    special_categories: {
      "Rookie of the Month": "Best first-time competitor",
      "Strategy Innovation": "Most creative cross-platform approach",
      "Community Leader": "Highest follower growth and engagement",
      "Risk Master": "Best risk-adjusted returns"
    }
  }
}
```

### 2. Real-Time Leaderboard System

#### Live Scoring Engine
```move
module tradeleague::competition_scoring {
    struct CompetitionState has key {
        competition_id: u64,
        participants: Table<address, ParticipantScore>,
        start_time: u64,
        end_time: u64,
        prize_pool: u64,
        scoring_weights: ScoringWeights
    }
    
    struct ParticipantScore has store {
        trader: address,
        merkle_pnl: i64,
        hyperion_fees_earned: u64,
        tapp_points_generated: u64,
        total_volume: u64,
        risk_score: u64,
        innovation_bonus: u64,
        current_rank: u64,
        last_updated: u64
    }
    
    public entry fun update_participant_score(
        competition_id: u64,
        participant: address,
        platform: u8, // 1=Merkle, 2=Hyperion, 3=Tapp
        performance_data: vector<u8>
    ) acquires CompetitionState {
        let competition = borrow_global_mut<CompetitionState>(@tradeleague);
        let participant_score = table::borrow_mut(&mut competition.participants, participant);
        
        if (platform == 1) { // Merkle Trade
            let (pnl, volume) = deserialize_merkle_data(performance_data);
            participant_score.merkle_pnl = pnl;
            participant_score.total_volume = participant_score.total_volume + volume;
        } else if (platform == 2) { // Hyperion
            let fees_earned = deserialize_hyperion_data(performance_data);
            participant_score.hyperion_fees_earned = participant_score.hyperion_fees_earned + fees_earned;
        } else if (platform == 3) { // Tapp Exchange
            let tapp_points = deserialize_tapp_data(performance_data);
            participant_score.tapp_points_generated = participant_score.tapp_points_generated + tapp_points;
        };
        
        // Recalculate composite score
        let new_composite_score = calculate_composite_score(participant_score, &competition.scoring_weights);
        update_leaderboard_rank(competition_id, participant, new_composite_score);
        
        // Emit real-time update event
        event::emit(ScoreUpdateEvent {
            competition_id,
            participant,
            new_score: new_composite_score,
            timestamp: timestamp::now_seconds()
        });
    }
}
```

### 3. Mobile Competition Interface

#### Competition Dashboard
```swift
struct CompetitionDashboard: View {
    @StateObject private var competitionService = CompetitionService()
    @State private var selectedCompetition: Competition?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Active competitions carousel
                ActiveCompetitionsCarousel(
                    competitions: competitionService.activeCompetitions,
                    selection: $selectedCompetition
                )
                
                // Live leaderboard
                if let competition = selectedCompetition {
                    LiveLeaderboard(competition: competition)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
                
                // Performance analytics
                PersonalPerformanceCard(
                    currentRank: competitionService.currentRank,
                    scoreBreakdown: competitionService.scoreBreakdown,
                    projectedPrize: competitionService.projectedPrize
                )
                
                // Platform-specific performance
                PlatformPerformanceGrid(
                    merkleStats: competitionService.merkleStats,
                    hyperionStats: competitionService.hyperionStats,
                    tappStats: competitionService.tappStats
                )
                
                // Quick actions
                QuickActionsPanel(
                    availableActions: competitionService.availableActions
                )
            }
            .padding()
        }
        .background(Color.white)
        .refreshable {
            await competitionService.refreshData()
        }
    }
}

struct LiveLeaderboard: View {
    let competition: Competition
    @StateObject private var leaderboardService = LeaderboardService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Live Leaderboard")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Updates every 30s")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(leaderboardService.topParticipants, id: \.address) { participant in
                    LeaderboardRow(
                        participant: participant,
                        isCurrentUser: participant.address == UserService.shared.walletAddress
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                }
            }
        }
        .padding()
        .background(GlassCard())
        .onReceive(leaderboardService.liveUpdates) { update in
            withAnimation(.spring(response: 0.6, dampingRatio: 0.8)) {
                leaderboardService.processUpdate(update)
            }
        }
    }
}

struct LeaderboardRow: View {
    let participant: Participant
    let isCurrentUser: Bool
    @State private var rankChanged = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank with animation
            RankBadge(
                rank: participant.rank,
                previousRank: participant.previousRank,
                animated: $rankChanged
            )
            
            // Avatar and username
            AsyncImage(url: participant.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(participant.username)
                    .font(.headline)
                    .fontWeight(isCurrentUser ? .bold : .medium)
                
                Text("Score: \(participant.compositeScore, specifier: "%.1f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Performance metrics
            VStack(alignment: .trailing, spacing: 2) {
                Text("+\(participant.totalPnL, specifier: "%.1f")%")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(participant.totalPnL >= 0 ? .green : .red)
                
                Text("$\(participant.volume, specifier: "%.0f")K vol")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrentUser ? Color.orange.opacity(0.1) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isCurrentUser ? Color.orange : Color.clear, lineWidth: 1)
                )
        )
        .onChange(of: participant.rank) { _ in
            withAnimation(.spring(response: 0.4, dampingRatio: 0.7)) {
                rankChanged.toggle()
            }
        }
    }
}
```

---

## Implementation Timeline

### Phase 1: Foundation (Weeks 1-2)
- [ ] Smart contract updates for competition scoring
- [ ] Merkle Trade API integration and testing
- [ ] Hyperion CLMM strategy framework
- [ ] Tapp Exchange hook development environment

### Phase 2: Competition Features (Weeks 3-4)  
- [ ] Real-time leaderboard system
- [ ] Cross-platform scoring algorithm
- [ ] Mobile competition dashboard
- [ ] Prize distribution mechanisms

### Phase 3: Advanced Integrations (Weeks 5-6)
- [ ] Custom Tapp hooks for social trading
- [ ] Hyperion automated strategy vaults
- [ ] Merkle perpetuals risk management
- [ ] Cross-platform analytics and reporting

### Phase 4: Testing & Launch (Weeks 7-8)
- [ ] Beta testing with select users
- [ ] Performance optimization
- [ ] Security audits
- [ ] Marketing and community launch

---

## Success Metrics

### Hackathon Judging Criteria
1. **Innovation (25%)**: Novel cross-platform integration approach
2. **Technical Excellence (25%)**: Clean architecture, security, performance  
3. **User Experience (25%)**: Intuitive mobile interface, smooth interactions
4. **Ecosystem Impact (25%)**: Real utility for Aptos DeFi ecosystem

### Target Metrics
- **User Engagement**: 5,000+ competition participants
- **Trading Volume**: $10M+ across all platforms
- **Platform Integration**: Seamless UX across Merkle, Hyperion, Tapp
- **Innovation Score**: Novel features not available elsewhere

### Demo Script (90 seconds)
**0:00-0:15**: Open app, show live cross-platform leaderboard  
**0:15-0:30**: Join Merkle perpetuals competition, execute leveraged trade  
**0:30-0:45**: Switch to Hyperion, deploy automated CLMM strategy  
**0:45-1:00**: Create custom Tapp hook for social trading  
**1:00-1:15**: Show real-time score updates and ranking changes  
**1:15-1:30**: Claim prize and share achievement on social media

---

**TradeLeague: Redefining DeFi Through Social Competition**

*Built for CTRL+Move • Powered by Aptos • Integrated with the Future*
