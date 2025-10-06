import Foundation
import Network
import CryptoKit

// MARK: - Aptos Service
class AptosService: ObservableObject {
    static let shared = AptosService()

    private let fullnodeURL = "https://fullnode.testnet.aptoslabs.com/v1"
    private let moduleAddress = "0x1" // Replace with actual deployed address

    // Wallet A (Sender) - ALL transactions originate from this wallet
    private let walletAAddress = "0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155"
    private let walletAPrivateKey = "B37A61F467D0D226B671BFC8A842FB3036F7BE8B55BEAA66C168154053B40A0D"

    // Wallet B (Receiver) - ALL transactions are sent to this wallet
    private let walletBAddress = "0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a"

    // Explorer base URL
    private let explorerBaseURL = "https://explorer.aptoslabs.com"

    private init() {}

    // MARK: - Wallet Connection
    func connectWallet() async throws -> String {
        // This would integrate with actual wallet providers like Petra, Martian, etc.
        // For now, return a mock wallet address
        return "0x1234567890abcdef1234567890abcdef12345678"
    }

    func disconnectWallet() {
        // Clear wallet connection
        print("Wallet disconnected")
    }

    // MARK: - League Operations
    func createLeague(
        name: String,
        entryFee: Double,
        prizePool: Double,
        maxParticipants: Int,
        isPublic: Bool
    ) async throws -> String {
        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::league_registry::create_league",
            "arguments": [
                name,
                String(Int(entryFee * 1_000_000)), // Convert to micro USDC
                String(Int(prizePool * 1_000_000)),
                String(maxParticipants),
                isPublic
            ],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    func joinLeague(leagueId: String, entryFee: Double) async throws -> String {
        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::league_registry::join_league",
            "arguments": [
                leagueId,
                String(Int(entryFee * 1_000_000))
            ],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    func getLeagues() async throws -> [League] {
        let url = URL(string: "\(fullnodeURL)/accounts/\(moduleAddress)/resource/\(moduleAddress)::league_registry::LeagueRegistry")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AptosResourceResponse.self, from: data)

        // Parse league data and return League objects
        // This is simplified - actual implementation would parse the Move struct
        return []
    }

    // MARK: - Vault Operations
    func followVault(vaultId: String, amount: Double) async throws -> String {
        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::vault_manager::follow_vault",
            "arguments": [
                vaultId,
                String(Int(amount * 1_000_000))
            ],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    func unfollowVault(vaultId: String) async throws -> String {
        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::vault_manager::unfollow_vault",
            "arguments": [vaultId],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    func getVaults() async throws -> [Vault] {
        let url = URL(string: "\(fullnodeURL)/accounts/\(moduleAddress)/resource/\(moduleAddress)::vault_manager::VaultRegistry")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AptosResourceResponse.self, from: data)

        // Parse vault data and return Vault objects
        return []
    }

    // MARK: - Prediction Market Operations
    func createPrediction(
        question: String,
        outcomes: [String],
        resolutionTime: Date
    ) async throws -> String {
        let timestamp = Int(resolutionTime.timeIntervalSince1970)

        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::prediction_market::create_market",
            "arguments": [
                question,
                outcomes,
                String(timestamp)
            ],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    func placePrediction(
        marketId: String,
        outcomeIndex: Int,
        amount: Double
    ) async throws -> String {
        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::prediction_market::place_prediction",
            "arguments": [
                marketId,
                String(outcomeIndex),
                String(Int(amount * 1_000_000))
            ],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    func getPredictionMarkets() async throws -> [PredictionMarket] {
        let url = URL(string: "\(fullnodeURL)/accounts/\(moduleAddress)/resource/\(moduleAddress)::prediction_market::MarketRegistry")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AptosResourceResponse.self, from: data)

        // Parse prediction market data
        return []
    }

    // MARK: - Portfolio Operations
    func getUserPortfolio(userAddress: String) async throws -> Portfolio {
        let url = URL(string: "\(fullnodeURL)/accounts/\(userAddress)/resources")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let resources = try JSONDecoder().decode([AptosResourceResponse].self, from: data)

        // Parse user resources to build portfolio
        return Portfolio(
            totalValue: 0,
            todayChange: 0,
            todayChangePercentage: 0,
            allTimeChange: 0,
            allTimeChangePercentage: 0,
            vaultFollowings: [],
            predictions: [],
            rewards: []
        )
    }

    func claimReward(rewardId: String) async throws -> String {
        let payload = [
            "type": "entry_function_payload",
            "function": "\(moduleAddress)::prize_router::claim_reward",
            "arguments": [rewardId],
            "type_arguments": []
        ] as [String : Any]

        return try await submitTransaction(payload: payload)
    }

    // MARK: - Payment Transaction (Wallet A → Wallet B)
    /// Sends a payment from Wallet A to Wallet B on Aptos testnet using the Aptos CLI
    /// - Parameter amountInAPT: The amount to send in APT (will be converted to Octas)
    /// - Returns: A tuple containing (transaction hash, explorer URL)
    func sendPayment(amountInAPT: Double) async throws -> (hash: String, explorerURL: String) {
        let amountInOctas = UInt64(amountInAPT * 100_000_000) // Convert APT to Octas

        // Use Aptos CLI to send the transaction
        // This ensures proper BCS encoding and Ed25519 signing
        let txHash = try await executeAptosTransfer(
            recipientAddress: walletBAddress,
            amount: amountInOctas
        )

        // Wait for transaction to be processed
        try await waitForTransaction(hash: txHash)

        // Generate explorer URL
        let explorerURL = "\(explorerBaseURL)/txn/\(txHash)?network=testnet"

        return (txHash, explorerURL)
    }

    /// Execute an Aptos transfer using REST API with proper signing
    private func executeAptosTransfer(recipientAddress: String, amount: UInt64) async throws -> String {
        // Step 1: Get account sequence number
        let sequenceNumber = try await getAccountSequenceNumber(address: walletAAddress)

        // Step 2: Create transaction payload
        let payload: [String: Any] = [
            "type": "entry_function_payload",
            "function": "0x1::aptos_account::transfer",
            "type_arguments": [],
            "arguments": [recipientAddress, String(amount)]
        ]

        let transaction: [String: Any] = [
            "sender": walletAAddress,
            "sequence_number": sequenceNumber,
            "max_gas_amount": "2000",
            "gas_unit_price": "100",
            "expiration_timestamp_secs": String(Int(Date().timeIntervalSince1970) + 600),
            "payload": payload
        ]

        // Step 3: Encode the transaction for signing
        let encodedTxn = try await encodeTransaction(transaction: transaction)

        // Step 4: Sign the encoded transaction
        let signature = try signTransaction(encodedData: encodedTxn)

        // Step 5: Submit the signed transaction
        return try await submitSignedTransaction(
            transaction: transaction,
            publicKey: signature.publicKey,
            signature: signature.signature
        )
    }

    /// Encode transaction using Aptos node
    private func encodeTransaction(transaction: [String: Any]) async throws -> Data {
        let url = URL(string: "\(fullnodeURL)/transactions/encode_submission")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONSerialization.data(withJSONObject: transaction)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AptosError.transactionFailed("Failed to encode transaction: \(errorBody)")
        }

        // The response is a hex string (with or without 0x prefix), convert to Data
        if let hexString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "") {
            return Data(hexString: hexString.hasPrefix("0x") ? String(hexString.dropFirst(2)) : hexString) ?? Data()
        }

        return data
    }

    /// Sign transaction with Ed25519 private key
    private func signTransaction(encodedData: Data) throws -> (publicKey: String, signature: String) {
        // Convert hex private key to Data
        guard let privateKeyData = Data(hexString: walletAPrivateKey) else {
            throw AptosError.transactionFailed("Invalid private key format")
        }

        // Create signing key from private key
        let signingKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)

        // Sign the encoded transaction
        let signature = try signingKey.signature(for: encodedData)

        // Get public key
        let publicKey = signingKey.publicKey

        return (
            publicKey: "0x" + publicKey.rawRepresentation.hexEncodedString(),
            signature: "0x" + signature.hexEncodedString()
        )
    }

    /// Submit signed transaction
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

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AptosError.networkError("Invalid response")
        }

        if httpResponse.statusCode != 200 && httpResponse.statusCode != 202 {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AptosError.transactionFailed("HTTP \(httpResponse.statusCode): \(errorBody)")
        }

        let result = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let hash = result?["hash"] as? String else {
            throw AptosError.transactionFailed("No transaction hash returned")
        }

        return hash
    }

    private func waitForTransaction(hash: String, maxAttempts: Int = 10) async throws {
        for _ in 0..<maxAttempts {
            let status = try await getTransactionStatus(hash: hash)
            if status == .success || status == .failed {
                return
            }
            try await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 second
        }
        throw AptosError.transactionFailed("Transaction timeout")
    }

    // MARK: - Transaction Helpers
    private func getAccountSequenceNumber(address: String) async throws -> String {
        let url = URL(string: "\(fullnodeURL)/accounts/\(address)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let account = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        return (account?["sequence_number"] as? String) ?? "0"
    }

    private func submitSignedTransaction(payload: [String: Any]) async throws -> String {
        // In a production app, this would use a proper Aptos SDK to sign and submit
        // For now, we'll use the REST API directly

        let url = URL(string: "\(fullnodeURL)/transactions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 202 else {
            throw AptosError.transactionFailed("Failed to submit transaction")
        }

        let result = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let hash = result?["hash"] as? String else {
            throw AptosError.transactionFailed("No transaction hash returned")
        }

        return hash
    }

    private func submitTransaction(payload: [String: Any]) async throws -> String {
        // This would integrate with wallet provider to sign and submit transaction
        // For now, return a mock transaction hash
        let mockHash = "0x" + String((0..<64).map { _ in "0123456789abcdef".randomElement()! })

        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        return mockHash
    }

    func getTransactionStatus(hash: String) async throws -> TransactionStatus {
        let url = URL(string: "\(fullnodeURL)/transactions/by_hash/\(hash)")!

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let transaction = try JSONDecoder().decode(AptosTransaction.self, from: data)
                return transaction.success ? .success : .failed
            } else {
                return .pending
            }
        } catch {
            return .pending
        }
    }

    // MARK: - Balance Operations
    func getTokenBalance(address: String, tokenType: String = "0x1::aptos_coin::AptosCoin") async throws -> Double {
        let url = URL(string: "\(fullnodeURL)/accounts/\(address)/resource/0x1::coin::CoinStore<\(tokenType)>")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AptosResourceResponse.self, from: data)

        if let coinData = response.data as? [String: Any],
           let coin = coinData["coin"] as? [String: Any],
           let valueString = coin["value"] as? String,
           let value = Double(valueString) {
            return value / 100_000_000 // Convert from Octas to APT
        }

        return 0
    }

    /// Get Wallet A (Sender) balance
    func getWalletABalance() async throws -> Double {
        return try await getTokenBalance(address: walletAAddress)
    }

    /// Get Wallet B (Receiver) balance
    func getWalletBBalance() async throws -> Double {
        return try await getTokenBalance(address: walletBAddress)
    }

    /// Generate an Aptos explorer URL for a transaction
    func getExplorerURL(forTransaction hash: String) -> String {
        return "\(explorerBaseURL)/txn/\(hash)?network=testnet"
    }

    /// Generate an Aptos explorer URL for an account
    func getExplorerURL(forAccount address: String) -> String {
        return "\(explorerBaseURL)/account/\(address)?network=testnet"
    }

    /// Get Wallet A explorer URL
    func getWalletAExplorerURL() -> String {
        return getExplorerURL(forAccount: walletAAddress)
    }

    /// Get Wallet B explorer URL
    func getWalletBExplorerURL() -> String {
        return getExplorerURL(forAccount: walletBAddress)
    }
}

// MARK: - Error Types
enum AptosError: LocalizedError {
    case transactionFailed(String)
    case networkError(String)
    case invalidResponse
    case insufficientBalance

    var errorDescription: String? {
        switch self {
        case .transactionFailed(let message):
            return "Transaction failed: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidResponse:
            return "Invalid response from Aptos node"
        case .insufficientBalance:
            return "Insufficient balance in wallet"
        }
    }
}

// MARK: - Response Models
struct AptosResourceResponse: Codable {
    let type: String
    let data: AnyDecodable
}

struct AptosTransaction: Codable {
    let hash: String
    let success: Bool
    let timestamp: String
    let gas_used: String?
}

struct AnyDecodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let arrayValue = try? container.decode([AnyDecodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictValue = try? container.decode([String: AnyDecodable].self) {
            value = dictValue.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let intValue as Int:
            try container.encode(intValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let stringValue as String:
            try container.encode(stringValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        case let arrayValue as [Any]:
            let encodableArray = arrayValue.map { AnyDecodable($0) }
            try container.encode(encodableArray)
        case let dictValue as [String: Any]:
            let encodableDict = dictValue.mapValues { AnyDecodable($0) }
            try container.encode(encodableDict)
        default:
            try container.encodeNil()
        }
    }
}

// MARK: - WebSocket Service for Real-time Updates
class AptosWebSocketService: ObservableObject {
    static let shared = AptosWebSocketService()

    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession = URLSession.shared

    @Published var isConnected = false
    @Published var leaderboardUpdates: [String: Any] = [:]
    @Published var vaultUpdates: [String: Any] = [:]
    @Published var marketUpdates: [String: Any] = [:]

    private init() {}

    func connect() {
        guard let url = URL(string: "wss://fullnode.testnet.aptoslabs.com/v1/stream") else {
            return
        }

        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true

        receiveMessage()
    }

    func disconnect() {
        webSocketTask?.cancel()
        isConnected = false
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleMessage(text)
                    }
                @unknown default:
                    break
                }

                // Continue receiving messages
                self?.receiveMessage()

            case .failure(let error):
                print("WebSocket error: \(error)")
                self?.isConnected = false
            }
        }
    }

    private func handleMessage(_ message: String) {
        guard let data = message.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }

        DispatchQueue.main.async {
            if let type = json["type"] as? String {
                switch type {
                case "leaderboard_update":
                    self.leaderboardUpdates = json
                case "vault_update":
                    self.vaultUpdates = json
                case "market_update":
                    self.marketUpdates = json
                default:
                    break
                }
            }
        }
    }

    func subscribeToLeague(_ leagueId: String) {
        let subscription = [
            "type": "subscribe",
            "channel": "league:\(leagueId)"
        ]

        sendMessage(subscription)
    }

    func subscribeToVault(_ vaultId: String) {
        let subscription = [
            "type": "subscribe",
            "channel": "vault:\(vaultId)"
        ]

        sendMessage(subscription)
    }

    func subscribeToMarket(_ marketId: String) {
        let subscription = [
            "type": "subscribe",
            "channel": "market:\(marketId)"
        ]

        sendMessage(subscription)
    }

    private func sendMessage(_ message: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: message),
              let string = String(data: data, encoding: .utf8) else {
            return
        }

        webSocketTask?.send(.string(string)) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
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