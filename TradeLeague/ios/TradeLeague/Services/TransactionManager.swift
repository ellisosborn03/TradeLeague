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
        description: String
    ) {
        let transaction = Transaction(
            id: UUID().uuidString,
            type: type,
            amount: amount,
            hash: hash,
            status: .success,
            timestamp: Date(),
            description: description
        )

        // Add to beginning of array (most recent first)
        transactions.insert(transaction, at: 0)

        // Save to UserDefaults
        saveTransactions()
    }

    /// Load transactions from storage
    private func loadTransactions() {
        // Try to load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "userTransactions"),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        } else {
            // Load mock data for demo
            loadMockTransactions()
        }
    }

    /// Save transactions to storage
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "userTransactions")
        }
    }

    /// Load mock transactions for demo
    private func loadMockTransactions() {
        transactions = [
            Transaction(
                id: "1",
                type: .follow,
                amount: 1000,
                hash: "0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4",
                status: .success,
                timestamp: Date(),
                description: "Followed Hyperion LP Strategy"
            ),
            Transaction(
                id: "2",
                type: .prediction,
                amount: 250,
                hash: "0x3a2cc8e76559d458ebd7a391849d99745ccf755c4f6c2526979d27c1dd9f3ec5",
                status: .success,
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
                description: "Predicted APT price increase"
            ),
            Transaction(
                id: "3",
                type: .deposit,
                amount: 500,
                hash: "0x5b3dd9f8770ad459fce8b4b2839e88856ddf866e5f7d3527a80e26c2fe8a4bc6",
                status: .success,
                timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                description: "Deposited to account"
            ),
            Transaction(
                id: "4",
                type: .reward,
                amount: 150,
                hash: "0x7c4ee9c68770bd570efe9c5f3a3f1891769af966ef8c4638b71e37d1de9b5dc7",
                status: .success,
                timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                description: "League reward claimed"
            )
        ]
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
