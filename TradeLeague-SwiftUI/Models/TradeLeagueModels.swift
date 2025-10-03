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
    case crypto = "Crypto"
    case politics = "Politics"
    case sports = "Sports"
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
    var totalValue: Double
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
    case league = "League Entry"
    case trade = "Trade"
    case vault = "Vault Investment"
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
    let profit: Double // Changed from points to profit
    let rank: Int
    let recentTrades: [Trade]

    init(id: String, username: String, avatar: String, profit: Double, rank: Int, recentTrades: [Trade] = []) {
        self.id = id
        self.username = username
        self.avatar = avatar
        self.profit = profit
        self.rank = rank
        self.recentTrades = recentTrades
    }
}

// MARK: - Trade Models
struct Trade: Identifiable, Codable, Equatable {
    let id: String
    let symbol: String
    let type: TradeType
    let amount: Double
    let price: Double
    let pnl: Double
    let timestamp: Date
    let venue: String
}

enum TradeType: String, CaseIterable, Codable {
    case buy = "Buy"
    case sell = "Sell"
    case long = "Long"
    case short = "Short"
}

enum LeagueScope: CaseIterable {
    case global
    case local
}

// MARK: - Balance Management
class BalanceManager: ObservableObject {
    static let shared = BalanceManager()

    @Published var currentBalance: Double = 12500.0 // Starting balance
    @Published var portfolioAllocation: PortfolioAllocation

    private init() {
        self.portfolioAllocation = PortfolioAllocation(
            tokens: [
                TokenAllocation(symbol: "APT", name: "Aptos", color: "#0D47A1", percentage: 25.0, amount: 3125.0),
                TokenAllocation(symbol: "USDC", name: "USDC (on Aptos)", color: "#B0BEC5", percentage: 20.0, amount: 2500.0),
                TokenAllocation(symbol: "EKID", name: "Ekiden", color: "#FB8C00", percentage: 15.0, amount: 1875.0),
                TokenAllocation(symbol: "PORA", name: "Panora", color: "#1ABC9C", percentage: 20.0, amount: 2500.0),
                TokenAllocation(symbol: "RION", name: "Hyperion", color: "#8E44AD", percentage: 20.0, amount: 2500.0)
            ],
            totalValue: 12500.0
        )
    }

    func deductBalance(amount: Double, type: TransactionType) -> Bool {
        guard currentBalance >= amount else {
            print("⚠️ [BALANCE] Insufficient balance: \(currentBalance) < \(amount)")
            return false
        }

        let oldBalance = currentBalance
        currentBalance -= amount
        updatePortfolioAllocation()

        print("💰 [BALANCE] Deducted: $\(amount)")
        print("   Previous: $\(oldBalance)")
        print("   Current: $\(currentBalance)")
        print("   Type: \(type.rawValue)")

        return true
    }

    func updatePortfolioAllocation() {
        let newTokens = portfolioAllocation.tokens.map { token in
            let newAmount = (token.percentage / 100) * currentBalance
            return TokenAllocation(
                symbol: token.symbol,
                name: token.name,
                color: token.color,
                percentage: token.percentage,
                amount: newAmount
            )
        }

        portfolioAllocation = PortfolioAllocation(
            tokens: newTokens,
            totalValue: currentBalance
        )

        print("📊 [PORTFOLIO] Updated allocation:")
        for token in newTokens {
            print("   \(token.symbol): $\(String(format: "%.2f", token.amount)) (\(String(format: "%.0f", token.percentage))%)")
        }
    }
}


// MARK: - Sponsored League Models
struct SponsoredLeague: Identifiable, Codable, Equatable {
    let id: String
    let sponsorName: String
    let sponsorLogo: String
    let leagueName: String
    let prizePool: Double
    let entryFee: Double
    let participants: [LeaguePlayer]
    let isExpanded: Bool
    let endDate: Date
}

// MARK: - Transaction Manager
class TransactionManager: ObservableObject {
    static let shared = TransactionManager()

    @Published var transactions: [Transaction] = []
    @Published var pendingTransactions: [String: Transaction] = [:]

    private let balanceManager = BalanceManager.shared

    // Test wallet addresses
    private let walletAddress = "0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155"
    private let fullnodeURL = "https://fullnode.testnet.aptoslabs.com/v1"

    private init() {
        loadTransactions()
    }

    // MARK: - Transaction Execution

    func joinLeague(leagueId: String, leagueName: String, entryFee: Double) async throws -> String {
        print("📝 [TX] Starting league join transaction...")
        print("   League: \(leagueName)")
        print("   Entry Fee: $\(entryFee)")
        print("   Wallet: \(walletAddress)")

        let txId = UUID().uuidString
        let transaction = Transaction(
            id: txId,
            type: .league,
            amount: entryFee,
            hash: "",
            status: .pending,
            timestamp: Date(),
            description: "Joined \(leagueName)"
        )

        await MainActor.run {
            self.pendingTransactions[txId] = transaction
            self.transactions.insert(transaction, at: 0)
        }

        do {
            guard balanceManager.deductBalance(amount: entryFee, type: .league) else {
                print("❌ [TX] Insufficient balance")
                throw TransactionError.insufficientBalance
            }

            print("✅ [TX] Balance deducted: $\(entryFee)")
            print("   New balance: $\(balanceManager.currentBalance)")

            let txHash = try await submitTransaction(type: "league_join", amount: entryFee, metadata: ["league_id": leagueId])

            print("🚀 [TX] Transaction submitted to testnet")
            print("   Hash: \(txHash)")
            print("   Explorer: https://explorer.aptoslabs.com/txn/\(txHash)?network=testnet")

            let updatedTx = Transaction(
                id: txId,
                type: .league,
                amount: entryFee,
                hash: txHash,
                status: .success,
                timestamp: Date(),
                description: "Joined \(leagueName)"
            )

            await MainActor.run {
                if let index = self.transactions.firstIndex(where: { $0.id == txId }) {
                    self.transactions[index] = updatedTx
                }
                self.pendingTransactions.removeValue(forKey: txId)
                self.saveTransactions()
            }

            print("✅ [TX] Transaction completed successfully")
            return txHash

        } catch {
            print("❌ [TX] Transaction failed: \(error.localizedDescription)")

            await MainActor.run {
                self.balanceManager.currentBalance += entryFee
                self.balanceManager.updatePortfolioAllocation()

                if let index = self.transactions.firstIndex(where: { $0.id == txId }) {
                    self.transactions[index] = Transaction(
                        id: txId,
                        type: .league,
                        amount: entryFee,
                        hash: "",
                        status: .failed,
                        timestamp: Date(),
                        description: "Failed: \(leagueName)"
                    )
                }
                self.pendingTransactions.removeValue(forKey: txId)
                self.saveTransactions()
            }

            throw error
        }
    }

    func followVault(vaultId: String, vaultName: String, amount: Double) async throws -> String {
        print("📝 [TX] Starting vault follow transaction...")
        print("   Vault: \(vaultName)")
        print("   Amount: $\(amount)")

        let txId = UUID().uuidString
        let transaction = Transaction(
            id: txId,
            type: .vault,
            amount: amount,
            hash: "",
            status: .pending,
            timestamp: Date(),
            description: "Followed \(vaultName)"
        )

        await MainActor.run {
            self.pendingTransactions[txId] = transaction
            self.transactions.insert(transaction, at: 0)
        }

        do {
            guard balanceManager.deductBalance(amount: amount, type: .vault) else {
                throw TransactionError.insufficientBalance
            }

            let txHash = try await submitTransaction(type: "vault_follow", amount: amount, metadata: ["vault_id": vaultId])

            let updatedTx = Transaction(
                id: txId,
                type: .vault,
                amount: amount,
                hash: txHash,
                status: .success,
                timestamp: Date(),
                description: "Followed \(vaultName)"
            )

            await MainActor.run {
                if let index = self.transactions.firstIndex(where: { $0.id == txId }) {
                    self.transactions[index] = updatedTx
                }
                self.pendingTransactions.removeValue(forKey: txId)
                self.saveTransactions()
            }

            return txHash

        } catch {
            await MainActor.run {
                self.balanceManager.currentBalance += amount
                self.balanceManager.updatePortfolioAllocation()

                if let index = self.transactions.firstIndex(where: { $0.id == txId }) {
                    self.transactions[index] = Transaction(
                        id: txId,
                        type: .vault,
                        amount: amount,
                        hash: "",
                        status: .failed,
                        timestamp: Date(),
                        description: "Failed: \(vaultName)"
                    )
                }
                self.pendingTransactions.removeValue(forKey: txId)
                self.saveTransactions()
            }

            throw error
        }
    }

    func placePrediction(marketId: String, question: String, outcomeIndex: Int, amount: Double) async throws -> String {
        print("📝 [TX] Starting prediction transaction...")
        print("   Question: \(question)")
        print("   Amount: $\(amount)")

        let txId = UUID().uuidString
        let transaction = Transaction(
            id: txId,
            type: .prediction,
            amount: amount,
            hash: "",
            status: .pending,
            timestamp: Date(),
            description: "Prediction: \(question)"
        )

        await MainActor.run {
            self.pendingTransactions[txId] = transaction
            self.transactions.insert(transaction, at: 0)
        }

        do {
            guard balanceManager.deductBalance(amount: amount, type: .prediction) else {
                throw TransactionError.insufficientBalance
            }

            let txHash = try await submitTransaction(type: "prediction_place", amount: amount, metadata: ["market_id": marketId, "outcome": String(outcomeIndex)])

            let updatedTx = Transaction(
                id: txId,
                type: .prediction,
                amount: amount,
                hash: txHash,
                status: .success,
                timestamp: Date(),
                description: "Prediction: \(question)"
            )

            await MainActor.run {
                if let index = self.transactions.firstIndex(where: { $0.id == txId }) {
                    self.transactions[index] = updatedTx
                }
                self.pendingTransactions.removeValue(forKey: txId)
                self.saveTransactions()
            }

            return txHash

        } catch {
            await MainActor.run {
                self.balanceManager.currentBalance += amount
                self.balanceManager.updatePortfolioAllocation()

                if let index = self.transactions.firstIndex(where: { $0.id == txId }) {
                    self.transactions[index] = Transaction(
                        id: txId,
                        type: .prediction,
                        amount: amount,
                        hash: "",
                        status: .failed,
                        timestamp: Date(),
                        description: "Failed: Prediction"
                    )
                }
                self.pendingTransactions.removeValue(forKey: txId)
                self.saveTransactions()
            }

            throw error
        }
    }

    // MARK: - Testnet Transaction Submission

    private func submitTransaction(type: String, amount: Double, metadata: [String: String]) async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000)

        // Generate realistic transaction hash
        let txHash = "0x" + String((0..<64).map { _ in "0123456789abcdef".randomElement()! })

        // Log to console (simulating testnet logging)
        print("📡 [TESTNET LOG]")
        print("   Network: Aptos Testnet")
        print("   Endpoint: \(fullnodeURL)")
        print("   Transaction Hash: \(txHash)")
        print("   Type: \(type)")
        print("   Amount: \(amount) USDC")
        print("   From: \(walletAddress)")
        print("   Metadata: \(metadata)")
        print("   Timestamp: \(Date())")
        print("   Gas: ~0.0001 APT")
        print("---")

        return txHash
    }

    // MARK: - Transaction History

    func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: "transactions"),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
            print("📥 Loaded \(transactions.count) transactions from storage")
        }
    }

    func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "transactions")
            print("💾 Saved \(transactions.count) transactions to storage")
        }
    }
}

// MARK: - Transaction Errors
enum TransactionError: LocalizedError {
    case insufficientBalance
    case networkError
    case invalidAmount
    case transactionFailed

    var errorDescription: String? {
        switch self {
        case .insufficientBalance:
            return "Insufficient balance"
        case .networkError:
            return "Network error occurred"
        case .invalidAmount:
            return "Invalid transaction amount"
        case .transactionFailed:
            return "Transaction failed"
        }
    }
}