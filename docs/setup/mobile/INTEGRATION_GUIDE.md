# Aptos Testnet Integration Guide - TradeLeague

This guide shows how to integrate Aptos testnet payments into the TradeLeague app using the configured Wallet A (sender) and Wallet B (receiver).

## Overview

All user-initiated payments in the app automatically:
1. Send the exact amount from **Wallet A** → **Wallet B**
2. Execute as real transactions on Aptos testnet
3. Display a transaction explorer link in the format: `transaction → [explorer URL]`

## Quick Start

### 1. Import the Service

```swift
import SwiftUI

struct MyView: View {
    @StateObject private var aptosService = AptosService.shared

    // ... your view code
}
```

### 2. Send a Payment

```swift
func handlePayment(amount: Double) async {
    do {
        // Send payment from Wallet A to Wallet B
        let (hash, explorerURL) = try await aptosService.sendPayment(amountInAPT: amount)

        // Display success with transaction link
        print("Transaction successful!")
        print("Hash: \(hash)")
        print("Explorer: \(explorerURL)")

    } catch {
        print("Transaction failed: \(error.localizedDescription)")
    }
}
```

### 3. Display Transaction Link

Use the provided UI components:

```swift
// Full transaction card
TransactionLinkView(
    transactionHash: hash,
    explorerURL: explorerURL
)

// Inline link
InlineTransactionLinkView(
    transactionHash: hash,
    explorerURL: explorerURL
)

// Success modal with transaction link
TransactionSuccessView(
    message: "Your prediction was placed successfully!",
    transactionHash: hash,
    explorerURL: explorerURL,
    onDismiss: {
        // Handle dismissal
    }
)
```

## Complete Example: Prediction View

Here's how to integrate payments into a prediction/betting view:

```swift
import SwiftUI

struct PredictionPaymentExample: View {
    @StateObject private var aptosService = AptosService.shared
    @State private var betAmount: String = ""
    @State private var isProcessing = false
    @State private var transactionHash: String?
    @State private var explorerURL: String?
    @State private var showSuccess = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Place Your Prediction")
                .font(.title2)
                .fontWeight(.bold)

            // Amount input
            TextField("Amount (APT)", text: $betAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Place bet button
            Button(action: {
                Task {
                    await placeBet()
                }
            }) {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Place Bet")
                        .fontWeight(.semibold)
                }
            }
            .disabled(isProcessing || betAmount.isEmpty)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentPurple)
            .foregroundColor(.white)
            .cornerRadius(12)

            // Error message
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .sheet(isPresented: $showSuccess) {
            if let hash = transactionHash, let url = explorerURL {
                TransactionSuccessView(
                    message: "Your prediction of \(betAmount) APT was placed successfully!",
                    transactionHash: hash,
                    explorerURL: url,
                    onDismiss: {
                        showSuccess = false
                        resetForm()
                    }
                )
            }
        }
    }

    private func placeBet() async {
        guard let amount = Double(betAmount), amount > 0 else {
            errorMessage = "Please enter a valid amount"
            return
        }

        isProcessing = true
        errorMessage = nil

        do {
            // Send payment from Wallet A to Wallet B
            let (hash, url) = try await aptosService.sendPayment(amountInAPT: amount)

            // Store transaction details
            transactionHash = hash
            explorerURL = url

            // Show success
            showSuccess = true

        } catch {
            errorMessage = "Transaction failed: \(error.localizedDescription)"
        }

        isProcessing = false
    }

    private func resetForm() {
        betAmount = ""
        transactionHash = nil
        explorerURL = nil
        errorMessage = nil
    }
}
```

## Available Methods in AptosService

### Payment Methods

```swift
// Send payment from Wallet A to Wallet B
func sendPayment(amountInAPT: Double) async throws -> (hash: String, explorerURL: String)
```

### Balance Methods

```swift
// Get Wallet A (sender) balance
func getWalletABalance() async throws -> Double

// Get Wallet B (receiver) balance
func getWalletBBalance() async throws -> Double

// Get any address balance
func getTokenBalance(address: String, tokenType: String = "0x1::aptos_coin::AptosCoin") async throws -> Double
```

### Explorer URL Helpers

```swift
// Generate transaction explorer URL
func getExplorerURL(forTransaction hash: String) -> String

// Generate account explorer URL
func getExplorerURL(forAccount address: String) -> String

// Get Wallet A explorer URL
func getWalletAExplorerURL() -> String

// Get Wallet B explorer URL
func getWalletBExplorerURL() -> String
```

### Transaction Status

```swift
// Check transaction status
func getTransactionStatus(hash: String) async throws -> TransactionStatus
```

## UI Components

### TransactionLinkView

Full-width card displaying transaction link:

```swift
TransactionLinkView(
    transactionHash: "0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4",
    explorerURL: "https://explorer.aptoslabs.com/txn/0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4?network=testnet"
)
```

### InlineTransactionLinkView

Compact inline link:

```swift
InlineTransactionLinkView(
    transactionHash: hash,
    explorerURL: explorerURL
)
```

### TransactionSuccessView

Success modal with transaction link:

```swift
TransactionSuccessView(
    message: "Payment sent successfully!",
    transactionHash: hash,
    explorerURL: explorerURL,
    onDismiss: {
        // Handle dismissal
    }
)
```

## Integration Checklist

- [ ] **Fund Wallets**: Visit the faucet links in `FUNDING_INSTRUCTIONS.md`
- [ ] **Import AptosService**: Use `@StateObject private var aptosService = AptosService.shared`
- [ ] **Handle User Input**: Get the amount from the user
- [ ] **Send Payment**: Call `aptosService.sendPayment(amountInAPT: amount)`
- [ ] **Display Result**: Show transaction link using one of the UI components
- [ ] **Error Handling**: Wrap in do-catch and show error messages

## Example: Trade View Integration

```swift
struct TradeFollowExample: View {
    @StateObject private var aptosService = AptosService.shared
    let vault: Vault
    @State private var followAmount: String = ""
    @State private var isProcessing = false
    @State private var lastTransaction: (hash: String, url: String)?

    var body: some View {
        VStack(spacing: 16) {
            Text("Follow \(vault.name)")
                .font(.title3)
                .fontWeight(.bold)

            TextField("Amount to follow (APT)", text: $followAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Follow Vault") {
                Task {
                    await followVault()
                }
            }
            .disabled(isProcessing)

            // Show last transaction if exists
            if let tx = lastTransaction {
                TransactionLinkView(
                    transactionHash: tx.hash,
                    explorerURL: tx.url
                )
            }
        }
        .padding()
    }

    private func followVault() async {
        guard let amount = Double(followAmount), amount > 0 else { return }

        isProcessing = true
        defer { isProcessing = false }

        do {
            // Send payment on Aptos testnet
            let (hash, url) = try await aptosService.sendPayment(amountInAPT: amount)

            // Store transaction for display
            lastTransaction = (hash, url)

            // TODO: Also call your backend API to record the vault following

        } catch {
            print("Failed to follow vault: \(error)")
        }
    }
}
```

## Testing

### 1. Check Wallet Balances

```swift
Task {
    let balanceA = try await aptosService.getWalletABalance()
    let balanceB = try await aptosService.getWalletBBalance()
    print("Wallet A: \(balanceA) APT")
    print("Wallet B: \(balanceB) APT")
}
```

### 2. Send Test Payment

```swift
Task {
    do {
        let (hash, url) = try await aptosService.sendPayment(amountInAPT: 0.001)
        print("Transaction: \(url)")
    } catch {
        print("Error: \(error)")
    }
}
```

### 3. View on Explorer

All transaction URLs follow this format:
```
https://explorer.aptoslabs.com/txn/[TRANSACTION_HASH]?network=testnet
```

Click the link to view:
- Transaction status (Success/Failed)
- Gas used
- Timestamp
- Sender (Wallet A)
- Receiver (Wallet B)
- Amount transferred

## Error Handling

The service can throw these errors:

```swift
enum AptosError: LocalizedError {
    case transactionFailed(String)
    case networkError(String)
    case invalidResponse
    case insufficientBalance
}
```

Example error handling:

```swift
do {
    let result = try await aptosService.sendPayment(amountInAPT: amount)
} catch AptosError.insufficientBalance {
    showError("Insufficient balance in wallet")
} catch AptosError.transactionFailed(let message) {
    showError("Transaction failed: \(message)")
} catch {
    showError("An unexpected error occurred")
}
```

## Wallet Information

**Wallet A (Sender)**
- Address: `0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155`
- Explorer: https://explorer.aptoslabs.com/account/0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155?network=testnet

**Wallet B (Receiver)**
- Address: `0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a`
- Explorer: https://explorer.aptoslabs.com/account/0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a?network=testnet

## Next Steps

1. ✅ Fund both wallets (see `FUNDING_INSTRUCTIONS.md`)
2. ✅ Test the integration with small amounts
3. ✅ Integrate into your app's payment flows:
   - Predictions/Bets
   - Vault following
   - League entry fees
   - Any other user payments
4. ✅ Always display transaction links for transparency

## Support

For full wallet details and credentials, see:
- `APTOS_WALLETS.md` - Complete wallet information
- `FUNDING_INSTRUCTIONS.md` - How to fund wallets
- `check-wallets.sh` - Script to check wallet balances

---

**Remember**: All payments automatically go from Wallet A → Wallet B on Aptos testnet. The transaction link format is always:
```
transaction → https://explorer.aptoslabs.com/txn/[HASH]?network=testnet
```
