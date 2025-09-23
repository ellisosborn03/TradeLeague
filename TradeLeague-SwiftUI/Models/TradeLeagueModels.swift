import Foundation

// MARK: - User Models
struct User: Identifiable, Codable, Equatable {
    let id: String
    let walletAddress: String
    let username: String
    let avatar: String?
    let totalVolume: Double
    let inviteCode: String
    let createdAt: Date
    let currentScore: Double
    let rank: Int?
}

// MARK: - League Models
struct League: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let creatorId: String
    let entryFee: Double
    let prizePool: Double
    let startTime: Date
    let endTime: Date?
    let isPublic: Bool
    let maxParticipants: Int
    let participants: [LeagueParticipant]
    let sponsorName: String?
    let sponsorLogo: String?
}

struct LeagueParticipant: Identifiable, Codable, Equatable {
    let id: String
    let userId: String
    let user: User
    let joinedAt: Date
    let currentScore: Double
    let rank: Int
    let percentageGain: Double
}

// MARK: - Vault Models
struct Vault: Identifiable, Codable, Equatable {
    let id: String
    let managerId: String
    let manager: User
    let name: String
    let strategy: VaultStrategy
    let venue: VaultVenue
    let totalAUM: Double
    let performanceFee: Double
    let allTimeReturn: Double
    let weeklyReturn: Double
    let monthlyReturn: Double
    let followers: Int
    let description: String
    let riskLevel: RiskLevel
}

enum VaultStrategy: String, CaseIterable, Codable {
    case marketMaking = "Market Making"
    case yieldFarming = "Yield Farming"
    case arbitrage = "Arbitrage"
    case perpsTrading = "Perps Trading"
    case liquidityProvision = "Liquidity Provision"
}

enum VaultVenue: String, CaseIterable, Codable {
    case hyperion = "Hyperion"
    case merkle = "Merkle"
    case tapp = "Tapp"
}

enum RiskLevel: String, CaseIterable, Codable {
    case conservative = "Conservative"
    case moderate = "Moderate"
    case aggressive = "Aggressive"
}

struct VaultFollowing: Identifiable, Codable {
    let id: String
    let vaultId: String
    let vault: Vault
    let amount: Double
    let followedAt: Date
    let currentValue: Double
    let pnl: Double
    let pnlPercentage: Double
}

// MARK: - Prediction Models
struct PredictionMarket: Identifiable, Codable, Equatable {
    let id: String
    let sponsor: String
    let sponsorLogo: String?
    let question: String
    let outcomes: [PredictionOutcome]
    let totalStaked: Double
    let resolutionTime: Date
    let resolved: Bool
    let winningOutcome: Int?
    let marketType: MarketType
    let category: PredictionCategory
}

enum MarketType: String, CaseIterable, Codable {
    case binary = "Binary"
    case multiple = "Multiple"
}

enum PredictionCategory: String, CaseIterable, Codable {
    case price = "Price"
    case volume = "Volume"
    case crossChain = "CrossChain"
    case derivatives = "Derivatives"
}

struct PredictionOutcome: Identifiable, Codable, Equatable {
    let id = UUID()
    let index: Int
    let label: String
    let probability: Double
    let totalStaked: Double
    let color: String
}

struct UserPrediction: Identifiable, Codable {
    let id: String
    let marketId: String
    let market: PredictionMarket
    let outcomeIndex: Int
    let stake: Double
    let potentialPayout: Double
    let placedAt: Date
    let settled: Bool
    let won: Bool?
}

// MARK: - Portfolio Models
struct Portfolio: Codable {
    let totalValue: Double
    let todayChange: Double
    let todayChangePercentage: Double
    let allTimeChange: Double
    let allTimeChangePercentage: Double
    let vaultFollowings: [VaultFollowing]
    let predictions: [UserPrediction]
    let rewards: [Reward]
}

struct Reward: Identifiable, Codable {
    let id: String
    let type: RewardType
    let amount: Double
    let description: String
    let claimedAt: Date?
    let expiresAt: Date?
}

enum RewardType: String, CaseIterable, Codable {
    case league = "League"
    case prediction = "Prediction"
    case referral = "Referral"
    case achievement = "Achievement"
}

// MARK: - Transaction Models
struct Transaction: Identifiable, Codable {
    let id: String
    let type: TransactionType
    let amount: Double
    let hash: String
    let status: TransactionStatus
    let timestamp: Date
    let description: String
}

enum TransactionType: String, CaseIterable, Codable {
    case deposit = "Deposit"
    case withdraw = "Withdraw"
    case follow = "Follow"
    case unfollow = "Unfollow"
    case prediction = "Prediction"
    case reward = "Reward"
}

enum TransactionStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case success = "Success"
    case failed = "Failed"
}

// MARK: - Token Allocation Models
struct TokenAllocation: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let name: String
    let color: String
    let percentage: Double
    let amount: Double
}

struct PortfolioAllocation: Codable {
    let tokens: [TokenAllocation]
    let totalValue: Double
}

// MARK: - League Player Models
struct LeaguePlayer: Identifiable, Codable, Equatable {
    let id: String
    let username: String
    let avatar: String
    let points: Int
    let rank: Int
}

enum LeagueScope: CaseIterable {
    case global
    case local
}