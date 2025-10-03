# TradeLeague: Social DeFi Gaming on Aptos

**TradeLeague** is a comprehensive social trading platform built on Aptos that gamifies DeFi participation through leagues, vault following, and prediction markets.

## 🚀 Quick Start

```bash
# Install dependencies for mobile app
cd TradeLeague
npm install

# Run on iOS
npx react-native run-ios

# Run on Android
npx react-native run-android
```

## 📁 Project Structure

```
Aptos/
├── TradeLeague/              # React Native mobile application
│   ├── contracts/            # Move smart contracts
│   ├── ios/                  # iOS native code
│   └── README.md             # Mobile app documentation
│
├── TradeLeague-SwiftUI/      # Native iOS SwiftUI application
│
├── docs/                     # All documentation
│   ├── hackathon/            # CTRL+Move hackathon materials
│   ├── product/              # PRD, demos, and product specs
│   ├── development/          # Development guides and notes
│   └── setup/                # Setup and integration guides
│
└── scripts/                  # Utility scripts
    ├── development/          # Development automation
    └── deployment/           # Deployment and wallet management
```

## 🏆 CTRL+Move Hackathon

TradeLeague is built for the CTRL+Move hackathon (August 4 - October 3, 2025). This project demonstrates:

- ✅ **Real Utility**: Intuitive mobile DeFi experiences
- ✅ **Breakthrough Design**: Gamified social trading
- ✅ **Performance-Driven**: Built on Aptos's parallel execution
- ✅ **Ecosystem Integration**: Merkle Trade, Hyperion, Tapp Exchange

📄 **[View Hackathon Strategy →](docs/hackathon/CTRL_MOVE_HACKATHON.md)**

## 📱 Features

### Core Features
- **League System**: Competitive leagues with leaderboards and rewards
- **Vault Following**: Copy successful DeFi strategies with one tap
- **Prediction Markets**: Sponsored prediction events with prizes
- **Social Trading**: Activity feed, rankings, and trader profiles

### Technical Highlights
- **Aptos Keyless** - Account abstraction for seamless onboarding without seed phrases
- Cross-platform React Native mobile app
- Move smart contracts on Aptos blockchain
- Real-time leaderboards and activity feeds
- Native iOS app with SwiftUI
- PostgreSQL backend with Node.js API

## 📚 Documentation

### Product Documentation
- **[Product Requirements Doc](docs/product/PRD.md)** - Complete feature specifications
- **[Demo Script](docs/product/DEMO_SCRIPT.md)** - Product walkthrough
- **[Platform Integrations](docs/product/PLATFORM_INTEGRATIONS.md)** - DeFi platform partnerships

### Development Guides
- **[Mobile App Setup](docs/setup/mobile/)** - Mobile development setup
- **[Sponsor Logos](docs/development/sponsor-logos/)** - UI customization guides

## 🛠 Technology Stack

**Frontend:**
- React Native (Mobile)
- SwiftUI (Native iOS)
- TypeScript

**Backend:**
- Node.js / Express
- PostgreSQL
- Redis

**Blockchain:**
- Aptos Move
- Aptos SDK
- [Aptos Keyless](https://aptos.dev/build/guides/aptos-keyless) - Account abstraction for passwordless auth
- Petra Wallet integration

## 🔧 Development Scripts

```bash
# Development automation
./scripts/development/auto-commit.sh       # Auto-commit changes
./scripts/development/claude-watcher.sh    # Watch for changes
./scripts/development/add-sponsor-logos.sh # Update sponsor assets

# Deployment
./scripts/deployment/check-wallets.sh      # Verify wallet balances
```

## 🌐 Integrated Platforms

TradeLeague integrates with leading Aptos DeFi protocols:

- **Merkle Trade** - Perpetual futures trading competitions
- **Hyperion** - Concentrated liquidity market making
- **Tapp Exchange** - Custom trading hook development

## 📊 Smart Contract Architecture

The Move smart contracts implement:
- League management and scoring
- Vault following and strategy replication
- Prediction market resolution
- Reward distribution
- Referral tracking

See `TradeLeague/contracts/` for contract source code.

## 🚀 Deployment

### Mobile App
```bash
cd TradeLeague

# iOS
npx react-native run-ios

# Android
npx react-native run-android
```

### Smart Contracts
```bash
cd TradeLeague/contracts

# Deploy to testnet
aptos move publish --profile testnet

# Deploy to mainnet
aptos move publish --profile mainnet
```

## 🤝 Contributing

This project was built for the CTRL+Move hackathon. For questions or collaboration opportunities, please open an issue.

## 📄 License

Copyright © 2025 TradeLeague. All rights reserved.

---

**Built for CTRL+Move Hackathon 2025** | **Powered by Aptos**
