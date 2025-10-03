import SwiftUI

/// A view component that displays an Aptos testnet transaction link
struct TransactionLinkView: View {
    let transactionHash: String
    let explorerURL: String

    var body: some View {
        Link(destination: URL(string: explorerURL)!) {
            HStack(spacing: 12) {
                // Transaction icon
                Image(systemName: "link.circle.fill")
                    .font(.title3)
                    .foregroundColor(.accentPurple)

                VStack(alignment: .leading, spacing: 4) {
                    Text("transaction")
                        .font(.caption)
                        .foregroundColor(.secondaryText)

                    Text(transactionHash.prefix(16) + "..." + transactionHash.suffix(8))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.primaryText)
                }

                Spacer()

                Image(systemName: "arrow.up.forward.square.fill")
                    .font(.title3)
                    .foregroundColor(.accentPurple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.accentPurple.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

/// A compact inline transaction link view
struct InlineTransactionLinkView: View {
    let transactionHash: String
    let explorerURL: String

    var body: some View {
        Link(destination: URL(string: explorerURL)!) {
            HStack(spacing: 6) {
                Text("transaction")
                    .font(.caption)
                    .foregroundColor(.secondaryText)

                Image(systemName: "arrow.right")
                    .font(.caption2)
                    .foregroundColor(.accentPurple)

                Text("View on Explorer")
                    .font(.caption)
                    .foregroundColor(.accentPurple)
                    .underline()
            }
        }
    }
}

/// A success alert view with transaction link
struct TransactionSuccessView: View {
    let message: String
    let transactionHash: String
    let explorerURL: String
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Success icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 80, height: 80)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }

            VStack(spacing: 8) {
                Text("Success!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }

            // Transaction link
            TransactionLinkView(
                transactionHash: transactionHash,
                explorerURL: explorerURL
            )

            // Dismiss button
            Button(action: onDismiss) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentPurple)
                    )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.darkBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.accentPurple.opacity(0.3), lineWidth: 1)
        }
        .padding()
    }
}

// Preview
struct TransactionLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()

            VStack(spacing: 20) {
                TransactionLinkView(
                    transactionHash: "0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4",
                    explorerURL: "https://explorer.aptoslabs.com/txn/0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4?network=testnet"
                )
                .padding()

                InlineTransactionLinkView(
                    transactionHash: "0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4",
                    explorerURL: "https://explorer.aptoslabs.com/txn/0x2d1bb97c5448f347dbd6b290fca2d51fa4da660fced328bd81d8c4dde8c2eec4?network=testnet"
                )
                .padding()

                Spacer()
            }
        }
    }
}
