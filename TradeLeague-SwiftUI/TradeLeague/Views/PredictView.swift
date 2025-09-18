import SwiftUI

struct PredictView: View {
    @State private var markets: [PredictionMarket] = []
    @State private var selectedMarket: PredictionMarket?
    @State private var userPredictions: [UserPrediction] = []
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Predict")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)

                                Text("Predict market outcomes")
                                    .font(.subheadline)
                                    .foregroundColor(.secondaryText)
                            }

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
            LazyVStack(spacing: 12) {
                ForEach(markets) { market in
                    PredictionMarketCard(market: market) {
                        onMarketTap(market)
                    }
                    .padding(.horizontal)
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
            VStack(spacing: 16) {
                Image(systemName: "crystal.ball")
                    .font(.system(size: 60))
                    .foregroundColor(.secondaryText)

                Text("No Predictions Yet")
                    .font(.headline)
                    .foregroundColor(.primaryText)

                Text("Make your first prediction on market outcomes to start earning")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
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
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(market.sponsor)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryBlue)

                            Spacer()

                            CategoryBadge(category: market.category)
                        }

                        Text(market.question)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primaryText)
                            .multilineTextAlignment(.leading)
                    }
                }

                // Outcomes
                VStack(spacing: 8) {
                    ForEach(market.outcomes) { outcome in
                        OutcomeRow(outcome: outcome, totalStaked: market.totalStaked)
                    }
                }

                Divider()
                    .background(Color.borderColor)

                // Footer
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Pool")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                        Text("$\(Int(market.totalStaked))")
                            .font(.headline)
                            .foregroundColor(.primaryText)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("Resolves")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                        Text(market.resolutionTime, style: .relative)
                            .font(.caption)
                            .foregroundColor(.tertiaryText)
                    }
                }
            }
            .padding()
            .background(Color.surfaceColor)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OutcomeRow: View {
    let outcome: PredictionOutcome
    let totalStaked: Double

    var body: some View {
        HStack {
            Text(outcome.label)
                .font(.subheadline)
                .foregroundColor(.primaryText)

            Spacer()

            HStack(spacing: 8) {
                Text("\(outcome.probability * 100, specifier: "%.0f")%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primaryText)

                // Probability bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.borderColor)
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
            return .successGreen
        case .volume:
            return .primaryBlue
        case .crossChain:
            return .warningYellow
        case .derivatives:
            return .chartPurple
        }
    }

    var body: some View {
        Text(category.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor)
            .cornerRadius(8)
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
                        .foregroundColor(.primaryBlue)

                    Text(prediction.market.question)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                        .lineLimit(2)
                }

                Spacer()

                if prediction.settled {
                    Text(prediction.won == true ? "WON" : "LOST")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(prediction.won == true ? .successGreen : .dangerRed)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((prediction.won == true ? Color.successGreen : Color.dangerRed).opacity(0.2))
                        .cornerRadius(8)
                } else {
                    Text("PENDING")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.warningYellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.warningYellow.opacity(0.2))
                        .cornerRadius(8)
                }
            }

            HStack {
                let selectedOutcome = prediction.market.outcomes[prediction.outcomeIndex]
                Text("Predicted: \(selectedOutcome.label)")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)

                Spacer()
            }

            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Staked")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("$\(Int(prediction.stake))")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }

                VStack(alignment: .leading) {
                    Text("Potential Payout")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                    Text("$\(Int(prediction.potentialPayout))")
                        .font(.headline)
                        .foregroundColor(.successGreen)
                }

                if !prediction.settled {
                    VStack(alignment: .leading) {
                        Text("Resolves")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                        Text(prediction.market.resolutionTime, style: .relative)
                            .font(.caption)
                            .foregroundColor(.tertiaryText)
                    }
                }
            }
        }
        .padding()
        .background(Color.surfaceColor)
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
                Color.darkBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(market.sponsor)
                                    .font(.subheadline)
                                    .foregroundColor(.primaryBlue)

                                Spacer()

                                CategoryBadge(category: market.category)
                            }

                            Text(market.question)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total Pool")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text("$\(Int(market.totalStaked))")
                                        .font(.headline)
                                        .foregroundColor(.primaryText)
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("Resolves")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                    Text(market.resolutionTime, style: .relative)
                                        .font(.headline)
                                        .foregroundColor(.primaryText)
                                }
                            }
                        }
                        .padding()
                        .background(Color.surfaceColor)
                        .cornerRadius(16)

                        // Outcomes
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Outcomes")
                                .font(.headline)
                                .foregroundColor(.primaryText)

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
                                    .foregroundColor(.primaryText)

                                Text("Predicting: \(outcome.label)")
                                    .font(.subheadline)
                                    .foregroundColor(.primaryBlue)

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Stake Amount")
                                        .foregroundColor(.secondaryText)
                                    TextField("Enter amount in USDC", text: $stakeAmount)
                                        .textFieldStyle(CustomTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }

                                if let stake = Double(stakeAmount), stake > 0 {
                                    let payout = stake / outcome.probability
                                    HStack {
                                        Text("Potential Payout:")
                                            .foregroundColor(.secondaryText)
                                        Spacer()
                                        Text("$\(payout, specifier: "%.2f")")
                                            .fontWeight(.bold)
                                            .foregroundColor(.successGreen)
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
                                        .background(Color.primaryBlue)
                                        .cornerRadius(12)
                                }
                                .disabled(stakeAmount.isEmpty || selectedOutcome == nil)
                            }
                            .padding()
                            .background(Color.surfaceColor)
                            .cornerRadius(16)
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

struct OutcomeDetailCard: View {
    let outcome: PredictionOutcome
    let totalStaked: Double
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(outcome.label)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primaryText)

                    Text("$\(Int(outcome.totalStaked)) staked")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(outcome.probability * 100, specifier: "%.0f")%")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: outcome.color))

                    Text("probability")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
            }
            .padding()
            .background(isSelected ? Color.primaryBlue.opacity(0.1) : Color.surfaceColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primaryBlue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PredictView()
}