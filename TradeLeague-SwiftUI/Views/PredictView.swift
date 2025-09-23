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

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                                Text("Predict")
                                    .font(Theme.Typography.heading1)
                                    .foregroundColor(Theme.ColorPalette.textPrimary)

                                Text("Predict market outcomes")
                                    .font(Theme.Typography.caption)
                                    .foregroundColor(Theme.ColorPalette.textSecondary)
                            }
                            .sharpPageTransition()

                            Spacer()
                        }

                        // Segment control
                        Picker("View", selection: $selectedSegment) {
                            Text("Markets").tag(0)
                            Text("My Predictions").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
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
            PredictionMarket(
                id: "1",
                sponsor: "Panora",
                sponsorLogo: "panora-logo",
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
                category: .price
            ),
            PredictionMarket(
                id: "2",
                sponsor: "Merkle Trade",
                sponsorLogo: "merkle-logo",
                question: "Which protocol will have highest TVL this month?",
                outcomes: [
                    PredictionOutcome(index: 0, label: "Pancake", probability: 0.4, totalStaked: 8000, color: "6C5CE7"),
                    PredictionOutcome(index: 1, label: "Thala", probability: 0.35, totalStaked: 7000, color: "74B9FF"),
                    PredictionOutcome(index: 2, label: "Liquidswap", probability: 0.25, totalStaked: 5000, color: "FDCB6E")
                ],
                totalStaked: 20000,
                resolutionTime: Calendar.current.date(byAdding: .day, value: 15, to: Date()) ?? Date(),
                resolved: false,
                winningOutcome: nil,
                marketType: .multiple,
                category: .volume
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
        PressableCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
                        HStack {
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
                        MetricNumber(value: Int(market.totalStaked))
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
            .glassCard()
        }
        .onTapGesture(perform: onTap)
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
        }
    }

    var body: some View {
        Text(category.rawValue)
            .font(Theme.Typography.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
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
        .background(Theme.ColorPalette.surface)
        .cornerRadius(16)
    }
}

struct PredictionMarketDetailView: View {
    let market: PredictionMarket
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOutcome: Int?
    @State private var stakeAmount = ""

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ColorPalette.darkBackground
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
                        .background(Theme.ColorPalette.surface)
                        .cornerRadius(16)

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

                                Button {
                                    // Make prediction action
                                } label: {
                                    Text("Place Prediction")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Theme.ColorPalette.primaryBlue)
                                        .cornerRadius(12)
                                }
                                .disabled(stakeAmount.isEmpty || selectedOutcome == nil)
                            }
                            .padding()
                            .background(Theme.ColorPalette.surface)
                            .cornerRadius(16)
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