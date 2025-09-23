import SwiftUI

struct LeagueView: View {
    @State private var selectedScope: LeagueScope = .global
    @State private var topPlayers: [LeaguePlayer] = []
    @State private var leaderboard: [LeaguePlayer] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 16) {
                            Text("TOP PLAYERS")
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

                        // Top 3 Players
                        if topPlayers.count >= 3 {
                            HStack(spacing: 20) {
                                Spacer()

                                // 2nd Place
                                TopPlayerCard(player: topPlayers[1], rank: 2)

                                // 1st Place (slightly raised)
                                TopPlayerCard(player: topPlayers[0], rank: 1)
                                    .offset(y: -10)

                                // 3rd Place
                                TopPlayerCard(player: topPlayers[2], rank: 3)

                                Spacer()
                            }
                            .padding(.horizontal)
                        }

                        // Leaderboard
                        VStack(spacing: 12) {
                            HStack {
                                Text("PLAYER")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("POINTS")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)

                            ForEach(Array(leaderboard.dropFirst(3).enumerated()), id: \.element.id) { index, player in
                                LeaderboardRowView(player: player, rank: index + 4)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.vertical)
                }
            }
            .onAppear {
                loadPlayers()
            }
        }
    }

    private func loadPlayers() {
        // Mock data - replace with actual API call
        let allPlayers = [
            LeaguePlayer(id: "1", username: "BAYC_ENJOYER", avatar: "🐵", points: 74829, rank: 1),
            LeaguePlayer(id: "2", username: "ALEX34628", avatar: "👨🏿", points: 72148, rank: 2),
            LeaguePlayer(id: "3", username: "GLOBALOUDE", avatar: "👨🏻‍💻", points: 70521, rank: 3),
            LeaguePlayer(id: "4", username: "CRYPTOLEV", avatar: "🐸", points: 43824, rank: 4),
            LeaguePlayer(id: "5", username: "SAMMY_LAH", avatar: "👨🏿", points: 39824, rank: 5),
            LeaguePlayer(id: "6", username: "MR_ZERO", avatar: "👨🏼", points: 35210, rank: 6),
            LeaguePlayer(id: "7", username: "PLAYERS74", avatar: "👨🏽", points: 33091, rank: 7)
        ]

        topPlayers = Array(allPlayers.prefix(3))
        leaderboard = allPlayers
    }
}

struct TopPlayerCard: View {
    let player: LeaguePlayer
    let rank: Int

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)

                Text(player.avatar)
                    .font(.title)

                // Rank badge
                Circle()
                    .fill(rankColor)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text("\(rank)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .offset(x: 20, y: -20)
            }

            VStack(spacing: 2) {
                Text(player.username)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text("\(player.points.formatted())")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }

    private var rankColor: Color {
        switch rank {
        case 1: return Color.yellow
        case 2: return Color.gray
        case 3: return Color.orange
        default: return Color.blue
        }
    }
}

struct LeaderboardRowView: View {
    let player: LeaguePlayer
    let rank: Int

    var body: some View {
        HStack(spacing: 12) {
            // Rank number
            Text("\(rank)")
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

            // Points
            Text("\(player.points.formatted())")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LeagueView()
}