import Foundation
import CryptoKit

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

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
        print("📡 [TESTNET] Submitting transaction to Aptos testnet...")

        // Submit actual transaction to Aptos testnet
        do {
            let txHash = try await submitRealTransaction(type: type, amount: amount, metadata: metadata)

            // Construct the actual Aptos explorer link
            let explorerLink = "https://explorer.aptoslabs.com/txn/\(txHash)?network=testnet"

            // Log detailed transaction information
            let amountInAPT = amount / 1000.0
            print("📡 [TESTNET LOG]")
            print("   Network: Aptos Testnet")
            print("   RPC Endpoint: \(fullnodeURL)")
            print("   Transaction Hash: \(txHash)")
            print("   Explorer Link: \(explorerLink)")
            print("   Type: \(type)")
            print("   Amount: $\(amount) USD → \(amountInAPT) APT")
            print("   From: \(walletAddress)")
            print("   To: 0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a")
            print("   Metadata: \(metadata)")
            print("   Timestamp: \(Date())")
            print("   Estimated Gas: ~0.0001 APT")
            print("")
            print("🔗 View transaction: \(explorerLink)")
            print("---")

            return txHash
        } catch {
            print("❌ [TESTNET] Transaction failed: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Real Testnet Transaction using REST API + Ed25519 Signing
    private func submitRealTransaction(type: String, amount: Double, metadata: [String: String]) async throws -> String {
        print("🔐 [TX] Loading wallet credentials...")

        // Wallet A (sender) private key
        let privateKeyHex = "B37A61F467D0D226B671BFC8A842FB3036F7BE8B55BEAA66C168154053B40A0D"
        // Wallet B (receiver)
        let receiverAddress = "0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a"

        print("🔐 [TX] Wallet loaded successfully")
        print("   Address: \(walletAddress)")

        // Convert USD amount to APT, then to Octas
        // $1000 = 1 APT, so $100 = 0.1 APT
        // 1 APT = 100,000,000 Octas
        let amountInAPT = amount / 1000.0
        let amountInOctas = UInt64(amountInAPT * 100_000_000)

        print("💵 [TX] Amount conversion:")
        print("   USD: $\(amount)")
        print("   APT: \(amountInAPT)")
        print("   Octas: \(amountInOctas)")

        // Create transaction payload - transfer from Wallet A to Wallet B
        let payload: [String: Any] = [
            "type": "entry_function_payload",
            "function": "0x1::aptos_account::transfer",
            "type_arguments": [],
            "arguments": [
                receiverAddress, // Send to Wallet B
                String(amountInOctas)
            ]
        ]

        // Get account sequence number
        guard let sequenceURL = URL(string: "\(fullnodeURL)/accounts/\(walletAddress)") else {
            throw TransactionError.networkError
        }

        print("📡 [TX] Fetching account info from testnet...")

        let (accountData, _) = try await URLSession.shared.data(from: sequenceURL)
        guard let accountInfo = try? JSONSerialization.jsonObject(with: accountData) as? [String: Any],
              let sequenceNumberString = accountInfo["sequence_number"] as? String else {
            throw TransactionError.networkError
        }

        print("✅ [TX] Account sequence number: \(sequenceNumberString)")

        // Create the transaction
        let transaction: [String: Any] = [
            "sender": walletAddress,
            "sequence_number": sequenceNumberString,
            "max_gas_amount": "2000",
            "gas_unit_price": "100",
            "expiration_timestamp_secs": String(Int(Date().timeIntervalSince1970) + 600),
            "payload": payload
        ]

        print("🚀 [TX] Encoding and signing transaction...")

        do {
            // Step 1: Encode the transaction
            print("📝 [TX] Step 1: Encoding transaction...")
            let encodedTxn = try await encodeTransaction(transaction: transaction)
            print("✅ [TX] Transaction encoded successfully")
            print("   Encoded size: \(encodedTxn.count) bytes")

            // Step 2: Sign the transaction with Ed25519
            print("🔐 [TX] Step 2: Signing transaction...")
            let signature = try signTransaction(encodedData: encodedTxn, privateKeyHex: privateKeyHex)
            print("✅ [TX] Transaction signed successfully")
            print("   Public key: \(signature.publicKey)")
            print("   Signature: \(signature.signature.prefix(20))...")

            // Step 3: Submit the signed transaction
            print("📤 [TX] Step 3: Submitting signed transaction...")
            let txHash = try await submitSignedTransaction(
                transaction: transaction,
                publicKey: signature.publicKey,
                signature: signature.signature
            )

            print("✅ [TX] Transaction submitted successfully!")
            print("   Hash: \(txHash)")

            return txHash
        } catch {
            print("❌ [TX] Transaction failed at some step")
            print("   Error: \(error)")
            print("   Error description: \(error.localizedDescription)")
            throw error
        }
    }

    /// Encode transaction using Aptos node
    private func encodeTransaction(transaction: [String: Any]) async throws -> Data {
        let url = URL(string: "\(fullnodeURL)/transactions/encode_submission")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONSerialization.data(withJSONObject: transaction)
        request.httpBody = jsonData

        print("📡 [ENCODE] Sending encode request to: \(url)")
        print("📦 [ENCODE] Transaction payload: \(String(data: jsonData, encoding: .utf8) ?? "N/A")")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [ENCODE] Invalid response type")
            throw TransactionError.networkError
        }

        print("📥 [ENCODE] Response status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ [ENCODE] Failed to encode transaction")
            print("   Status code: \(httpResponse.statusCode)")
            print("   Error body: \(errorBody)")
            throw TransactionError.transactionFailed
        }

        // The response is a hex string, convert to Data
        if let hexString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "") {
            print("✅ [ENCODE] Received hex string: \(hexString.prefix(40))...")
            let cleanHex = hexString.hasPrefix("0x") ? String(hexString.dropFirst(2)) : hexString
            if let encodedData = Data(hexString: cleanHex) {
                return encodedData
            } else {
                print("❌ [ENCODE] Failed to convert hex string to Data")
                throw TransactionError.transactionFailed
            }
        }

        print("❌ [ENCODE] Response is not a valid hex string")
        return data
    }

    /// Sign transaction with Ed25519 private key using CryptoKit
    private func signTransaction(encodedData: Data, privateKeyHex: String) throws -> (publicKey: String, signature: String) {
        guard let privateKeyData = Data(hexString: privateKeyHex) else {
            throw TransactionError.transactionFailed
        }

        let signingKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
        let signature = try signingKey.signature(for: encodedData)
        let publicKey = signingKey.publicKey

        return (
            publicKey: "0x" + publicKey.rawRepresentation.hexEncodedString(),
            signature: "0x" + signature.hexEncodedString()
        )
    }

    /// Submit signed transaction to Aptos testnet
    private func submitSignedTransaction(
        transaction: [String: Any],
        publicKey: String,
        signature: String
    ) async throws -> String {
        let signedTransaction: [String: Any] = [
            "sender": transaction["sender"]!,
            "sequence_number": transaction["sequence_number"]!,
            "max_gas_amount": transaction["max_gas_amount"]!,
            "gas_unit_price": transaction["gas_unit_price"]!,
            "expiration_timestamp_secs": transaction["expiration_timestamp_secs"]!,
            "payload": transaction["payload"]!,
            "signature": [
                "type": "ed25519_signature",
                "public_key": publicKey,
                "signature": signature
            ]
        ]

        let url = URL(string: "\(fullnodeURL)/transactions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONSerialization.data(withJSONObject: signedTransaction)
        request.httpBody = jsonData

        print("📡 [SUBMIT] Sending transaction to: \(url)")
        print("📦 [SUBMIT] Signed transaction size: \(jsonData.count) bytes")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [SUBMIT] Invalid response type")
            throw TransactionError.networkError
        }

        print("📥 [SUBMIT] Response status: \(httpResponse.statusCode)")

        if httpResponse.statusCode != 200 && httpResponse.statusCode != 202 {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ [SUBMIT] Transaction submission failed")
            print("   Status code: \(httpResponse.statusCode)")
            print("   Error body: \(errorBody)")
            throw TransactionError.transactionFailed
        }

        let responseBody = String(data: data, encoding: .utf8) ?? "N/A"
        print("📥 [SUBMIT] Response body: \(responseBody)")

        let result = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let hash = result?["hash"] as? String else {
            print("❌ [SUBMIT] No transaction hash in response")
            print("   Response: \(result ?? [:])")
            throw TransactionError.transactionFailed
        }

        print("✅ [SUBMIT] Transaction hash extracted: \(hash)")

        return hash
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
// MARK: - Data Extensions for Hex Conversion
extension Data {
    init?(hexString: String) {
        let cleanedHex = hexString.replacingOccurrences(of: "0x", with: "")
        let len = cleanedHex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = cleanedHex.index(cleanedHex.startIndex, offsetBy: i*2)
            let k = cleanedHex.index(j, offsetBy: 2)
            let bytes = cleanedHex[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }

    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
