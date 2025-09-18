import SwiftUI

struct TestOrangeTheme: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Strava Orange Theme Test")
                .font(Theme.Typography.heading1)
                .foregroundColor(Theme.ColorPalette.primary)

            Text("Primary Color #FC5200")
                .font(Theme.Typography.body)
                .padding()
                .background(Theme.ColorPalette.primary)
                .foregroundColor(.white)
                .cornerRadius(8)

            PrimaryButton(title: "Orange Button") {
                print("Button tapped")
            }

            PressableCard {
                VStack {
                    Text("Glass Card")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                    Text("With blur effect")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
                .padding()
                .glassCard()
            }

            HStack(spacing: 20) {
                RankView(rank: 1, isUp: true)
                MetricNumber(value: 12345)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.ColorPalette.background)
    }
}

#Preview {
    TestOrangeTheme()
}