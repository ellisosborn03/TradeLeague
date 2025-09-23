import SwiftUI

struct LeagueView: View {
    @State private var selectedLeague: League?
    @State private var leagues: [League] = []
    @State private var showCreateLeague = false

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: Theme.Spacing.md) {
                        // Header with create button
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                Text("Leagues")
                                    .font(Theme.Typography.heading1)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)

                                Text("Compete in sponsored leagues")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                            }

                            Spacer()

                            Button {
                                showCreateLeague = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Theme.ColorPalette.primary)
                            }
                        }
                        .padding(.horizontal)
                        .sharpPageTransition()

                        // Featured League (if any)
                        if let featuredLeague = leagues.first {
                            FeaturedLeagueCard(league: featuredLeague)
                                .padding(.horizontal)
                        }

                        // Active Leagues
                        LazyVStack(spacing: Theme.Spacing.sm) {
                            ForEach(Array(leagues.enumerated()), id: \.element.id) { index, league in
                                LeagueCard(league: league) {
                                    selectedLeague = league
                                }
                                .padding(.horizontal)
                                .animation(Theme.Animation.base.delay(Double(index) * 0.03), value: leagues)
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
        PressableCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Text("🏆 Featured")
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.secondary)

                    Spacer()

                    if let sponsor = league.sponsorName {
                        Text(sponsor)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                }

                Text(league.name)
                    .font(Theme.Typography.heading2)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        Text("Prize Pool")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        MetricNumber(value: Int(league.prizePool))
                            .foregroundColor(Theme.ColorPalette.success)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: Theme.Spacing.xxs) {
                        Text("Entry Fee")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text("$\(Int(league.entryFee))")
                            .font(Theme.Typography.mono)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                    }
                }

                PrimaryButton(title: "Join League") {
                    // Join league action
                }
            }
            .padding(Theme.Spacing.md)
            .glassCard(isActive: true)
        }
    }
}

struct LeagueCard: View {
    let league: League
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Theme.Spacing.sm) {
                // League icon or sponsor logo
                Circle()
                    .fill(Theme.ColorPalette.primary.opacity(0.15))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("🏆")
                            .font(.title2)
                    )

                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                    Text(league.name)
                        .font(Theme.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("$\(Int(league.prizePool)) pool")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.success)

                        Text("•")
                            .foregroundColor(Theme.ColorPalette.textSecondary)

                        Text("\(league.participants.count)/\(league.maxParticipants) players")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }

                    if let endTime = league.endTime {
                        Text("Ends \(endTime, style: .relative)")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary.opacity(0.7))
                    }
                }

                Spacer()

                VStack(spacing: Theme.Spacing.xxs) {
                    Text("$\(Int(league.entryFee))")
                        .font(Theme.Typography.mono)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                    Text("entry")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }
            .padding(Theme.Spacing.md)
            .glassCard()
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
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                VStack(spacing: Theme.Spacing.lg) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("Create League")
                            .font(Theme.Typography.heading1)
                            .foregroundColor(Theme.ColorPalette.textPrimary)

                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("League Name")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                            TextField("Enter league name", text: $leagueName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        HStack(spacing: Theme.Spacing.md) {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                Text("Entry Fee")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                TextField("$0", text: $entryFee)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    #if os(iOS)
                                    .keyboardType(.decimalPad)
                                    #endif
                            }

                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                Text("Prize Pool")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                TextField("$0", text: $prizePool)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    #if os(iOS)
                                    .keyboardType(.decimalPad)
                                    #endif
                            }
                        }

                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Max Participants")
                                .font(Theme.Typography.caption)
                                .foregroundColor(Theme.ColorPalette.textSecondary)
                            TextField("100", text: $maxParticipants)
                                .textFieldStyle(CustomTextFieldStyle())
                                #if os(iOS)
                                .keyboardType(.numberPad)
                                #endif
                        }

                        Toggle("Public League", isOn: $isPublic)
                            .font(Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                    }

                    Spacer()

                    PrimaryButton(title: "Create League") {
                        dismiss()
                    }
                    .disabled(leagueName.isEmpty)
                }
                .padding()
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.ColorPalette.primary)
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.ColorPalette.primary)
                }
                #endif
            }
        }
    }
}

struct LeagueDetailView: View {
    let league: League
    @Environment(\.dismiss) private var dismiss
    @State private var currentRanks: [Int] = []

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            if let sponsor = league.sponsorName {
                                Text(sponsor)
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.primary)
                            }

                            Text(league.name)
                                .font(Theme.Typography.heading1)
                                .foregroundColor(Theme.ColorPalette.textPrimary)
                                .sharpPageTransition()

                            HStack(spacing: Theme.Spacing.lg) {
                                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                    Text("Prize Pool")
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    MetricNumber(value: Int(league.prizePool))
                                        .foregroundColor(Theme.ColorPalette.success)
                                }

                                VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                    Text("Entry Fee")
                                        .font(Theme.Typography.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text("$\(Int(league.entryFee))")
                                        .font(Theme.Typography.heading2)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                }
                            }
                        }
                        .padding(Theme.Spacing.md)
                        .glassCard()

                        // Leaderboard
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Leaderboard")
                                .font(Theme.Typography.heading2)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            if league.participants.isEmpty {
                                Text("No participants yet")
                                    .font(Theme.Typography.body)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                                    .padding()
                            } else {
                                ForEach(Array(league.participants.enumerated()), id: \.element.id) { index, participant in
                                    LeaderboardRow(participant: participant, rank: index + 1)
                                        .animation(Theme.Animation.base.delay(Double(index) * 0.03), value: league.participants)
                                }
                            }
                        }
                        .padding(Theme.Spacing.md)
                        .glassCard()

                        // Join button
                        PrimaryButton(title: "Join League - $\(Int(league.entryFee))") {
                            // Join league action
                        }
                    }
                    .padding()
                }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.ColorPalette.primary)
                }
                #else
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.ColorPalette.primary)
                }
                #endif
            }
        }
    }
}

struct LeaderboardRow: View {
    let participant: LeagueParticipant
    let rank: Int

    var body: some View {
        HStack {
            // Rank
            RankView(rank: rank, isUp: participant.percentageGain >= 0)
                .frame(width: 60)

            // User info
            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                Text(participant.user.username)
                    .font(Theme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.ColorPalette.textPrimary)
                Text("$\(Int(participant.currentScore))")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }

            Spacer()

            // Performance
            VStack(alignment: .trailing, spacing: Theme.Spacing.xxs) {
                Text("\(participant.percentageGain >= 0 ? "+" : "")\(participant.percentageGain, specifier: "%.1f")%")
                    .font(Theme.Typography.mono)
                    .fontWeight(.bold)
                    .foregroundColor(participant.percentageGain >= 0 ? Theme.ColorPalette.success : Theme.ColorPalette.error)
                Text("gain")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
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
    }
}

#Preview {
    LeagueView()
}