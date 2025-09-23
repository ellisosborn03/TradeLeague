import SwiftUI

struct LeagueView: View {
    @State private var selectedScope: LeagueScope = .global
    @State private var sponsoredLeagues: [SponsoredLeague] = []
    @State private var expandedLeagues: Set<String> = []

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 16) {
                            Text("LEAGUES")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)

                            // Scope Toggle
                            HStack(spacing: 0) {
                                Button(action: { selectedScope = .global }) {
                                    Text("GLOBAL")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedScope == .global ? .white : .gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedScope == .global ? Color.black : Color.clear
                                        )
                                }

                                Button(action: { selectedScope = .local }) {
                                    Text("LOCAL")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedScope == .local ? .white : .gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedScope == .local ? Color.black : Color.clear
                                        )
                                }
                            }
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }

                        // Sponsored Leagues
                        LazyVStack(spacing: 12) {
                            ForEach(sponsoredLeagues) { league in
                                SponsoredLeagueCard(
                                    league: league,
                                    isExpanded: expandedLeagues.contains(league.id)
                                ) {
                                    toggleLeague(league.id)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .onAppear {
                loadSponsoredLeagues()
            }
        }
    }

    private func toggleLeague(_ leagueId: String) {
        if expandedLeagues.contains(leagueId) {
            expandedLeagues.remove(leagueId)
        } else {
            expandedLeagues.insert(leagueId)
        }
    }

    private func loadSponsoredLeagues() {
        // Mock sponsored leagues with realistic data
        sponsoredLeagues = [
            SponsoredLeague(
                id: "circle",
                sponsorName: "Circle",
                sponsorLogo: "🔵",
                leagueName: "USDC Challenge",
                prizePool: 10000,
                entryFee: 100,
                participants: [
                    LeaguePlayer(id: "1", username: "CIRCLE_KING", avatar: "👑", profit: 2847.23, rank: 1),
                    LeaguePlayer(id: "2", username: "STABLECOIN_PRO", avatar: "🏆", profit: 1923.45, rank: 2),
                    LeaguePlayer(id: "3", username: "DEFI_MASTER", avatar: "💎", profit: 1456.78, rank: 3),
                    LeaguePlayer(id: "4", username: "YIELD_HUNTER", avatar: "🎯", profit: -234.56, rank: 4),
                    LeaguePlayer(id: "5", username: "RISK_TAKER", avatar: "⚡", profit: -567.89, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
            ),
            SponsoredLeague(
                id: "hyperion",
                sponsorName: "Hyperion",
                sponsorLogo: "⚡",
                leagueName: "Lightning Liquidity",
                prizePool: 7500,
                entryFee: 75,
                participants: [
                    LeaguePlayer(id: "6", username: "LIGHTNING_FAST", avatar: "⚡", profit: 3245.67, rank: 1),
                    LeaguePlayer(id: "7", username: "SPEED_DEMON", avatar: "👹", profit: 2134.89, rank: 2),
                    LeaguePlayer(id: "8", username: "QUICK_SILVER", avatar: "🥈", profit: 1876.34, rank: 3),
                    LeaguePlayer(id: "9", username: "FLASH_TRADER", avatar: "💫", profit: 987.12, rank: 4),
                    LeaguePlayer(id: "10", username: "TURBO_MODE", avatar: "🚀", profit: -123.45, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
            ),
            SponsoredLeague(
                id: "merkle",
                sponsorName: "Merkle Trade",
                sponsorLogo: "🌲",
                leagueName: "Derivatives Derby",
                prizePool: 5000,
                entryFee: 50,
                participants: [
                    LeaguePlayer(id: "11", username: "MERKLE_MAGICIAN", avatar: "🧙", profit: 1987.65, rank: 1),
                    LeaguePlayer(id: "12", username: "TREE_CLIMBER", avatar: "🐒", profit: 1543.21, rank: 2),
                    LeaguePlayer(id: "13", username: "BRANCH_MASTER", avatar: "🌿", profit: 1234.56, rank: 3),
                    LeaguePlayer(id: "14", username: "LEAF_BLOWER", avatar: "🍃", profit: 876.43, rank: 4),
                    LeaguePlayer(id: "15", username: "ROOT_ACCESS", avatar: "🔓", profit: -345.67, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
            ),
            SponsoredLeague(
                id: "tapp",
                sponsorName: "Tapp Network",
                sponsorLogo: "📱",
                leagueName: "Mobile Masters",
                prizePool: 3000,
                entryFee: 25,
                participants: [
                    LeaguePlayer(id: "16", username: "TAP_KING", avatar: "👑", profit: 1456.78, rank: 1),
                    LeaguePlayer(id: "17", username: "MOBILE_MAVEN", avatar: "📱", profit: 1234.56, rank: 2),
                    LeaguePlayer(id: "18", username: "APP_MASTER", avatar: "🏅", profit: 987.65, rank: 3),
                    LeaguePlayer(id: "19", username: "TOUCH_TRADER", avatar: "👆", profit: 543.21, rank: 4),
                    LeaguePlayer(id: "20", username: "SWIPE_SNIPER", avatar: "🎯", profit: -234.56, rank: 5)
                ],
                isExpanded: false,
                endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
            )
        ]
    }
}

struct SponsoredLeagueCard: View {
    let league: SponsoredLeague
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // League Header (always visible)
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    // Sponsor Logo
                    Text(league.sponsorLogo)
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(league.sponsorName)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(league.leagueName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(Int(league.prizePool))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Prize Pool")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())

            // Expandable Leaderboard
            if isExpanded {
                VStack(spacing: 8) {
                    // Header
                    HStack {
                        Text("PLAYER")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("PROFIT/LOSS")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Players
                    ForEach(league.participants) { player in
                        HStack(spacing: 12) {
                            // Rank
                            Text("\(player.rank)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(width: 20)

                            // Avatar
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(player.avatar)
                                        .font(.title3)
                                )

                            // Username
                            Text(player.username)
                                .font(.subheadline)
                                .foregroundColor(.black)

                            Spacer()

                            // Profit/Loss
                            Text("\(player.profit >= 0 ? "+" : "")$\(player.profit, specifier: "%.0f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(player.profit >= 0 ? .green : .red)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }

                    // League Info
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Entry Fee: $\(Int(league.entryFee))")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Ends in \(timeUntilEnd(league.endDate))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Button("Join League") {
                            // Join league action
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .cornerRadius(20)
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.top, 4)
            }
        }
    }

    private func timeUntilEnd(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        return "\(days) days"
    }
}

#Preview {
    LeagueView()
}