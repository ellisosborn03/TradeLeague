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

                // Particle background
                HeroParticles(particleCount: 30)
                    .opacity(0.3)

                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Profile Header
                        if let user = user {
                            ProfileHeader(user: user, portfolio: portfolio) {
                                showSettings = true
                            }
                        }


                        // Segment Control
                        VStack(spacing: 0) {
                            CustomSegmentToggle(
                                options: [0, 1, 2],
                                optionLabels: [0: "LEAGUES", 1: "HOLDINGS", 2: "ACTIVITY"],
                                selection: $selectedSegment
                            )
                            .padding(.horizontal)

                            // Content based on selected segment
                            Group {
                                if selectedSegment == 0 {
                                    RewardsView(rewards: portfolio?.rewards ?? [])
                                } else if selectedSegment == 1 {
                                    HoldingsView(portfolio: portfolio)
                                } else {
                                    ActivityView(transactions: transactions)
                                }
                            }
                            .padding(.top)
                        }

                        // Powered by Aptos Footer
                        HStack(spacing: Theme.Spacing.xs) {
                            Text("Powered by Aptos")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                        }
                        .padding(.vertical, Theme.Spacing.lg)
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
            username: "Ellis O.",
            avatar: "ellis",
            totalVolume: 125000,
            inviteCode: "CTRLMOVE",
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
                    type: .league,
                    amount: 750,
                    description: "Hyperion Lightning Liquidity Winner",
                    claimedAt: nil,
                    expiresAt: Calendar.current.date(byAdding: .day, value: 5, to: Date())
                ),
                Reward(
                    id: "3",
                    type: .prediction,
                    amount: 200,
                    description: "Aptos Price Prediction Success",
                    claimedAt: Date(),
                    expiresAt: nil
                ),
                Reward(
                    id: "4",
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
                        .font(Theme.Typography.displayM)
                        .fontWeight(.bold)
                        .tracking(-1.0)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .reveal(delay: 0.1)

                    Text("Track your performance")
                        .font(Theme.Typography.bodyS)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                        .reveal(delay: 0.2)
                }

                Spacer()

                Button(action: onSettingsTap) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(Theme.ColorPalette.primary)
                }
            }

            // User Info Card
            OptimizedPressableCard {
                VStack(spacing: Theme.Spacing.md) {
                    HStack(spacing: Theme.Spacing.md) {
                        // Avatar
                        if let avatarName = user.avatar {
                            Image(avatarName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Theme.ColorPalette.primary, lineWidth: 2)
                                )
                        } else {
                            Circle()
                                .fill(Theme.ColorPalette.gradientPrimary)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(String(user.username.prefix(1)).uppercased())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                        }

                        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                            Text(user.username)
                                .font(Theme.Typography.bodyL)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

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

                    // Streak Bar inside the same card with equal spacing
                    VStack(spacing: Theme.Spacing.sm) {
                        Spacer()
                            .frame(height: Theme.Spacing.xs)

                        StreakBarInCard()

                        Spacer()
                            .frame(height: Theme.Spacing.xs)
                    }
                }
                .padding(Theme.Spacing.md)
                .optimizedGlassCard(style: .glass)
            }
        }
    }
}

struct PortfolioSummaryCard: View {
    let portfolio: Portfolio
    @StateObject private var balanceManager = BalanceManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Top section with Portfolio title, value, and performance
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Portfolio")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    CountUpText(target: balanceManager.currentBalance, fontSize: Theme.Typography.displayL)
                        .foregroundColor(Theme.ColorPalette.successGreen)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Rank")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text("#7")
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                    }

                    HStack(spacing: 4) {
                        Text("+\(portfolio.todayChangePercentage, specifier: "%.1f")% today")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }

                    HStack(spacing: 4) {
                        Text("Week")
                            .font(Theme.Typography.captionS)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Theme.ColorPalette.successGreen)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.md)

            // Mini chart section
            VStack(alignment: .leading, spacing: 8) {
                MiniPortfolioChart()
                    .frame(height: 60)
                    .padding(.horizontal, Theme.Spacing.md)
            }
            .padding(.bottom, Theme.Spacing.md)
        }
        .optimizedGlassCard(style: .glass)
        .reveal(delay: 0.3)
    }
}

struct MiniPortfolioChart: View {
    @State private var animateChart = false

    private let dataPoints: [Double] = [0.3, 0.7, 0.4, 0.8, 0.6, 0.9, 0.5, 0.85, 0.7, 0.95]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background dots pattern
                ForEach(0..<8, id: \.self) { row in
                    ForEach(0..<12, id: \.self) { col in
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 2, height: 2)
                            .position(
                                x: CGFloat(col) * (geometry.size.width / 12) + 10,
                                y: CGFloat(row) * (geometry.size.height / 8) + 5
                            )
                    }
                }

                // Chart line
                Path { path in
                    let width = geometry.size.width - 20
                    let height = geometry.size.height - 10

                    for (index, point) in dataPoints.enumerated() {
                        let x = 10 + (width / CGFloat(dataPoints.count - 1)) * CGFloat(index)
                        let y = height - (height * point) + 5

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .trim(from: 0, to: animateChart ? 1 : 0)
                .stroke(Theme.ColorPalette.successGreen, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .animation(.easeInOut(duration: 1.5), value: animateChart)

                // Data points
                ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, point in
                    let width = geometry.size.width - 20
                    let height = geometry.size.height - 10
                    let x = 10 + (width / CGFloat(dataPoints.count - 1)) * CGFloat(index)
                    let y = height - (height * point) + 5

                    Circle()
                        .fill(Theme.ColorPalette.successGreen)
                        .frame(width: 4, height: 4)
                        .position(x: x, y: y)
                        .scaleEffect(animateChart ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1), value: animateChart)
                }
            }
        }
        .onAppear {
            animateChart = true
        }
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
        .optimizedGlassCard(style: .flat)
    }
}

struct HoldingsView: View {
    let portfolio: Portfolio?
    @StateObject private var balanceManager = BalanceManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Portfolio Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Portfolio")
                    .font(Theme.Typography.heading2)
                    .foregroundColor(Theme.ColorPalette.textPrimary)
                    .padding(.horizontal)

                PieChartView(allocation: balanceManager.portfolioAllocation, portfolio: portfolio)
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
        .optimizedGlassCard(style: .flat)
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
        .optimizedGlassCard(style: .flat)
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
            // Reward type icon/logo
            if let logoName = rewardLogo {
                SponsorLogoView.medium(logoName)
            } else {
                Circle()
                    .fill(rewardTypeColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(rewardTypeIcon)
                            .font(.title3)
                            .foregroundColor(rewardTypeColor)
                    )
            }

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
        .optimizedGlassCard(style: .flat)
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

    private var rewardLogo: String? {
        let description = reward.description.lowercased()
        if description.contains("circle") {
            return "Circle"
        } else if description.contains("hyperion") {
            return "Hyperion"
        } else if description.contains("aptos") {
            return "Aptos"
        } else if description.contains("merkle") {
            return "Merkle Trade"
        } else if description.contains("tapp") {
            return "Tapp Network"
        }
        return nil
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
        .optimizedGlassCard(style: .flat)
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
        case .league:
            return Theme.ColorPalette.primaryBlue
        case .trade:
            return Theme.ColorPalette.successGreen
        case .vault:
            return Theme.ColorPalette.chartPurple
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
        case .league:
            return "trophy.fill"
        case .trade:
            return "chart.line.uptrend.xyaxis"
        case .vault:
            return "building.columns.fill"
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
                Theme.ColorPalette.background
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
                            icon: "key",
                            title: "Keyless Account",
                            subtitle: "0x742d35c1e3f42000ab734c2d6b4f4b4e5f"
                        ) {
                            // Keyless key action - copy to clipboard
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
    let portfolio: Portfolio?
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
                        color: Color.fromHex(token.color) ?? Theme.ColorPalette.primary
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
                        .font(Theme.Typography.captionS)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    Text("$\(allocation.totalValue, specifier: "%.0f")")
                        .font(Theme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }
            }

            // Legend
            VStack(spacing: 8) {
                ForEach(allocation.tokens) { token in
                    HStack {
                        Circle()
                            .fill(Color.fromHex(token.color) ?? Theme.ColorPalette.primary)
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

            // Performance metrics (moved here from PortfolioSummaryCard)
            if let portfolio = portfolio {
                HStack(spacing: Theme.Spacing.lg) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today")
                            .font(.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)

                        Text("$\(portfolio.todayChange, specifier: "%.0f")")
                            .font(.headline)
                            .foregroundColor(portfolio.todayChange >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)

                        Text("\(portfolio.todayChangePercentage >= 0 ? "+" : "")\(portfolio.todayChangePercentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundColor(portfolio.todayChangePercentage >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .optimizedGlassCard(style: .flat)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("All Time")
                            .font(.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)

                        Text("$\(portfolio.allTimeChange, specifier: "%.0f")")
                            .font(.headline)
                            .foregroundColor(portfolio.allTimeChange >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)

                        Text("\(portfolio.allTimeChangePercentage >= 0 ? "+" : "")\(portfolio.allTimeChangePercentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundColor(portfolio.allTimeChangePercentage >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .optimizedGlassCard(style: .flat)
                }
            }
        }
        .reveal(delay: 0.4)
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
    static func fromHex(_ hex: String) -> Color? {
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

        return Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct StreakBarView: View {
    @State private var isLoading = true
    @State private var streakCount = 7
    @State private var progressWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Daily Trading Streak")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Spacer()

                if !isLoading {
                    Text("\(streakCount) days")
                        .font(Theme.Typography.bodyS)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.primary)
                }
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.ColorPalette.surface)
                        .frame(height: 8)

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Theme.ColorPalette.primary,
                                Theme.ColorPalette.primaryBlue
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: progressWidth, height: 8)
                        .animation(.easeInOut(duration: 1.0), value: progressWidth)

                    // Loading indicator
                    if isLoading {
                        HStack(spacing: 4) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Theme.ColorPalette.primary)
                                    .frame(width: 4, height: 4)
                                    .scaleEffect(isLoading ? 1.2 : 0.8)
                                    .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2), value: isLoading)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 8)
        }
        .padding(Theme.Spacing.md)
        .optimizedGlassCard(style: .glass)
        .onAppear {
            // Simulate loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }

                // Animate progress bar based on streak
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let targetWidth = CGFloat(streakCount) / 30.0 // 30 day max for visual purposes
                    progressWidth = min(targetWidth, 1.0) * UIScreen.main.bounds.width * 0.8
                }
            }
        }
    }
}

struct StreakBarInCard: View {
    @State private var isLoading = true
    @State private var streakCount = 7
    @State private var progressWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Daily Trading Streak")
                    .font(Theme.Typography.bodyS)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Spacer()

                if !isLoading {
                    Text("\(streakCount) days")
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.orangeAccessible)
                }
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Theme.ColorPalette.orangeLight.opacity(0.2))
                        .frame(height: 6)

                    // Progress - shows progression through orange intensity
                    RoundedRectangle(cornerRadius: 3)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Theme.ColorPalette.orangeLight.opacity(0.6),
                                Theme.ColorPalette.orangeLight,
                                Theme.ColorPalette.orangeDark
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: progressWidth, height: 6)
                        .animation(.easeInOut(duration: 1.0), value: progressWidth)

                    // Loading indicator
                    if isLoading {
                        HStack(spacing: 3) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Theme.ColorPalette.orangeLight)
                                    .frame(width: 3, height: 3)
                                    .scaleEffect(isLoading ? 1.2 : 0.8)
                                    .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2), value: isLoading)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .onAppear {
                    // Simulate loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isLoading = false
                        }

                        // Animate progress bar based on streak
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let targetWidth = CGFloat(streakCount) / 30.0 // 30 day max for visual purposes
                            progressWidth = min(targetWidth, 1.0) * geometry.size.width
                        }
                    }
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    ProfileView()
}