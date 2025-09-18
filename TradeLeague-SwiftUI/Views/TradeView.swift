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

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                Text("Trade")
                                    .font(Theme.Typography.heading1)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)

                                Text("Follow top trading vaults")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                            }
                            .sharpPageTransition()

                            Spacer()
                        }

                        // Segment control
                        Picker("View", selection: $selectedSegment) {
                            Text("Discover").tag(0)
                            Text("Following").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .animation(Theme.Animation.fast, value: selectedSegment)
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
                    .foregroundColor(.secondaryText)

                Text("No Vaults Followed")
                    .font(.headline)
                    .foregroundColor(.primaryText)

                Text("Discover and follow top performing vaults to copy their strategies")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
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
        PressableCard {
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

                            Text(vault.venue.rawValue)
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.primary)
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
            .glassCard()
        }
        .onTapGesture(perform: onTap)
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
                        .foregroundColor(.primaryText)

                    Text("Following since \(following.followedAt, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                Button("Unfollow") {
                    // Unfollow action
                }
                .font(.caption)
                .foregroundColor(.dangerRed)
            }

            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Invested")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("$\(Int(following.amount))")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }

                VStack(alignment: .leading) {
                    Text("Current Value")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("$\(Int(following.currentValue))")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }

                VStack(alignment: .leading) {
                    Text("P&L")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("\(following.pnlPercentage >= 0 ? "+" : "")\(following.pnlPercentage, specifier: "%.1f")%")
                        .font(.headline)
                        .foregroundColor(following.pnlPercentage >= 0 ? .successGreen : .dangerRed)
                }
            }
        }
        .padding()
        .background(Color.surfaceColor)
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
                Color.darkBackground
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
                                        .foregroundColor(.primaryText)

                                    Text("Managed by \(vault.manager.username)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondaryText)
                                }

                                Spacer()

                                RiskLevelBadge(riskLevel: vault.riskLevel)
                            }

                            Text(vault.description)
                                .foregroundColor(.secondaryText)
                        }
                        .padding()
                        .background(Color.surfaceColor)
                        .cornerRadius(16)

                        // Performance
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Performance")
                                .font(.headline)
                                .foregroundColor(.primaryText)

                            HStack(spacing: 20) {
                                PerformanceMetric(
                                    title: "All Time Return",
                                    value: vault.allTimeReturn,
                                    isPercentage: true
                                )

                                PerformanceMetric(
                                    title: "Monthly Return",
                                    value: vault.monthlyReturn,
                                    isPercentage: true
                                )
                            }

                            HStack(spacing: 20) {
                                PerformanceMetric(
                                    title: "Total AUM",
                                    value: vault.totalAUM,
                                    prefix: "$"
                                )

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Followers")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text("\(vault.followers)")
                                        .font(.headline)
                                        .foregroundColor(.primaryText)
                                }
                            }
                        }
                        .padding()
                        .background(Color.surfaceColor)
                        .cornerRadius(16)

                        // Follow section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Follow Vault")
                                .font(.headline)
                                .foregroundColor(.primaryText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Amount to Follow")
                                    .foregroundColor(.secondaryText)
                                TextField("Enter amount in USDC", text: $followAmount)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }

                            Text("Performance Fee: \(Int(vault.performanceFee))%")
                                .font(.caption)
                                .foregroundColor(.secondaryText)

                            Button {
                                // Follow vault action
                            } label: {
                                Text("Follow Vault")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.primaryBlue)
                                    .cornerRadius(12)
                            }
                            .disabled(followAmount.isEmpty)
                        }
                        .padding()
                        .background(Color.surfaceColor)
                        .cornerRadius(16)
                    }
                    .padding()
                }
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

#Preview {
    TradeView()
}