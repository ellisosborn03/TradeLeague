import Foundation
import SwiftUI

/// Manages user transactions and activity history
class TransactionManager: ObservableObject {
    static let shared = TransactionManager()

    @Published var transactions: [Transaction] = []

    private init() {
        loadTransactions()
    }

    /// Add a new transaction to the activity feed
    func addTransaction(
        type: TransactionType,
        amount: Double,
        hash: String,
        description: String,
        status: TransactionStatus = .success
    ) {
        let transaction = Transaction(
            id: UUID().uuidString,
            type: type,
            amount: amount,
            hash: hash,
            status: status,
            timestamp: Date(),
            description: description
        )

        // Add to beginning of array (most recent first)
        transactions.insert(transaction, at: 0)

        // Save to UserDefaults
        saveTransactions()
    }

    /// Add a pending transaction and execute it on the blockchain
    /// Returns the transaction ID for tracking
    func addAndExecuteTransaction(
        type: TransactionType,
        amount: Double,
        description: String
    ) async throws -> String {
        // Create pending transaction with temporary hash
        let transactionId = UUID().uuidString
        let pendingTransaction = Transaction(
            id: transactionId,
            type: type,
            amount: amount,
            hash: "", // Will be updated with actual hash
            status: .pending,
            timestamp: Date(),
            description: description
        )

        // Add to beginning of array (most recent first)
        await MainActor.run {
            transactions.insert(pendingTransaction, at: 0)
            saveTransactions()
        }

        do {
            // Execute the actual blockchain transaction
            let (hash, _) = try await AptosService.shared.sendPayment(amountInAPT: amount)

            // Update transaction with actual hash and success status
            await MainActor.run {
                updateTransaction(id: transactionId, hash: hash, status: .success)
            }

            return transactionId
        } catch {
            // Update transaction to failed status
            await MainActor.run {
                updateTransaction(id: transactionId, hash: "", status: .failed)
            }
            throw error
        }
    }

    /// Update an existing transaction's status and hash
    func updateTransaction(id: String, hash: String, status: TransactionStatus) {
        if let index = transactions.firstIndex(where: { $0.id == id }) {
            let updatedTransaction = Transaction(
                id: transactions[index].id,
                type: transactions[index].type,
                amount: transactions[index].amount,
                hash: hash.isEmpty ? transactions[index].hash : hash,
                status: status,
                timestamp: transactions[index].timestamp,
                description: transactions[index].description
            )
            transactions[index] = updatedTransaction
            saveTransactions()
        }
    }

    /// Load transactions from storage
    private func loadTransactions() {
        // Clear any old mock transactions from UserDefaults
        // This ensures we start fresh with only real blockchain transactions
        UserDefaults.standard.removeObject(forKey: "userTransactions")

        // Start with empty transactions - only real blockchain transactions will be added
        transactions = []
    }

    /// Save transactions to storage
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "userTransactions")
        }
    }

    /// Load mock transactions for demo
    private func loadMockTransactions() {
        // Start with empty transactions - only show real blockchain transactions
        transactions = []
    }

    /// Clear all transactions (for testing)
    func clearTransactions() {
        transactions = []
        saveTransactions()
    }

    /// Get transactions for a specific type
    func getTransactions(ofType type: TransactionType) -> [Transaction] {
        return transactions.filter { $0.type == type }
    }
}
