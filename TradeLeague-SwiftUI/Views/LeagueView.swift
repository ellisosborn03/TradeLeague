import SwiftUI

struct LeagueView: View {
    @State private var selectedLeague: League?
    @State private var leagues: [League] = []
    @State private var showCreateLeague = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Header with create button
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Leagues")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)

                                Text("Compete in sponsored leagues")
                                    .font(.subheadline)
                                    .foregroundColor(.secondaryText)
                            }

                            Spacer()

                            Button {
                                showCreateLeague = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                        .padding(.horizontal)

                        // Featured League (if any)
                        if let featuredLeague = leagues.first {
                            FeaturedLeagueCard(league: featuredLeague)
                                .padding(.horizontal)
                        }

                        // Active Leagues
                        LazyVStack(spacing: 12) {
                            ForEach(leagues) { league in
                                LeagueCard(league: league) {
                                    selectedLeague = league
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .onAppear {
                loadLeagues()
            }
            .sheet(isPresented: $showCreateLeague) {
                CreateLeagueView()
            }
            .sheet(item: $selectedLeague) { league in
                LeagueDetailView(league: league)
            }
        }
    }

    private func loadLeagues() {
        // Mock data - replace with actual API call
        leagues = [
            League(
                id: "1",
                name: "Circle USDC Challenge",
                creatorId: "sponsor1",
                entryFee: 100,
                prizePool: 10000,
                startTime: Date(),
                endTime: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
                isPublic: true,
                maxParticipants: 100,
                participants: [],
                sponsorName: "Circle",
                sponsorLogo: "circle-logo"
            ),
            League(
                id: "2",
                name: "Hyperion Liquidity Masters",
                creatorId: "sponsor2",
                entryFee: 50,
                prizePool: 5000,
                startTime: Date(),
                endTime: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
                isPublic: true,
                maxParticipants: 50,
                participants: [],
                sponsorName: "Hyperion",
                sponsorLogo: "hyperion-logo"
            )
        ]
    }
}

struct FeaturedLeagueCard: View {
    let league: League

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🏆 Featured")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.warningYellow)

                Spacer()

                if let sponsor = league.sponsorName {
                    Text(sponsor)
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }

            Text(league.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)

            HStack {
                VStack(alignment: .leading) {
                    Text("Prize Pool")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("$\(Int(league.prizePool))")
                        .font(.headline)
                        .foregroundColor(.successGreen)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Entry Fee")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("$\(Int(league.entryFee))")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }
            }

            Button {
                // Join league action
            } label: {
                Text("Join League")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.primaryBlue, Color.primaryBlue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.surfaceColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

struct LeagueCard: View {
    let league: League
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // League icon or sponsor logo
                Circle()
                    .fill(Color.primaryBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("🏆")
                            .font(.title2)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(league.name)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("$\(Int(league.prizePool)) pool")
                            .font(.caption)
                            .foregroundColor(.successGreen)

                        Text("•")
                            .foregroundColor(.secondaryText)

                        Text("\(league.participants.count)/\(league.maxParticipants) players")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }

                    if let endTime = league.endTime {
                        Text("Ends \(endTime, style: .relative)")
                            .font(.caption)
                            .foregroundColor(.tertiaryText)
                    }
                }

                Spacer()

                VStack {
                    Text("$\(Int(league.entryFee))")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    Text("entry")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }
            .padding()
            .background(Color.surfaceColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CreateLeagueView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var leagueName = ""
    @State private var entryFee = ""
    @State private var prizePool = ""
    @State private var maxParticipants = ""
    @State private var isPublic = true

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Create League")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("League Name")
                                .foregroundColor(.secondaryText)
                            TextField("Enter league name", text: $leagueName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Entry Fee")
                                    .foregroundColor(.secondaryText)
                                TextField("$0", text: $entryFee)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Prize Pool")
                                    .foregroundColor(.secondaryText)
                                TextField("$0", text: $prizePool)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Max Participants")
                                .foregroundColor(.secondaryText)
                            TextField("100", text: $maxParticipants)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                        }

                        Toggle("Public League", isOn: $isPublic)
                            .foregroundColor(.primaryText)
                    }

                    Spacer()

                    Button {
                        // Create league action
                        dismiss()
                    } label: {
                        Text("Create League")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryBlue)
                            .cornerRadius(12)
                    }
                    .disabled(leagueName.isEmpty)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
            }
        }
    }
}

struct LeagueDetailView: View {
    let league: League
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 12) {
                            if let sponsor = league.sponsorName {
                                Text(sponsor)
                                    .font(.subheadline)
                                    .foregroundColor(.primaryBlue)
                            }

                            Text(league.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)

                            HStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("Prize Pool")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text("$\(Int(league.prizePool))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.successGreen)
                                }

                                VStack(alignment: .leading) {
                                    Text("Entry Fee")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text("$\(Int(league.entryFee))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primaryText)
                                }
                            }
                        }
                        .padding()
                        .background(Color.surfaceColor)
                        .cornerRadius(16)

                        // Leaderboard
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Leaderboard")
                                .font(.headline)
                                .foregroundColor(.primaryText)

                            if league.participants.isEmpty {
                                Text("No participants yet")
                                    .foregroundColor(.secondaryText)
                                    .padding()
                            } else {
                                ForEach(league.participants) { participant in
                                    LeaderboardRow(participant: participant)
                                }
                            }
                        }
                        .padding()
                        .background(Color.surfaceColor)
                        .cornerRadius(16)

                        // Join button
                        Button {
                            // Join league action
                        } label: {
                            Text("Join League - $\(Int(league.entryFee))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryBlue)
                                .cornerRadius(12)
                        }
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

struct LeaderboardRow: View {
    let participant: LeagueParticipant

    var body: some View {
        HStack {
            // Rank
            Text("#\(participant.rank)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
                .frame(width: 40)

            // User info
            VStack(alignment: .leading) {
                Text(participant.user.username)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                Text("$\(Int(participant.currentScore))")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }

            Spacer()

            // Performance
            VStack(alignment: .trailing) {
                Text("+\(participant.percentageGain, specifier: "%.1f")%")
                    .font(.headline)
                    .foregroundColor(participant.percentageGain >= 0 ? .successGreen : .dangerRed)
                Text("gain")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
        }
        .padding(.vertical, 8)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.surfaceLight)
            .cornerRadius(8)
            .foregroundColor(.primaryText)
    }
}

#Preview {
    LeagueView()
}