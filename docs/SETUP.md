# TradeLeague Setup Guide

Complete guide to setting up TradeLeague development environment and deploying the application.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Mobile App Setup](#mobile-app-setup)
4. [Backend Setup](#backend-setup)
5. [Smart Contract Setup](#smart-contract-setup)
6. [Database Setup](#database-setup)
7. [Development Workflow](#development-workflow)
8. [Testing](#testing)
9. [Deployment](#deployment)
10. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

#### All Platforms
- **Node.js**: v18.x or higher
- **npm** or **yarn**: Latest version
- **Git**: Latest version
- **Aptos CLI**: Latest version

#### iOS Development
- **macOS**: Catalina (10.15) or higher
- **Xcode**: 14.x or higher
- **CocoaPods**: Latest version
- **Ruby**: 2.7 or higher (for CocoaPods)

#### Android Development
- **Android Studio**: Latest version
- **Android SDK**: API Level 31 or higher
- **JDK**: 11 or higher

#### Backend Development
- **PostgreSQL**: 14.x or higher
- **Redis**: 6.x or higher
- **Docker** (optional): For containerized development

### Accounts Required
- **Aptos Wallet**: Petra or compatible wallet
- **GitHub Account**: For repository access
- **Aptos Faucet**: For testnet tokens

---

## Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/ellisosborn03/TradeLeague.git
cd TradeLeague
```

### 2. Install Aptos CLI

**macOS (Homebrew):**
```bash
brew install aptos
```

**Linux:**
```bash
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
```

**Verify Installation:**
```bash
aptos --version
```

### 3. Create Aptos Account

```bash
# Initialize Aptos configuration
aptos init --network testnet

# This will create:
# - Private key
# - Public key
# - Account address
```

### 4. Fund Your Account (Testnet)

```bash
aptos account fund-with-faucet --account default
```

Or use the web faucet:
https://aptoslabs.com/testnet-faucet

---

## Mobile App Setup

### React Native App

#### 1. Install Dependencies

```bash
cd TradeLeague
npm install
```

#### 2. iOS Setup

**Install CocoaPods:**
```bash
sudo gem install cocoapods
```

**Install iOS Dependencies:**
```bash
cd ios
pod install
cd ..
```

**Configure Signing:**
1. Open `ios/TradeLeague.xcworkspace` in Xcode
2. Select TradeLeague target
3. Go to "Signing & Capabilities"
4. Select your development team
5. Change bundle identifier if needed

#### 3. Android Setup

**Create `local.properties`:**
```bash
# In TradeLeague/android/local.properties
sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
```

**Configure Gradle:**
Ensure `android/gradle.properties` exists with:
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m
android.useAndroidX=true
android.enableJetifier=true
```

#### 4. Environment Variables

Create `.env` file in `TradeLeague/`:

```env
# API Configuration
API_URL=http://localhost:3000/api/v1
WS_URL=ws://localhost:3000/ws

# Aptos Configuration
APTOS_NETWORK=testnet
APTOS_NODE_URL=https://fullnode.testnet.aptoslabs.com/v1
APTOS_FAUCET_URL=https://faucet.testnet.aptoslabs.com

# Contract Addresses
LEAGUE_CONTRACT_ADDRESS=0x...
PREDICTION_CONTRACT_ADDRESS=0x...
VAULT_CONTRACT_ADDRESS=0x...

# Feature Flags
ENABLE_PREDICTIONS=true
ENABLE_VAULT_FOLLOWING=true
```

#### 5. Run the App

**iOS:**
```bash
npx react-native run-ios
# or specific simulator
npx react-native run-ios --simulator="iPhone 14 Pro"
```

**Android:**
```bash
npx react-native run-android
# or specific device
npx react-native run-android --deviceId=<device-id>
```

**Metro Bundler:**
```bash
# In a separate terminal
npx react-native start
# or with cache reset
npx react-native start --reset-cache
```

### SwiftUI App

#### 1. Open Project

```bash
cd TradeLeague-SwiftUI
open TradeLeague.xcodeproj
```

#### 2. Configure Signing

1. Select TradeLeague target
2. Go to "Signing & Capabilities"
3. Select your development team
4. Update bundle identifier if needed

#### 3. Install Dependencies

SwiftUI uses Swift Package Manager. Dependencies should install automatically when you build.

If needed, manually refresh:
- File → Packages → Resolve Package Versions

#### 4. Configuration

Edit `TradeLeague/Config.swift`:

```swift
struct Config {
    static let apiURL = "http://localhost:3000/api/v1"
    static let wsURL = "ws://localhost:3000/ws"
    static let aptosNetwork = "testnet"
    static let nodeURL = "https://fullnode.testnet.aptoslabs.com/v1"
}
```

#### 5. Build and Run

- Select target device/simulator
- Press ⌘+R or click Run button

---

## Backend Setup

### 1. Database Installation

**PostgreSQL (macOS):**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Create Database:**
```bash
createdb tradeleague_dev
```

**Redis (macOS):**
```bash
brew install redis
brew services start redis
```

### 2. Backend Dependencies

```bash
cd backend
npm install
```

### 3. Environment Configuration

Create `backend/.env`:

```env
# Server
NODE_ENV=development
PORT=3000
HOST=localhost

# Database
DATABASE_URL=postgresql://localhost:5432/tradeleague_dev
DATABASE_POOL_MIN=2
DATABASE_POOL_MAX=10

# Redis
REDIS_URL=redis://localhost:6379
REDIS_PREFIX=tradeleague:

# JWT
JWT_SECRET=your-super-secret-key-change-in-production
JWT_EXPIRES_IN=1h
REFRESH_TOKEN_EXPIRES_IN=7d

# Aptos
APTOS_NETWORK=testnet
APTOS_NODE_URL=https://fullnode.testnet.aptoslabs.com/v1
PRIVATE_KEY=your-private-key-from-aptos-init

# CORS
CORS_ORIGINS=http://localhost:*,exp://*

# Rate Limiting
RATE_LIMIT_WINDOW_MS=3600000
RATE_LIMIT_MAX_REQUESTS=1000
```

### 4. Database Migration

```bash
# Run migrations
npm run migrate:latest

# Seed database (optional)
npm run seed
```

### 5. Start Backend

```bash
# Development mode (with hot reload)
npm run dev

# Production mode
npm run build
npm start
```

---

## Smart Contract Setup

### 1. Navigate to Contracts

```bash
cd TradeLeague/contracts
```

### 2. Install Move Dependencies

```bash
# Dependencies are managed in Move.toml
# Aptos CLI will handle them automatically
```

### 3. Compile Contracts

```bash
aptos move compile
```

### 4. Test Contracts

```bash
aptos move test
```

### 5. Deploy to Testnet

```bash
# Deploy all modules
aptos move publish --profile testnet

# Or deploy specific module
aptos move publish --profile testnet --named-addresses tradeleague=<your-address>
```

### 6. Verify Deployment

```bash
# Check deployed modules
aptos account list --account <your-address>
```

### 7. Initialize Contracts

```bash
# Initialize league manager
aptos move run \
  --function-id '<your-address>::league_manager::initialize' \
  --profile testnet

# Initialize prediction market
aptos move run \
  --function-id '<your-address>::prediction_market::initialize' \
  --profile testnet
```

---

## Database Setup

### Schema

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wallet_address VARCHAR(66) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE,
  email VARCHAR(255),
  avatar_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leagues table
CREATE TABLE leagues (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  sponsor_id UUID REFERENCES sponsors(id),
  contract_address VARCHAR(66),
  entry_fee DECIMAL(18, 8),
  prize_pool DECIMAL(18, 8),
  max_participants INTEGER,
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- League participants
CREATE TABLE league_participants (
  league_id UUID REFERENCES leagues(id),
  user_id UUID REFERENCES users(id),
  score DECIMAL(18, 8),
  rank INTEGER,
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (league_id, user_id)
);

-- Create indexes
CREATE INDEX idx_users_wallet ON users(wallet_address);
CREATE INDEX idx_leagues_status ON leagues(status);
CREATE INDEX idx_league_participants_league ON league_participants(league_id);
CREATE INDEX idx_league_participants_user ON league_participants(user_id);
```

### Migrations

```bash
# Create new migration
npm run migrate:make <migration_name>

# Run all pending migrations
npm run migrate:latest

# Rollback last migration
npm run migrate:rollback

# Rollback all migrations
npm run migrate:rollback --all
```

---

## Development Workflow

### 1. Start All Services

**Terminal 1 - Database:**
```bash
# PostgreSQL and Redis should be running
brew services list
```

**Terminal 2 - Backend:**
```bash
cd backend
npm run dev
```

**Terminal 3 - Mobile (React Native):**
```bash
cd TradeLeague
npx react-native start
```

**Terminal 4 - Run App:**
```bash
# iOS
npx react-native run-ios

# Android
npx react-native run-android
```

### 2. Code Structure

```
TradeLeague/
├── src/
│   ├── components/       # Reusable UI components
│   ├── screens/          # Screen components
│   ├── navigation/       # Navigation setup
│   ├── services/         # API services
│   ├── hooks/            # Custom hooks
│   ├── context/          # State management
│   ├── utils/            # Utilities
│   └── types/            # TypeScript types
```

### 3. Making Changes

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes
3. Test locally
4. Commit: `git commit -m "description"`
5. Push: `git push origin feature/your-feature`
6. Create pull request

### 4. Linting and Formatting

```bash
# Run linter
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format
```

---

## Testing

### Mobile App Tests

```bash
cd TradeLeague

# Run unit tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test file
npm test -- src/components/Button.test.tsx
```

### Backend Tests

```bash
cd backend

# Run all tests
npm test

# Run integration tests
npm run test:integration

# Run with coverage
npm run test:coverage
```

### Smart Contract Tests

```bash
cd contracts

# Run all tests
aptos move test

# Run specific test
aptos move test --filter test_create_league
```

### E2E Tests

```bash
# Install Detox (first time)
npm install -g detox-cli

# Build app for testing
detox build --configuration ios.sim.debug

# Run E2E tests
detox test --configuration ios.sim.debug
```

---

## Deployment

### Mobile App Deployment

#### iOS (TestFlight)

1. **Archive Build:**
   - Open project in Xcode
   - Product → Archive
   - Wait for archive to complete

2. **Upload to App Store Connect:**
   - Window → Organizer
   - Select archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Upload

3. **Submit to TestFlight:**
   - Go to App Store Connect
   - Select app
   - TestFlight tab
   - Add testers

#### Android (Google Play)

1. **Generate Release APK:**
```bash
cd android
./gradlew bundleRelease
```

2. **Sign APK:**
```bash
# Create keystore (first time)
keytool -genkey -v -keystore tradeleague.keystore -alias tradeleague -keyalg RSA -keysize 2048 -validity 10000

# Sign APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore tradeleague.keystore app/build/outputs/bundle/release/app-release.aab tradeleague
```

3. **Upload to Play Console:**
   - Go to Google Play Console
   - Select app
   - Production → Create new release
   - Upload AAB

### Backend Deployment

#### Using Heroku

```bash
# Install Heroku CLI
brew tap heroku/brew && brew install heroku

# Login
heroku login

# Create app
heroku create tradeleague-api

# Add PostgreSQL
heroku addons:create heroku-postgresql:hobby-dev

# Add Redis
heroku addons:create heroku-redis:hobby-dev

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your-secret

# Deploy
git push heroku main

# Run migrations
heroku run npm run migrate:latest
```

### Smart Contract Deployment

#### Mainnet Deployment

```bash
# Create mainnet profile
aptos init --network mainnet --profile mainnet

# Fund account (from exchange or faucet)

# Deploy contracts
aptos move publish --profile mainnet

# Verify deployment
aptos account list --profile mainnet
```

---

## Troubleshooting

### Common Issues

#### iOS Build Fails

**Problem:** `CocoaPods could not find compatible versions...`

**Solution:**
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

#### Metro Bundler Issues

**Problem:** `Unable to resolve module...`

**Solution:**
```bash
# Clear Metro cache
npx react-native start --reset-cache

# Or delete node_modules and reinstall
rm -rf node_modules
npm install
```

#### Android Build Fails

**Problem:** `SDK location not found`

**Solution:**
Create `android/local.properties`:
```
sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
```

#### Database Connection Errors

**Problem:** `Connection refused to PostgreSQL`

**Solution:**
```bash
# Check if PostgreSQL is running
brew services list

# Start PostgreSQL
brew services start postgresql@14

# Test connection
psql -d tradeleague_dev
```

#### Smart Contract Deployment Fails

**Problem:** `Insufficient gas`

**Solution:**
```bash
# Check account balance
aptos account list

# Fund account
aptos account fund-with-faucet --account default

# Try with explicit gas parameters
aptos move publish --gas-unit-price 100 --max-gas 100000
```

### Getting Help

- **Documentation**: Check `docs/` folder
- **GitHub Issues**: [github.com/ellisosborn03/TradeLeague/issues](https://github.com/ellisosborn03/TradeLeague/issues)
- **Discord**: Join our community (link in README)
- **Twitter**: [@0xTradingLeague](https://twitter.com/0xTradingLeague)

---

**Last Updated**: October 2025
**Version**: 1.0.0
