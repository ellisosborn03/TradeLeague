import SwiftUI

struct LeagueView: View {
    @State private var selectedScope: LeagueScope = .global
    @State private var sponsoredLeagues: [SponsoredLeague] = []
    @State private var expandedLeagues: Set<String> = []
    @State private var friendsLeaderboard: [LeaguePlayer] = []

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Header with animated transition
                        VStack(spacing: Theme.Spacing.md) {
                            HStack {
                                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                    Text("Leagues")
                                        .font(Theme.Typography.heading1)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                        .sharpPageTransition()

                                    Text("Compete in sponsored challenges")
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)

                            // Scope Toggle with orange theme
                            HStack(spacing: 0) {
                                Button(action: {
                                    withAnimation(Theme.Animation.fast) {
                                        selectedScope = .global
                                    }
                                }) {
                                    Text("GLOBAL")
                                        .font(Theme.Typography.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedScope == .global ? .white : Theme.ColorPalette.textSecondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, Theme.Spacing.sm)
                                        .background(
                                            selectedScope == .global ?
                                            AnyShapeStyle(Theme.ColorPalette.gradientPrimary) :
                                            AnyShapeStyle(Color.clear)
                                        )
                                }

                                Button(action: {
                                    withAnimation(Theme.Animation.fast) {
                                        selectedScope = .local
                                    }
                                }) {
                                    Text("FRIENDS")
                                        .font(Theme.Typography.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedScope == .local ? .white : Theme.ColorPalette.textSecondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, Theme.Spacing.sm)
                                        .background(
                                            selectedScope == .local ?
                                            AnyShapeStyle(Theme.ColorPalette.gradientPrimary) :
                                            AnyShapeStyle(Color.clear)
                                        )
                                }
                            }
                            .background(Theme.ColorPalette.surface)
                            .cornerRadius(Theme.Radius.full)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.full)
                                    .stroke(
                                        selectedScope == .local ?
                                        Theme.ColorPalette.primary :
                                        Theme.ColorPalette.divider,
                                        lineWidth: selectedScope == .local ? 2 : 1
                                    )
                                    .shadow(
                                        color: selectedScope == .local ?
                                        Theme.ColorPalette.primary.opacity(0.3) :
                                        Color.clear,
                                        radius: 4
                                    )
                            )
                            .padding(.horizontal)
                        }

                        // Content based on selected scope
                        if selectedScope == .global {
                            GlobalLeaguesView(
                                sponsoredLeagues: sponsoredLeagues,
                                expandedLeagues: $expandedLeagues
                            )
                        } else {
                            FriendsLeaderboardView(players: friendsLeaderboard)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .onAppear {
                loadData()
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
                    LeaguePlayer(id: "1", username: "Alex Chen", avatar: "👨🏻‍💼", profit: 2847.23, rank: 1),
                    LeaguePlayer(id: "2", username: "Sarah Kim", avatar: "👩🏻‍💻", profit: 1923.45, rank: 2),
                    LeaguePlayer(id: "3", username: "Marcus Johnson", avatar: "👨🏿‍🚀", profit: 1456.78, rank: 3),
                    LeaguePlayer(id: "4", username: "Elena Rodriguez", avatar: "👩🏽‍🔬", profit: -234.56, rank: 4),
                    LeaguePlayer(id: "5", username: "David Park", avatar: "👨🏻‍🎨", profit: -567.89, rank: 5)
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
                    LeaguePlayer(id: "6", username: "Rachel Wong", avatar: "👩🏻‍⚕️", profit: 3245.67, rank: 1),
                    LeaguePlayer(id: "7", username: "James Miller", avatar: "👨🏼‍🏫", profit: 2134.89, rank: 2),
                    LeaguePlayer(id: "8", username: "Priya Sharma", avatar: "👩🏽‍💼", profit: 1876.34, rank: 3),
                    LeaguePlayer(id: "9", username: "Tom Anderson", avatar: "👨🏻‍🔧", profit: 987.12, rank: 4),
                    LeaguePlayer(id: "10", username: "Lisa Zhang", avatar: "👩🏻‍🎓", profit: -123.45, rank: 5)
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
                    LeaguePlayer(id: "11", username: "Kevin Liu", avatar: "👨🏻‍💻", profit: 1987.65, rank: 1),
                    LeaguePlayer(id: "12", username: "Emma Thompson", avatar: "👩🏼‍🚀", profit: 1543.21, rank: 2),
                    LeaguePlayer(id: "13", username: "Carlos Ruiz", avatar: "👨🏽‍🔬", profit: 1234.56, rank: 3),
                    LeaguePlayer(id: "14", username: "Sophie Martin", avatar: "👩🏻‍🎨", profit: 876.43, rank: 4),
                    LeaguePlayer(id: "15", username: "Michael Brown", avatar: "👨🏿‍💼", profit: -345.67, rank: 5)
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
                    LeaguePlayer(id: "16", username: "Anna Petrov", avatar: "👩🏻‍⚕️", profit: 1456.78, rank: 1),
                    LeaguePlayer(id: "17", username: "Jake Wilson", avatar: "👨🏼‍🏫", profit: 1234.56, rank: 2),
                    LeaguePlayer(id: "18", username: "Maya Patel", avatar: "👩🏽‍💻", profit: 987.65, rank: 3),
                    LeaguePlayer(id: "19", username: "Ryan O'Connor", avatar: "👨🏻‍🚀", profit: 543.21, rank: 4),
                    LeaguePlayer(id: "20", username: "Zoe Davis", avatar: "👩🏼‍🔬", profit: -234.56, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
            )
        ]
    }

    private func loadFriendsLeaderboard() {
        friendsLeaderboard = [
            LeaguePlayer(id: "f1", username: "John Smith", avatar: "👨🏻‍💼", profit: 2345.67, rank: 1),
            LeaguePlayer(id: "f2", username: "Maria Garcia", avatar: "👩🏽‍💻", profit: 1876.43, rank: 2),
            LeaguePlayer(id: "f3", username: "Chris Lee", avatar: "👨🏻‍🚀", profit: 1234.89, rank: 3),
            LeaguePlayer(id: "f4", username: "Amy Chen", avatar: "👩🏻‍🔬", profit: 987.65, rank: 4),
            LeaguePlayer(id: "f5", username: "Robert Kim", avatar: "👨🏻‍🎨", profit: 543.21, rank: 5),
            LeaguePlayer(id: "f6", username: "Lisa Wang", avatar: "👩🏻‍⚕️", profit: 234.56, rank: 6)
        ]
    }
}

struct GlobalLeaguesView: View {
    let sponsoredLeagues: [SponsoredLeague]
    @Binding var expandedLeagues: Set<String>

    var body: some View {
        LazyVStack(spacing: Theme.Spacing.md) {
            ForEach(Array(sponsoredLeagues.enumerated()), id: \.element.id) { index, league in
                SponsoredLeagueCard(
                    league: league,
                    isExpanded: expandedLeagues.contains(league.id)
                ) {
                    withAnimation(Theme.Animation.base) {
                        if expandedLeagues.contains(league.id) {
                            expandedLeagues.remove(league.id)
                        } else {
                            expandedLeagues.insert(league.id)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(Theme.Animation.base.delay(Double(index) * 0.05), value: sponsoredLeagues)
            }
        }
    }
}

struct FriendsLeaderboardView: View {
    let players: [LeaguePlayer]

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Podium for top 3
            if players.count >= 3 {
                PodiumView(topPlayers: Array(players.prefix(3)))
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
                        LeaderboardRowView(player: player, rank: index + 4)
                            .padding(.horizontal)
                            .glassCard()
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

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
            Spacer()

            // 2nd Place
            if topPlayers.count > 1 {
                PodiumPlayerView(player: topPlayers[1], rank: 2, height: 80)
            }

            // 1st Place (tallest)
            if topPlayers.count > 0 {
                PodiumPlayerView(player: topPlayers[0], rank: 1, height: 100)
            }

            // 3rd Place
            if topPlayers.count > 2 {
                PodiumPlayerView(player: topPlayers[2], rank: 3, height: 60)
            }

            Spacer()
        }
        .padding()
        .glassCard()
    }
}

struct PodiumPlayerView: View {
    let player: LeaguePlayer
    let rank: Int
    let height: CGFloat

    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            // Avatar
            Text(player.avatar)
                .font(.system(size: 32))
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Theme.ColorPalette.surface)
                        .overlay(
                            Circle()
                                .stroke(rankColor, lineWidth: 2)
                        )
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
    let onToggle: () -> Void

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
                        Text("$\(Int(league.prizePool))")
                            .font(Theme.Typography.body)
                            .fontWeight(.bold)
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
                .glassCard(isActive: isExpanded)
            }
            .buttonStyle(PlainButtonStyle())

            // Expandable Content
            if isExpanded {
                VStack(spacing: Theme.Spacing.sm) {
                    // Top 3 Podium
                    if league.participants.count >= 3 {
                        PodiumView(topPlayers: Array(league.participants.prefix(3)))
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
                                LeaderboardRowView(player: player, rank: index + 4)
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

                        PrimaryButton(title: "Join League") {
                            // Join league action
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

            Text(logoText)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(logoTextColor)
        }
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

    private var logoTextColor: Color {
        return .white
    }

    private var logoText: String {
        switch company {
        case "circle": return "C"
        case "hyperion": return "H"
        case "merkle": return "M"
        case "tapp": return "T"
        default: return "?"
        }
    }
}

struct LeaderboardRowView: View {
    let player: LeaguePlayer
    let rank: Int

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            // Rank
            Text("\(rank)")
                .font(Theme.Typography.body)
                .fontWeight(.medium)
                .foregroundColor(Theme.ColorPalette.textPrimary)
                .frame(width: 24)

            // Avatar
            Text(player.avatar)
                .font(.title3)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Theme.ColorPalette.surface)
                )

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
        }
        .padding(.vertical, Theme.Spacing.xs)
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

#Preview {
    LeagueView()
}