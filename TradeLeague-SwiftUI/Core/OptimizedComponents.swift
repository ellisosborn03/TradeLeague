import SwiftUI

// MARK: - Enhanced Primary Button with Gradient + Glow
struct OptimizedPrimaryButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.Typography.button)
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(
                    LinearGradient(
                        colors: [
                            Theme.ColorPalette.orangeLight,
                            Theme.ColorPalette.primary,
                            Theme.ColorPalette.orangeDark
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                )
                .shadow(
                    color: isPressed ? Theme.ColorPalette.shadowGlowPressed : Theme.ColorPalette.shadowGlow,
                    radius: isPressed ? 20 : 12,
                    x: 0,
                    y: 8
                )
                .scaleEffect(isPressed ? 0.98 : (isHovered ? 1.02 : 1.0))
                .animation(
                    isPressed ? Theme.Animation.pressIn : Theme.Animation.hoverIn,
                    value: isPressed
                )
                .animation(Theme.Animation.hoverOut, value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }) {}
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Count-Up Text Animation
struct CountUpText: View {
    let target: Double
    let formatter: NumberFormatter?
    @State private var value: Double = 0

    init(target: Double, formatter: NumberFormatter? = nil) {
        self.target = target
        self.formatter = formatter
    }

    var body: some View {
        Text(formattedValue)
            .font(Theme.Typography.displayM)
            .fontWeight(.bold)
            .tracking(-1.0) // Apply tight tracking
            .onAppear {
                withAnimation(Theme.Animation.countUp) {
                    value = target
                }
            }
    }

    private var formattedValue: String {
        if let formatter = formatter {
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
        return value.formatted(.number.precision(.fractionLength(1)))
    }
}

// MARK: - Reveal on Scroll Animation
struct RevealModifier: ViewModifier {
    @State private var visible = false
    let delay: Double

    init(delay: Double = 0) {
        self.delay = delay
    }

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 12)
            .animation(
                Theme.Animation.reveal.delay(delay),
                value: visible
            )
            .onAppear {
                visible = true
            }
    }
}

extension View {
    func reveal(delay: Double = 0) -> some View {
        self.modifier(RevealModifier(delay: delay))
    }
}

// MARK: - Enhanced Chip Component
struct OptimizedChip: View {
    let text: String
    let style: ChipStyle
    @State private var isPressed = false

    enum ChipStyle {
        case primary, secondary, outline

        var backgroundColor: Color {
            switch self {
            case .primary: return Theme.ColorPalette.primary
            case .secondary: return Theme.ColorPalette.surface
            case .outline: return Color.clear
            }
        }

        var textColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return Theme.ColorPalette.textPrimary
            case .outline: return Theme.ColorPalette.primary
            }
        }

        var borderColor: Color {
            switch self {
            case .primary: return Color.clear
            case .secondary: return Theme.ColorPalette.border
            case .outline: return Theme.ColorPalette.primary
            }
        }
    }

    var body: some View {
        Text(text)
            .font(Theme.Typography.chip)
            .foregroundColor(style.textColor)
            .padding(.vertical, Theme.Spacing.chipVerticalS)
            .padding(.horizontal, Theme.Spacing.chipHorizontalS)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.full)
                    .stroke(style.borderColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.full))
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(Theme.Animation.pressIn, value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                isPressed = pressing
            }) {}
    }
}

// MARK: - Hero Particle Effects
struct HeroParticles: View {
    let particleCount: Int
    @State private var time: TimeInterval = 0

    init(particleCount: Int = 60) {
        self.particleCount = particleCount
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let currentTime = timeline.date.timeIntervalSinceReferenceDate

            Canvas { context, size in
                for i in 0..<particleCount {
                    let baseIndex = Double(i)
                    let phase = baseIndex / Double(particleCount) * 2 * .pi

                    // Slow movement with slight drift
                    let x = (sin(currentTime * 0.03 + phase) * 0.5 + 0.5) * size.width
                    let y = (cos(currentTime * 0.02 + phase + 1.5) * 0.5 + 0.5) * size.height

                    // Particle size variation
                    let particleSize: CGFloat = CGFloat.random(in: 1...3)

                    // Sparkle effect (1 in 20 particles)
                    let isSparkle = Int.random(in: 0...19) == 0
                    let opacity = isSparkle ? 0.35 : CGFloat.random(in: 0.10...0.18)

                    let rect = CGRect(
                        x: x - particleSize/2,
                        y: y - particleSize/2,
                        width: particleSize,
                        height: particleSize
                    )

                    context.opacity = opacity
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(Theme.ColorPalette.primary)
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Enhanced Glass Card with Optimized Shadows
struct OptimizedGlassCard: ViewModifier {
    let isActive: Bool
    let style: CardStyle

    enum CardStyle {
        case glass, elevated, flat
    }

    init(isActive: Bool = false, style: CardStyle = .glass) {
        self.isActive = isActive
        self.style = style
    }

    func body(content: Content) -> some View {
        content
            .background(backgroundView)
            .overlay(overlayView)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            .shadow(color: Theme.ColorPalette.shadowAmbient, radius: 1, x: 0, y: 1)
            .shadow(color: Theme.ColorPalette.shadowKey, radius: 12, x: 0, y: 8)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .glass:
            Theme.ColorPalette.glassSurface
                .background(.ultraThinMaterial)
        case .elevated:
            Color.white
        case .flat:
            Theme.ColorPalette.surface
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        RoundedRectangle(cornerRadius: Theme.Radius.md)
            .stroke(
                isActive ? Theme.ColorPalette.primary : Theme.ColorPalette.border,
                lineWidth: isActive ? 2 : 1
            )
    }
}

extension View {
    func optimizedGlassCard(isActive: Bool = false, style: OptimizedGlassCard.CardStyle = .glass) -> some View {
        self.modifier(OptimizedGlassCard(isActive: isActive, style: style))
    }
}

// MARK: - Stat Display Component
struct StatDisplay: View {
    let title: String
    let value: String
    let subtitle: String?
    let trend: TrendDirection?

    enum TrendDirection {
        case up, down, neutral

        var color: Color {
            switch self {
            case .up: return Theme.ColorPalette.successGreen
            case .down: return Theme.ColorPalette.dangerRed
            case .neutral: return Theme.ColorPalette.textSecondary
            }
        }

        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.ColorPalette.textSecondary)
                .padding(.bottom, Theme.Spacing.headingMargin)

            HStack(alignment: .firstTextBaseline, spacing: Theme.Spacing.xs) {
                Text(value)
                    .font(Theme.Typography.displayS)
                    .foregroundColor(Theme.ColorPalette.textPrimary)

                if let trend = trend {
                    HStack(spacing: 4) {
                        Image(systemName: trend.icon)
                            .font(.caption)

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(Theme.Typography.captionS)
                        }
                    }
                    .foregroundColor(trend.color)
                }
            }
        }
        .reveal()
    }
}

// MARK: - Enhanced Pressable Card
struct OptimizedPressableCard<Content: View>: View {
    @GestureState private var isPressed = false
    @State private var isHovered = false
    let content: () -> Content
    let action: (() -> Void)?

    init(action: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: action ?? {}) {
            content()
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : (isHovered ? 1.01 : 1.0))
        .animation(Theme.Animation.pressIn, value: isPressed)
        .animation(Theme.Animation.hoverIn, value: isHovered)
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in
                    state = true
                }
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}