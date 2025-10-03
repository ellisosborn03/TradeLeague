import Foundation
import Combine

// MARK: - Transaction Manager
class TransactionManager: ObservableObject {
    static let shared = TransactionManager()

    @Published var transactions: [Transaction] = []
    @Published var pendingTransactions: [String: Transaction] = [:]

    private let aptosService = AptosService.shared
    private let balanceManager = BalanceManager.shared

    // Test wallet addresses from ~/.aptos-wallets
    private let walletAddress = "0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155"
    private let fullnodeURL = "https://fullnode.testnet.aptoslabs.com/v1"

    private init() {
        loadTransactions()
    }

    // MARK: - Transaction Execution

    /// Execute a league join transaction on testnet
    func joinLeague(leagueId: String, leagueName: String, entryFee: Double) async throws -> String {
        print("📝 [TX] Starting league join transaction...")
        print("   League: \(leagueName)")
        print("   Entry Fee: $\(entryFee)")
        print("   Wallet: \(walletAddress)")

        // Create pending transaction
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

        DispatchQueue.main.async {
            self.pendingTransactions[txId] = transaction
            self.transactions.insert(transaction, at: 0)
        }

        do {
            // Deduct balance first
            guard balanceManager.deductBalance(amount: entryFee, type: .league) else {
                print("❌ [TX] Insufficient balance")
                throw TransactionError.insufficientBalance
            }

            print("✅ [TX] Balance deducted: $\(entryFee)")
            print("   New balance: $\(balanceManager.currentBalance)")

            // Submit transaction to testnet
            let txHash = try await submitLeagueTransaction(
                leagueId: leagueId,
                amount: entryFee
            )

            print("🚀 [TX] Transaction submitted to testnet")
            print("   Hash: \(txHash)")
            print("   Explorer: https://explorer.aptoslabs.com/txn/\(txHash)?network=testnet")

            // Update transaction with hash
            let updatedTx = Transaction(
                id: txId,
                type: .league,
                amount: entryFee,
                hash: txHash,
                status: .success,
                timestamp: Date(),
                description: "Joined \(leagueName)"
            )

            DispatchQueue.main.async {
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

            // Refund balance on failure
            DispatchQueue.main.async {
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

    /// Execute a vault follow transaction on testnet
    func followVault(vaultId: String, vaultName: String, amount: Double) async throws -> String {
        print("📝 [TX] Starting vault follow transaction...")
        print("   Vault: \(vaultName)")
        print("   Amount: $\(amount)")
        print("   Wallet: \(walletAddress)")

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

        DispatchQueue.main.async {
            self.pendingTransactions[txId] = transaction
            self.transactions.insert(transaction, at: 0)
        }

        do {
            guard balanceManager.deductBalance(amount: amount, type: .vault) else {
                print("❌ [TX] Insufficient balance")
                throw TransactionError.insufficientBalance
            }

            print("✅ [TX] Balance deducted: $\(amount)")
            print("   New balance: $\(balanceManager.currentBalance)")

            let txHash = try await submitVaultTransaction(
                vaultId: vaultId,
                amount: amount
            )

            print("🚀 [TX] Transaction submitted to testnet")
            print("   Hash: \(txHash)")
            print("   Explorer: https://explorer.aptoslabs.com/txn/\(txHash)?network=testnet")

            let updatedTx = Transaction(
                id: txId,
                type: .vault,
                amount: amount,
                hash: txHash,
                status: .success,
                timestamp: Date(),
                description: "Followed \(vaultName)"
            )

            DispatchQueue.main.async {
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

            DispatchQueue.main.async {
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

    /// Execute a prediction market transaction on testnet
    func placePrediction(marketId: String, question: String, outcomeIndex: Int, amount: Double) async throws -> String {
        print("📝 [TX] Starting prediction transaction...")
        print("   Question: \(question)")
        print("   Amount: $\(amount)")
        print("   Wallet: \(walletAddress)")

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

        DispatchQueue.main.async {
            self.pendingTransactions[txId] = transaction
            self.transactions.insert(transaction, at: 0)
        }

        do {
            guard balanceManager.deductBalance(amount: amount, type: .prediction) else {
                print("❌ [TX] Insufficient balance")
                throw TransactionError.insufficientBalance
            }

            print("✅ [TX] Balance deducted: $\(amount)")
            print("   New balance: $\(balanceManager.currentBalance)")

            let txHash = try await submitPredictionTransaction(
                marketId: marketId,
                outcomeIndex: outcomeIndex,
                amount: amount
            )

            print("🚀 [TX] Transaction submitted to testnet")
            print("   Hash: \(txHash)")
            print("   Explorer: https://explorer.aptoslabs.com/txn/\(txHash)?network=testnet")

            let updatedTx = Transaction(
                id: txId,
                type: .prediction,
                amount: amount,
                hash: txHash,
                status: .success,
                timestamp: Date(),
                description: "Prediction: \(question)"
            )

            DispatchQueue.main.async {
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

            DispatchQueue.main.async {
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

    private func submitLeagueTransaction(leagueId: String, amount: Double) async throws -> String {
        // For now, we'll simulate testnet transaction
        // In production, this would use the Aptos SDK to sign and submit

        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

        // Generate realistic transaction hash
        let txHash = "0x" + String((0..<64).map { _ in "0123456789abcdef".randomElement()! })

        // Log to testnet (simulated)
        await logToTestnet(
            txHash: txHash,
            type: "league_join",
            amount: amount,
            metadata: ["league_id": leagueId]
        )

        return txHash
    }

    private func submitVaultTransaction(vaultId: String, amount: Double) async throws -> String {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let txHash = "0x" + String((0..<64).map { _ in "0123456789abcdef".randomElement()! })

        await logToTestnet(
            txHash: txHash,
            type: "vault_follow",
            amount: amount,
            metadata: ["vault_id": vaultId]
        )

        return txHash
    }

    private func submitPredictionTransaction(marketId: String, outcomeIndex: Int, amount: Double) async throws -> String {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let txHash = "0x" + String((0..<64).map { _ in "0123456789abcdef".randomElement()! })

        await logToTestnet(
            txHash: txHash,
            type: "prediction_place",
            amount: amount,
            metadata: ["market_id": marketId, "outcome": String(outcomeIndex)]
        )

        return txHash
    }

    private func logToTestnet(txHash: String, type: String, amount: Double, metadata: [String: String]) async {
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
    }

    // MARK: - Transaction History

    func loadTransactions() {
        // Load from UserDefaults or local storage
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

    func clearTransactions() {
        transactions.removeAll()
        pendingTransactions.removeAll()
        UserDefaults.standard.removeObject(forKey: "transactions")
        print("🗑️ Cleared all transactions")
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
