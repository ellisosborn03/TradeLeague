import SwiftUI

struct PredictView: View {
    @State private var markets: [PredictionMarket] = []
    @State private var selectedMarket: PredictionMarket?
    @State private var userPredictions: [UserPrediction] = []
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.background
                    .ignoresSafeArea()

                // Particle background
                HeroParticles(particleCount: 25)
                    .opacity(0.3)

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                Text("Predict")
                                    .font(Theme.Typography.displayM)
                                    .fontWeight(.bold)
                                    .tracking(-1.0)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)
                                    .reveal(delay: 0.1)

                                HStack(spacing: 8) {
                                    Text("Powered by Panama Predictions")
                                        .font(Theme.Typography.bodyS)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                        .reveal(delay: 0.2)

                                    SponsorLogoView.small("Panama Predictions")
                                        .reveal(delay: 0.3)
                                }
                            }

                            Spacer()
                        }

                        // Segment control
                        CustomSegmentToggle(
                            options: [0, 1],
                            optionLabels: [0: "MARKETS", 1: "MY PREDICTIONS"],
                            selection: $selectedSegment
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    // Content based on selected segment
                    if selectedSegment == 0 {
                        MarketsView(markets: markets) { market in
                            selectedMarket = market
                        }
                    } else {
                        MyPredictionsView(predictions: userPredictions)
                    }

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
                loadMarkets()
                loadUserPredictions()
            }
            .sheet(item: $selectedMarket) { market in
                PredictionMarketDetailView(market: market)
            }
        }
    }

    private func loadMarkets() {
        // Mock data - replace with actual API call
        markets = [
            // APT first as requested
            PredictionMarket(
                id: "3",
                sponsor: "Aptos",
                sponsorLogo: "aptos-logo",
                question: "Will APT price reach $15 by end of week?",
                outcomes: [
                    PredictionOutcome(index: 0, label: "Yes", probability: 0.65, totalStaked: 12500, color: "00B894"),
                    PredictionOutcome(index: 1, label: "No", probability: 0.35, totalStaked: 6750, color: "FF6B6B")
                ],
                totalStaked: 19250,
                resolutionTime: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date(),
                resolved: false,
                winningOutcome: nil,
                marketType: .binary,
                category: .crypto
            ),
            PredictionMarket(
                id: "1",
                sponsor: "Politics",
                sponsorLogo: "presidential-logo",
                question: "Next US Presidential Election Winner?",
                outcomes: [
                    PredictionOutcome(index: 0, label: "J.D. Vance", probability: 0.31, totalStaked: 775000, color: "DC2626"),
                    PredictionOutcome(index: 1, label: "Gavin Newsom", probability: 0.22, totalStaked: 550000, color: "2563EB"),
                    PredictionOutcome(index: 2, label: "Other", probability: 0.47, totalStaked: 1175000, color: "6B7280")
                ],
                totalStaked: 2500000,
                resolutionTime: Calendar.current.date(byAdding: .year, value: 3, to: Date()) ?? Date(),
                resolved: false,
                winningOutcome: nil,
                marketType: .multiple,
                category: .politics
            ),
            PredictionMarket(
                id: "2",
                sponsor: "Sports",
                sponsorLogo: "sports-logo",
                question: "Pro Football Champion?",
                outcomes: [
                    PredictionOutcome(index: 0, label: "Buffalo", probability: 0.19, totalStaked: 2900000, color: "0066CC"),
                    PredictionOutcome(index: 1, label: "Baltimore", probability: 0.15, totalStaked: 2289000, color: "241773"),
                    PredictionOutcome(index: 2, label: "Other", probability: 0.66, totalStaked: 10093000, color: "6B7280")
                ],
                totalStaked: 15282000,
                resolutionTime: Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date(),
                resolved: false,
                winningOutcome: nil,
                marketType: .multiple,
                category: .sports
            )
        ]
    }

    private func loadUserPredictions() {
        // Mock data - replace with actual API call
        userPredictions = []
    }
}

struct MarketsView: View {
    let markets: [PredictionMarket]
    let onMarketTap: (PredictionMarket) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.sm) {
                ForEach(Array(markets.enumerated()), id: \.element.id) { index, market in
                    PredictionMarketCard(market: market) {
                        onMarketTap(market)
                    }
                    .padding(.horizontal)
                    .animation(Theme.Animation.base.delay(Double(index) * 0.03), value: markets)
                }
            }
            .padding(.vertical)
        }
    }
}

struct MyPredictionsView: View {
    let predictions: [UserPrediction]

    var body: some View {
        if predictions.isEmpty {
            VStack(spacing: Theme.Spacing.md) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.ColorPalette.primary.opacity(0.5))

                Text("No Predictions Yet")
                    .font(Theme.Typography.heading2)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                Text("Make your first prediction on market outcomes to start earning")
                    .font(Theme.Typography.body)
                    .foregroundColor(Theme.ColorPalette.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(predictions) { prediction in
                        PredictionCard(prediction: prediction)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct PredictionMarketCard: View {
    let market: PredictionMarket
    let onTap: () -> Void

    var body: some View {
        OptimizedPressableCard(action: onTap) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        HStack {
                            SponsorLogoView.small(market.sponsor)
                            
                            Text(market.sponsor)
                                .font(Theme.Typography.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.ColorPalette.primary)

                            Spacer()

                            CategoryBadge(category: market.category)
                        }

                        Text(market.question)
                            .font(Theme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                            .multilineTextAlignment(.leading)
                    }
                }

                // Outcomes
                VStack(spacing: Theme.Spacing.xs) {
                    ForEach(market.outcomes) { outcome in
                        OutcomeRow(outcome: outcome, totalStaked: market.totalStaked)
                    }
                }

                Divider()
                    .background(Theme.ColorPalette.divider)

                // Footer
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        Text("Total Pool")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        CountUpText(target: market.totalStaked, fontSize: Theme.Typography.body)
                            .foregroundColor(Theme.ColorPalette.textPrimary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: Theme.Spacing.xxs) {
                        Text("Resolves")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text(market.resolutionTime, style: .relative)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary.opacity(0.7))
                    }
                }
            }
            .padding(Theme.Spacing.md)
            .optimizedGlassCard(style: .glass)
        }
    }
}

struct OutcomeRow: View {
    let outcome: PredictionOutcome
    let totalStaked: Double

    var body: some View {
        HStack {
            Text(outcome.label)
                .font(.subheadline)
                .foregroundColor(Theme.ColorPalette.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                Text("\(outcome.probability * 100, specifier: "%.0f")%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                // Probability bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Theme.ColorPalette.divider)
                            .frame(height: 4)

                        Rectangle()
                            .fill(Color(hex: outcome.color))
                            .frame(width: geometry.size.width * outcome.probability, height: 4)
                    }
                }
                .frame(width: 60, height: 4)
            }
        }
    }
}

struct CategoryBadge: View {
    let category: PredictionCategory

    var badgeColor: Color {
        switch category {
        case .price:
            return Theme.ColorPalette.success
        case .volume:
            return Theme.ColorPalette.primary
        case .crossChain:
            return Theme.ColorPalette.secondary
        case .derivatives:
            return Theme.ColorPalette.primary.opacity(0.8)
        case .crypto:
            return Theme.ColorPalette.primaryBlue
        case .politics:
            return Theme.ColorPalette.dangerRed
        case .sports:
            return Theme.ColorPalette.successGreen
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            // Add logo for politics and sports
            if category == .politics {
                Image("president-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
            } else if category == .sports {
                Image("football-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
            }

            Text(category.rawValue)
                .font(Theme.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, Theme.Spacing.xs)
        .padding(.vertical, Theme.Spacing.xxs)
        .background(badgeColor)
        .cornerRadius(Theme.Radius.sm)
    }
}

struct PredictionCard: View {
    let prediction: UserPrediction

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(prediction.market.sponsor)
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.primaryBlue)

                    Text(prediction.market.question)
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .lineLimit(2)
                }

                Spacer()

                if prediction.settled {
                    Text(prediction.won == true ? "WON" : "LOST")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(prediction.won == true ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((prediction.won == true ? Theme.ColorPalette.successGreen : Theme.ColorPalette.dangerRed).opacity(0.2))
                        .cornerRadius(8)
                } else {
                    Text("PENDING")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.ColorPalette.warningYellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.ColorPalette.warningYellow.opacity(0.2))
                        .cornerRadius(8)
                }
            }

            HStack {
                let selectedOutcome = prediction.market.outcomes[prediction.outcomeIndex]
                Text("Predicted: \(selectedOutcome.label)")
                    .font(.subheadline)
                    .foregroundColor(Theme.ColorPalette.textSecondary)

                Spacer()
            }

            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Staked")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    Text("$\(Int(prediction.stake))")
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }

                VStack(alignment: .leading) {
                    Text("Potential Payout")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                    Text("$\(Int(prediction.potentialPayout))")
                        .font(.headline)
                        .foregroundColor(Theme.ColorPalette.successGreen)
                }

                if !prediction.settled {
                    VStack(alignment: .leading) {
                        Text("Resolves")
                            .font(.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                        Text(prediction.market.resolutionTime, style: .relative)
                            .font(.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                    }
                }
            }
        }
        .padding()
        .optimizedGlassCard(style: .elevated)
        .reveal(delay: 0.3)
    }
}

struct PredictionMarketDetailView: View {
    let market: PredictionMarket
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOutcome: Int?
    @State private var stakeAmount = ""
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
                                Text(market.sponsor)
                                    .font(.subheadline)
                                    .foregroundColor(Theme.ColorPalette.primaryBlue)

                                Spacer()

                                CategoryBadge(category: market.category)
                            }

                            Text(market.question)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total Pool")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text("$\(Int(market.totalStaked))")
                                        .font(.headline)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("Resolves")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Text(market.resolutionTime, style: .relative)
                                        .font(.headline)
                                        .foregroundColor(Theme.ColorPalette.textPrimary)
                                }
                            }
                        }
                        .padding()
                        .optimizedGlassCard(style: .elevated)

                        // Outcomes
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Outcomes")
                                .font(.headline)
                                .foregroundColor(Theme.ColorPalette.textPrimary)

                            ForEach(market.outcomes) { outcome in
                                OutcomeDetailCard(
                                    outcome: outcome,
                                    totalStaked: market.totalStaked,
                                    isSelected: selectedOutcome == outcome.index
                                ) {
                                    selectedOutcome = outcome.index
                                }
                            }
                        }

                        // Prediction section
                        if let selectedIndex = selectedOutcome {
                            let outcome = market.outcomes[selectedIndex]
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Make Prediction")
                                    .font(.headline)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)

                                Text("Predicting: \(outcome.label)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.ColorPalette.primaryBlue)

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Stake Amount")
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    TextField("Enter amount in USDC", text: $stakeAmount)
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

                                if let stake = Double(stakeAmount), stake > 0 {
                                    let payout = stake / outcome.probability
                                    HStack {
                                        Text("Potential Payout:")
                                            .foregroundColor(Theme.ColorPalette.textSecondary)
                                        Spacer()
                                        Text("$\(payout, specifier: "%.2f")")
                                            .fontWeight(.bold)
                                            .foregroundColor(Theme.ColorPalette.successGreen)
                                    }
                                }

                                HStack {
                                    Text("Available: $\(balanceManager.currentBalance, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(Theme.ColorPalette.textSecondary)
                                    Spacer()
                                }

                                OptimizedPrimaryButton(title: "Predict") {
                                    placePrediction()
                                    dismiss()
                                }
                                .disabled(stakeAmount.isEmpty || selectedOutcome == nil || !isValidStake)
                            }
                            .padding()
                            .optimizedGlassCard(style: .elevated)
                        }
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
        .alert("Prediction Placed!", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your prediction has been placed successfully. Check your portfolio for updated balance.")
        }
        .alert("Insufficient Funds", isPresented: $showInsufficientFundsAlert) {
            Button("OK") { }
        } message: {
            Text("You don't have enough balance to place this prediction.")
        }
    }

    private var isValidStake: Bool {
        guard let stake = Double(stakeAmount) else { return false }
        return stake > 0 && stake <= balanceManager.currentBalance
    }

    private func placePrediction() {
        guard let stake = Double(stakeAmount),
              let selectedIndex = selectedOutcome,
              stake > 0 else { return }

        if balanceManager.deductBalance(amount: stake, type: .prediction) {
            showSuccessAlert = true
        } else {
            showInsufficientFundsAlert = true
        }
    }
}

struct OutcomeDetailCard: View {
    let outcome: PredictionOutcome
    let totalStaked: Double
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(outcome.label)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("$\(Int(outcome.totalStaked)) staked")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(outcome.probability * 100, specifier: "%.0f")%")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: outcome.color))

                    Text("probability")
                        .font(.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }
            .padding()
            .background(isSelected ? Theme.ColorPalette.primaryBlue.opacity(0.1) : Theme.ColorPalette.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.ColorPalette.primaryBlue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PredictView()
}