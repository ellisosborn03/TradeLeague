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
                                Text("Trade")
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

                            OptimizedPrimaryButton(title: "Follow Vault") {
                                // Follow vault action
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

#Preview {
    TradeView()
}