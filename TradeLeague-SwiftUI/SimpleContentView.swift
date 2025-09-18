import SwiftUI

struct SimpleContentView: View {
    @State private var selectedTab = 0

    // Strava Orange Color #FC5200
    let stravaOrange = Color(red: 0.988, green: 0.322, blue: 0.0)

    var body: some View {
        TabView(selection: $selectedTab) {
            SimpleLeagueView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("League")
                }
                .tag(0)

            SimpleTradeView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Trade")
                }
                .tag(1)

            SimplePredictView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Predict")
                }
                .tag(2)

            SimpleProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("You")
                }
                .tag(3)
        }
        .accentColor(stravaOrange)
    }
}

struct SimpleLeagueView: View {
    let stravaOrange = Color(red: 0.988, green: 0.322, blue: 0.0)

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Leagues")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)

                                Text("Compete in sponsored leagues")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button(action: {}) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(stravaOrange)
                            }
                        }
                        .padding(.horizontal)

                        // League Cards
                        VStack(spacing: 16) {
                            LeagueCard(
                                title: "Circle USDC Challenge",
                                sponsor: "Circle",
                                prizePool: 10000,
                                entryFee: 100,
                                participants: "45/100",
                                stravaOrange: stravaOrange
                            )

                            LeagueCard(
                                title: "Hyperion Liquidity Masters",
                                sponsor: "Hyperion",
                                prizePool: 5000,
                                entryFee: 50,
                                participants: "23/50",
                                stravaOrange: stravaOrange
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

struct LeagueCard: View {
    let title: String
    let sponsor: String
    let prizePool: Int
    let entryFee: Int
    let participants: String
    let stravaOrange: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🏆 \(sponsor)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(stravaOrange)

                Spacer()
            }

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)

            HStack {
                VStack(alignment: .leading) {
                    Text("Prize Pool")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\(prizePool)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Entry Fee")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$\(entryFee)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }

            HStack {
                Text("\(participants) players")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button("Join League") {
                    // Join action
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        colors: [stravaOrange, stravaOrange.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct SimpleTradeView: View {
    let stravaOrange = Color(red: 0.988, green: 0.322, blue: 0.0)

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    Text("Trade")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Follow top trading vaults")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 80))
                        .foregroundColor(stravaOrange)

                    Text("Trading features coming soon!")
                        .font(.headline)
                        .foregroundColor(.black)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct SimplePredictView: View {
    let stravaOrange = Color(red: 0.988, green: 0.322, blue: 0.0)

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    Text("Predict")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Predict market outcomes")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundColor(stravaOrange)

                    Text("Prediction markets coming soon!")
                        .font(.headline)
                        .foregroundColor(.black)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct SimpleProfileView: View {
    let stravaOrange = Color(red: 0.988, green: 0.322, blue: 0.0)

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("You")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    // Profile Card
                    VStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [stravaOrange, stravaOrange.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("C")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )

                        Text("CryptoTrader")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text("Rank #7")
                            .font(.subheadline)
                            .foregroundColor(stravaOrange)

                        HStack(spacing: 40) {
                            VStack {
                                Text("$12,500")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("Portfolio")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            VStack {
                                Text("+25.0%")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Text("All Time")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    SimpleContentView()
}