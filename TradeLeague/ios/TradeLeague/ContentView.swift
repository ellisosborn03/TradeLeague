import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LeagueView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Compete")
                }

            TradeView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Trade")
                }

            PredictView()
                .tabItem {
                    Image(systemName: "crystal.ball")
                    Text("Predict")
                }

            AptosTestView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Aptos")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("You")
                }
        }
        .accentColor(Color.primaryBlue)
        .background(Color.darkBackground)
    }
}

#Preview {
    ContentView()
}