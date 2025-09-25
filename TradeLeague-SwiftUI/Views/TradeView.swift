import SwiftUI

struct TradeView: View {
    @State private var vaults: [Vault] = []
    @State private var selectedVault: Vault?
    @State private var followings: [VaultFollowing] = []
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                // Particle background
                HeroParticles(particleCount: 35)
                    .opacity(0.3)

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                Text("Follow")
                                    .font(Theme.Typography.displayM)
                                    .fontWeight(.bold)
                                    .tracking(-1.0)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)
                                    .reveal(delay: 0.1)

                                Text("Follow top trading vaults")
                                    .font(Theme.Typography.bodyS)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                    .reveal(delay: 0.2)
                            }

                            Spacer()
                        }

                        // Segment control
                        CustomSegmentToggle(
                            options: [0, 1],
                            optionLabels: [0: "DISCOVER", 1: "FOLLOWING"],
                            selection: $selectedSegment
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    // Content based on selected segment
                    if selectedSegment == 0 {
                        DiscoverVaultsView(vaults: vaults) { vault in
                            selectedVault = vault
                        }
                    } else {
                        FollowingVaultsView(followings: followings)
                    }

                    // Powered by Aptos Footer
                    HStack(spacing: Theme.Spacing.xs) {
                        Text("Powered by")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)

                        AsyncImage(url: URL(string: "https://cryptologos.cc/logos/aptos-apt-logo.svg")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Text("Aptos")
                                .font(Theme.Typography.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                        }
                        .frame(width: 16, height: 16)

                        Text("Aptos")
                            .font(Theme.Typography.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                    .padding(.top, Theme.Spacing.lg)
                    .padding(.bottom, Theme.Spacing.md)
                }
            }
            .onAppear {
                loadVaults()
                loadFollowings()
            }
            .sheet(item: $selectedVault) { vault in
                VaultDetailView(vault: vault)
            }
        }
    }

    private func loadVaults() {
        // Mock data - replace with actual API call
        vaults = [
            Vault(
                id: "1",
                managerId: "user1",
                manager: User(
                    id: "user1",
                    walletAddress: "0x123",
                    username: "CryptoWizard",
                    avatar: nil,
                    totalVolume: 1000000,
                    inviteCode: "WIZARD",
                    createdAt: Date(),
                    currentScore: 95000,
                    rank: 1
                ),
                name: "Hyperion LP Strategy",
                strategy: .liquidityProvision,
                venue: .hyperion,
                totalAUM: 500000,
                performanceFee: 15,
                allTimeReturn: 45.8,
                weeklyReturn: 3.2,
                monthlyReturn: 12.1,
                followers: 342,
                description: "Conservative liquidity provision strategy focusing on stable pools",
                riskLevel: .conservative
            ),
            Vault(
                id: "2",
                managerId: "user2",
                manager: User(
                    id: "user2",
                    walletAddress: "0x456",
                    username: "DeFiMaster",
                    avatar: nil,
                    totalVolume: 750000,
                    inviteCode: "DEFI",
                    createdAt: Date(),
                    currentScore: 87000,
                    rank: 3
                ),
                name: "Merkle Perps Alpha",
                strategy: .perpsTrading,
                venue: .merkle,
                totalAUM: 250000,
                performanceFee: 20,
                allTimeReturn: 67.3,
                weeklyReturn: 5.8,
                monthlyReturn: 18.9,
                followers: 156,
                description: "Aggressive perpetual futures trading with high returns",
                riskLevel: .aggressive
            )
        ]
    }

    private func loadFollowings() {
        // Mock data - replace with actual API call
        followings = []
    }
}

struct DiscoverVaultsView: View {
    let vaults: [Vault]
    let onVaultTap: (Vault) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.sm) {
                ForEach(Array(vaults.enumerated()), id: \.element.id) { index, vault in
                    VaultCard(vault: vault) {
                        onVaultTap(vault)
                    }
                    .padding(.horizontal)
                    .animation(Theme.Animation.base.delay(Double(index) * 0.03), value: vaults)
                }
            }
            .padding(.vertical)
        }
    }
}

struct FollowingVaultsView: View {
    let followings: [VaultFollowing]

    var body: some View {
        if followings.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.ColorPalette.textSecondary)

                Text("No Vaults Followed")
                    .font(.headline)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Text("Discover and follow top performing vaults to copy their strategies")
                    .font(.subheadline)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(followings) { following in
                        FollowingCard(following: following)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct VaultCard: View {
    let vault: Vault
    let onTap: () -> Void

    var body: some View {
        OptimizedPressableCard(action: onTap) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        Text(vault.name)
                            .font(Theme.Typography.body)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)

                        HStack {
                            Text("by \(vault.manager.username)")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)

                            Text("•")
                                .foregroundColor(Theme.ColorPalette.textSecondary)

                            HStack(spacing: 4) {
                                SponsorLogoView.small(vault.venue.rawValue)

                                Text(vault.venue.rawValue)
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.primary)
                            }
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: Theme.Spacing.xxs) {
                        RiskLevelBadge(riskLevel: vault.riskLevel)

                        Text("\(vault.followers) followers")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                }

                // Strategy and description
                Text(vault.strategy.rawValue)
                    .font(Theme.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.ColorPalette.primary)

                Text(vault.description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
                    .lineLimit(2)

                // Performance metrics
                HStack(spacing: Theme.Spacing.lg) {
                    PerformanceMetric(
                        title: "All Time",
                        value: vault.allTimeReturn,
                        isPercentage: true
                    )

                    PerformanceMetric(
                        title: "Monthly",
                        value: vault.monthlyReturn,
                        isPercentage: true
                    )

                    PerformanceMetric(
                        title: "AUM",
                        value: vault.totalAUM,
                        prefix: "$"
                    )
                }

                Divider()
                    .background(Theme.ColorPalette.divider)

                // Follow button
                HStack {
                    Text("Performance Fee: \(Int(vault.performanceFee))%")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Spacer()

                    Text("Follow")
                        .font(Theme.Typography.button)
                        .foregroundColor(Theme.ColorPalette.primary)
                }
            }
            .padding(Theme.Spacing.md)
            .optimizedGlassCard(style: .glass)
        }
    }
}

struct FollowingCard: View {
    let following: VaultFollowing

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(following.vault.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Following since \(following.followedAt, style: .date)")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }

                Spacer()

                Button("Unfollow") {
                    // Unfollow action
                }
                .font(.caption)
                .foregroundColor(Theme.ColorPalette.dangerRed)
            }

            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Invested")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    CountUpText(target: Double(following.amount), fontSize: Theme.Typography.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }

                VStack(alignment: .leading) {
                    Text("Current Value")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    CountUpText(target: Double(following.currentValue), fontSize: Theme.Typography.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }

                VStack(alignment: .leading) {
                    Text("P&L")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    Text("\(following.pnlPercentage >= 0 ? "+" : "")\(following.pnlPercentage, specifier: "%.1f")%")
                        .font(.headline)
                        .foregroundColor(following.pnlPercentage >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                }
            }
        }
        .padding()
        .background(Theme.ColorPalette.surface)
        .cornerRadius(16)
    }
}

struct RiskLevelBadge: View {
    let riskLevel: RiskLevel

    var badgeColor: Color {
        switch riskLevel {
        case .conservative:
            return Theme.ColorPalette.success
        case .moderate:
            return Theme.ColorPalette.secondary
        case .aggressive:
            return Theme.ColorPalette.error
        }
    }

    var body: some View {
        Text(riskLevel.rawValue)
            .font(Theme.Typography.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, Theme.Spacing.xs)
            .padding(.vertical, Theme.Spacing.xxs)
            .background(badgeColor)
            .cornerRadius(Theme.Radius.sm)
    }
}

struct PerformanceMetric: View {
    let title: String
    let value: Double
    let isPercentage: Bool
    let prefix: String

    init(title: String, value: Double, isPercentage: Bool = false, prefix: String = "") {
        self.title = title
        self.value = value
        self.isPercentage = isPercentage
        self.prefix = prefix
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.ColorPalette.textSecondary)

            HStack(spacing: 2) {
                if !prefix.isEmpty {
                    Text(prefix)
                        .font(Theme.Typography.mono)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }

                if value >= 1000000 {
                    Text("\(value / 1000000, specifier: "%.1f")M")
                        .font(Theme.Typography.mono)
                        .fontWeight(.bold)
                        .foregroundColor(isPercentage ? (value >= 0 ? Theme.ColorPalette.success : Theme.ColorPalette.error) : Theme.ColorPalette.textPrimary)
                } else if value >= 1000 {
                    Text("\(value / 1000, specifier: "%.1f")K")
                        .font(Theme.Typography.mono)
                        .fontWeight(.bold)
                        .foregroundColor(isPercentage ? (value >= 0 ? Theme.ColorPalette.success : Theme.ColorPalette.error) : Theme.ColorPalette.textPrimary)
                } else {
                    Text("\(value, specifier: "%.1f")")
                        .font(Theme.Typography.mono)
                        .fontWeight(.bold)
                        .foregroundColor(isPercentage ? (value >= 0 ? Theme.ColorPalette.success : Theme.ColorPalette.error) : Theme.ColorPalette.textPrimary)
                }

                if isPercentage {
                    Text("%")
                        .font(Theme.Typography.mono)
                        .fontWeight(.bold)
                        .foregroundColor(value >= 0 ? Theme.ColorPalette.success : Theme.ColorPalette.error)
                }
            }
        }
    }
}

struct VaultDetailView: View {
    let vault: Vault
    @Environment(\.dismiss) private var dismiss
    @State private var followAmount = ""

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(vault.name)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)

                                    Text("Managed by \(vault.manager.username)")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                }

                                Spacer()

                                RiskLevelBadge(riskLevel: vault.riskLevel)
                            }

                            Text(vault.description)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Performance
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Performance")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            // Full width performance grid
                            VStack(spacing: 16) {
                                HStack {
                                    PerformanceMetric(
                                        title: "All Time Return",
                                        value: vault.allTimeReturn,
                                        isPercentage: true
                                    )

                                    Spacer()

                                    PerformanceMetric(
                                        title: "Monthly Return",
                                        value: vault.monthlyReturn,
                                        isPercentage: true
                                    )
                                }

                                HStack {
                                    PerformanceMetric(
                                        title: "Total AUM",
                                        value: vault.totalAUM,
                                        prefix: "$"
                                    )

                                    Spacer()

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Followers")
                                            .font(.caption)
                                            .foregroundColor(Theme.ColorPalette.textSecondary)
                                        Text("\(vault.followers)")
                                            .font(.headline)
                                            .foregroundColor(Theme.ColorPalette.textPrimary)
                                    }
                                }
                            }

                            // Performance Chart
                            VaultPerformanceChart(vault: vault)
                                .frame(height: 200)
                                .padding(.top)
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Follow section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Follow Vault")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Amount to Follow")
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                TextField("Enter amount in USDC", text: $followAmount)
                                    .padding(Theme.Spacing.sm)
                                    .font(Theme.Typography.body)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                            .fill(Theme.ColorPalette.surface)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                                    .stroke(Theme.ColorPalette.divider, lineWidth: 1)
                                            )
                                    )
                                    .foregroundColor(Theme.ColorPalette.textPrimary)
                                    #if os(iOS)
                                    .keyboardType(.numberPad)
                                    #endif
                            }

                            Text("Performance Fee: \(Int(vault.performanceFee))%")
                                .font(.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)

                            OptimizedPrimaryButton(title: "Follow") {
                                // Follow vault action
                                dismiss()
                            }
                            .disabled(followAmount.isEmpty)
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)
                    }
                    .padding()
                }
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

struct VaultPerformanceChart: View {
    let vault: Vault
    @State private var animateChart = false

    // Realistic performance data points for different vault types
    private var dataPoints: [Double] {
        switch vault.strategy {
        case .marketMaking:
            return [1.0, 1.02, 1.01, 1.04, 1.03, 1.06, 1.05, 1.08, 1.07, 1.10, 1.09, 1.12, 1.11, 1.15, 1.14, 1.17, 1.16, 1.19, 1.18, 1.21]
        case .yieldFarming:
            return [1.0, 1.03, 1.02, 1.05, 1.08, 1.06, 1.09, 1.12, 1.10, 1.14, 1.13, 1.16, 1.19, 1.17, 1.20, 1.23, 1.21, 1.25, 1.24, 1.28]
        case .arbitrage:
            return [1.0, 1.01, 1.03, 1.02, 1.04, 1.06, 1.05, 1.07, 1.09, 1.08, 1.10, 1.12, 1.11, 1.13, 1.15, 1.14, 1.16, 1.18, 1.17, 1.20]
        case .perpsTrading:
            return [1.0, 0.98, 1.02, 1.05, 1.01, 1.08, 1.04, 1.12, 1.08, 1.15, 1.11, 1.18, 1.14, 1.22, 1.18, 1.26, 1.22, 1.30, 1.26, 1.35]
        case .liquidityProvision:
            return [1.0, 1.02, 1.04, 1.03, 1.06, 1.08, 1.07, 1.10, 1.12, 1.11, 1.14, 1.16, 1.15, 1.18, 1.20, 1.19, 1.22, 1.24, 1.23, 1.26]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with performance indicators separated
            HStack {
                Text("Performance Chart (30 Days)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Spacer()

                HStack(spacing: 24) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Current")
                            .font(.caption2)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text("+\(vault.allTimeReturn, specifier: "%.1f")%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(vault.allTimeReturn >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                    }

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Monthly")
                            .font(.caption2)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text("+\(vault.monthlyReturn, specifier: "%.1f")%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(vault.monthlyReturn >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                    }
                }
            }

            // Chart area with proper bounding
            GeometryReader { geometry in
                ZStack {
                    // Chart background with proper bounds
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.ColorPalette.surface.opacity(0.3))
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    // Background grid
                    ForEach(0..<5, id: \.self) { row in
                        ForEach(0..<15, id: \.self) { col in
                            Circle()
                                .fill(Theme.ColorPalette.divider.opacity(0.2))
                                .frame(width: 1, height: 1)
                                .position(
                                    x: 20 + CGFloat(col) * ((geometry.size.width - 40) / 15),
                                    y: 15 + CGFloat(row) * ((geometry.size.height - 30) / 5)
                                )
                        }
                    }

                    // Area fill with proper margins
                    Path { path in
                        let width = geometry.size.width - 40  // 20px margin on each side
                        let height = geometry.size.height - 30  // 15px margin top/bottom
                        let startX: CGFloat = 20
                        let startY: CGFloat = 15
                        let minValue = dataPoints.min() ?? 1.0
                        let maxValue = dataPoints.max() ?? 1.0
                        let range = maxValue - minValue

                        // Start from bottom
                        path.move(to: CGPoint(x: startX, y: startY + height))

                        // Draw to first point
                        if let firstPoint = dataPoints.first {
                            let normalizedValue = range > 0 ? (firstPoint - minValue) / range : 0.5
                            let y = startY + height - (height * normalizedValue)
                            path.addLine(to: CGPoint(x: startX, y: y))
                        }

                        // Draw curve through points
                        for (index, point) in dataPoints.enumerated() {
                            let x = startX + (width / CGFloat(dataPoints.count - 1)) * CGFloat(index)
                            let normalizedValue = range > 0 ? (point - minValue) / range : 0.5
                            let y = startY + height - (height * normalizedValue)
                            path.addLine(to: CGPoint(x: x, y: y))
                        }

                        // Close area back to bottom
                        if !dataPoints.isEmpty {
                            path.addLine(to: CGPoint(x: startX + width, y: startY + height))
                            path.addLine(to: CGPoint(x: startX, y: startY + height))
                        }
                    }
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            vault.allTimeReturn >= 0 ? Theme.ColorPalette.successGreen.opacity(0.3) : Theme.ColorPalette.dangerRed.opacity(0.3),
                            vault.allTimeReturn >= 0 ? Theme.ColorPalette.successGreen.opacity(0.1) : Theme.ColorPalette.dangerRed.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .scaleEffect(x: animateChart ? 1 : 0, y: 1, anchor: .leading)
                    .animation(.easeInOut(duration: 1.2), value: animateChart)

                    // Chart line
                    Path { path in
                        let width = geometry.size.width - 40
                        let height = geometry.size.height - 30
                        let startX: CGFloat = 20
                        let startY: CGFloat = 15
                        let minValue = dataPoints.min() ?? 1.0
                        let maxValue = dataPoints.max() ?? 1.0
                        let range = maxValue - minValue

                        for (index, point) in dataPoints.enumerated() {
                            let x = startX + (width / CGFloat(dataPoints.count - 1)) * CGFloat(index)
                            let normalizedValue = range > 0 ? (point - minValue) / range : 0.5
                            let y = startY + height - (height * normalizedValue)

                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .trim(from: 0, to: animateChart ? 1 : 0)
                    .stroke(
                        vault.allTimeReturn >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed,
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                    .animation(.easeInOut(duration: 1.5), value: animateChart)

                    // Data points
                    ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, point in
                        let width = geometry.size.width - 40
                        let height = geometry.size.height - 30
                        let startX: CGFloat = 20
                        let startY: CGFloat = 15
                        let minValue = dataPoints.min() ?? 1.0
                        let maxValue = dataPoints.max() ?? 1.0
                        let range = maxValue - minValue
                        let x = startX + (width / CGFloat(dataPoints.count - 1)) * CGFloat(index)
                        let normalizedValue = range > 0 ? (point - minValue) / range : 0.5
                        let y = startY + height - (height * normalizedValue)

                        Circle()
                            .fill(vault.allTimeReturn >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                            .frame(width: 3, height: 3)
                            .position(x: x, y: y)
                            .scaleEffect(animateChart ? 1 : 0)
                            .animation(.easeInOut(duration: 0.4).delay(Double(index) * 0.03), value: animateChart)
                    }
                }
            }
        }
        .onAppear {
            animateChart = true
        }
    }
}

#Preview {
    TradeView()
}