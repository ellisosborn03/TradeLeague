import SwiftUI

struct LoadingScreen: View {
    @State private var isAnimating = false
    @State private var progress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            // Background with subtle gradient
            LinearGradient(
                colors: [
                    Theme.ColorPalette.background,
                    Theme.ColorPalette.surface.opacity(0.8),
                    Theme.ColorPalette.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Particle background
            HeroParticles(particleCount: 30)
                .opacity(0.6)

            VStack(spacing: Theme.Spacing.sectionGap) {
                Spacer()

                // Logo and brand section
                VStack(spacing: Theme.Spacing.lg) {
                    // Animated logo placeholder
                    ZStack {
                        Circle()
                            .stroke(
                                Theme.ColorPalette.primary.opacity(0.2),
                                lineWidth: 3
                            )
                            .frame(width: 80, height: 80)

                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                Theme.ColorPalette.gradientPrimary,
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(
                                Animation.linear(duration: 2).repeatForever(autoreverses: false),
                                value: rotationAngle
                            )

                        // Inner pulsing circle
                        Circle()
                            .fill(Theme.ColorPalette.gradientPrimary)
                            .frame(width: 40, height: 40)
                            .scaleEffect(pulseScale)
                            .animation(
                                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                value: pulseScale
                            )
                    }

                    // App name with stylized typography
                    VStack(spacing: Theme.Spacing.xs) {
                        Text("TradeLeague")
                            .font(Theme.Typography.displayL)
                            .fontWeight(.bold)
                            .tracking(-1.2) // Apply tight tracking
                            .foregroundColor(Theme.ColorPalette.primary)
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .animation(
                                Theme.Animation.reveal.delay(0.3),
                                value: isAnimating
                            )

                        Text("Powered by Aptos")
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.ColorPalette.textSecondary)
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .animation(
                                Theme.Animation.reveal.delay(0.6),
                                value: isAnimating
                            )
                    }
                }

                Spacer()

                // Loading progress section
                VStack(spacing: Theme.Spacing.md) {
                    // Progress bar
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(CustomProgressViewStyle())
                        .frame(width: 200)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(
                            Theme.Animation.reveal.delay(0.9),
                            value: isAnimating
                        )

                    // Loading text
                    Text("Loading your portfolio...")
                        .font(Theme.Typography.bodyS)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                        .opacity(isAnimating ? 0.8 : 0.0)
                        .animation(
                            Theme.Animation.reveal.delay(1.2),
                            value: isAnimating
                        )
                }
                .padding(.bottom, Theme.Spacing.sectionGap)
            }
            .padding(Theme.Spacing.xl)
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Trigger main animations
        withAnimation(.easeOut(duration: 0.5)) {
            isAnimating = true
        }

        // Start rotation
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }

        // Start pulse
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }

        // Animate progress
        withAnimation(.easeInOut(duration: 3.0)) {
            progress = 1.0
        }
    }
}

// Custom Progress View Style
struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Theme.Radius.full)
                .fill(Theme.ColorPalette.surface)
                .frame(height: 4)

            RoundedRectangle(cornerRadius: Theme.Radius.full)
                .fill(Theme.ColorPalette.gradientPrimary)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 200, height: 4)
                .animation(Theme.Animation.countUp, value: configuration.fractionCompleted)
        }
    }
}

// Accessibility helper
struct AccessibilityOptimizedView<Content: View>: View {
    let content: Content
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if reduceMotion {
            // Static version for accessibility
            content
                .animation(nil, value: UUID())
        } else {
            // Full animation version
            content
        }
    }
}

// Haptic feedback helper
struct HapticFeedback {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }

    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }

    static func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}

// Enhanced accessibility modifiers
extension View {
    func accessibilityOptimized() -> some View {
        AccessibilityOptimizedView {
            self
        }
    }

    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }

    func accessibleOrangeText(weight: Font.Weight = .semibold, size: CGFloat = 16) -> some View {
        self
            .font(.system(size: max(size, 16), weight: weight))
            .foregroundColor(size >= 16 && weight >= .semibold ? Theme.ColorPalette.orangeAccessible : Theme.ColorPalette.textPrimary)
    }
}

#Preview {
    LoadingScreen()
}