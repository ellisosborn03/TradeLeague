# TradeLeague API Documentation

## Base URL

```
Production: https://api.tradeleague.io/v1
Staging: https://staging-api.tradeleague.io/v1
Development: http://localhost:3000/api/v1
```

## Authentication

TradeLeague uses JWT (JSON Web Tokens) for authentication. All authenticated endpoints require an `Authorization` header.

### Getting a Token

```http
POST /auth/connect
Content-Type: application/json

{
  "walletAddress": "0x1234...abcd",
  "signature": "0xabcd...1234",
  "message": "Sign in to TradeLeague"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid-here",
    "walletAddress": "0x1234...abcd",
    "username": "trader123",
    "createdAt": "2025-01-15T10:30:00Z"
  }
}
```

### Using the Token

Include the token in the Authorization header:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Refreshing Tokens

```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## Error Responses

All errors follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      "field": "Additional context"
    }
  }
}
```

### Common Error Codes

| Code | Status | Description |
|------|--------|-------------|
| `UNAUTHORIZED` | 401 | Missing or invalid authentication token |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 422 | Request validation failed |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |

## Rate Limiting

- **Authenticated**: 1000 requests per hour
- **Unauthenticated**: 100 requests per hour

Rate limit headers are included in responses:

```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 995
X-RateLimit-Reset: 1640123400
```

---

## Endpoints

### Authentication

#### POST /auth/connect
Connect wallet and authenticate user.

**Request Body:**
```json
{
  "walletAddress": "string",
  "signature": "string",
  "message": "string"
}
```

**Response:** `200 OK`
```json
{
  "token": "string",
  "refreshToken": "string",
  "user": { ... }
}
```

#### POST /auth/refresh
Refresh authentication token.

**Request Body:**
```json
{
  "refreshToken": "string"
}
```

**Response:** `200 OK`
```json
{
  "token": "string",
  "refreshToken": "string"
}
```

---

### Users

#### GET /users/me
Get current user profile.

**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "id": "uuid",
  "walletAddress": "0x1234...abcd",
  "username": "trader123",
  "email": "user@example.com",
  "stats": {
    "totalTrades": 150,
    "winRate": 0.67,
    "totalPnL": 5000.50,
    "leaguesJoined": 5,
    "leaguesWon": 2
  },
  "createdAt": "2025-01-15T10:30:00Z"
}
```

#### PATCH /users/me
Update user profile.

**Auth Required:** Yes

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "avatar": "string"
}
```

**Response:** `200 OK`
```json
{
  "id": "uuid",
  "username": "newusername",
  ...
}
```

#### GET /users/:userId
Get public user profile.

**Response:** `200 OK`
```json
{
  "id": "uuid",
  "username": "trader123",
  "stats": { ... },
  "achievements": [...]
}
```

---

### Leagues

#### GET /leagues
List available leagues.

**Query Parameters:**
- `type` (optional): `perps` | `prediction` | `vault`
- `status` (optional): `upcoming` | `active` | `completed`
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20, max: 100)

**Response:** `200 OK`
```json
{
  "leagues": [
    {
      "id": "uuid",
      "name": "Merkle Perps Championship",
      "type": "perps",
      "status": "active",
      "sponsor": {
        "id": "uuid",
        "name": "Merkle Trade",
        "logo": "https://..."
      },
      "entryFee": 10.0,
      "prizePool": 10000.0,
      "participants": 150,
      "maxParticipants": 500,
      "startDate": "2025-01-20T00:00:00Z",
      "endDate": "2025-02-20T00:00:00Z",
      "rules": {
        "minTradeSize": 100,
        "allowedMarkets": ["BTC-PERP", "ETH-PERP"]
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "pages": 3
  }
}
```

#### GET /leagues/:leagueId
Get league details.

**Response:** `200 OK`
```json
{
  "id": "uuid",
  "name": "Merkle Perps Championship",
  "description": "Weekly leveraged trading competition...",
  "type": "perps",
  "status": "active",
  "sponsor": { ... },
  "entryFee": 10.0,
  "prizePool": 10000.0,
  "prizeDistribution": [
    { "rank": 1, "prize": 5000.0 },
    { "rank": 2, "prize": 3000.0 },
    { "rank": 3, "prize": 2000.0 }
  ],
  "participants": 150,
  "maxParticipants": 500,
  "startDate": "2025-01-20T00:00:00Z",
  "endDate": "2025-02-20T00:00:00Z",
  "rules": { ... },
  "leaderboard": [
    {
      "rank": 1,
      "userId": "uuid",
      "username": "trader1",
      "score": 1250.5,
      "pnl": 2500.0
    }
  ]
}
```

#### POST /leagues/:leagueId/join
Join a league.

**Auth Required:** Yes

**Request Body:**
```json
{
  "acceptRules": true
}
```

**Response:** `201 Created`
```json
{
  "leagueId": "uuid",
  "userId": "uuid",
  "joinedAt": "2025-01-15T10:30:00Z",
  "transactionHash": "0xabcd...1234"
}
```

#### GET /leagues/:leagueId/leaderboard
Get league leaderboard.

**Query Parameters:**
- `page` (optional): Page number
- `limit` (optional): Items per page (max: 100)

**Response:** `200 OK`
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "userId": "uuid",
      "username": "trader1",
      "avatar": "https://...",
      "score": 1250.5,
      "pnl": 2500.0,
      "trades": 45,
      "winRate": 0.72
    }
  ],
  "userRank": {
    "rank": 15,
    "score": 850.0
  }
}
```

---

### Predictions

#### GET /predictions
List active prediction markets.

**Query Parameters:**
- `status` (optional): `open` | `locked` | `resolved`
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:** `200 OK`
```json
{
  "predictions": [
    {
      "id": "uuid",
      "marketId": "BTC-PRICE-30K",
      "question": "Will BTC reach $30k by Feb 1?",
      "options": ["Yes", "No"],
      "totalPool": 5000.0,
      "participants": 250,
      "odds": {
        "Yes": 1.65,
        "No": 2.35
      },
      "lockTime": "2025-02-01T00:00:00Z",
      "resolutionTime": "2025-02-01T23:59:59Z",
      "status": "open"
    }
  ]
}
```

#### POST /predictions/:predictionId/bet
Place a bet on prediction market.

**Auth Required:** Yes

**Request Body:**
```json
{
  "outcome": "Yes",
  "amount": 100.0
}
```

**Response:** `201 Created`
```json
{
  "betId": "uuid",
  "predictionId": "uuid",
  "outcome": "Yes",
  "amount": 100.0,
  "potentialWin": 165.0,
  "transactionHash": "0xabcd...1234",
  "placedAt": "2025-01-15T10:30:00Z"
}
```

#### GET /predictions/:predictionId/my-bets
Get user's bets on a prediction.

**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "bets": [
    {
      "id": "uuid",
      "outcome": "Yes",
      "amount": 100.0,
      "potentialWin": 165.0,
      "status": "pending",
      "placedAt": "2025-01-15T10:30:00Z"
    }
  ],
  "totalStaked": 100.0,
  "potentialWinnings": 165.0
}
```

---

### Vaults

#### GET /vaults
List available vaults.

**Query Parameters:**
- `sortBy` (optional): `performance` | `followers` | `aum`
- `timeframe` (optional): `24h` | `7d` | `30d` | `all`
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:** `200 OK`
```json
{
  "vaults": [
    {
      "id": "uuid",
      "address": "0xabcd...1234",
      "name": "BTC Momentum Strategy",
      "description": "Long BTC with momentum indicators",
      "manager": {
        "userId": "uuid",
        "username": "trader_pro"
      },
      "stats": {
        "aum": 50000.0,
        "followers": 125,
        "performance": {
          "24h": 0.025,
          "7d": 0.15,
          "30d": 0.45,
          "all": 1.25
        },
        "sharpeRatio": 2.5,
        "maxDrawdown": 0.15
      },
      "fees": {
        "management": 0.02,
        "performance": 0.20
      }
    }
  ]
}
```

#### POST /vaults/:vaultId/follow
Follow a vault strategy.

**Auth Required:** Yes

**Request Body:**
```json
{
  "allocationPercentage": 50,
  "autoCopy": true,
  "maxSlippage": 0.01
}
```

**Response:** `201 Created`
```json
{
  "followId": "uuid",
  "vaultId": "uuid",
  "allocationPercentage": 50,
  "autoCopy": true,
  "transactionHash": "0xabcd...1234",
  "followedAt": "2025-01-15T10:30:00Z"
}
```

#### DELETE /vaults/:vaultId/unfollow
Unfollow a vault.

**Auth Required:** Yes

**Response:** `200 OK`
```json
{
  "unfollowedAt": "2025-01-15T10:30:00Z",
  "transactionHash": "0xabcd...1234"
}
```

#### GET /vaults/:vaultId/trades
Get vault trade history.

**Query Parameters:**
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:** `200 OK`
```json
{
  "trades": [
    {
      "id": "uuid",
      "type": "buy",
      "asset": "BTC",
      "amount": 1.5,
      "price": 28500.0,
      "total": 42750.0,
      "timestamp": "2025-01-15T10:30:00Z",
      "copied": true
    }
  ]
}
```

---

### Activities

#### GET /activities
Get activity feed.

**Auth Required:** Yes

**Query Parameters:**
- `type` (optional): Filter by activity type
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:** `200 OK`
```json
{
  "activities": [
    {
      "id": "uuid",
      "type": "trade",
      "user": {
        "id": "uuid",
        "username": "trader123"
      },
      "metadata": {
        "asset": "BTC",
        "action": "buy",
        "amount": 0.5,
        "price": 28500.0
      },
      "timestamp": "2025-01-15T10:30:00Z"
    },
    {
      "id": "uuid",
      "type": "league_join",
      "user": {
        "id": "uuid",
        "username": "newbie99"
      },
      "metadata": {
        "leagueName": "Merkle Perps Championship"
      },
      "timestamp": "2025-01-15T10:25:00Z"
    }
  ]
}
```

---

### Leaderboards

#### GET /leaderboards/global
Get global leaderboard.

**Query Parameters:**
- `timeframe` (optional): `24h` | `7d` | `30d` | `all`
- `metric` (optional): `pnl` | `winRate` | `volume`
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:** `200 OK`
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "userId": "uuid",
      "username": "trader_king",
      "avatar": "https://...",
      "metric": 15000.0,
      "trades": 200,
      "winRate": 0.75
    }
  ],
  "userRank": {
    "rank": 42,
    "metric": 2500.0
  }
}
```

---

### Transactions

#### GET /transactions
Get user transaction history.

**Auth Required:** Yes

**Query Parameters:**
- `type` (optional): Filter by transaction type
- `status` (optional): `pending` | `confirmed` | `failed`
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:** `200 OK`
```json
{
  "transactions": [
    {
      "id": "uuid",
      "hash": "0xabcd...1234",
      "type": "league_join",
      "amount": 10.0,
      "status": "confirmed",
      "blockNumber": 12345678,
      "timestamp": "2025-01-15T10:30:00Z",
      "explorerUrl": "https://explorer.aptoslabs.com/txn/0xabcd...1234"
    }
  ]
}
```

#### GET /transactions/:transactionHash
Get transaction details.

**Response:** `200 OK`
```json
{
  "id": "uuid",
  "hash": "0xabcd...1234",
  "type": "league_join",
  "amount": 10.0,
  "status": "confirmed",
  "blockNumber": 12345678,
  "gasUsed": 0.001,
  "timestamp": "2025-01-15T10:30:00Z",
  "metadata": {
    "leagueId": "uuid",
    "leagueName": "Merkle Perps Championship"
  }
}
```

---

## WebSocket API

### Connection

```javascript
const ws = new WebSocket('wss://api.tradeleague.io/ws');

// Authenticate
ws.send(JSON.stringify({
  type: 'auth',
  token: 'your-jwt-token'
}));
```

### Subscriptions

#### Subscribe to Leaderboard Updates

```javascript
ws.send(JSON.stringify({
  type: 'subscribe',
  channel: 'leaderboard',
  leagueId: 'uuid'
}));
```

**Updates:**
```json
{
  "type": "leaderboard_update",
  "leagueId": "uuid",
  "data": {
    "rank": 1,
    "userId": "uuid",
    "username": "trader1",
    "score": 1250.5
  }
}
```

#### Subscribe to Activity Feed

```javascript
ws.send(JSON.stringify({
  type: 'subscribe',
  channel: 'activities'
}));
```

**Updates:**
```json
{
  "type": "new_activity",
  "data": {
    "id": "uuid",
    "type": "trade",
    "user": { ... },
    "metadata": { ... }
  }
}
```

#### Subscribe to Price Updates

```javascript
ws.send(JSON.stringify({
  type: 'subscribe',
  channel: 'prices',
  symbols: ['BTC', 'ETH']
}));
```

**Updates:**
```json
{
  "type": "price_update",
  "symbol": "BTC",
  "price": 28500.0,
  "change24h": 0.025,
  "timestamp": "2025-01-15T10:30:00Z"
}
```

---

## SDK Examples

### JavaScript/TypeScript

```typescript
import { TradeLeagueSDK } from '@tradeleague/sdk';

const sdk = new TradeLeagueSDK({
  apiKey: 'your-api-key',
  network: 'mainnet'
});

// Connect wallet
const { token } = await sdk.auth.connect({
  walletAddress: '0x1234...abcd',
  signature: '0xabcd...1234'
});

// Join league
const result = await sdk.leagues.join('league-id');

// Get leaderboard
const leaderboard = await sdk.leagues.getLeaderboard('league-id');
```

### Swift

```swift
import TradeLeagueSDK

let sdk = TradeLeagueSDK(config: .production)

// Connect wallet
try await sdk.auth.connect(
    walletAddress: "0x1234...abcd",
    signature: "0xabcd...1234"
)

// Join league
let result = try await sdk.leagues.join("league-id")

// Get leaderboard
let leaderboard = try await sdk.leagues.getLeaderboard("league-id")
```

---

## Changelog

### v1.0.0 (January 2025)
- Initial API release
- Authentication endpoints
- League management
- Prediction markets
- Vault following
- Activity feeds
- Real-time WebSocket support

---

**API Version**: 1.0.0
**Last Updated**: October 2025
**Support**: api-support@tradeleague.io
