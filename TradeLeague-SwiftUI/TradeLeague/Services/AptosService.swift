import Foundation
import Network

// MARK: - Aptos Service
class AptosService: ObservableObject {
    static let shared = AptosService()

    private let fullnodeURL = "https://fullnode.testnet.aptoslabs.com/v1"
    private let moduleAddress = "0x1" // Replace with actual deployed address

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

    // MARK: - Transaction Helpers
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