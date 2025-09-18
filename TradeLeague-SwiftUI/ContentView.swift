import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LeagueView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("League")
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