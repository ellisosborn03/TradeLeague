# Product Requirements Document
## TradeLeague: Social DeFi Gaming on Aptos

**Version:** 1.0  
**Date:** September 2025  
**Status:** MVP Specification

---

## Executive Summary

**One-liner:** iOS app with four pages — League, Trade, Predict, You — that uses Aptos testnet to onboard users into DeFi through social leaderboards, copy trading, and sponsor-powered prediction events.

**Vision:** TradeLeague democratizes DeFi access by transforming complex financial primitives into an intuitive, gamified mobile experience. By leveraging Aptos's high-performance blockchain and integrating multiple ecosystem partners, we create a social trading environment where users learn, compete, and earn together.

---

## 1. Strategic Overview

### 1.1 Problem Statement
- **Barrier to Entry:** DeFi remains inaccessible to mainstream users due to complexity, technical barriers, and lack of social context
- **Fragmented Ecosystem:** Users must navigate multiple protocols, wallets, and interfaces to participate in DeFi
- **Missing Social Layer:** Traditional DeFi lacks the social validation and competitive elements that drive engagement
- **Education Gap:** No clear path from zero knowledge to active DeFi participation

### 1.2 Solution
TradeLeague creates a unified social trading experience that:
- Abstracts blockchain complexity through Circle's Programmable Wallets
- Gamifies DeFi participation through leagues and leaderboards
- Enables social learning through vault following and copy trading
- Provides sponsored prediction markets as low-risk entry points

### 1.3 Success Metrics
| Metric | Target (30 days) | Measurement Method |
|--------|------------------|-------------------|
| New Wallets Created | 10,000 | Circle API + on-chain |
| Total Volume (Testnet USDC) | $1M equivalent | Smart contract events |
| Active Daily Users | 2,000 | Nodit indexer |
| Viral Coefficient | >1.2 | Invite conversions |
| Prediction Market Participation | 5,000 entries | Contract events |

---

## 2. User Personas

### 2.1 Primary Persona: The Social Trader
- **Age:** 22-35
- **Background:** Active on social media, follows financial influencers
- **Pain Points:** Wants to trade but intimidated by technical complexity
- **Goals:** Learn from successful traders, compete with friends
- **Journey:** Joins through invite → Follows top traders → Enters predictions → Creates own league

### 2.2 Secondary Persona: The DeFi Native
- **Age:** 25-40
- **Background:** Experienced crypto user, multiple wallets
- **Pain Points:** Fragmented portfolio tracking, no social validation
- **Goals:** Showcase expertise, monetize knowledge
- **Journey:** Creates vault → Gains followers → Wins leagues → Becomes influencer

### 2.3 Tertiary Persona: The Curious Newcomer
- **Age:** 18-30
- **Background:** Heard about crypto, never participated
- **Pain Points:** Don't know where to start, fear of losing money
- **Goals:** Learn safely, join friends' activities
- **Journey:** Receives invite → Gets free testnet USDC → Joins friend's league → Makes first prediction

---

## 3. Core Features Specification

### 3.1 League Page
**Purpose:** Social competition and discovery hub

#### 3.1.1 Global Leaderboard
- **Display Format:**
  ```
  Rank | Avatar | Username | Portfolio % | 24h Change | Trophy
  #1   | [IMG]  | @whale   | +342%      | ↑12%       | 🏆
  ```
- **Sorting Options:** All-time, Weekly, Daily, By League
- **Live Updates:** Real-time position changes with animations
- **Social Features:** Follow users, view their vaults, copy strategies

#### 3.1.2 League Management
- **Create League:**
  - Custom name (max 30 chars)
  - Entry fee (0-1000 testnet USDC)
  - Duration (1 week, 1 month, ongoing)
  - Private/Public toggle
  - Max participants (10-1000)
- **Join League:**
  - Browse public leagues
  - Search by name/code
  - Filter by entry fee, duration, participants
  - One-tap join with auto-wallet creation

#### 3.1.3 Sponsored Events
- **Circle League:** Weekly competition for highest USDC volume
- **Hyperion Masters:** CLMM liquidity provision and composability challenges
- **Tapp Innovation:** Best custom hook strategy contest
- **Kana Cross-Chain:** Multi-chain arbitrage competition
- **Merkle Masters:** Perpetuals trading leaderboard
- **Nodit Analytics:** Best on-chain analysis competition
- **Display:** Banner carousel with countdown timers and partner branding

### 3.2 Trade Page
**Purpose:** Advanced trading with specialized platform features

#### 3.2.1 Platform Features Tabs
- **All Vaults:** General vault discovery and copy trading
- **Hyperion CLMM:** Concentrated liquidity strategies and composability solutions
- **Tapp Hooks:** Dynamic fee pools and custom trading strategies  
- **Kana Bridge:** Cross-chain asset management and swaps
- **Traditional:** Standard orderbook and AMM trading

#### 3.2.2 Vault Browser
- **Card Layout:**
  ```
  [Vault Name]
  Strategy: Market Making | Yield Farming | Arbitrage
  Venue: Hyperion | Merkle | Tapp
  Performance: +127% (30d)
  Followers: 234 | AUM: $45.2K
  [Follow Button]
  ```
- **Filtering:**
  - By venue (Hyperion, Merkle, Tapp)
  - By strategy type
  - By performance (7d, 30d, all-time)
  - By risk level (Conservative, Moderate, Aggressive)

#### 3.2.2 Vault Following Mechanics
- **Follow Process:**
  1. Select allocation amount (min 10 USDC)
  2. Review strategy description
  3. Accept terms (fees, lock period)
  4. Confirm transaction
- **Management:**
  - View current allocations
  - Adjust follow amounts
  - Emergency withdraw (with penalty)
  - Performance tracking per vault

#### 3.2.3 Vault Creation (Advanced)
- **Requirements:** 
  - Min 100 USDC deposit
  - KYC verification (future)
- **Configuration:**
  - Strategy name and description
  - Trading venue selection
  - Fee structure (0-20% performance)
  - Max capacity

### 3.3 Predict Page
**Purpose:** Multi-platform prediction markets and derivatives

#### 3.3.1 Platform Tabs
- **Panora Markets:** Price predictions and oracle-based betting
- **Ekiden Derivatives:** Futures and options prediction markets
- **Cross-Chain Events:** Multi-chain outcome predictions via Kana Labs
- **Perpetuals:** Merkle Trade leverage and funding rate predictions

#### 3.3.2 Market Types
- **Price Predictions (Panora):**
  - Will APT be above $X by Friday?
  - Binary Yes/No format
  - 5-100 USDC stakes
- **Cross-chain Events (Kana Labs):**
  - Which chain will have more volume?
  - Multiple choice format
- **Derivatives (Ekiden):**
  - Futures settlement predictions
  - Range-based outcomes

#### 3.3.2 Market Interface
- **Card Design:**
  ```
  [Sponsor Logo]
  Question: Will BTC break $100K this week?
  
  YES: 67% ($45.2K)  |  NO: 33% ($22.1K)
  
  Your Position: YES @ 10 USDC
  Potential Payout: 14.9 USDC
  
  Time Remaining: 2d 14h 32m
  [Place Prediction Button]
  ```

#### 3.3.3 Settlement Process
- Oracle-based resolution
- Automatic payout distribution
- Historical accuracy tracking
- Dispute mechanism (48h window)

### 3.4 You Page
**Purpose:** Portfolio management and social sharing

#### 3.4.1 Portfolio Dashboard
- **Metrics Display:**
  ```
  Total Value: $1,234.56
  Today: +$45.23 (+3.8%)
  All-time: +$234.56 (+23.4%)
  
  [Performance Chart]
  
  Active Positions:
  - Hyperion Vault: $500 (+12%)
  - Merkle Perps: $400 (-3%)
  - Predictions: $334.56 (+45%)
  ```

#### 3.4.2 Wallet Management
- **Circle Integration:**
  - View address (truncated)
  - Export private key (with warnings)
  - Recovery phrase backup
- **Transaction History:**
  - Deposits/Withdrawals
  - Trades executed
  - Rewards claimed
  - Sortable by date/type/amount

#### 3.4.3 Educational Hub
- **Platform Education:**
  - **Hyperion Guide:** "Understanding Concentrated Liquidity" with interactive examples
  - **Tapp.Exchange Tutorial:** "Building Your First Hook Strategy" 
  - **Kana Labs Overview:** "Cross-Chain Trading Made Simple"
  - **Nodit Analytics:** "Reading On-Chain Data Like a Pro"
  - **Link Collection:** Direct links to partner platforms and documentation

- **Strategy Learning:**
  - Video tutorials from successful vault managers
  - Risk management best practices
  - Market analysis tools and techniques
  - DeFi concept explanations with real examples

#### 3.4.4 Social Features
- **Share Card Generation:**
  - Leaderboard position
  - Performance metrics
  - Custom message
  - QR code for app download
- **Invite System:**
  - Unique referral code
  - Tracking dashboard
  - Bonus structure (both parties)

---

## 4. Technical Architecture

### 4.1 System Architecture
```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   iOS App   │────▶│  API Gateway │────▶│   Aptos     │
│  (Swift)    │     │   (Node.js)  │     │  Testnet    │
└─────────────┘     └──────────────┘     └─────────────┘
       │                    │                     │
       ▼                    ▼                     ▼
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Circle    │     │    Nodit     │     │    Move     │
│   Wallets   │     │   Indexer    │     │  Contracts  │
└─────────────┘     └──────────────┘     └─────────────┘
```

### 4.2 Smart Contract Modules

#### 4.2.1 league_registry.move
```move
module tradeleague::league_registry {
    struct League has key, store {
        id: u64,
        name: String,
        creator: address,
        participants: vector<address>,
        entry_fee: u64,
        prize_pool: u64,
        start_time: u64,
        end_time: u64,
        is_public: bool
    }
    
    public entry fun create_league(
        creator: &signer,
        name: String,
        entry_fee: u64,
        duration: u64,
        is_public: bool
    )
    
    public entry fun join_league(
        user: &signer,
        league_id: u64
    )
    
    public fun get_leaderboard(
        league_id: u64
    ): vector<LeaderboardEntry>
}
```

#### 4.2.2 vault_manager.move
```move
module tradeleague::vault_manager {
    struct Vault has key, store {
        id: u64,
        manager: address,
        strategy: String,
        venue: String,
        total_deposits: u64,
        performance_fee: u64,
        followers: vector<address>,
        historical_performance: vector<u64>
    }
    
    public entry fun create_vault(
        manager: &signer,
        strategy: String,
        venue: String,
        performance_fee: u64
    )
    
    public entry fun follow_vault(
        user: &signer,
        vault_id: u64,
        amount: u64
    )
    
    public entry fun execute_trade(
        manager: &signer,
        vault_id: u64,
        trade_data: vector<u8>
    )
}
```

#### 4.2.3 prediction_market.move
```move
module tradeleague::prediction_market {
    struct Market has key, store {
        id: u64,
        sponsor: String,
        question: String,
        outcomes: vector<String>,
        stakes: vector<u64>,
        resolution_time: u64,
        oracle_source: String,
        resolved: bool,
        winning_outcome: Option<u64>
    }
    
    public entry fun create_market(
        sponsor: &signer,
        question: String,
        outcomes: vector<String>,
        resolution_time: u64
    )
    
    public entry fun place_prediction(
        user: &signer,
        market_id: u64,
        outcome_index: u64,
        amount: u64
    )
    
    public entry fun settle_market(
        oracle: &signer,
        market_id: u64,
        winning_outcome: u64
    )
}
```

### 4.3 API Specification

#### 4.3.1 Authentication
```typescript
POST /api/auth/login
{
  "wallet_address": "0x123...",
  "signature": "0xabc...",
  "message": "Login to TradeLeague",
  "timestamp": 1234567890
}

Response:
{
  "token": "jwt_token",
  "user": {
    "id": "user_123",
    "wallet": "0x123...",
    "username": "@trader",
    "avatar": "ipfs://..."
  }
}
```

#### 4.3.2 League Operations
```typescript
GET /api/leagues
Query: ?type=public&sort=prize_pool&limit=20

POST /api/leagues
{
  "name": "Whale League",
  "entry_fee": 100,
  "duration": 604800,
  "is_public": true,
  "max_participants": 100
}

POST /api/leagues/:id/join
{
  "transaction_hash": "0x..."
}
```

#### 4.3.3 Vault Operations
```typescript
GET /api/vaults
Query: ?venue=hyperion&strategy=yield&sort=performance

POST /api/vaults/:id/follow
{
  "amount": 100,
  "transaction_hash": "0x..."
}

GET /api/vaults/:id/performance
Response: {
  "daily": [/* 30 data points */],
  "weekly": [/* 12 data points */],
  "monthly": [/* 12 data points */]
}
```

### 4.4 Database Schema

```sql
-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    wallet_address VARCHAR(66) UNIQUE NOT NULL,
    username VARCHAR(30) UNIQUE,
    avatar_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    total_volume DECIMAL(20,2) DEFAULT 0,
    invite_code VARCHAR(10) UNIQUE,
    invited_by UUID REFERENCES users(id)
);

-- Leagues Table
CREATE TABLE leagues (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    creator_id UUID REFERENCES users(id),
    entry_fee DECIMAL(10,2),
    prize_pool DECIMAL(20,2),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    is_public BOOLEAN DEFAULT true,
    max_participants INTEGER DEFAULT 100,
    created_at TIMESTAMP DEFAULT NOW()
);

-- League Participants
CREATE TABLE league_participants (
    league_id UUID REFERENCES leagues(id),
    user_id UUID REFERENCES users(id),
    joined_at TIMESTAMP DEFAULT NOW(),
    current_score DECIMAL(20,2) DEFAULT 0,
    rank INTEGER,
    PRIMARY KEY (league_id, user_id)
);

-- Vaults Table
CREATE TABLE vaults (
    id UUID PRIMARY KEY,
    manager_id UUID REFERENCES users(id),
    name VARCHAR(100) NOT NULL,
    strategy VARCHAR(50),
    venue VARCHAR(50),
    total_aum DECIMAL(20,2) DEFAULT 0,
    performance_fee DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT NOW(),
    all_time_return DECIMAL(10,2) DEFAULT 0
);

-- Vault Followers
CREATE TABLE vault_followers (
    vault_id UUID REFERENCES vaults(id),
    user_id UUID REFERENCES users(id),
    amount DECIMAL(20,2),
    followed_at TIMESTAMP DEFAULT NOW(),
    current_value DECIMAL(20,2),
    PRIMARY KEY (vault_id, user_id)
);

-- Predictions Table
CREATE TABLE predictions (
    id UUID PRIMARY KEY,
    market_id UUID NOT NULL,
    user_id UUID REFERENCES users(id),
    outcome_index INTEGER,
    stake DECIMAL(10,2),
    potential_payout DECIMAL(10,2),
    placed_at TIMESTAMP DEFAULT NOW(),
    settled BOOLEAN DEFAULT false,
    won BOOLEAN
);
```

---

## 5. Integration Specifications

### 5.1 Circle Integration
**Purpose:** Wallet infrastructure and USDC management

#### Implementation Details:
- **SDK:** Circle Web3 Services SDK v2.0
- **Endpoints:**
  - Wallet Creation: `POST /w3s/wallets`
  - USDC Transfer: `POST /w3s/transactions/transfer`
  - Balance Query: `GET /w3s/wallets/{id}/balances`
- **Security:**
  - API key stored in secure enclave
  - Transaction signing via biometric auth
  - Session management with 24h expiry

### 5.2 Hyperion Integration
**Purpose:** Concentrated Liquidity Market Maker (CLMM) with advanced SDK
**Website:** https://hyperion.xyz/

#### Key Features:
- **Concentrated Liquidity:** Capital efficiency up to 4000x
- **Composability Solutions:** Build on top of CLMM infrastructure
- **Advanced SDK:** Full-featured development toolkit
- **Liquidity Optimization:** Automated range management

#### SDK Implementation:
```typescript
interface HyperionSDK {
  // CLMM Operations
  async createConcentratedPosition(params: {
    pool: string,
    lowerTick: number,
    upperTick: number,
    liquidity: number,
    token0Amount: number,
    token1Amount: number
  }): Promise<PositionNFT>
  
  async adjustRange(params: {
    positionId: number,
    newLowerTick: number,
    newUpperTick: number
  }): Promise<TransactionResult>
  
  // Composability Features
  async deployStrategy(params: {
    strategyType: 'RangeOrder' | 'Momentum' | 'MeanReversion',
    parameters: StrategyParams
  }): Promise<StrategyContract>
  
  // Analytics
  async getPositionMetrics(positionId: number): Promise<{
    currentValue: number,
    fees24h: number,
    impermanentLoss: number,
    apr: number
  }>
  
  async simulatePosition(params: SimulationParams): Promise<SimulationResult>
}
```

#### TradeLeague Composability Solutions:
1. **Auto-Range Vault:** Automatically adjusts liquidity ranges based on volatility
2. **Fee Harvester:** Compounds earned fees back into positions
3. **Delta-Neutral Strategy:** Maintains market-neutral exposure
4. **Liquidity Mining Optimizer:** Maximizes rewards across multiple pools

### 5.3 Merkle Trade Integration
**Purpose:** Perpetual futures strategies

#### Key Features:
- Leverage control (1x-10x)
- Stop loss automation
- Funding rate optimization
- Cross-margin management

### 5.4 Tapp.Exchange Integration
**Purpose:** Innovative pools with composable hooks and dynamic fees
**Documentation:** https://github.com/tapp-exchange/hook-documentation

#### Key Features:
- **Dynamic Fee System:** Adaptive fees based on market conditions
- **Composable Hooks:** Custom logic for advanced strategies
- **Tapp Points:** Reward layer for liquidity providers
- **Managed Custody:** Security handled by Tapp.Exchange

#### Hooks Implementation:
```typescript
interface TappHook {
  // Hook lifecycle methods
  beforeSwap(params: SwapParams): ValidationResult
  afterSwap(params: SwapParams, result: SwapResult): void
  beforeAddLiquidity(params: LiquidityParams): ValidationResult
  afterAddLiquidity(params: LiquidityParams, result: LPTokens): void
  
  // Custom strategies
  dynamicFeeCalculation(params: {
    volume24h: number,
    volatility: number,
    liquidity: number
  }): number
  
  rebalanceStrategy(params: {
    currentRatio: number,
    targetRatio: number,
    slippage: number
  }): RebalanceAction[]
}
```

#### TradeLeague Custom Hooks:
1. **Smart Rebalancing Hook:** Automatically rebalances vault positions
2. **IL Protection Hook:** Hedges against impermanent loss
3. **Yield Optimizer Hook:** Compounds rewards and optimizes APY
4. **Risk Manager Hook:** Enforces position limits and stop losses

#### Tapp Points Integration:
- Users earn Tapp Points for providing liquidity
- Bonus multipliers for TradeLeague vaults
- Points displayed in portfolio dashboard
- Redeemable for trading fee discounts

### 5.5 Panora Integration
**Purpose:** Price feeds and prediction data

#### Oracle Specification:
```typescript
interface PanoraOracle {
  getPrice(token: string): Promise<number>
  getPriceHistory(token: string, period: string): Promise<PricePoint[]>
  subscribeToPriceFeed(tokens: string[], callback: Function): Subscription
}
```

### 5.6 Kana Labs Integration
**Purpose:** Cross-chain liquidity aggregation and bridging
**Website:** https://kanalabs.io/

#### Key Features:
- Multi-chain liquidity aggregation across 100+ chains
- Smart routing for optimal swap rates
- Cross-chain trading without leaving the app
- Seamless USDC bridging to/from Aptos

#### Implementation:
```typescript
interface KanaLabsIntegration {
  async aggregateSwap(params: {
    fromChain: string,
    toChain: string,
    fromToken: string,
    toToken: string,
    amount: number,
    slippage: number
  }): Promise<SwapResult>
  
  async getBestRoute(params: {
    chains: string[],
    inputToken: string,
    outputToken: string,
    amount: number
  }): Promise<Route[]>
  
  async bridgeAssets(params: {
    sourceChain: string,
    destChain: 'aptos',
    token: string,
    amount: number
  }): Promise<BridgeReceipt>
}
```

#### Bridge Flow:
1. Initiate cross-chain swap via Kana API
2. Smart routing finds optimal path
3. Execute multi-hop swaps if needed
4. Bridge assets to Aptos
5. Credit user TradeLeague account
6. Enable immediate trading

### 5.7 Nodit Integration
**Purpose:** Enterprise-grade Aptos infrastructure and data indexing
**Developer Portal:** https://developer.nodit.io/reference/aptos-quickstart

#### Core Services:
- **High-Performance RPC:** 99.99% uptime guaranteed
- **Real-time Indexing:** Sub-second data updates
- **Historical Data API:** Complete transaction history
- **WebSocket Streams:** Live event subscriptions
- **Analytics Dashboard:** On-chain metrics and insights

#### Implementation:
```typescript
interface NoditProvider {
  // RPC Methods
  async getAccount(address: string): Promise<AccountData>
  async getTransactions(params: {
    address: string,
    limit: number,
    offset: number
  }): Promise<Transaction[]>
  
  // Indexer Methods
  async queryEvents(params: {
    module: string,
    event_type: string,
    start_time: number,
    end_time: number
  }): Promise<Event[]>
  
  // WebSocket Subscriptions
  subscribe(channel: 'transactions' | 'events' | 'blocks', 
           filter: FilterParams,
           callback: (data: any) => void): Subscription
}
```

#### WebSocket Events:
```typescript
// Real-time leaderboard updates
nodit.subscribe('events', {
  module: 'tradeleague::league_registry',
  event_type: 'ScoreUpdateEvent'
}, (event) => {
  updateLeaderboard({
    user_id: event.user,
    league_id: event.league,
    new_score: event.score,
    rank_change: event.rank_delta
  })
})

// Transaction monitoring
nodit.subscribe('transactions', {
  function: 'tradeleague::vault_manager::execute_trade'
}, (tx) => {
  processVaultTrade(tx)
})
```

### 5.8 Ekiden Integration
**Purpose:** Derivatives prediction markets

#### Contract Interface:
- Create futures markets
- Settlement price feeds
- Automatic expiry handling
- PnL distribution

---

## 6. User Experience Design

### 6.1 Design Principles
1. **Mobile-First:** Optimized for one-handed use
2. **Progressive Disclosure:** Complex features revealed gradually
3. **Social Proof:** Visible success stories and peer activities
4. **Instant Gratification:** Immediate feedback on all actions
5. **Error Prevention:** Confirmation dialogs for irreversible actions

### 6.2 Visual Design System

#### Color Palette
```css
--primary: #6C5CE7;      /* TradeLeague Purple */
--secondary: #00B894;    /* Success Green */
--danger: #FF6B6B;       /* Loss Red */
--background: #0A0E27;   /* Deep Navy */
--surface: #151A3A;      /* Card Background */
--text-primary: #FFFFFF;
--text-secondary: #8B92B9;
```

#### Typography
```css
--heading-1: 600 32px/40px 'SF Pro Display';
--heading-2: 600 24px/32px 'SF Pro Display';
--body: 400 16px/24px 'SF Pro Text';
--caption: 400 14px/20px 'SF Pro Text';
--mono: 400 14px/20px 'SF Mono';
```

### 6.3 Navigation Flow
```
App Launch
    ├── Splash Screen (1s)
    ├── Wallet Check
    │   ├── Has Wallet → Home
    │   └── No Wallet → Onboarding
    │
    ├── Tab Bar (Always Visible)
    │   ├── League (Trophy Icon)
    │   ├── Trade (Chart Icon)
    │   ├── Predict (Crystal Ball Icon)
    │   └── You (Profile Icon)
    │
    └── Deep Links
        ├── Invite Link → Auto Wallet Creation
        ├── League Link → Join League
        └── Vault Link → Follow Vault
```

### 6.4 Micro-interactions
- **Pull to Refresh:** Spring animation with haptic feedback
- **Success States:** Confetti animation + sound
- **Loading States:** Skeleton screens with shimmer
- **Transitions:** 60fps slide/fade animations
- **Gestures:** Swipe to delete, long press for options

---

## 7. Security & Compliance

### 7.1 Security Measures
- **Wallet Security:**
  - Biometric authentication
  - Secure enclave key storage
  - Transaction signing isolation
  - Session timeout (30 min idle)

- **Smart Contract Security:**
  - Formal verification of Move modules
  - Reentrancy guards
  - Access control via capabilities
  - Time-locked admin functions

- **API Security:**
  - Rate limiting (100 req/min)
  - JWT with refresh tokens
  - Request signing
  - IP whitelisting for admin

### 7.2 Data Privacy
- **User Data:**
  - Minimal PII collection
  - Encrypted at rest (AES-256)
  - GDPR-compliant deletion
  - No third-party sharing

- **Transaction Privacy:**
  - No logging of amounts
  - Anonymized analytics
  - Opt-in data sharing

### 7.3 Testnet Considerations
- Clear "TESTNET" labels
- No real money involved disclaimers
- Educational content about testnet vs mainnet
- Automatic reset warnings

---

## 8. Analytics & Monitoring

### 8.1 Key Performance Indicators

#### User Acquisition
- Daily Active Users (DAU)
- Monthly Active Users (MAU)
- User Retention (D1, D7, D30)
- Viral Coefficient (K-factor)
- Cost Per Acquisition (CPA)

#### Engagement Metrics
- Sessions per User
- Session Duration
- Features Used per Session
- Social Actions (follows, shares)
- Push Notification CTR

#### Financial Metrics
- Total Value Locked (TVL)
- Daily Trading Volume
- Average Deposit Size
- Vault Performance Distribution
- Prediction Market Volume

### 8.2 Event Tracking
```typescript
// Core Events
track('app_opened', { source: 'notification' | 'direct' })
track('wallet_created', { method: 'invite' | 'organic' })
track('league_joined', { league_id, entry_fee })
track('vault_followed', { vault_id, amount })
track('prediction_placed', { market_id, outcome, stake })
track('reward_claimed', { amount, type })
track('invite_sent', { channel: 'sms' | 'link' })
```

### 8.3 Error Monitoring
- Sentry integration for crash reporting
- Custom error boundaries
- Network failure tracking
- Smart contract revert reasons
- User feedback collection

---

## 9. Go-to-Market Strategy

### 9.1 Launch Phases

#### Phase 1: Closed Beta (Week 1-2)
- 100 invited users
- Core feature testing
- Bug fixes and optimization
- Influencer seeding

#### Phase 2: Open Beta (Week 3-4)
- Public testnet launch
- Marketing campaign start
- Community building
- Sponsor activations

#### Phase 3: Growth (Week 5+)
- Referral program activation
- Paid acquisition
- Content marketing
- Partnership announcements

### 9.2 User Acquisition Channels
1. **Organic Social:** Twitter, TikTok, Discord
2. **Influencer Partnerships:** Crypto Twitter KOLs
3. **Sponsor Channels:** Cross-promotion with partners
4. **Referral Program:** 10 USDC for successful invites
5. **Content Marketing:** Blog, YouTube tutorials

### 9.3 Retention Strategy
- **Daily Rewards:** Login streaks
- **Weekly Tournaments:** Sponsored prizes
- **Social Features:** Friend activity feed
- **Achievement System:** Badges and titles
- **Push Notifications:** Price alerts, league updates

---

## 10. Development Roadmap

### 10.1 MVP Timeline (8 weeks)

#### Weeks 1-2: Foundation
- [ ] Smart contract development
- [ ] Circle wallet integration
- [ ] Basic iOS app structure
- [ ] API development

#### Weeks 3-4: Core Features
- [ ] League functionality
- [ ] Vault following system
- [ ] Basic prediction markets
- [ ] Portfolio tracking

#### Weeks 5-6: Integrations
- [ ] DEX integrations (Hyperion, Merkle, Tapp)
- [ ] Oracle integrations (Panora, Nodit)
- [ ] Cross-chain support (Kana)
- [ ] Derivatives (Ekiden)

#### Weeks 7-8: Polish & Launch
- [ ] UI/UX refinements
- [ ] Performance optimization
- [ ] Security audit
- [ ] Beta testing
- [ ] Marketing preparation

### 10.2 Post-MVP Features

#### Version 1.1 (Month 2)
- Tokenized trader cards (NFTs)
- Advanced charting tools
- Social feed with trade sharing
- Multi-language support

#### Version 1.2 (Month 3)
- Real World Assets (RWA) vaults
- Telegram mini-app
- Desktop web app
- Advanced analytics dashboard

#### Version 2.0 (Month 4+)
- Mainnet migration
- Fiat on-ramp integration
- Institutional features
- DAO governance

---

## 11. Risk Analysis

### 11.1 Technical Risks
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Smart contract vulnerability | Medium | High | Formal verification, audits |
| Scalability issues | Low | Medium | Caching, indexing optimization |
| Third-party API failures | Medium | Medium | Fallback providers, queuing |
| iOS app rejection | Low | High | Compliance review, TestFlight |

### 11.2 Business Risks
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Low user adoption | Medium | High | Aggressive marketing, incentives |
| Regulatory changes | Low | High | Legal counsel, compliance |
| Partner dependencies | Medium | Medium | Multiple integrations per feature |
| Market volatility | High | Low | Testnet environment, education |

---

## 12. Success Criteria

### 12.1 Hackathon Judging Metrics
1. **Innovation:** Novel approach to DeFi onboarding ✓
2. **Technical Excellence:** Clean architecture, security ✓
3. **User Experience:** Intuitive, beautiful interface ✓
4. **Ecosystem Integration:** 8+ Aptos partners ✓
5. **Market Potential:** Clear path to mainnet ✓

### 12.2 Demo Script (90 seconds)

**0:00-0:10** - App opens to League page, scrolling leaderboard
"TradeLeague brings social trading to Aptos"

**0:10-0:25** - Join Circle League, show rewards
"Compete in sponsored leagues with real prizes"

**0:25-0:40** - Navigate to Trade, follow top vault
"Copy successful traders with one tap"

**0:40-0:55** - Enter Panora price prediction
"Predict markets powered by ecosystem partners"

**0:55-1:10** - Show portfolio gains in You tab
"Track performance and claim rewards"

**1:10-1:25** - Generate and share social card
"Invite friends to grow your league"

**1:25-1:30** - Close with tagline
"TradeLeague: Where DeFi Meets Social"

---

## 13. Appendices

### 13.1 Glossary
- **Vault:** Managed trading strategy users can follow
- **League:** Competitive group with leaderboard
- **Prediction Market:** Binary or multiple-choice betting market
- **TVL:** Total Value Locked in protocol
- **Testnet:** Aptos test environment with fake money

### 13.2 Resources
- [Aptos Documentation](https://aptos.dev)
- [Circle Web3 Services](https://developers.circle.com/w3s/docs)
- [Move Language Guide](https://aptos.dev/move/move-on-aptos)
- [Partner Documentation Links](#integrations-by-sponsor)

### 13.3 Contact Information
- **Product:** product@tradeleague.xyz
- **Technical:** dev@tradeleague.xyz
- **Partnerships:** partners@tradeleague.xyz
- **Support:** help@tradeleague.xyz

---

*This PRD represents the complete specification for TradeLeague MVP. For questions or clarifications, please contact the product team.*

**Document Version Control:**
- v1.0 - Initial Release (September 2025)
- Last Updated: September 12, 2025
- Next Review: Post-MVP Launch

---

## 6.5 iOS UI Design Specification (Strava-Orange Inspired)

### Core Aesthetic

**Design Language:** Sporty, energetic, bold — orange as the hero color, softened with whites, greys, and translucent glass panels.

**Tone:** Dynamic and motivating, with a competitive edge (leaderboards and live updates feel like sports scores).

**Interaction Style:** Glass cards, smooth gradients, high-contrast typography, bold orange CTAs.

### Color Palette
```css
--primary: #FC5200;      /* Strava Orange */
--secondary: #FF7A33;    /* Gradient variation */
--background: #FFFFFF;   /* Clean white */
--surface: rgba(255,255,255,0.6); /* Glass blur */
--text-primary: #111111;
--text-secondary: #666666;
--divider: #E0E0E0;
```

**Usage:**
- Orange → CTAs, active tabs, graph highlights
- White → Main page backgrounds
- Grey → Labels, muted elements
- Glass → Leaderboards, trade cards, prediction markets

### Typography
```css
--heading-1: 700 32px/40px 'SF Pro Display';
--heading-2: 600 24px/32px 'SF Pro Display';
--body: 400 16px/24px 'SF Pro Text';
--caption: 400 14px/20px 'SF Pro Text';
--mono: 500 14px/20px 'SF Mono';
```

- Headlines: Bold, in black or orange
- Numbers/Metrics: Monospaced, bold (like live sports data)
- Body Text: Neutral grey for instructions

### Layout & Components

**Hero Section:** White base with angled orange gradient stripe; central glass leaderboard card; bold orange CTA.

**Leaderboards & Cards:** White glass with blur and light grey borders; hover/active → orange glow with smooth scale-up.

**Navigation:**
- Top nav: White background, black text, orange active state.
- Bottom nav (League, Trade, Predict, You): Glass bar with orange icons.

### Motion & Transitions

- Page transitions: Fade-slide with orange sweep.
- Hover/active states: Light orange highlight + small scale-up.
- Loading: Skeleton shimmer in orange/grey.
- Success: Pulse glow on CTAs, subtle orange-white confetti.

### Glass Defaults

- Cards: rgba(255,255,255,0.5) with backdrop-filter: blur(20px)
- Borders: 1px solid rgba(255,255,255,0.4) + faint shadow
- Layering: Overlapping translucent cards for depth

### Gradients & Overlays

- CTA Buttons: linear-gradient(90deg, #FC5200, #FF7A33)
- Highlight Stripes: Orange gradient diagonals behind cards
- Charts: Orange line with soft white glow, grey gridlines

### Accessibility

- Black/orange on white for high contrast
- Glass retains enough opacity for readability
- Reduced motion toggle disables animations

## 6.6 Motion & Animation (Pow-powered)

### Goals

- Feel fast, sporty, and precise (no bouncy, rubbery lag).
- Celebrate wins; stay minimal elsewhere.
- Never block taps; all animations are interruptible and spring back to "real time."

**Library:** Pow by EmergeTools ([GitHub](https://github.com/EmergeTools/Pow))

### Global Motion Tokens

#### Durations
- xfast: 120ms   (tiny affordances: tab icon taps, button press)
- fast:  180ms   (card hovers, chip selects)
- base:  240ms   (page transitions, list inserts/removes)
- slow:  320ms   (hero/celebration accents, modal present)

#### Easing / Springs (Pow presets or custom)
- snap:         critically-damped snap-in for small UI feedback
- sharpSpring:  response 0.42, dampingRatio 0.82 (default)
- glide:        response 0.30, dampingRatio 0.78 (scroll-linked)
- settle:       response 0.22, dampingRatio 0.90 (final settle)

#### Staggers
- listEnter: 30ms between siblings (max 6 items)
- confettiBurst: 12–18ms randomized

### Page Transitions (League / Trade / Predict / You)

- **In:** fade+slide 8–12pt from the trailing edge, base duration, sharpSpring.
- **Out:** quick fade 0.12s; content scales to 0.985 to imply depth.
- **Hero Stripe:** a subtle orange sweep (8% opacity) runs diagonally over 220ms on first appearance only.

### Cards & Leaderboards

- **Hover/Active:** scale 1.00 → 1.02 (xfast, snap), shadow elevation +1; orange rim glow fades in 140ms.
- **Insert/Remove:** vertical slide 10–14pt with spring sharpSpring; cross-fade text.
- **Live Rank Change:** number flips with y-axis 3D turn (max 8°), duration 160ms, snap. Green arrow ticks up; red ticks down.

### Charts & Metrics

- **Line draw:** 240ms reveal on first load; thereafter morph with glide.
- **Number roll:** monospaced counter tween with per-digit spring (xfast); no blur.
- **Gain/Loss flash:** 80ms flash on series color, immediately settles.

### Buttons & CTAs

- **Press:** scale 0.98 → 1.00 on release (xfast), shadow lifts.
- **Success Pulse:** 2 pulses over 360ms total; then settle.
- **Disabled → Enabled:** 140ms tint/opacity crossfade.

### Loading & Skeletons

- **Shimmer:** left→right 900ms, subtle orange/grey gradient, 12% amplitude.
- **Defer:** content appears in small groups (3–5 elements) with 30ms stagger.

### Celebration Moments

**Win / Payout / New Rank:** micro-confetti (orange/white), 650ms total, 24 particles max; haptic .success. Snapshot card gently pops (1.00 → 1.04 → 1.00).

### Reduced Motion

If Reduce Motion is on: replace movement with opacity/scale ≤ 1% changes; disable confetti and 3D flips; keep focus outlines and color feedback intact.

### Pow Integration (SwiftUI examples)

Assumes Pow is added via Swift Package Manager.

#### 1) Sharp, interruptible page transition
```swift
import SwiftUI
import Pow

struct PageTransition: ViewModifier {
    @State private var appear = false
    func body(content: Content) -> some View {
        content
            .opacity(appear ? 1 : 0)
            .offset(x: appear ? 0 : 12, y: 0)
            .animation(.spring(response: 0.24, dampingRatio: 0.82), value: appear)
            .onAppear { appear = true }
    }
}
extension View {
    func sharpPageTransition() -> some View {
        modifier(PageTransition())
    }
}
```

#### 2) Live rank change "flip" and arrow tick
```swift
struct RankView: View {
    @State var rank: Int
    @State private var tilt = false

    var body: some View {
        HStack(spacing: 8) {
            Text("#\(rank)")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .rotation3DEffect(.degrees(tilt ? 0 : 8),
                                  axis: (x: 0, y: 1, z: 0))
                .animation(.spring(response: 0.16, dampingRatio: 1.0), value: tilt)

            Image(systemName: "arrowtriangle.up.fill") // or .down.fill
                .scaleEffect(tilt ? 1.0 : 0.8)
                .animation(.spring(response: 0.14, dampingRatio: 0.9), value: tilt)
        }
        .onChange(of: rank) { _ in
            tilt.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { tilt.toggle() }
        }
    }
}
```

#### 3) Card press feedback (snap)
```swift
struct PressableCard<Content: View>: View {
    @GestureState private var isPressed = false
    let content: () -> Content

    var body: some View {
        content()
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.12, dampingRatio: 1.0), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
            )
    }
}
```

#### 4) Number roll (per-digit spring)
```swift
struct MetricNumber: View {
    let value: Int
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(String(value)), id: \.self) { ch in
                Text(String(ch))
                    .font(.system(.title2, design: .monospaced).weight(.bold))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.12, dampingRatio: 0.95), value: value)
            }
        }
    }
}
```

#### 5) Confetti celebration (lightweight)

Use Pow's particle utilities or a simple CAEmitterLayer wrapper; cap particles to ≤24 and lifespan ≤0.65s. Trigger only on truly meaningful milestones (league win, payout claimed, new personal best).

### Performance Budget & QA

- **Frame rate:** 120 fps on ProMotion, 60 fps otherwise; frame time ≤ 8ms target.
- **Overdraw:** ≤ 3×; avoid nested blurs; reuse glass layers.
- **Haptics:** .light for taps, .medium for commit, .success for celebrations; never layer multiple haptics.
- **Accessibility checks:** VoiceOver focus doesn't move during animation; reduced-motion path verified.
- **Test matrix:** iPhone 12, 13, 15 Pro (ProMotion), low-power mode on/off, dark/light, Reduce Motion on/off.

### Developer notes

- Keep animations cancelable: use state-driven springs rather than fixed timers.
- Prefer spring(response:dampingRatio:) over cubic-bezier for "sporty" feel.
- Limit simultaneous animating layers to ≤ 5 per screen.

---