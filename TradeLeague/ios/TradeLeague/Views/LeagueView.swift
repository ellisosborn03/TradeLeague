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
                                Text("Compete")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)

                                Text("Join sponsored challenges and compete")
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
                participants: [
                    LeagueParticipant(
                        id: "p1",
                        userId: "u1",
                        user: User(
                            id: "u1",
                            walletAddress: "0x123",
                            username: "CryptoMaster",
                            avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
                            totalVolume: 50000,
                            inviteCode: "MASTER",
                            createdAt: Date(),
                            currentScore: 15000,
                            rank: 1
                        ),
                        joinedAt: Date(),
                        currentScore: 15000,
                        rank: 1,
                        percentageGain: 12.5
                    ),
                    LeagueParticipant(
                        id: "p2",
                        userId: "u2",
                        user: User(
                            id: "u2",
                            walletAddress: "0x456",
                            username: "TradeWizard",
                            avatar: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
                            totalVolume: 35000,
                            inviteCode: "WIZARD",
                            createdAt: Date(),
                            currentScore: 12000,
                            rank: 2
                        ),
                        joinedAt: Date(),
                        currentScore: 12000,
                        rank: 2,
                        percentageGain: 8.3
                    ),
                    LeagueParticipant(
                        id: "p3",
                        userId: "u3",
                        user: User(
                            id: "u3",
                            walletAddress: "0x789",
                            username: "AptosGuru",
                            avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
                            totalVolume: 28000,
                            inviteCode: "GURU",
                            createdAt: Date(),
                            currentScore: 10500,
                            rank: 3
                        ),
                        joinedAt: Date(),
                        currentScore: 10500,
                        rank: 3,
                        percentageGain: 5.2
                    )
                ],
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
                participants: [
                    LeagueParticipant(
                        id: "p1",
                        userId: "u1",
                        user: User(
                            id: "u1",
                            walletAddress: "0x123",
                            username: "CryptoMaster",
                            avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
                            totalVolume: 50000,
                            inviteCode: "MASTER",
                            createdAt: Date(),
                            currentScore: 15000,
                            rank: 1
                        ),
                        joinedAt: Date(),
                        currentScore: 15000,
                        rank: 1,
                        percentageGain: 12.5
                    ),
                    LeagueParticipant(
                        id: "p2",
                        userId: "u2",
                        user: User(
                            id: "u2",
                            walletAddress: "0x456",
                            username: "TradeWizard",
                            avatar: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
                            totalVolume: 35000,
                            inviteCode: "WIZARD",
                            createdAt: Date(),
                            currentScore: 12000,
                            rank: 2
                        ),
                        joinedAt: Date(),
                        currentScore: 12000,
                        rank: 2,
                        percentageGain: 8.3
                    ),
                    LeagueParticipant(
                        id: "p3",
                        userId: "u3",
                        user: User(
                            id: "u3",
                            walletAddress: "0x789",
                            username: "AptosGuru",
                            avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
                            totalVolume: 28000,
                            inviteCode: "GURU",
                            createdAt: Date(),
                            currentScore: 10500,
                            rank: 3
                        ),
                        joinedAt: Date(),
                        currentScore: 10500,
                        rank: 3,
                        percentageGain: 5.2
                    )
                ],
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
                if let logoName = league.sponsorLogo {
                    Image(logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                } else {
                    Circle()
                        .fill(Color.primaryBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("🏆")
                                .font(.title2)
                        )
                }

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
    @StateObject private var transactionManager = TransactionManager.shared
    @State private var isJoining = false
    @State private var errorMessage: String?

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
                            Task {
                                await joinLeague()
                            }
                        } label: {
                            HStack {
                                if isJoining {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Join League - $\(Int(league.entryFee))")
                                        .font(.headline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isJoining ? Color.gray : Color.primaryBlue)
                            .cornerRadius(12)
                        }
                        .disabled(isJoining)

                        if let error = errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.dangerRed)
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

    private func joinLeague() async {
        isJoining = true
        errorMessage = nil

        do {
            // Execute real transaction on Aptos testnet
            _ = try await transactionManager.addAndExecuteTransaction(
                type: .follow,
                amount: league.entryFee,
                description: "Joined league: \(league.name)"
            )

            // Close the detail view after successful join
            await MainActor.run {
                dismiss()
            }
        } catch {
            errorMessage = "Failed to join league: \(error.localizedDescription)"
        }

        isJoining = false
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

            // User avatar
            Group {
                if let avatarURL = participant.user.avatar, !avatarURL.isEmpty {
                    AsyncImage(url: URL(string: avatarURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.5)
                            )
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.primaryBlue.opacity(0.7))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(participant.user.username.prefix(1)).uppercased())
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }

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