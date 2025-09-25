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
                                Text("Trade, earn, and compete with friends.")
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
                        Text("Powered by Aptos")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                    .padding(.vertical, Theme.Spacing.lg)
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
        // Sample players for all challenges
        let samplePlayers = [
            LeaguePlayer(id: "1", username: "Alex", avatar: "nft1", profit: 2847.23, rank: 1),
            LeaguePlayer(id: "2", username: "Sarah", avatar: "nft2", profit: 1923.45, rank: 2),
            LeaguePlayer(id: "3", username: "Maya", avatar: "nft3", profit: 1456.78, rank: 3),
            LeaguePlayer(id: "4", username: "Jake", avatar: "nft1", profit: -234.56, rank: 4),
            LeaguePlayer(id: "5", username: "Ryan", avatar: "nft2", profit: -567.89, rank: 5)
        ]

        sponsoredLeagues = [
            // Circle Challenge
            SponsoredLeague(
                id: "circle",
                sponsorName: "Circle",
                sponsorLogo: "circle",
                leagueName: "Circle Challenge",
                prizePool: 10000,
                entryFee: 100,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()
            ),
            // Ekiden Challenge
            SponsoredLeague(
                id: "ekiden",
                sponsorName: "Ekiden",
                sponsorLogo: "ekiden",
                leagueName: "Ekiden Challenge",
                prizePool: 7500,
                entryFee: 75,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
            ),
            // Hyperion Challenge
            SponsoredLeague(
                id: "hyperion",
                sponsorName: "Hyperion",
                sponsorLogo: "hyperion",
                leagueName: "Hyperion Challenge",
                prizePool: 6000,
                entryFee: 60,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
            ),
            // Kana Labs Challenge
            SponsoredLeague(
                id: "kanalabs",
                sponsorName: "Kana Labs",
                sponsorLogo: "kanalabs",
                leagueName: "Kana Labs Challenge",
                prizePool: 5000,
                entryFee: 50,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
            ),
            // Kofi Challenge
            SponsoredLeague(
                id: "kofi",
                sponsorName: "Kofi",
                sponsorLogo: "kofi",
                leagueName: "Kofi Challenge",
                prizePool: 4000,
                entryFee: 40,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
            ),
            // Merkle Trade Challenge
            SponsoredLeague(
                id: "merkle",
                sponsorName: "Merkle Trade",
                sponsorLogo: "merkle",
                leagueName: "Merkle Trade Challenge",
                prizePool: 8000,
                entryFee: 80,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            ),
            // NODIT Challenge
            SponsoredLeague(
                id: "nodit",
                sponsorName: "NODIT",
                sponsorLogo: "nodit",
                leagueName: "NODIT Challenge",
                prizePool: 3500,
                entryFee: 35,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
            ),
            // Panora Challenge
            SponsoredLeague(
                id: "panora",
                sponsorName: "Panora",
                sponsorLogo: "panora",
                leagueName: "Panora Challenge",
                prizePool: 5500,
                entryFee: 55,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()
            ),
            // Tapp Exchange Challenge
            SponsoredLeague(
                id: "tapp",
                sponsorName: "Tapp Exchange",
                sponsorLogo: "tapp",
                leagueName: "Tapp Exchange Challenge",
                prizePool: 4500,
                entryFee: 45,
                participants: samplePlayers,
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
            )
        ]
    }

    private func loadFriendsLeaderboard() {
        friendsLeaderboard = [
            LeaguePlayer(id: "f1", username: "Avery", avatar: "nft3", profit: 2345.67, rank: 1, recentTrades: [
                Trade(id: "t1", symbol: "APT", type: .long, amount: 500, price: 12.45, pnl: 890.23, timestamp: Date().addingTimeInterval(-3600), venue: "Merkle"),
                Trade(id: "t2", symbol: "USDC", type: .buy, amount: 1000, price: 1.0, pnl: 245.67, timestamp: Date().addingTimeInterval(-7200), venue: "Hyperion"),
                Trade(id: "t3", symbol: "BTC", type: .long, amount: 0.5, price: 67000, pnl: 1209.77, timestamp: Date().addingTimeInterval(-10800), venue: "Tapp")
            ]),
            LeaguePlayer(id: "f2", username: "Aria", avatar: "nft1", profit: 1876.43, rank: 2, recentTrades: [
                Trade(id: "t4", symbol: "ETH", type: .long, amount: 2, price: 3400, pnl: 678.90, timestamp: Date().addingTimeInterval(-2700), venue: "Merkle"),
                Trade(id: "t5", symbol: "APT", type: .sell, amount: 300, price: 13.20, pnl: 456.78, timestamp: Date().addingTimeInterval(-5400), venue: "Hyperion"),
                Trade(id: "t6", symbol: "SOL", type: .short, amount: 10, price: 180, pnl: 740.75, timestamp: Date().addingTimeInterval(-8100), venue: "Tapp")
            ]),
            LeaguePlayer(id: "f3", username: "Jade", avatar: "nft2", profit: 1234.89, rank: 3, recentTrades: [
                Trade(id: "t7", symbol: "USDC", type: .buy, amount: 2000, price: 1.0, pnl: 534.21, timestamp: Date().addingTimeInterval(-1800), venue: "Hyperion"),
                Trade(id: "t8", symbol: "APT", type: .long, amount: 400, price: 12.80, pnl: 700.68, timestamp: Date().addingTimeInterval(-4500), venue: "Merkle")
            ]),
            LeaguePlayer(id: "f4", username: "Satoshi", avatar: "doge.png", profit: 987.65, rank: 4, recentTrades: [
                Trade(id: "t9", symbol: "BTC", type: .long, amount: 0.3, price: 66800, pnl: 456.78, timestamp: Date().addingTimeInterval(-2100), venue: "Tapp"),
                Trade(id: "t10", symbol: "ETH", type: .short, amount: 1.5, price: 3380, pnl: 234.56, timestamp: Date().addingTimeInterval(-6300), venue: "Merkle"),
                Trade(id: "t11", symbol: "APT", type: .buy, amount: 250, price: 12.65, pnl: 296.31, timestamp: Date().addingTimeInterval(-9000), venue: "Hyperion")
            ]),
            LeaguePlayer(id: "f5", username: "Vitalik", avatar: "vitalik.png", profit: 543.21, rank: 5, recentTrades: [
                Trade(id: "t12", symbol: "ETH", type: .long, amount: 1, price: 3420, pnl: 123.45, timestamp: Date().addingTimeInterval(-3300), venue: "Merkle"),
                Trade(id: "t13", symbol: "USDC", type: .sell, amount: 800, price: 1.0, pnl: 89.76, timestamp: Date().addingTimeInterval(-7800), venue: "Hyperion"),
                Trade(id: "t14", symbol: "SOL", type: .long, amount: 5, price: 175, pnl: 330.00, timestamp: Date().addingTimeInterval(-11700), venue: "Tapp")
            ]),
            LeaguePlayer(id: "f6", username: "Mia", avatar: "nft3", profit: 234.56, rank: 6, recentTrades: [
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
                    SponsorLogoView.medium(league.sponsorName)

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
        // Handle local images (doge.png, vitalik.png, nft1, nft2, nft3)
        if avatarURL.contains(".png") || avatarURL.hasPrefix("nft") || avatarURL.hasPrefix("doge") || avatarURL.hasPrefix("vitalik") {
            // Remove .png extension if present for asset catalog lookup
            let imageName = avatarURL.replacingOccurrences(of: ".png", with: "")
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else if avatarURL.hasPrefix("http") {
            // Handle URL-based images (fallback for any remaining URLs)
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
        } else {
            // Default placeholder for invalid image references
            Circle()
                .fill(Theme.ColorPalette.surface)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                        .font(.system(size: size * 0.4))
                )
                .frame(width: size, height: size)
        }
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

struct USDCChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isUnlocked = false
    @State private var challengeCompleted = false
    @State private var amount = ""
    @State private var selectedStrategy = 0
    @State private var showConfirmModal = false
    @State private var showSuccessToast = false

    private let strategies = [
        StrategyCard(id: 0, name: "Coinbase USDC Lending", yield: "4.2% APY", risk: "Low", description: "Earn yield through Coinbase's institutional lending program"),
        StrategyCard(id: 1, name: "Aave v3", yield: "3.8% APY", risk: "Medium", description: "Decentralized lending protocol with variable rates"),
        StrategyCard(id: 2, name: "Compound v3", yield: "4.1% APY", risk: "Medium", description: "Autonomous interest rate protocol"),
        StrategyCard(id: 3, name: "USYC", yield: "5.1% APY", risk: "Low", description: "Hashnote US Yield Coin backed by T-Bills")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Hero Card
                        heroCard

                        // Status Banner
                        if challengeCompleted {
                            statusBanner
                        }

                        // Main Content
                        if isUnlocked {
                            unlockedContent
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Deploy USDC")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.ColorPalette.primary)
                }
            }
        }
        .sheet(isPresented: $showConfirmModal) {
            confirmModal
        }
        .overlay(
            Group {
                if showSuccessToast {
                    successToast
                }
            },
            alignment: .top
        )
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("USDC Challenge")
                        .font(Theme.Typography.heading2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    if !isUnlocked {
                        Text("Join the $50 Challenge to unlock yield.")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    } else {
                        Text("Deploy your USDC to earn yield")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: isUnlocked ? "checkmark.circle.fill" : "lock.circle.fill")
                    .font(.title2)
                    .foregroundColor(isUnlocked ? Theme.ColorPalette.successGreen : Theme.ColorPalette.textSecondary)
            }

            if !isUnlocked {
                Button(action: joinChallenge) {
                    HStack {
                        Text("Join for $50")
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)

                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.ColorPalette.primary)
                    .cornerRadius(Theme.Radius.sm)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private var statusBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Theme.ColorPalette.successGreen)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text("Challenge Completed")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Text("You've successfully joined the $50 USDC Challenge")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(Theme.ColorPalette.successGreen.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .stroke(Theme.ColorPalette.successGreen.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var unlockedContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Amount Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                HStack {
                    TextField("0.00", text: $amount)
                        .font(Theme.Typography.heading3)
                        .fontWeight(.semibold)
                        .keyboardType(.decimalPad)

                    Text("USDC")
                        .font(Theme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                .stroke(Theme.ColorPalette.border, lineWidth: 1)
                        )
                )

                HStack {
                    Text("Minimum: $10 USDC")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Spacer()

                    Text("Available: $1,234.56")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }

            // Strategy Selection
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose Strategy")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                VStack(spacing: 8) {
                    ForEach(strategies, id: \.id) { strategy in
                        strategyCardView(strategy)
                    }
                }
            }

            // Deploy Button
            Button(action: deployFunds) {
                Text("Deploy USDC")
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                            .fill(isValidAmount ? Theme.ColorPalette.primary : Theme.ColorPalette.textSecondary)
                    )
            }
            .disabled(!isValidAmount)
        }
    }

    private func strategyCardView(_ strategy: StrategyCard) -> some View {
        Button(action: { selectedStrategy = strategy.id }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(strategy.name)
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)

                        Spacer()

                        Text(strategy.yield)
                            .font(Theme.Typography.body)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.ColorPalette.successGreen)
                    }

                    HStack {
                        Text(strategy.description)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)

                        Spacer()

                        Text(strategy.risk + " Risk")
                            .font(Theme.Typography.captionS)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(riskColor(strategy.risk).opacity(0.1))
                            )
                            .foregroundColor(riskColor(strategy.risk))
                    }
                }

                Image(systemName: selectedStrategy == strategy.id ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedStrategy == strategy.id ? Theme.ColorPalette.primary : Theme.ColorPalette.textSecondary)
                    .font(.title3)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.sm)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                            .stroke(selectedStrategy == strategy.id ? Theme.ColorPalette.primary : Theme.ColorPalette.border, lineWidth: selectedStrategy == strategy.id ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var confirmModal: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Theme.ColorPalette.primary)

                    VStack(spacing: 8) {
                        Text("Join USDC Challenge")
                            .font(Theme.Typography.heading2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)

                        Text("Stake $50 USDC to unlock yield strategies")
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()

                VStack(spacing: 12) {
                    Button(action: confirmJoin) {
                        Text("Confirm & Join")
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.ColorPalette.primary)
                            .cornerRadius(Theme.Radius.sm)
                    }

                    Button("Cancel") {
                        showConfirmModal = false
                    }
                    .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    private var successToast: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Theme.ColorPalette.successGreen)
                .font(.title3)

            Text("Challenge joined.")
                .font(Theme.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(Theme.ColorPalette.textPrimary)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding()
        .transition(.move(edge: .top).combined(with: .opacity))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showSuccessToast = false
                }
            }
        }
    }

    private var isValidAmount: Bool {
        guard let amountValue = Double(amount) else { return false }
        return amountValue >= 10 && amountValue <= 1234.56
    }

    private func riskColor(_ risk: String) -> Color {
        switch risk.lowercased() {
        case "low": return Theme.ColorPalette.successGreen
        case "medium": return Theme.ColorPalette.warningYellow
        case "high": return Theme.ColorPalette.dangerRed
        default: return Theme.ColorPalette.textSecondary
        }
    }

    private func joinChallenge() {
        showConfirmModal = true
    }

    private func confirmJoin() {
        showConfirmModal = false
        withAnimation {
            challengeCompleted = true
            isUnlocked = true
            showSuccessToast = true
        }
    }

    private func deployFunds() {
        // Deploy funds logic
    }
}

struct StrategyCard {
    let id: Int
    let name: String
    let yield: String
    let risk: String
    let description: String
}

struct LeagueJoinView: View {
    let league: SponsoredLeague
    @Environment(\.dismiss) private var dismiss
    @State private var joinAmount = ""
    @State private var showSuccessAlert = false
    @State private var showInsufficientFundsAlert = false
    @StateObject private var balanceManager = BalanceManager.shared

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

                            Text(challengeDescription)
                                .font(Theme.Typography.body)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Challenge Details
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Challenge Details")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            VStack(spacing: 8) {
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
                                        Text(participantCount)
                                            .font(.headline)
                                            .foregroundColor(Theme.ColorPalette.textPrimary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Ends In")
                                            .font(.caption)
                                            .foregroundColor(Theme.ColorPalette.textSecondary)
                                        Text(endsIn)
                                            .font(.headline)
                                            .foregroundColor(Theme.ColorPalette.textPrimary)
                                    }
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

                            // Top 3 competitors with icons
                            HStack(spacing: 20) {
                                ForEach(Array(league.participants.prefix(3).enumerated()), id: \.element.id) { index, player in
                                    VStack(spacing: 8) {
                                        // Avatar with rank border
                                        ZStack {
                                            Circle()
                                                .stroke(
                                                    index == 0 ? Color.yellow :
                                                    index == 1 ? Color.gray :
                                                    Color(red: 0.8, green: 0.5, blue: 0.2),
                                                    lineWidth: 3
                                                )
                                                .frame(width: 56, height: 56)

                                            AvatarView(avatarURL: player.avatar, size: 50)
                                        }

                                        // Name
                                        Text(player.username)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(Theme.ColorPalette.textPrimary)

                                        // Profit
                                        Text("+$\(Int(player.profit))")
                                            .font(.caption2)
                                            .foregroundColor(Theme.ColorPalette.successGreen)

                                        // Rank badge
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                index == 0 ? Color.yellow :
                                                index == 1 ? Color.gray :
                                                Color(red: 0.8, green: 0.5, blue: 0.2)
                                            )
                                            .clipShape(Circle())
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 12)
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Join button
                        Button("Join with $\(Int(league.entryFee))") {
                            joinLeague()
                            dismiss()
                        }
                        .font(Theme.Typography.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.md)
                        .background(Theme.ColorPalette.orangeLight)
                        .cornerRadius(Theme.Radius.sm)
                        .disabled(balanceManager.currentBalance < league.entryFee)
                        .padding(.horizontal)
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
        .alert("League Joined!", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("You have successfully joined the league. Check your portfolio for updated balance.")
        }
        .alert("Insufficient Funds", isPresented: $showInsufficientFundsAlert) {
            Button("OK") { }
        } message: {
            Text("You don't have enough balance to join this league.")
        }
    }

    private var challengeDescription: String {
        switch league.id {
        case "circle":
            return "Compete on stablecoin capital efficiency: earn the highest risk-adjusted yield from USDC across approved venues."
        case "ekiden":
            return "Trade spot & perps on Ekiden (Aptos). Highest net PnL with prudent leverage wins."
        case "hyperion":
            return "Hybrid orderbook/AMM sprint: maximize volume-weighted PnL on approved pairs."
        case "kanalabs":
            return "Execute cross-DEX routes via Kana Labs; score = (net PnL + routing efficiency bonus)."
        case "kofi":
            return "Stake on Aptos via Kofi. Highest net staking APY captured (slashing-adjusted) wins."
        case "merkle":
            return "Perps tournament: best risk-adjusted PnL with capped leverage tiers."
        case "nodit":
            return "Infra power-user run: deploy to supported dApps; score blends uptime of positions + realized yield."
        case "panora":
            return "Trade via Panora aggregator; maximize slippage-adjusted PnL across routed swaps."
        case "tapp":
            return "Provide liquidity and trade on Tapp. Score = LP fees + trading PnL – IL penalty."
        default:
            return "Compete with traders worldwide in this sponsored challenge."
        }
    }

    private var participantCount: String {
        switch league.id {
        case "circle": return "5"
        case "ekiden": return "18"
        case "hyperion": return "22"
        case "kanalabs": return "31"
        case "kofi": return "40"
        case "merkle": return "27"
        case "nodit": return "36"
        case "panora": return "29"
        case "tapp": return "33"
        default: return "\(league.participants.count)"
        }
    }

    private var endsIn: String {
        switch league.id {
        case "circle": return "4 days, 23 hr"
        case "ekiden": return "6 days, 5 hr"
        case "hyperion": return "3 days, 14 hr"
        case "kanalabs": return "2 days, 19 hr"
        case "kofi": return "5 days, 2 hr"
        case "merkle": return "1 day, 20 hr"
        case "nodit": return "6 days, 12 hr"
        case "panora": return "4 days, 1 hr"
        case "tapp": return "3 days, 9 hr"
        default: return league.endDate.timeIntervalSinceNow > 0 ? "\(Int(league.endDate.timeIntervalSinceNow / 86400)) days" : "0 days"
        }
    }

    private func joinLeague() {
        let entryAmount = 50.0 // Fixed $50 entry as requested

        if balanceManager.deductBalance(amount: entryAmount, type: .league) {
            showSuccessAlert = true
        } else {
            showInsufficientFundsAlert = true
        }
    }
}

#Preview {
    LeagueView()
}