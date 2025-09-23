import SwiftUI

struct ProfileView: View {
    @State private var user: User?
    @State private var portfolio: Portfolio?
    @State private var transactions: [Transaction] = []
    @State private var showSettings = false
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
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
                            .animation(Theme.Animation.fast, value: selectedSegment)

                            // Content based on selected segment
                            Group {
                                if selectedSegment == 0 {
                                    HoldingsView(portfolio: portfolio)
                                } else if selectedSegment == 1 {
                                    RewardsView(rewards: portfolio?.rewards ?? [])
                                } else {
                                    ActivityView(transactions: transactions)
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
                loadTransactions()
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
            username: "CryptoTrader",
            avatar: nil,
            totalVolume: 125000,
            inviteCode: "CRYPTO123",
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

    private func loadTransactions() {
        // Mock data - replace with actual API call
        transactions = [
            Transaction(
                id: "1",
                type: .follow,
                amount: 1000,
                hash: "0xabc123",
                status: .success,
                timestamp: Date(),
                description: "Followed Hyperion LP Strategy"
            ),
            Transaction(
                id: "2",
                type: .prediction,
                amount: 250,
                hash: "0xdef456",
                status: .success,
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
                description: "Predicted APT price increase"
            )
        ]
    }
}

struct ProfileHeader: View {
    let user: User
    let portfolio: Portfolio?
    let onSettingsTap: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text("You")
                        .font(Theme.Typography.heading1)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Track your performance")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
                .sharpPageTransition()

                Spacer()

                Button(action: onSettingsTap) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(Theme.ColorPalette.primary)
                }
            }

            // User Info Card
            PressableCard {
                HStack(spacing: Theme.Spacing.md) {
                    // Avatar
                    Circle()
                        .fill(Theme.ColorPalette.gradientPrimary)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(String(user.username.prefix(1)).uppercased())
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        Text(user.username)
                            .font(Theme.Typography.heading2)
                            .foregroundColor(Theme.ColorPalette.textPrimary)

                        if let rank = user.rank {
                            RankView(rank: rank, isUp: true)
                        }

                        Text("Total Volume: $\(Int(user.totalVolume / 1000))K")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }

                    Spacer()

                    // Invite Code
                    VStack(spacing: Theme.Spacing.xxs) {
                        Text("Invite Code")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text(user.inviteCode)
                            .font(Theme.Typography.mono)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.ColorPalette.primary)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(Theme.ColorPalette.primary.opacity(0.1))
                            .cornerRadius(Theme.Radius.sm)
                    }
                }
                .padding(Theme.Spacing.md)
                .glassCard()
            }
        }
    }
}

struct PortfolioSummaryCard: View {
    let portfolio: Portfolio

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Portfolio")
                .font(Theme.Typography.heading2)
                .foregroundColor(Theme.ColorPalette.textPrimary)

            // Total Value
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                Text("Total Value")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)

                Text("$\(portfolio.totalValue, specifier: "%.2f")")
                    .font(Theme.Typography.heading1)
                    .foregroundColor(Theme.ColorPalette.textPrimary)
            }

            // Performance metrics
            HStack(spacing: Theme.Spacing.lg) {
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
        .padding(Theme.Spacing.md)
        .glassCard()
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
                .foregroundColor(Theme.ColorPalette.textSecondary)

            Text("$\(value, specifier: "%.0f")")
                .font(.headline)
                .foregroundColor(value >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)

            Text("\(percentage >= 0 ? "+" : "")\(percentage, specifier: "%.1f")%")
                .font(.caption)
                .foregroundColor(percentage >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.ColorPalette.surface)
        .cornerRadius(12)
    }
}

struct HoldingsView: View {
    let portfolio: Portfolio?
    @State private var portfolioAllocation: PortfolioAllocation = PortfolioAllocation(
        tokens: [
            TokenAllocation(symbol: "APT", name: "Aptos", color: "#0D47A1", percentage: 25.0, amount: 3125.0),
            TokenAllocation(symbol: "USDC", name: "USDC (on Aptos)", color: "#B0BEC5", percentage: 20.0, amount: 2500.0),
            TokenAllocation(symbol: "EKID", name: "Ekiden", color: "#FB8C00", percentage: 15.0, amount: 1875.0),
            TokenAllocation(symbol: "PORA", name: "Panora", color: "#1ABC9C", percentage: 20.0, amount: 2500.0),
            TokenAllocation(symbol: "RION", name: "Hyperion", color: "#8E44AD", percentage: 20.0, amount: 2500.0)
        ],
        totalValue: 12500.0
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Token Allocation Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Token Allocation")
                    .font(Theme.Typography.heading2)
                    .foregroundColor(Theme.ColorPalette.textPrimary)
                    .padding(.horizontal)

                PieChartView(allocation: portfolioAllocation)
                    .padding(.horizontal)
            }

            if let portfolio = portfolio {
                // Vault Holdings
                if !portfolio.vaultFollowings.isEmpty {
                    Text("Vault Holdings")
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .padding(.horizontal)
                        .padding(.top)

                    ForEach(portfolio.vaultFollowings) { following in
                        VaultHoldingCard(following: following)
                            .padding(.horizontal)
                    }
                }

                // Prediction Holdings
                if !portfolio.predictions.isEmpty {
                    Text("Active Predictions")
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .padding(.horizontal)
                        .padding(.top)

                    ForEach(portfolio.predictions) { prediction in
                        PredictionHoldingCard(prediction: prediction)
                            .padding(.horizontal)
                    }
                }

                if portfolio.vaultFollowings.isEmpty && portfolio.predictions.isEmpty {
                    // Show empty state only for vault/prediction holdings, not token allocation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vault Holdings")
                            .font(.headline)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                            .padding(.horizontal)
                            .padding(.top)

                        Text("Active Predictions")
                            .font(.headline)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                            .padding(.horizontal)
                            .padding(.top)

                        EmptyHoldingsView()
                    }
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
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Text("by \(following.vault.manager.username)")
                    .font(.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(following.currentValue, specifier: "%.0f")")
                    .font(.headline)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Text("\(following.pnlPercentage >= 0 ? "+" : "")\(following.pnlPercentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(following.pnlPercentage >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
            }
        }
        .padding()
        .background(Theme.ColorPalette.surface)
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
                    .foregroundColor(Theme.ColorPalette.textPrimary)
                    .lineLimit(1)

                let outcome = prediction.market.outcomes[prediction.outcomeIndex]
                Text("Predicted: \(outcome.label)")
                    .font(.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(prediction.potentialPayout, specifier: "%.0f")")
                    .font(.headline)
                    .foregroundColor(Theme.ColorPalette.successGreen)

                Text("potential")
                    .font(.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }
        }
        .padding()
        .background(Theme.ColorPalette.surface)
        .cornerRadius(12)
    }
}

struct EmptyHoldingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.pie")
                .font(.system(size: 60))
                .foregroundColor(Theme.ColorPalette.textSecondary)

            Text("No Holdings")
                .font(.headline)
                .foregroundColor(Theme.ColorPalette.textPrimary)

            Text("Start following vaults or making predictions to see your holdings here")
                .font(.subheadline)
                .foregroundColor(Theme.ColorPalette.textSecondary)
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
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Text("No Rewards")
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Participate in leagues and refer friends to earn rewards")
                        .font(.subheadline)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
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
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                HStack {
                    Text(reward.type.rawValue)
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    if let expiresAt = reward.expiresAt, reward.claimedAt == nil {
                        Text("• Expires \(expiresAt, style: .relative)")
                            .font(.caption)
                            .foregroundColor(Theme.ColorPalette.dangerRed)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("$\(Int(reward.amount))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.ColorPalette.successGreen)

                if reward.claimedAt == nil {
                    Button("Claim") {
                        // Claim reward action
                    }
                    .font(.caption)
                    .foregroundColor(Theme.ColorPalette.primaryBlue)
                } else {
                    Text("Claimed")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }
        }
        .padding()
        .background(Theme.ColorPalette.surface)
        .cornerRadius(12)
    }

    private var rewardTypeColor: Color {
        switch reward.type {
        case .league:
            return Theme.ColorPalette.warningYellow
        case .prediction:
            return Theme.ColorPalette.primaryBlue
        case .referral:
            return Theme.ColorPalette.successGreen
        case .achievement:
            return Theme.ColorPalette.chartPurple
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
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Text("No Activity")
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Your trading activity will appear here")
                        .font(.subheadline)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
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

    var body: some View {
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
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                HStack {
                    Text(transaction.type.rawValue)
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Text("•")
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Text(transaction.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("$\(Int(transaction.amount))")
                    .font(.headline)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                StatusBadge(status: transaction.status)
            }
        }
        .padding()
        .background(Theme.ColorPalette.surface)
        .cornerRadius(12)
    }

    private var transactionTypeColor: Color {
        switch transaction.type {
        case .deposit:
            return Theme.ColorPalette.successGreen
        case .withdraw:
            return Theme.ColorPalette.dangerRed
        case .follow, .unfollow:
            return Theme.ColorPalette.primaryBlue
        case .prediction:
            return Theme.ColorPalette.chartPurple
        case .reward:
            return Theme.ColorPalette.warningYellow
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
            return Theme.ColorPalette.warningYellow
        case .success:
            return Theme.ColorPalette.successGreen
        case .failed:
            return Theme.ColorPalette.dangerRed
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.darkBackground
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

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
                            .foregroundColor(Theme.ColorPalette.dangerRed)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.ColorPalette.dangerRed.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.ColorPalette.primaryBlue)
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
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Theme.ColorPalette.primaryBlue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }
            .padding()
            .background(Theme.ColorPalette.surface)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PieChartView: View {
    let allocation: PortfolioAllocation
    @State private var animatedPercentages: [Double] = []

    var body: some View {
        VStack(spacing: 16) {
            // Pie Chart
            ZStack {
                Circle()
                    .stroke(Theme.ColorPalette.surface, lineWidth: 2)
                    .frame(width: 200, height: 200)

                ForEach(Array(allocation.tokens.enumerated()), id: \.element.id) { index, token in
                    PieSlice(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: Color(hex: token.color) ?? Theme.ColorPalette.primary
                    )
                    .frame(width: 200, height: 200)
                }

                // Center hole
                Circle()
                    .fill(Theme.ColorPalette.background)
                    .frame(width: 100, height: 100)

                // Total value in center
                VStack {
                    Text("Total")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    Text("$\(allocation.totalValue, specifier: "%.0f")")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }
            }

            // Legend
            VStack(spacing: 8) {
                ForEach(allocation.tokens) { token in
                    HStack {
                        Circle()
                            .fill(Color(hex: token.color) ?? Theme.ColorPalette.primary)
                            .frame(width: 12, height: 12)

                        Text(token.symbol)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textPrimary)

                        Spacer()

                        Text("\(token.percentage, specifier: "%.0f")%")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textSecondary)

                        Text("$\(token.amount, specifier: "%.0f")")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                    }
                }
            }
            .padding()
            .glassCard()
        }
    }

    private func startAngle(for index: Int) -> Angle {
        let previousPercentages = allocation.tokens.prefix(index).map { $0.percentage }.reduce(0, +)
        return Angle.degrees(previousPercentages * 3.6 - 90) // -90 to start from top
    }

    private func endAngle(for index: Int) -> Angle {
        let currentAndPreviousPercentages = allocation.tokens.prefix(index + 1).map { $0.percentage }.reduce(0, +)
        return Angle.degrees(currentAndPreviousPercentages * 3.6 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color

    var body: some View {
        Path { path in
            let center = CGPoint(x: 100, y: 100)
            let radius: CGFloat = 100

            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(color)
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ProfileView()
}