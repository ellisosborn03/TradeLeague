import SwiftUI

struct ProfileView: View {
    @State private var user: User?
    @State private var portfolio: Portfolio?
    @StateObject private var transactionManager = TransactionManager.shared
    @State private var showSettings = false
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        if let user = user {
                            ProfileHeader(user: user, portfolio: portfolio) {
                                showSettings = true
                            }
                        }

                        // Portfolio Summary
                        if let portfolio = portfolio {
                            PortfolioSummaryCard(portfolio: portfolio)
                        }

                        // Segment Control
                        VStack(spacing: 0) {
                            Picker("View", selection: $selectedSegment) {
                                Text("Holdings").tag(0)
                                Text("Rewards").tag(1)
                                Text("Activity").tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)

                            // Content based on selected segment
                            Group {
                                if selectedSegment == 0 {
                                    HoldingsView(portfolio: portfolio)
                                } else if selectedSegment == 1 {
                                    RewardsView(rewards: portfolio?.rewards ?? [])
                                } else {
                                    ActivityView(transactions: transactionManager.transactions)
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                loadUserData()
                loadPortfolio()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private func loadUserData() {
        // Mock data - replace with actual API call
        user = User(
            id: "user1",
            walletAddress: "0x1234567890abcdef",
            username: "Ellis",
            avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
            totalVolume: 125000,
            inviteCode: "ELLIS123",
            createdAt: Date(),
            currentScore: 85000,
            rank: 7
        )
    }

    private func loadPortfolio() {
        // Mock data - replace with actual API call
        portfolio = Portfolio(
            totalValue: 12500,
            todayChange: 340,
            todayChangePercentage: 2.8,
            allTimeChange: 2500,
            allTimeChangePercentage: 25.0,
            vaultFollowings: [],
            predictions: [],
            rewards: [
                Reward(
                    id: "1",
                    type: .league,
                    amount: 500,
                    description: "Circle League 3rd Place",
                    claimedAt: nil,
                    expiresAt: Calendar.current.date(byAdding: .day, value: 7, to: Date())
                ),
                Reward(
                    id: "2",
                    type: .referral,
                    amount: 50,
                    description: "Friend Referral Bonus",
                    claimedAt: Date(),
                    expiresAt: nil
                )
            ]
        )
    }

}

struct ProfileHeader: View {
    let user: User
    let portfolio: Portfolio?
    let onSettingsTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("You")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)

                    Text("Track your performance")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                Button(action: onSettingsTap) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.primaryBlue)
                }
            }

            // User Info Card
            HStack(spacing: 16) {
                // Avatar
                Group {
                    if let avatarURL = user.avatar, !avatarURL.isEmpty {
                        AsyncImage(url: URL(string: avatarURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(0.8)
                                )
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primaryBlue, lineWidth: 2)
                        )
                    } else {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.primaryBlue, .chartPurple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(user.username.prefix(1)).uppercased())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.username)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)

                    if let rank = user.rank {
                        Text("Rank #\(rank)")
                            .font(.subheadline)
                            .foregroundColor(.primaryBlue)
                    }

                    Text("Total Volume: $\(Int(user.totalVolume / 1000))K")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                // Invite Code
                VStack {
                    Text("Invite Code")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text(user.inviteCode)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.primaryBlue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.surfaceColor)
            .cornerRadius(16)
        }
    }
}

struct PortfolioSummaryCard: View {
    let portfolio: Portfolio

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio")
                .font(.headline)
                .foregroundColor(.primaryText)

            // Total Value
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Value")
                    .font(.caption)
                    .foregroundColor(.secondaryText)

                Text("$\(portfolio.totalValue, specifier: "%.2f")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
            }

            // Performance metrics
            HStack(spacing: 20) {
                PerformanceMetricCard(
                    title: "Today",
                    value: portfolio.todayChange,
                    percentage: portfolio.todayChangePercentage
                )

                PerformanceMetricCard(
                    title: "All Time",
                    value: portfolio.allTimeChange,
                    percentage: portfolio.allTimeChangePercentage
                )
            }
        }
        .padding()
        .background(Color.surfaceColor)
        .cornerRadius(16)
    }
}

struct PerformanceMetricCard: View {
    let title: String
    let value: Double
    let percentage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)

            Text("$\(value, specifier: "%.0f")")
                .font(.headline)
                .foregroundColor(value >= 0 ? .successGreen : .dangerRed)

            Text("\(percentage >= 0 ? "+" : "")\(percentage, specifier: "%.1f")%")
                .font(.caption)
                .foregroundColor(percentage >= 0 ? .successGreen : .dangerRed)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.surfaceLight)
        .cornerRadius(12)
    }
}

struct HoldingsView: View {
    let portfolio: Portfolio?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let portfolio = portfolio {
                // Vault Holdings
                if !portfolio.vaultFollowings.isEmpty {
                    Text("Vault Holdings")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                        .padding(.horizontal)

                    ForEach(portfolio.vaultFollowings) { following in
                        VaultHoldingCard(following: following)
                            .padding(.horizontal)
                    }
                }

                // Prediction Holdings
                if !portfolio.predictions.isEmpty {
                    Text("Active Predictions")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                        .padding(.horizontal)
                        .padding(.top)

                    ForEach(portfolio.predictions) { prediction in
                        PredictionHoldingCard(prediction: prediction)
                            .padding(.horizontal)
                    }
                }

                if portfolio.vaultFollowings.isEmpty && portfolio.predictions.isEmpty {
                    EmptyHoldingsView()
                }
            } else {
                EmptyHoldingsView()
            }
        }
    }
}

struct VaultHoldingCard: View {
    let following: VaultFollowing

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(following.vault.name)
                    .font(.headline)
                    .foregroundColor(.primaryText)

                Text("by \(following.vault.manager.username)")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(following.currentValue, specifier: "%.0f")")
                    .font(.headline)
                    .foregroundColor(.primaryText)

                Text("\(following.pnlPercentage >= 0 ? "+" : "")\(following.pnlPercentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(following.pnlPercentage >= 0 ? .successGreen : .dangerRed)
            }
        }
        .padding()
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }
}

struct PredictionHoldingCard: View {
    let prediction: UserPrediction

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(prediction.market.question)
                    .font(.subheadline)
                    .foregroundColor(.primaryText)
                    .lineLimit(1)

                let outcome = prediction.market.outcomes[prediction.outcomeIndex]
                Text("Predicted: \(outcome.label)")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(prediction.potentialPayout, specifier: "%.0f")")
                    .font(.headline)
                    .foregroundColor(.successGreen)

                Text("potential")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
        }
        .padding()
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }
}

struct EmptyHoldingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.pie")
                .font(.system(size: 60))
                .foregroundColor(.secondaryText)

            Text("No Holdings")
                .font(.headline)
                .foregroundColor(.primaryText)

            Text("Start following vaults or making predictions to see your holdings here")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}

struct RewardsView: View {
    let rewards: [Reward]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if rewards.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "gift")
                        .font(.system(size: 60))
                        .foregroundColor(.secondaryText)

                    Text("No Rewards")
                        .font(.headline)
                        .foregroundColor(.primaryText)

                    Text("Participate in leagues and trading competitions to earn rewards")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                ForEach(rewards) { reward in
                    RewardCard(reward: reward)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct RewardCard: View {
    let reward: Reward

    var body: some View {
        HStack {
            // Reward type icon
            Circle()
                .fill(rewardTypeColor.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(rewardTypeIcon)
                        .font(.title3)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(reward.description)
                    .font(.headline)
                    .foregroundColor(.primaryText)

                HStack {
                    Text(reward.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondaryText)

                    if let expiresAt = reward.expiresAt, reward.claimedAt == nil {
                        Text("• Expires \(expiresAt, style: .relative)")
                            .font(.caption)
                            .foregroundColor(.dangerRed)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("$\(Int(reward.amount))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.successGreen)

                if reward.claimedAt == nil {
                    Button("Claim") {
                        // Claim reward action
                    }
                    .font(.caption)
                    .foregroundColor(.primaryBlue)
                } else {
                    Text("Claimed")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }
        }
        .padding()
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }

    private var rewardTypeColor: Color {
        switch reward.type {
        case .league:
            return .warningYellow
        case .prediction:
            return .primaryBlue
        case .referral:
            return .successGreen
        case .achievement:
            return .chartPurple
        }
    }

    private var rewardTypeIcon: String {
        switch reward.type {
        case .league:
            return "🏆"
        case .prediction:
            return "🔮"
        case .referral:
            return "👥"
        case .achievement:
            return "⭐"
        }
    }
}

struct ActivityView: View {
    let transactions: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if transactions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock")
                        .font(.system(size: 60))
                        .foregroundColor(.secondaryText)

                    Text("No Activity")
                        .font(.headline)
                        .foregroundColor(.primaryText)

                    Text("Your trading activity will appear here")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                ForEach(transactions) { transaction in
                    TransactionCard(transaction: transaction)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct TransactionCard: View {
    let transaction: Transaction
    @StateObject private var aptosService = AptosService.shared

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Transaction type icon
                Circle()
                    .fill(transactionTypeColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: transactionTypeIcon)
                            .foregroundColor(transactionTypeColor)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.description)
                        .font(.headline)
                        .foregroundColor(.primaryText)

                    HStack {
                        Text(transaction.type.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondaryText)

                        Text("•")
                            .foregroundColor(.secondaryText)

                        Text(transaction.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("$\(Int(transaction.amount))")
                        .font(.headline)
                        .foregroundColor(.primaryText)

                    StatusBadge(status: transaction.status)
                }
            }

            // Transaction link - clickable to view on Aptos testnet explorer
            if !transaction.hash.isEmpty {
                HStack(spacing: 6) {
                    Link(destination: URL(string: aptosService.getExplorerURL(forTransaction: transaction.hash))!) {
                        HStack(spacing: 4) {
                            Text("transaction")
                                .font(.caption)
                                .foregroundColor(.accentPurple)
                                .underline()

                            Image(systemName: "arrow.up.forward.square")
                                .font(.caption2)
                                .foregroundColor(.accentPurple)
                        }
                    }

                    Text("→")
                        .font(.caption)
                        .foregroundColor(.secondaryText)

                    Text(transaction.hash.prefix(8) + "..." + transaction.hash.suffix(6))
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(.secondaryText)

                    Spacer()
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }

    private var transactionTypeColor: Color {
        switch transaction.type {
        case .deposit:
            return .successGreen
        case .withdraw:
            return .dangerRed
        case .follow, .unfollow:
            return .primaryBlue
        case .prediction:
            return .chartPurple
        case .reward:
            return .warningYellow
        }
    }

    private var transactionTypeIcon: String {
        switch transaction.type {
        case .deposit:
            return "arrow.down.circle.fill"
        case .withdraw:
            return "arrow.up.circle.fill"
        case .follow:
            return "plus.circle.fill"
        case .unfollow:
            return "minus.circle.fill"
        case .prediction:
            return "crystal.ball"
        case .reward:
            return "gift.fill"
        }
    }
}

struct StatusBadge: View {
    let status: TransactionStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(8)
    }

    private var statusColor: Color {
        switch status {
        case .pending:
            return .warningYellow
        case .success:
            return .successGreen
        case .failed:
            return .dangerRed
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)

                    VStack(spacing: 12) {
                        SettingsRow(
                            icon: "person.circle",
                            title: "Profile",
                            subtitle: "Update your profile information"
                        ) {
                            // Profile action
                        }

                        SettingsRow(
                            icon: "bell",
                            title: "Notifications",
                            subtitle: "Manage notification preferences"
                        ) {
                            // Notifications action
                        }

                        SettingsRow(
                            icon: "lock",
                            title: "Security",
                            subtitle: "Wallet and security settings"
                        ) {
                            // Security action
                        }

                        SettingsRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            subtitle: "Get help and contact support"
                        ) {
                            // Help action
                        }
                    }

                    Spacer()

                    Button {
                        // Disconnect wallet action
                    } label: {
                        Text("Disconnect Wallet")
                            .font(.headline)
                            .foregroundColor(.dangerRed)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.dangerRed.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.primaryBlue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primaryText)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            .padding()
            .background(Color.surfaceColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
}