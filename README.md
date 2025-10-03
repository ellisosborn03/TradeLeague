# TradeLeague

> Social DeFi super app built on Aptos where users trade, predict, and compete with friends through spot, perps, predictions, and copy trading.

**[@0xTradingLeague](https://twitter.com/0xTradingLeague)** | **[GitHub](https://github.com/ellisosborn03/TradeLeague)** | **[Demo Video](https://youtube.com/watch?v=ykivz0CzOUA)** | **[Pitch Deck](https://canva.com/design/DAGyRYsD7ss/ckNcDvvZfhWKFvmFIddv-Q/view?utm_content=DAGyRYsD7ss&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hb8114c781f)**

---

## 🎯 Overview

TradeLeague is fantasy football for crypto, a social DeFi super app built on Aptos. We transform complex financial primitives into intuitive, gamified mobile experiences where anyone can trade, predict, and compete with friends.

**Options trading already existed, but Robinhood made it accessible.** In the same way, TradeLeague takes DeFi products such as perps, prediction markets, and vault strategies and delivers them through a mobile, easy-to-use app that billions of people are already familiar with.

### 🏆 Leagues: DeFi as a Sport

A novel feature is **leagues**, where users join structured competitions that feel like fantasy sports for crypto. Each league has its own rules, live leaderboards, and rewards, letting friends and communities compete head-to-head. Alongside leagues, vault following and prediction markets give users more ways to engage with DeFi as a sport: sponsored competitions, social bragging rights, and real prizes for performance. This makes trading social, accessible, and fun in a way DeFi has never been.

### ⚡ Built on Aptos

TradeLeague is built natively on Aptos's parallel execution, sub-second finality, and low fees, delivering the speed and scalability needed for production-grade DeFi. We integrate directly with partners like **Merkle Trade**, **Hyperion**, **Tapp**, and **Circle** to showcase composability and real-world financial utility.

**Just as fantasy football turned sports into a global phenomenon, TradeLeague will make DeFi social, competitive, and engaging for everyone.**

## 📹 Demo & Resources

- **[Video Demo](https://youtube.com/watch?v=ykivz0CzOUA)** - Full product walkthrough
- **[Pitch Deck](https://canva.com/design/DAGyRYsD7ss/ckNcDvvZfhWKFvmFIddv-Q/view)** - Complete project presentation
- **[GitHub Repository](https://github.com/ellisosborn03/TradeLeague)** - Open source code
- **[Twitter](https://twitter.com/0xTradingLeague)** - Follow for updates

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

## 📱 Features

### Core Features
- **League System**: Competitive leagues with leaderboards and rewards
- **Vault Following**: Copy successful DeFi strategies with one tap
- **Prediction Markets**: Sponsored prediction events with prizes
- **Social Trading**: Activity feed, rankings, and trader profiles

### Product Images

![Product 1](https://drive.google.com/uc?export=view&id=1tcEgrZBy_VtpXTG7h2mZjliVOA09cQGN)
![Product 2](https://drive.google.com/uc?export=view&id=1DqH7UXSIfh0iRVpx8NMfYuUPn9WrU4Nl)
![Product 3](https://drive.google.com/uc?export=view&id=17hpQnfzG5rXjI2J0CJwM7h6pTuWWHCvs)
![Product 4](https://drive.google.com/uc?export=view&id=1tl_UJa4koa-G2gzmG7HvJu7yLukkLBZN)


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

## 🏆 CTRL+Move Hackathon

TradeLeague is built for the **CTRL+Move hackathon** (August 4 - October 3, 2025), showcasing:

- **Real Utility**: Making DeFi accessible through mobile-first design
- **Breakthrough Design**: Gamified social trading that feels like fantasy sports
- **Performance-Driven**: Built on Aptos's parallel execution and sub-second finality
- **Ecosystem Integration**: Deep integration with Merkle Trade, Hyperion, Tapp, and Circle

📄 **[View Complete Hackathon Strategy →](docs/hackathon/CTRL_MOVE_HACKATHON.md)**

## 🤝 Contributing

For questions, collaboration opportunities, or feedback, please:
- Open an issue on [GitHub](https://github.com/ellisosborn03/TradeLeague)
- Follow us on [Twitter](https://twitter.com/0xTradingLeague)
- Watch our [demo video](https://youtube.com/watch?v=ykivz0CzOUA)

## 📄 License

Copyright © 2025 TradeLeague. All rights reserved.

---

**Built for CTRL+Move Hackathon 2025** | **Powered by Aptos** | **[@0xTradingLeague](https://twitter.com/0xTradingLeague)**
