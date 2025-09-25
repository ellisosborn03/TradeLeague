import SwiftUI

struct LeagueView: View {
    @State private var selectedScope: LeagueScope = .local
    @State private var sponsoredLeagues: [SponsoredLeague] = []
    @State private var expandedLeagues: Set<String> = []
    @State private var friendsLeaderboard: [LeaguePlayer] = []
    @State private var selectedLeague: SponsoredLeague?

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                // Particle background
                HeroParticles(particleCount: 40)
                    .opacity(0.4)

                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Header with animated transition
                        VStack(spacing: Theme.Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                Text("Leagues")
                                    .font(Theme.Typography.displayM)
                                    .fontWeight(.bold)
                                    .tracking(-1.0)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)
                                    .reveal(delay: 0.1)

                                    Text("Compete in sponsored challenges")
                                    .font(Theme.Typography.bodyS)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                    .reveal(delay: 0.2)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)

                            // Scope Toggle with orange theme
                            CustomSegmentToggle(
                                options: [LeagueScope.local, LeagueScope.global],
                                optionLabels: [.local: "FRIENDS", .global: "GLOBAL"],
                                selection: $selectedScope
                            )
                            .padding(.horizontal)
                        }

                        // Caption based on selected scope
                        VStack(spacing: Theme.Spacing.sm) {
                            if selectedScope == .global {
                                Text("Compete with traders worldwide in sponsored challenges. Entry fees and prize pools vary by league.")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .reveal(delay: 0.3)
                            } else {
                                Text("See how you stack up against your friends. Invite more friends to climb the leaderboard.")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .reveal(delay: 0.3)
                            }

                            // Content based on selected scope
                            if selectedScope == .global {
                                GlobalLeaguesView(
                                    sponsoredLeagues: sponsoredLeagues,
                                    expandedLeagues: $expandedLeagues
                                ) { league in
                                    selectedLeague = league
                                }
                            } else {
                                FriendsLeaderboardView(players: friendsLeaderboard)
                            }
                        }
                    }
                    .padding(.vertical)

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
                loadData()
            }
            .sheet(item: $selectedLeague) { league in
                LeagueJoinView(league: league)
            }
        }
    }

    private func loadData() {
        loadSponsoredLeagues()
        loadFriendsLeaderboard()
    }

    private func loadSponsoredLeagues() {
        sponsoredLeagues = [
            SponsoredLeague(
                id: "circle",
                sponsorName: "Circle",
                sponsorLogo: "circle",
                leagueName: "USDC Challenge",
                prizePool: 10000,
                entryFee: 100,
                participants: [
                    LeaguePlayer(id: "1", username: "Alex", avatar: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=150&h=150&fit=crop&crop=face", profit: 2847.23, rank: 1, recentTrades: [
                        Trade(id: "gt1", symbol: "USDC", type: .buy, amount: 5000, price: 1.0, pnl: 1200.45, timestamp: Date().addingTimeInterval(-1800), venue: "Circle"),
                        Trade(id: "gt2", symbol: "APT", type: .long, amount: 800, price: 12.30, pnl: 1646.78, timestamp: Date().addingTimeInterval(-5400), venue: "Merkle")
                    ]),
                    LeaguePlayer(id: "2", username: "Sarah", avatar: "https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=150&h=150&fit=crop&crop=face", profit: 1923.45, rank: 2, recentTrades: [
                        Trade(id: "gt3", symbol: "BTC", type: .long, amount: 0.8, price: 66500, pnl: 890.23, timestamp: Date().addingTimeInterval(-2700), venue: "Hyperion"),
                        Trade(id: "gt4", symbol: "ETH", type: .buy, amount: 3, price: 3350, pnl: 1033.22, timestamp: Date().addingTimeInterval(-6300), venue: "Merkle")
                    ]),
                    LeaguePlayer(id: "3", username: "Maya", avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop&crop=face", profit: 1456.78, rank: 3, recentTrades: [
                        Trade(id: "gt5", symbol: "SOL", type: .long, amount: 15, price: 178, pnl: 678.90, timestamp: Date().addingTimeInterval(-3600), venue: "Tapp"),
                        Trade(id: "gt6", symbol: "USDC", type: .sell, amount: 2000, price: 1.0, pnl: 777.88, timestamp: Date().addingTimeInterval(-7200), venue: "Circle")
                    ]),
                    LeaguePlayer(id: "4", username: "Jake", avatar: "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&h=150&fit=crop&crop=face", profit: -234.56, rank: 4, recentTrades: [
                        Trade(id: "gt7", symbol: "APT", type: .short, amount: 300, price: 13.00, pnl: -123.45, timestamp: Date().addingTimeInterval(-4500), venue: "Hyperion"),
                        Trade(id: "gt8", symbol: "BTC", type: .sell, amount: 0.2, price: 67000, pnl: -111.11, timestamp: Date().addingTimeInterval(-8100), venue: "Tapp")
                    ]),
                    LeaguePlayer(id: "5", username: "Ryan", avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face", profit: -567.89, rank: 5, recentTrades: [
                        Trade(id: "gt9", symbol: "ETH", type: .short, amount: 2, price: 3400, pnl: -345.67, timestamp: Date().addingTimeInterval(-5100), venue: "Merkle"),
                        Trade(id: "gt10", symbol: "SOL", type: .sell, amount: 8, price: 182, pnl: -222.22, timestamp: Date().addingTimeInterval(-9000), venue: "Hyperion")
                    ])
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
            ),
            SponsoredLeague(
                id: "hyperion",
                sponsorName: "Hyperion",
                sponsorLogo: "hyperion",
                leagueName: "Lightning Liquidity",
                prizePool: 7500,
                entryFee: 75,
                participants: [
                    LeaguePlayer(id: "6", username: "Emma", avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face", profit: 3245.67, rank: 1),
                    LeaguePlayer(id: "7", username: "James", avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face", profit: 2134.89, rank: 2),
                    LeaguePlayer(id: "8", username: "Priya", avatar: "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150&h=150&fit=crop&crop=face", profit: 1876.34, rank: 3),
                    LeaguePlayer(id: "9", username: "Carlos", avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face", profit: 987.12, rank: 4),
                    LeaguePlayer(id: "10", username: "Lisa", avatar: "https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=150&h=150&fit=crop&crop=face", profit: -123.45, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
            ),
            SponsoredLeague(
                id: "merkle",
                sponsorName: "Merkle Trade",
                sponsorLogo: "merkle",
                leagueName: "Derivatives Derby",
                prizePool: 5000,
                entryFee: 50,
                participants: [
                    LeaguePlayer(id: "11", username: "Kevin", avatar: "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=150&h=150&fit=crop&crop=face", profit: 1987.65, rank: 1),
                    LeaguePlayer(id: "12", username: "Zoe", avatar: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&h=150&fit=crop&crop=face", profit: 1543.21, rank: 2),
                    LeaguePlayer(id: "13", username: "David", avatar: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face", profit: 1234.56, rank: 3),
                    LeaguePlayer(id: "14", username: "Sophie", avatar: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&h=150&fit=crop&crop=face", profit: 876.43, rank: 4),
                    LeaguePlayer(id: "15", username: "Mike", avatar: "https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=150&h=150&fit=crop&crop=face", profit: -345.67, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
            ),
            SponsoredLeague(
                id: "tapp",
                sponsorName: "Tapp Network",
                sponsorLogo: "tapp",
                leagueName: "Mobile Masters",
                prizePool: 3000,
                entryFee: 25,
                participants: [
                    LeaguePlayer(id: "16", username: "Anna", avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop&crop=face", profit: 1456.78, rank: 1),
                    LeaguePlayer(id: "17", username: "Tom", avatar: "https://images.unsplash.com/photo-1541101767792-f9b2b1c4f127?w=150&h=150&fit=crop&crop=face", profit: 1234.56, rank: 2),
                    LeaguePlayer(id: "18", username: "Nina", avatar: "https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=150&h=150&fit=crop&crop=face", profit: 987.65, rank: 3),
                    LeaguePlayer(id: "19", username: "Leo", avatar: "https://images.unsplash.com/photo-1463453091185-61582044d556?w=150&h=150&fit=crop&crop=face", profit: 543.21, rank: 4),
                    LeaguePlayer(id: "20", username: "Ben", avatar: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face", profit: -234.56, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
            )
        ]
    }

    private func loadFriendsLeaderboard() {
        friendsLeaderboard = [
            LeaguePlayer(id: "f1", username: "Max", avatar: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=150&h=150&fit=crop&crop=face", profit: 2345.67, rank: 1, recentTrades: [
                Trade(id: "t1", symbol: "APT", type: .long, amount: 500, price: 12.45, pnl: 890.23, timestamp: Date().addingTimeInterval(-3600), venue: "Merkle"),
                Trade(id: "t2", symbol: "USDC", type: .buy, amount: 1000, price: 1.0, pnl: 245.67, timestamp: Date().addingTimeInterval(-7200), venue: "Hyperion"),
                Trade(id: "t3", symbol: "BTC", type: .long, amount: 0.5, price: 67000, pnl: 1209.77, timestamp: Date().addingTimeInterval(-10800), venue: "Tapp")
            ]),
            LeaguePlayer(id: "f2", username: "Aria", avatar: "https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=150&h=150&fit=crop&crop=face", profit: 1876.43, rank: 2, recentTrades: [
                Trade(id: "t4", symbol: "ETH", type: .long, amount: 2, price: 3400, pnl: 678.90, timestamp: Date().addingTimeInterval(-2700), venue: "Merkle"),
                Trade(id: "t5", symbol: "APT", type: .sell, amount: 300, price: 13.20, pnl: 456.78, timestamp: Date().addingTimeInterval(-5400), venue: "Hyperion"),
                Trade(id: "t6", symbol: "SOL", type: .short, amount: 10, price: 180, pnl: 740.75, timestamp: Date().addingTimeInterval(-8100), venue: "Tapp")
            ]),
            LeaguePlayer(id: "f3", username: "Jade", avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop&crop=face", profit: 1234.89, rank: 3, recentTrades: [
                Trade(id: "t7", symbol: "USDC", type: .buy, amount: 2000, price: 1.0, pnl: 534.21, timestamp: Date().addingTimeInterval(-1800), venue: "Hyperion"),
                Trade(id: "t8", symbol: "APT", type: .long, amount: 400, price: 12.80, pnl: 700.68, timestamp: Date().addingTimeInterval(-4500), venue: "Merkle")
            ]),
            LeaguePlayer(id: "f4", username: "Satoshi", avatar: "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&h=150&fit=crop&crop=face", profit: 987.65, rank: 4, recentTrades: [
                Trade(id: "t9", symbol: "BTC", type: .long, amount: 0.3, price: 66800, pnl: 456.78, timestamp: Date().addingTimeInterval(-2100), venue: "Tapp"),
                Trade(id: "t10", symbol: "ETH", type: .short, amount: 1.5, price: 3380, pnl: 234.56, timestamp: Date().addingTimeInterval(-6300), venue: "Merkle"),
                Trade(id: "t11", symbol: "APT", type: .buy, amount: 250, price: 12.65, pnl: 296.31, timestamp: Date().addingTimeInterval(-9000), venue: "Hyperion")
            ]),
            LeaguePlayer(id: "f5", username: "Vitalik", avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face", profit: 543.21, rank: 5, recentTrades: [
                Trade(id: "t12", symbol: "ETH", type: .long, amount: 1, price: 3420, pnl: 123.45, timestamp: Date().addingTimeInterval(-3300), venue: "Merkle"),
                Trade(id: "t13", symbol: "USDC", type: .sell, amount: 800, price: 1.0, pnl: 89.76, timestamp: Date().addingTimeInterval(-7800), venue: "Hyperion"),
                Trade(id: "t14", symbol: "SOL", type: .long, amount: 5, price: 175, pnl: 330.00, timestamp: Date().addingTimeInterval(-11700), venue: "Tapp")
            ]),
            LeaguePlayer(id: "f6", username: "Mia", avatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face", profit: 234.56, rank: 6, recentTrades: [
                Trade(id: "t15", symbol: "APT", type: .buy, amount: 100, price: 12.90, pnl: 67.89, timestamp: Date().addingTimeInterval(-4200), venue: "Hyperion"),
                Trade(id: "t16", symbol: "BTC", type: .sell, amount: 0.1, price: 67200, pnl: 166.67, timestamp: Date().addingTimeInterval(-8700), venue: "Tapp")
            ])
        ]
    }
}

struct GlobalLeaguesView: View {
    let sponsoredLeagues: [SponsoredLeague]
    @Binding var expandedLeagues: Set<String>
    @State private var expandedPlayers: Set<String> = []
    let onLeagueJoin: (SponsoredLeague) -> Void

    var body: some View {
        LazyVStack(spacing: Theme.Spacing.md) {
            ForEach(Array(sponsoredLeagues.enumerated()), id: \.element.id) { index, league in
                SponsoredLeagueCard(
                    league: league,
                    isExpanded: expandedLeagues.contains(league.id),
                    expandedPlayers: $expandedPlayers,
                    onToggle: {
                        withAnimation(Theme.Animation.base) {
                            if expandedLeagues.contains(league.id) {
                                expandedLeagues.remove(league.id)
                            } else {
                                expandedLeagues.insert(league.id)
                            }
                        }
                    },
                    onJoin: {
                        onLeagueJoin(league)
                    }
                )
                .padding(.horizontal)
                .animation(Theme.Animation.base.delay(Double(index) * 0.05), value: sponsoredLeagues)
            }
        }
    }
}

struct FriendsLeaderboardView: View {
    let players: [LeaguePlayer]
    @State private var expandedPlayers: Set<String> = []

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Podium for top 3
            if players.count >= 3 {
                PodiumView(
                    topPlayers: Array(players.prefix(3)),
                    expandedPlayers: $expandedPlayers
                )
                    .padding(.horizontal)
            }

            // List for 4th onwards
            if players.count > 3 {
                VStack(spacing: Theme.Spacing.sm) {
                    HStack {
                        Text("FRIENDS RANKING")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Spacer()
                        Text("PROFIT/LOSS")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                    .padding(.horizontal)

                    ForEach(Array(players.dropFirst(3).enumerated()), id: \.element.id) { index, player in
                        LeaderboardRowView(
                            player: player,
                            rank: index + 4,
                            isExpanded: expandedPlayers.contains(player.id)
                        ) {
                            withAnimation(Theme.Animation.base) {
                                if expandedPlayers.contains(player.id) {
                                    expandedPlayers.remove(player.id)
                                } else {
                                    expandedPlayers.insert(player.id)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .optimizedGlassCard(style: .flat)
                        .reveal(delay: Double(index) * 0.05)
                        .animation(Theme.Animation.base.delay(Double(index) * 0.03), value: players)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct PodiumView: View {
    let topPlayers: [LeaguePlayer]
    @Binding var expandedPlayers: Set<String>

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
                Spacer()

            // 2nd Place
            if topPlayers.count > 1 {
                PodiumPlayerView(
                    player: topPlayers[1],
                    rank: 2,
                    height: 80,
                    isExpanded: expandedPlayers.contains(topPlayers[1].id)
                ) {
                    withAnimation(Theme.Animation.base) {
                        if expandedPlayers.contains(topPlayers[1].id) {
                            expandedPlayers.remove(topPlayers[1].id)
                        } else {
                            expandedPlayers.insert(topPlayers[1].id)
                        }
                    }
                }
            }

            // 1st Place (tallest)
            if topPlayers.count > 0 {
                PodiumPlayerView(
                    player: topPlayers[0],
                    rank: 1,
                    height: 100,
                    isExpanded: expandedPlayers.contains(topPlayers[0].id)
                ) {
                    withAnimation(Theme.Animation.base) {
                        if expandedPlayers.contains(topPlayers[0].id) {
                            expandedPlayers.remove(topPlayers[0].id)
                        } else {
                            expandedPlayers.insert(topPlayers[0].id)
                        }
                    }
                }
            }

            // 3rd Place
            if topPlayers.count > 2 {
                PodiumPlayerView(
                    player: topPlayers[2],
                    rank: 3,
                    height: 60,
                    isExpanded: expandedPlayers.contains(topPlayers[2].id)
                ) {
                    withAnimation(Theme.Animation.base) {
                        if expandedPlayers.contains(topPlayers[2].id) {
                            expandedPlayers.remove(topPlayers[2].id)
                        } else {
                            expandedPlayers.insert(topPlayers[2].id)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .optimizedGlassCard(style: .elevated)
        .reveal(delay: 0.3)
    }
}

struct PodiumPlayerView: View {
    let player: LeaguePlayer
    let rank: Int
    let height: CGFloat
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Button(action: onTap) {
                VStack(spacing: Theme.Spacing.xs) {
                    // Avatar
                    AvatarView(avatarURL: player.avatar, size: 50)
                        .overlay(
                            Circle()
                                .stroke(rankColor, lineWidth: 2)
                        )

                    // Name
                    Text(player.username)
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    // Profit
                    Text("\(player.profit >= 0 ? "+" : "")$\(player.profit, specifier: "%.0f")")
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(player.profit >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Trades dropdown
            if isExpanded && !player.recentTrades.isEmpty {
                VStack(spacing: Theme.Spacing.xs) {
                    ForEach(player.recentTrades.prefix(3)) { trade in
                        TradeRowView(trade: trade, isCompact: true)
                    }
                }
                .padding(Theme.Spacing.xs)
                .background(Theme.ColorPalette.surface.opacity(0.8))
                .cornerRadius(Theme.Radius.sm)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.95)),
                    removal: .opacity
                ))
            }

            // Podium
            Rectangle()
                .fill(Theme.ColorPalette.gradientPrimary)
                .frame(width: 60, height: height)
                .cornerRadius(Theme.Radius.sm, corners: [.topLeft, .topRight])
                .overlay(
                    VStack {
                        Text("\(rank)")
                            .font(Theme.Typography.heading2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, Theme.Spacing.xs)
                )
        }
    }

    private var rankColor: Color {
        switch rank {
        case 1: return Color(hex: "FFD700") // Gold
        case 2: return Color(hex: "C0C0C0") // Silver
        case 3: return Color(hex: "CD7F32") // Bronze
        default: return Theme.ColorPalette.primary
        }
    }
}

struct SponsoredLeagueCard: View {
    let league: SponsoredLeague
    let isExpanded: Bool
    @Binding var expandedPlayers: Set<String>
    let onToggle: () -> Void
    let onJoin: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // League Header
            Button(action: onToggle) {
                HStack(spacing: Theme.Spacing.md) {
                    // Company Logo
                    CompanyLogoView(company: league.sponsorLogo)

                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        Text(league.sponsorName)
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text(league.leagueName)
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: Theme.Spacing.xxs) {
                        CountUpText(target: Double(league.prizePool), fontSize: Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                        Text("Prize Pool")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.ColorPalette.primary)
                        .font(Theme.Typography.caption)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(Theme.Animation.fast, value: isExpanded)
                }
                .padding(Theme.Spacing.md)
                .optimizedGlassCard(isActive: isExpanded, style: .glass)
            }
            .buttonStyle(PlainButtonStyle())

            // Expandable Content
            if isExpanded {
                VStack(spacing: Theme.Spacing.sm) {
                    // Top 3 Podium
                    if league.participants.count >= 3 {
                        PodiumView(
                            topPlayers: Array(league.participants.prefix(3)),
                            expandedPlayers: $expandedPlayers
                        )
                    }

                    // Remaining players
                    if league.participants.count > 3 {
                        VStack(spacing: Theme.Spacing.xs) {
                            HStack {
                                Text("LEADERBOARD")
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                Spacer()
                                Text("PROFIT/LOSS")
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                            }
                            .padding(.horizontal)

                            ForEach(Array(league.participants.dropFirst(3).enumerated()), id: \.element.id) { index, player in
                                LeaderboardRowView(
                                    player: player,
                                    rank: index + 4,
                                    isExpanded: expandedPlayers.contains(player.id)
                                ) {
                                    withAnimation(Theme.Animation.base) {
                                        if expandedPlayers.contains(player.id) {
                                            expandedPlayers.remove(player.id)
                                        } else {
                                            expandedPlayers.insert(player.id)
                                        }
                                    }
                                }
                                    .padding(.horizontal, Theme.Spacing.sm)
                            }
                        }
                    }

                    // League Info & Join Button
                    HStack {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                            Text("Entry Fee: $\(Int(league.entryFee))")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                            Text("Ends in \(timeUntilEnd(league.endDate))")
                                .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                        }

                        Spacer()

                        OptimizedPrimaryButton(title: "Join League") {
                            onJoin()
                        }
                    }
                    .padding()
                }
                .background(Theme.ColorPalette.surface.opacity(0.5))
                .cornerRadius(Theme.Radius.md)
                .padding(.top, Theme.Spacing.xs)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.95)),
                    removal: .opacity
                ))
            }
        }
    }

    private func timeUntilEnd(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        return "\(days) days"
    }
}

struct CompanyLogoView: View {
    let company: String

    var body: some View {
        ZStack {
            Circle()
                .fill(logoBackgroundColor)
                .frame(width: 40, height: 40)
            
            Image(systemName: fallbackIcon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .clipShape(Circle())
        .background(
            Circle()
                .fill(Color.white)
                .frame(width: 44, height: 44)
        )
    }

    private var logoBackgroundColor: Color {
        switch company {
        case "circle": return Color(hex: "007AFF")
        case "hyperion": return Color(hex: "6366F1")
        case "merkle": return Color(hex: "10B981")
        case "tapp": return Color(hex: "F59E0B")
        default: return Theme.ColorPalette.primary
        }
    }
    
    private var fallbackIcon: String {
        switch company {
        case "circle": return "dollarsign.circle.fill"
        case "hyperion": return "chart.line.uptrend.xyaxis"
        case "merkle": return "chart.bar.xaxis"
        case "tapp": return "link.circle.fill"
        default: return "building.2.crop.circle"
        }
    }
}

struct AvatarView: View {
    let avatarURL: String
    let size: CGFloat

    var body: some View {
        AsyncImage(url: URL(string: avatarURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Circle()
                .fill(Theme.ColorPalette.surface)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                        .font(.system(size: size * 0.4))
                )
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct LeaderboardRowView: View {
    let player: LeaguePlayer
    let rank: Int
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Button(action: onTap) {
                HStack(spacing: Theme.Spacing.sm) {
                    // Rank
                    Text("\(rank)")
                        .font(Theme.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .frame(width: 24)

                    // Avatar
                    AvatarView(avatarURL: player.avatar, size: 32)

                    // Username
                    Text(player.username)
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Spacer()

                    // Profit/Loss
                    Text("\(player.profit >= 0 ? "+" : "")$\(player.profit, specifier: "%.0f")")
                        .font(Theme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(player.profit >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)

                    // Chevron indicator
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                        .font(.system(size: 12))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(Theme.Animation.fast, value: isExpanded)
                }
                .padding(.vertical, Theme.Spacing.xs)
            }
            .buttonStyle(PlainButtonStyle())

            // Trades dropdown
            if isExpanded && !player.recentTrades.isEmpty {
                VStack(spacing: Theme.Spacing.xs) {
                    ForEach(player.recentTrades.prefix(5)) { trade in
                        TradeRowView(trade: trade, isCompact: false)
                    }
                }
                .padding(Theme.Spacing.sm)
                .background(Theme.ColorPalette.surface.opacity(0.8))
                .cornerRadius(Theme.Radius.md)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.95)),
                    removal: .opacity
                ))
            }
        }
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct TradeRowView: View {
    let trade: Trade
    let isCompact: Bool

    var body: some View {
        HStack(spacing: Theme.Spacing.xs) {
            // Trade type indicator
            Circle()
                .fill(tradeTypeColor)
                .frame(width: isCompact ? 6 : 8, height: isCompact ? 6 : 8)

            // Symbol and type
            VStack(alignment: .leading, spacing: 0) {
                Text(trade.symbol)
                    .font(isCompact ? Theme.Typography.captionS : Theme.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.ColorPalette.textPrimary)
                if !isCompact {
                    Text(trade.type.rawValue)
                        .font(Theme.Typography.captionS)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }

            Spacer()

            if !isCompact {
                // Amount and price
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(trade.amount, specifier: "%.2f")")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                    Text("@$\(trade.price, specifier: "%.2f")")
                        .font(Theme.Typography.captionS)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }

                Spacer()
            }

            // P&L
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(trade.pnl >= 0 ? "+" : "")$\(trade.pnl, specifier: "%.0f")")
                    .font(isCompact ? Theme.Typography.captionS : Theme.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(trade.pnl >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                if !isCompact {
                    Text(trade.venue)
                        .font(Theme.Typography.captionS)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }
        }
        .padding(.vertical, isCompact ? Theme.Spacing.xxs : Theme.Spacing.xs)
        .padding(.horizontal, isCompact ? Theme.Spacing.xs : Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(Color.white.opacity(0.5))
        )
    }

    private var tradeTypeColor: Color {
        switch trade.type {
        case .buy, .long:
            return Theme.ColorPalette.successGreen
        case .sell, .short:
            return Theme.ColorPalette.dangerRed
        }
    }
}

struct LeagueJoinView: View {
    let league: SponsoredLeague
    @Environment(\.dismiss) private var dismiss
    @State private var joinAmount = ""

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
                                SponsorLogoView.large(league.sponsorName)

                                VStack(alignment: .leading) {
                                    Text(league.leagueName)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)

                                    Text("Sponsored by \(league.sponsorName)")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                }

                                Spacer()
                            }

                            Text("Compete with traders worldwide in this sponsored challenge. Entry fee required to participate.")
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // League Details
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Challenge Details")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Prize Pool")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text("$\(Int(league.prizePool))")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.ColorPalette.primary)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Entry Fee")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text("$\(Int(league.entryFee))")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                }
                            }

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Participants")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text("\(league.participants.count)")
                                        .font(.headline)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Ends In")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text(league.endDate, style: .relative)
                                        .font(.headline)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                }
                            }
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Current Leaders
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Current Leaders")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            ForEach(Array(league.participants.prefix(3).enumerated()), id: \.element.id) { index, player in
                                HStack {
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                        .frame(width: 24)

                                    AvatarView(avatarURL: player.avatar, size: 32)

                                    Text(player.username)
                                        .font(.headline)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)

                                    Spacer()

                                    Text("\(player.profit >= 0 ? "+" : "")$\(player.profit, specifier: "%.0f")")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(player.profit >= 0 ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Join section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Join Challenge")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Entry Amount")
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                TextField("Enter amount in USDC", text: $joinAmount)
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

                            Text("Entry Fee: $\(Int(league.entryFee)) • Minimum entry to participate")
                                .font(.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)

                            OptimizedPrimaryButton(title: "Join Challenge for $\(Int(league.entryFee))") {
                                // Join challenge action - will show success toast
                                dismiss()
                            }
                            .disabled(joinAmount.isEmpty)
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
    LeagueView()
}