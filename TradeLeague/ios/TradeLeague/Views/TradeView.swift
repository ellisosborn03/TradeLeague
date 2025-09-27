import SwiftUI

struct TradeView: View {
    @State private var vaults: [Vault] = []
    @State private var selectedVault: Vault?
    @State private var followings: [VaultFollowing] = []
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Trade")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)

                                Text("Follow top trading vaults")
                                    .font(.subheadline)
                                    .foregroundColor(.secondaryText)
                            }

                            Spacer()
                        }

                        // Segment control
                        Picker("View", selection: $selectedSegment) {
                            Text("Discover").tag(0)
                            Text("Following").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
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
                    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
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
                    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
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
            LazyVStack(spacing: 12) {
                ForEach(vaults) { vault in
                    VaultCard(vault: vault) {
                        onVaultTap(vault)
                    }
                    .padding(.horizontal)
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
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vault.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)

                        HStack {
                            Text("by \(vault.manager.username)")
                                .font(.caption)
                                .foregroundColor(.secondaryText)

                            Text("•")
                                .foregroundColor(.secondaryText)

                            Text(vault.venue.rawValue)
                                .font(.caption)
                                .foregroundColor(.primaryBlue)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        RiskLevelBadge(riskLevel: vault.riskLevel)

                        Text("\(vault.followers) followers")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                }

                // Strategy and description
                Text(vault.strategy.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primaryBlue)

                Text(vault.description)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                    .lineLimit(2)

                // Performance metrics
                HStack(spacing: 20) {
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
                    .background(Color.borderColor)

                // Follow button
                HStack {
                    Text("Performance Fee: \(Int(vault.performanceFee))%")
                        .font(.caption)
                        .foregroundColor(.secondaryText)

                    Spacer()

                    Text("Follow")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                }
            }
            .padding()
            .background(Color.surfaceColor)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
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
            return .successGreen
        case .moderate:
            return .warningYellow
        case .aggressive:
            return .dangerRed
        }
    }

    var body: some View {
        Text(riskLevel.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor)
            .cornerRadius(8)
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
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)

            HStack(spacing: 2) {
                if !prefix.isEmpty {
                    Text(prefix)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }

                if value >= 1000000 {
                    Text("\(value / 1000000, specifier: "%.1f")M")
                        .font(.headline)
                        .foregroundColor(isPercentage ? (value >= 0 ? .successGreen : .dangerRed) : .primaryText)
                } else if value >= 1000 {
                    Text("\(value / 1000, specifier: "%.1f")K")
                        .font(.headline)
                        .foregroundColor(isPercentage ? (value >= 0 ? .successGreen : .dangerRed) : .primaryText)
                } else {
                    Text("\(value, specifier: "%.1f")")
                        .font(.headline)
                        .foregroundColor(isPercentage ? (value >= 0 ? .successGreen : .dangerRed) : .primaryText)
                }

                if isPercentage {
                    Text("%")
                        .font(.headline)
                        .foregroundColor(value >= 0 ? .successGreen : .dangerRed)
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