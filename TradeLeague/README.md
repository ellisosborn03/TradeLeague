# TradeLeague: Social DeFi Gaming on Aptos

**TradeLeague** is a comprehensive social trading platform built on Aptos that gamifies DeFi participation through leagues, vault following, and prediction markets. This repository contains the complete implementation including React Native mobile app, Move smart contracts, Node.js backend API, and PostgreSQL database.

## 🚀 Quick Demo

TradeLeague transforms complex DeFi into an intuitive, gamified mobile experience where users can:

- **Compete in Leagues**: Join sponsored leagues and climb leaderboards
- **Follow Top Traders**: Copy successful vault strategies with one tap  
- **Predict Markets**: Participate in sponsored prediction events
- **Earn Rewards**: Get rewarded for performance, referrals, and participation

## 📱 Features

### Core Features
- **League System**: Create/join competitive leagues with leaderboards
- **Vault Following**: Copy trade successful DeFi strategies 
- **Prediction Markets**: Bet on price movements and market outcomes
- **Social Portfolio**: Track performance and share achievements
- **Real-time Updates**: Live leaderboards and market data via WebSocket

### Sponsor Integrations
- **Circle**: Programmable wallets and USDC infrastructure
- **Hyperion**: CLMM liquidity strategies and composability
- **Merkle Trade**: Perpetual futures trading
- **Tapp Exchange**: Hook-based programmable liquidity
- **Panora**: Price feeds and prediction data
- **Kana Labs**: Cross-chain liquidity aggregation
- **Nodit**: Enterprise Aptos infrastructure
- **Ekiden**: On-chain derivatives platform

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React Native  │────│   Backend API   │────│ Aptos Testnet   │
│   Mobile App    │    │   (Node.js)     │    │ Move Contracts  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐             │
         └──────────────│  PostgreSQL DB  │─────────────┘
                        └─────────────────┘
```

### Components

1. **📱 React Native App** (`/TradeLeague/`)
   - TypeScript-based mobile app with beautiful UI
   - Tab navigation: League, Trade, Predict, You
   - Real-time updates via WebSocket
   - Aptos SDK integration

2. **⛓️ Move Smart Contracts** (`/TradeLeague/contracts/`)
   - `league_registry.move`: League creation and management
   - `vault_manager.move`: Trading vault operations
   - `prediction_market.move`: Prediction market logic
   - `prize_router.move`: Reward distribution system

3. **🔧 Backend API** (`/TradeLeague/backend/`)
   - Express.js REST API with TypeScript
   - JWT authentication with wallet signatures
   - Real-time WebSocket server
   - Aptos blockchain event processing

4. **💾 Database** (`/TradeLeague/backend/database/`)
   - PostgreSQL with comprehensive schema
   - 11 tables with proper relationships
   - Automatic triggers and functions
   - Performance optimized indexes

## 🛠️ Setup & Installation

### Prerequisites
- Node.js 18+
- React Native CLI
- PostgreSQL 14+
- iOS development setup (Xcode)
- Aptos CLI (optional)

### 1. Clone Repository
```bash
git clone https://github.com/ellisosborn03/TradeLeague.git
cd TradeLeague
```

### 2. Setup Mobile App
```bash
cd TradeLeague
npm install

# Install iOS dependencies
cd ios && pod install && cd ..

# Start Metro bundler
npm start

# Run on iOS simulator (in another terminal)
npx react-native run-ios
```

### 3. Setup Backend
```bash
cd backend
npm install

# Setup environment variables
cp .env.example .env
# Edit .env with your configuration

# Build TypeScript
npm run build

# Start development server
npm run dev
```

### 4. Setup Database
```bash
# Create PostgreSQL database
createdb tradeleague

# Run schema setup
psql -d tradeleague -f backend/database/schema.sql
```

### 5. Deploy Smart Contracts (Optional)
```bash
cd contracts

# Initialize Aptos CLI
aptos init

# Compile contracts
aptos move compile

# Deploy to testnet
aptos move publish --named-addresses tradeleague=<your-address>
```

## 📋 Environment Configuration

### Backend Environment Variables
```env
# Server
PORT=3000
NODE_ENV=development
JWT_SECRET=your-secret-key

# Database
DB_HOST=localhost
DB_NAME=tradeleague
DB_USER=postgres
DB_PASSWORD=your-password

# Aptos
APTOS_FULLNODE_URL=https://fullnode.testnet.aptoslabs.com/v1
TRADELEAGUE_MODULE_ADDRESS=0x1

# Partners (get from respective platforms)
CIRCLE_API_KEY=your-circle-key
HYPERION_API_KEY=your-hyperion-key
MERKLE_API_KEY=your-merkle-key
# ... etc
```

## 🧪 Testing

### Run Mobile App Tests
```bash
cd TradeLeague
npm test
```

### Run Backend Tests
```bash
cd backend
npm test
```

### Manual Testing Checklist
- [ ] App launches and navigation works
- [ ] User can create/join leagues
- [ ] Vault following interface functional
- [ ] Prediction markets display correctly
- [ ] Portfolio tracking works
- [ ] WebSocket real-time updates
- [ ] Backend API endpoints respond
- [ ] Database operations complete

## 📚 API Documentation

### Authentication
```bash
POST /api/auth/wallet-login
POST /api/auth/create-account
GET /api/auth/me
```

### Leagues
```bash
GET /api/leagues
POST /api/leagues
GET /api/leagues/:id
POST /api/leagues/:id/join
GET /api/leagues/:id/leaderboard
```

### Vaults
```bash
GET /api/vaults
POST /api/vaults/:id/follow
GET /api/vaults/:id/performance
```

### Predictions
```bash
GET /api/predictions
POST /api/predictions/:id/predict
GET /api/predictions/:id/odds
```

### Users
```bash
GET /api/users/profile
GET /api/users/leaderboard
```

### WebSocket Events
```bash
# Subscribe to channels
{"type": "subscribe", "channel": "leagues"}
{"type": "subscribe", "channel": "vault:123"}
{"type": "subscribe", "channel": "prediction:456"}

# Receive updates
{"type": "leaderboard_update", "data": {...}}
{"type": "vault_update", "data": {...}}
{"type": "market_update", "data": {...}}
```

## 🎨 Design System

### Colors
```typescript
const Colors = {
  primary: '#6C5CE7',    // TradeLeague Purple
  secondary: '#00B894',   // Success Green  
  danger: '#FF6B6B',     // Loss Red
  background: '#0A0E27',  // Deep Navy
  surface: '#151A3A',    // Card Background
};
```

### Typography
```typescript
const Typography = {
  h1: { fontSize: 32, fontWeight: '600' },
  h2: { fontSize: 24, fontWeight: '600' },
  body: { fontSize: 16, fontWeight: '400' },
  caption: { fontSize: 12, fontWeight: '400' },
};
```

## 🔗 Smart Contract Addresses

### Testnet Deployments
```
League Registry: 0x1::tradeleague_league_registry
Vault Manager: 0x1::tradeleague_vault_manager  
Prediction Market: 0x1::tradeleague_prediction_market
Prize Router: 0x1::tradeleague_prize_router
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Development Guidelines
- Follow TypeScript strict mode
- Use ESLint and Prettier for code formatting
- Write tests for new features
- Update documentation
- Follow Move coding standards for smart contracts

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Hackathon Demo

### 90-Second Demo Script

**0:00-0:10** - App opens to League page with live leaderboard
> "TradeLeague brings social trading to Aptos testnet"

**0:10-0:25** - Join Circle League sponsored event  
> "Compete in sponsored leagues with real prizes"

**0:25-0:40** - Navigate to Trade tab, follow top-performing vault
> "Copy successful traders with one tap"

**0:40-0:55** - Enter Panora price prediction market
> "Predict markets powered by ecosystem partners"

**0:55-1:10** - Check portfolio gains in You tab
> "Track performance and claim rewards"

**1:10-1:25** - Generate social sharing card with QR code
> "Invite friends to grow your league"

**1:25-1:30** - Close with ecosystem integration highlights
> "TradeLeague: Where DeFi meets social gaming"

### Key Metrics for Judges
- ✅ **Innovation**: Novel social approach to DeFi onboarding
- ✅ **Technical Excellence**: Complete full-stack implementation
- ✅ **User Experience**: Beautiful, intuitive mobile interface  
- ✅ **Ecosystem Integration**: 8+ Aptos partner integrations
- ✅ **Market Potential**: Clear path from testnet to mainnet

## 📞 Support

- **GitHub Issues**: [Create an issue](https://github.com/ellisosborn03/TradeLeague/issues)
- **Email**: team@tradeleague.xyz
- **Discord**: Join our community server

---

**Built with ❤️ for the Aptos ecosystem**

*TradeLeague democratizes DeFi access by transforming complex financial primitives into an intuitive, gamified mobile experience. Join the revolution! 🚀*