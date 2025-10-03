import SwiftUI

/// Demo view for testing Aptos testnet payments
/// Shows wallet balances and allows sending test transactions
struct AptosTestView: View {
    @StateObject private var aptosService = AptosService.shared
    @StateObject private var transactionManager = TransactionManager.shared
    @State private var walletABalance: Double = 0
    @State private var walletBBalance: Double = 0
    @State private var sendAmount: String = "0.01"
    @State private var isLoading = false
    @State private var isSending = false
    @State private var lastTransaction: (hash: String, url: String)?
    @State private var errorMessage: String?
    @State private var showSuccess = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🚀 Aptos Testnet")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)

                            Text("Live Payment Demo")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                        }
                        .padding(.top)

                        // Wallet A Card
                        WalletCardView(
                            title: "Wallet A (Sender)",
                            address: "0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155",
                            balance: walletABalance,
                            isLoading: isLoading,
                            explorerURL: aptosService.getWalletAExplorerURL()
                        )

                        // Arrow
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.accentPurple)

                        // Wallet B Card
                        WalletCardView(
                            title: "Wallet B (Receiver)",
                            address: "0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a",
                            balance: walletBBalance,
                            isLoading: isLoading,
                            explorerURL: aptosService.getWalletBExplorerURL()
                        )

                        // Send Payment Section
                        VStack(spacing: 16) {
                            Text("Send Test Payment")
                                .font(.headline)
                                .foregroundColor(.primaryText)

                            HStack {
                                TextField("Amount", text: $sendAmount)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)

                                Text("APT")
                                    .foregroundColor(.secondaryText)
                                    .padding(.trailing)
                            }

                            Button(action: {
                                Task {
                                    await sendPayment()
                                }
                            }) {
                                HStack {
                                    if isSending {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Image(systemName: "paperplane.fill")
                                        Text("Send from A → B")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(walletABalance > 0 ? Color.accentPurple : Color.gray)
                                )
                                .foregroundColor(.white)
                            }
                            .disabled(isSending || walletABalance == 0)
                            .padding(.horizontal)

                            if let error = errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.cardBackground)
                        )
                        .padding(.horizontal)

                        // Last Transaction
                        if let tx = lastTransaction {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Last Transaction")
                                    .font(.headline)
                                    .foregroundColor(.primaryText)

                                TransactionLinkView(
                                    transactionHash: tx.hash,
                                    explorerURL: tx.url
                                )
                            }
                            .padding(.horizontal)
                        }

                        // Refresh Button
                        Button(action: {
                            Task {
                                await loadBalances()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Refresh Balances")
                            }
                            .foregroundColor(.accentPurple)
                        }
                        .padding(.bottom)

                        // Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ℹ️ How it works")
                                .font(.headline)
                                .foregroundColor(.primaryText)

                            VStack(alignment: .leading, spacing: 8) {
                                InfoRow(icon: "1.circle.fill", text: "Fund Wallet A using the testnet faucet")
                                InfoRow(icon: "2.circle.fill", text: "Enter an amount and tap 'Send'")
                                InfoRow(icon: "3.circle.fill", text: "Transaction executes on Aptos testnet")
                                InfoRow(icon: "4.circle.fill", text: "View transaction on explorer")
                            }

                            if walletABalance == 0 {
                                Link(destination: URL(string: "https://aptos.dev/network/faucet?address=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155")!) {
                                    HStack {
                                        Image(systemName: "drop.fill")
                                        Text("Get Testnet APT from Faucet")
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.green)
                                    )
                                    .foregroundColor(.white)
                                }
                                .padding(.top)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.cardBackground.opacity(0.5))
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await loadBalances()
                }
            }
            .sheet(isPresented: $showSuccess) {
                if let tx = lastTransaction {
                    TransactionSuccessView(
                        message: "Successfully sent \(sendAmount) APT from Wallet A to Wallet B!",
                        transactionHash: tx.hash,
                        explorerURL: tx.url,
                        onDismiss: {
                            showSuccess = false
                            Task {
                                await loadBalances()
                            }
                        }
                    )
                }
            }
        }
    }

    private func loadBalances() async {
        isLoading = true
        errorMessage = nil

        do {
            async let balanceA = aptosService.getWalletABalance()
            async let balanceB = aptosService.getWalletBBalance()

            walletABalance = try await balanceA
            walletBBalance = try await balanceB
        } catch {
            errorMessage = "Failed to load balances: \(error.localizedDescription)"
            walletABalance = 0
            walletBBalance = 0
        }

        isLoading = false
    }

    private func sendPayment() async {
        guard let amount = Double(sendAmount), amount > 0 else {
            errorMessage = "Please enter a valid amount"
            return
        }

        guard amount <= walletABalance else {
            errorMessage = "Insufficient balance in Wallet A"
            return
        }

        isSending = true
        errorMessage = nil

        do {
            let (hash, url) = try await aptosService.sendPayment(amountInAPT: amount)
            lastTransaction = (hash, url)

            // Add to activity feed
            transactionManager.addTransaction(
                type: .deposit,
                amount: amount,
                hash: hash,
                description: "Test payment: \(amount) APT"
            )

            showSuccess = true
        } catch {
            errorMessage = "Transaction failed: \(error.localizedDescription)"
        }

        isSending = false
    }
}

struct WalletCardView: View {
    let title: String
    let address: String
    let balance: Double
    let isLoading: Bool
    let explorerURL: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primaryText)

                Spacer()

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentPurple))
                }
            }

            Text(balance == 0 ? "0 APT" : String(format: "%.4f APT", balance))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(balance > 0 ? .green : .secondaryText)

            Text(address.prefix(16) + "..." + address.suffix(8))
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondaryText)

            Link(destination: URL(string: explorerURL)!) {
                HStack {
                    Image(systemName: "link.circle.fill")
                    Text("View on Explorer")
                        .font(.caption)
                }
                .foregroundColor(.accentPurple)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentPurple.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentPurple)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondaryText)
        }
    }
}

// Preview
struct AptosTestView_Previews: PreviewProvider {
    static var previews: some View {
        AptosTestView()
    }
}
