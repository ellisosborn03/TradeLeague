import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                LeagueView()
                    .tag(0)

                TradeView()
                    .tag(1)

                PredictView()
                    .tag(2)

                ProfileView()
                    .tag(3)
            }

            // Custom Tab Bar
            HStack(spacing: 0) {
                TabBarItem(icon: "trophy.fill", title: "League", isSelected: selectedTab == 0)
                    .onTapGesture { withAnimation(Theme.Animation.fast) { selectedTab = 0 } }

                TabBarItem(icon: "plus.circle.fill", title: "Follow", isSelected: selectedTab == 1)
                    .onTapGesture { withAnimation(Theme.Animation.fast) { selectedTab = 1 } }

                TabBarItem(icon: "sparkles", title: "Predict", isSelected: selectedTab == 2)
                    .onTapGesture { withAnimation(Theme.Animation.fast) { selectedTab = 2 } }

                TabBarItem(icon: "person.circle.fill", title: "You", isSelected: selectedTab == 3)
                    .onTapGesture { withAnimation(Theme.Animation.fast) { selectedTab = 3 } }
            }
            .padding(.horizontal, Theme.Spacing.xs)
            .padding(.vertical, Theme.Spacing.sm)
            .background(
                Theme.ColorPalette.glassSurface
                    .background(.ultraThinMaterial)
                    .overlay(
                        Rectangle()
                            .fill(Theme.ColorPalette.divider)
                            .frame(height: 0.5),
                        alignment: .top
                    )
            )
        }
        .background(Theme.ColorPalette.background)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: Theme.Spacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .scaleEffect(isSelected ? 1.1 : 1.0)

            Text(title)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundColor(isSelected ? Theme.ColorPalette.primary : Theme.ColorPalette.textSecondary)
        .frame(maxWidth: .infinity)
        .animation(Theme.Animation.xfast, value: isSelected)
    }
}

#Preview {
    ContentView()
}