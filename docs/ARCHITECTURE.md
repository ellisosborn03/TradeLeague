# TradeLeague Architecture

## System Overview

TradeLeague is a social DeFi super app built on Aptos with a mobile-first architecture. The system consists of multiple layers working together to deliver a seamless trading experience.

```
┌─────────────────────────────────────────────────────────┐
│                    Client Layer                         │
│  ┌──────────────────┐      ┌──────────────────┐        │
│  │  React Native    │      │   SwiftUI iOS    │        │
│  │   Mobile App     │      │   Native App     │        │
│  └──────────────────┘      └──────────────────┘        │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   API Gateway Layer                     │
│              Node.js / Express Backend                  │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  PostgreSQL  │  │    Redis     │  │Aptos Blockchain│
│   Database   │  │    Cache     │  │  Move Smart  │
│              │  │              │  │  Contracts   │
└──────────────┘  └──────────────┘  └──────────────┘
                                            │
                          ┌─────────────────┼─────────────────┐
                          ▼                 ▼                 ▼
                  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
                  │ Merkle Trade │  │  Hyperion    │  │    Tapp      │
                  │    (Perps)   │  │   (CLMM)     │  │  (Hooks)     │
                  └──────────────┘  └──────────────┘  └──────────────┘
```

## Component Architecture

### 1. Mobile Applications

#### React Native App (`/TradeLeague`)
- **Cross-platform**: iOS and Android support
- **TypeScript**: Type-safe development
- **State Management**: React Context + Hooks
- **Navigation**: React Navigation
- **Styling**: Styled Components

**Key Modules:**
```
TradeLeague/
├── src/
│   ├── components/        # Reusable UI components
│   ├── screens/           # Screen components
│   ├── navigation/        # Navigation configuration
│   ├── services/          # API and blockchain services
│   ├── hooks/             # Custom React hooks
│   ├── context/           # Global state management
│   ├── utils/             # Utility functions
│   └── types/             # TypeScript definitions
├── ios/                   # iOS native code
└── android/               # Android native code
```

#### SwiftUI App (`/TradeLeague-SwiftUI`)
- **Native iOS**: SwiftUI for optimal performance
- **MVVM Architecture**: Clean separation of concerns
- **Combine Framework**: Reactive programming
- **Aptos SDK Integration**: Direct blockchain interaction

**Key Modules:**
```
TradeLeague-SwiftUI/
├── Models/               # Data models
├── Views/                # SwiftUI views
├── Services/             # Business logic and API
├── Core/                 # Core utilities and theme
└── Assets.xcassets/      # Images and assets
```

### 2. Backend API

#### Node.js / Express Server
- **RESTful API**: Standard HTTP endpoints
- **Authentication**: JWT-based auth
- **Real-time Updates**: WebSocket support
- **Rate Limiting**: API throttling

**API Structure:**
```
/api/v1/
├── /auth              # Authentication endpoints
├── /users             # User management
├── /leagues           # League operations
├── /predictions       # Prediction markets
├── /vaults            # Vault following
├── /leaderboards      # Rankings and scores
├── /activities        # Activity feed
└── /transactions      # Transaction history
```

### 3. Database Layer

#### PostgreSQL Schema
```sql
-- Core Tables
users
  - id (UUID)
  - wallet_address (String)
  - username (String)
  - created_at (Timestamp)

leagues
  - id (UUID)
  - name (String)
  - type (Enum: perps, prediction, vault)
  - sponsor_id (UUID)
  - start_date (Timestamp)
  - end_date (Timestamp)

league_participants
  - league_id (UUID)
  - user_id (UUID)
  - score (Numeric)
  - rank (Integer)

predictions
  - id (UUID)
  - market_id (String)
  - user_id (UUID)
  - prediction (Numeric)
  - amount (Numeric)

vault_follows
  - id (UUID)
  - follower_id (UUID)
  - vault_address (String)
  - auto_copy (Boolean)

activities
  - id (UUID)
  - user_id (UUID)
  - action_type (Enum)
  - metadata (JSONB)
  - created_at (Timestamp)
```

#### Redis Cache
- **Session Storage**: User sessions
- **Real-time Data**: Leaderboard caching
- **Rate Limiting**: Request tracking
- **Pub/Sub**: Real-time notifications

### 4. Blockchain Layer

#### Aptos Move Smart Contracts

**Contract Architecture:**
```
contracts/
├── sources/
│   ├── league_manager.move      # League creation and management
│   ├── prediction_market.move   # Prediction market logic
│   ├── vault_manager.move       # Vault following
│   ├── reward_distributor.move  # Prize distribution
│   └── referral_tracker.move    # Referral system
└── Move.toml                    # Package configuration
```

**Key Smart Contract Functions:**

```move
// League Manager
public entry fun create_league(
    creator: &signer,
    name: String,
    entry_fee: u64,
    prize_pool: u64,
    start_time: u64,
    end_time: u64
)

public entry fun join_league(
    participant: &signer,
    league_id: address
)

// Prediction Market
public entry fun create_prediction(
    creator: &signer,
    market_id: String,
    end_time: u64
)

public entry fun place_bet(
    bettor: &signer,
    prediction_id: address,
    amount: u64,
    outcome: bool
)

// Vault Manager
public entry fun create_vault_strategy(
    creator: &signer,
    name: String,
    description: String
)

public entry fun follow_vault(
    follower: &signer,
    vault_address: address,
    allocation_percentage: u8
)
```

### 5. Integration Layer

#### DeFi Protocol Integrations

**Merkle Trade (Perpetuals)**
- Position management
- Leverage control
- PnL tracking
- Risk scoring

**Hyperion (CLMM)**
- Liquidity provision
- Fee collection
- IL monitoring
- Strategy optimization

**Tapp (Custom Hooks)**
- Pre-trade hooks
- Post-trade hooks
- Custom logic execution
- Strategy automation

## Data Flow

### 1. User Authentication Flow
```
1. User opens app
2. App checks for existing session
3. If no session:
   a. User connects wallet (Petra/Aptos Keyless)
   b. App generates JWT token
   c. Token stored in secure storage
4. JWT included in all API requests
5. Backend validates JWT
6. Session cached in Redis
```

### 2. League Join Flow
```
1. User browses available leagues
2. User selects league to join
3. Frontend calls POST /api/v1/leagues/{id}/join
4. Backend validates:
   - User eligibility
   - Entry fee availability
5. Backend initiates blockchain transaction
6. Smart contract processes entry:
   - Transfers entry fee
   - Adds user to participants
   - Emits join event
7. Backend updates database
8. Real-time notification sent via WebSocket
9. UI updates with confirmation
```

### 3. Prediction Market Flow
```
1. User views active predictions
2. User makes prediction + stakes tokens
3. Frontend validates input
4. Frontend calls POST /api/v1/predictions
5. Backend creates transaction:
   - Calls prediction_market::place_bet
   - Locks tokens in smart contract
6. Smart contract:
   - Validates market is open
   - Records prediction
   - Emits bet placed event
7. Backend stores prediction in DB
8. Cache invalidated for leaderboard
9. UI shows confirmation
10. At market resolution:
    - Oracle provides outcome
    - Smart contract distributes rewards
    - Leaderboards updated
```

### 4. Vault Following Flow
```
1. User discovers top-performing vaults
2. User selects vault to follow
3. User sets allocation percentage
4. Frontend calls POST /api/v1/vaults/follow
5. Backend initiates transaction:
   - Calls vault_manager::follow_vault
   - Sets auto-copy parameters
6. When vault executes trade:
   - Smart contract detects trade
   - Copies trade to follower's account
   - Adjusts for allocation percentage
7. Backend tracks performance
8. Real-time updates via WebSocket
```

## Security Architecture

### 1. Authentication & Authorization
- **Wallet-based Auth**: No passwords, wallet signatures
- **Aptos Keyless**: Account abstraction for seamless UX
- **JWT Tokens**: Short-lived tokens (1 hour)
- **Refresh Tokens**: Secure refresh mechanism
- **Role-based Access**: Admin, user, sponsor roles

### 2. Smart Contract Security
- **Access Control**: Only authorized callers
- **Reentrancy Guards**: Protection against reentrancy attacks
- **Integer Overflow**: Safe math operations
- **Emergency Pause**: Admin pause functionality
- **Time Locks**: Delayed admin actions

### 3. Data Security
- **Encryption at Rest**: Database encryption
- **HTTPS Only**: All API calls encrypted
- **Input Validation**: Strict validation on all inputs
- **SQL Injection Prevention**: Parameterized queries
- **XSS Prevention**: Output sanitization

### 4. Infrastructure Security
- **Rate Limiting**: Prevent DDoS attacks
- **CORS Configuration**: Restricted origins
- **API Key Rotation**: Regular key updates
- **Audit Logging**: Comprehensive activity logs
- **Backup Strategy**: Regular automated backups

## Performance Optimization

### 1. Frontend Optimization
- **Code Splitting**: Lazy load components
- **Image Optimization**: Compressed images, lazy loading
- **Bundle Size**: Tree shaking, minification
- **Caching**: Local storage for static data
- **Memoization**: React.memo for expensive components

### 2. Backend Optimization
- **Database Indexing**: Optimized queries
- **Connection Pooling**: Efficient DB connections
- **Caching Strategy**: Redis for hot data
- **Query Optimization**: Efficient joins and aggregations
- **Load Balancing**: Horizontal scaling

### 3. Blockchain Optimization
- **Batch Transactions**: Group multiple operations
- **Gas Optimization**: Efficient contract code
- **Event Indexing**: Quick historical data access
- **Parallel Execution**: Leverage Aptos parallelism

## Monitoring & Observability

### 1. Application Monitoring
- **Error Tracking**: Sentry integration
- **Performance Monitoring**: New Relic / DataDog
- **User Analytics**: Mixpanel / Amplitude
- **A/B Testing**: Feature flag system

### 2. Infrastructure Monitoring
- **Server Metrics**: CPU, memory, disk usage
- **API Metrics**: Response times, error rates
- **Database Metrics**: Query performance, connection count
- **Blockchain Metrics**: Transaction success rate, gas costs

### 3. Alerting
- **Error Alerts**: Critical errors notify team
- **Performance Alerts**: Slow queries, high latency
- **Security Alerts**: Unusual activity patterns
- **Business Metrics**: Unusual trading patterns

## Scalability Strategy

### 1. Horizontal Scaling
- **Load Balancing**: Distribute traffic across servers
- **Auto-scaling**: Dynamic server provisioning
- **Database Sharding**: Partition large tables
- **CDN**: Static asset delivery

### 2. Caching Strategy
- **L1 Cache**: In-memory application cache
- **L2 Cache**: Redis distributed cache
- **L3 Cache**: CDN edge caching
- **Cache Invalidation**: Smart invalidation strategies

### 3. Database Scaling
- **Read Replicas**: Separate read/write loads
- **Connection Pooling**: Efficient connection management
- **Query Optimization**: Index optimization
- **Archival Strategy**: Move old data to cold storage

## Development Workflow

### 1. Local Development
```bash
# Backend
cd TradeLeague/backend
npm install
npm run dev

# Mobile (React Native)
cd TradeLeague
npm install
npx react-native run-ios

# Mobile (SwiftUI)
open TradeLeague-SwiftUI/TradeLeague.xcodeproj
# Run in Xcode
```

### 2. Testing Strategy
- **Unit Tests**: Jest for backend, XCTest for iOS
- **Integration Tests**: API endpoint testing
- **E2E Tests**: Detox for mobile
- **Smart Contract Tests**: Move test framework

### 3. CI/CD Pipeline
```
1. Git push to branch
2. GitHub Actions triggered
3. Run linters and formatters
4. Run unit tests
5. Run integration tests
6. Build application
7. Deploy to staging (on main)
8. Manual approval for production
9. Deploy to production
```

## Future Architecture Enhancements

### Planned Improvements
1. **Microservices**: Split monolith into services
2. **GraphQL**: Replace REST with GraphQL
3. **Message Queue**: RabbitMQ for async processing
4. **Data Warehouse**: Analytics data lake
5. **ML Pipeline**: Recommendation engine
6. **Multi-chain**: Support additional blockchains
7. **Decentralized Storage**: IPFS for user data

---

**Last Updated**: October 2025
**Version**: 1.0.0
