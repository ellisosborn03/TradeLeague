import SwiftUI
import UIKit

struct PageTransition: ViewModifier {
    @State private var appear = false

    func body(content: Content) -> some View {
        content
            .opacity(appear ? 1 : 0)
            .offset(x: appear ? 0 : 12, y: 0)
            .animation(.spring(duration: 0.24, bounce: 0.18), value: appear)
            .onAppear { appear = true }
    }
}

struct PressableCard<Content: View>: View {
    @GestureState private var isPressed = false
    let content: () -> Content

    var body: some View {
        content()
            .scaleEffect(isPressed ? 0.98 : 1)
            .shadow(color: isPressed ? Theme.ColorPalette.primary.opacity(0.2) : Color.black.opacity(0.1),
                    radius: isPressed ? 8 : 4,
                    x: 0,
                    y: isPressed ? 4 : 2)
            .animation(.spring(duration: 0.12, bounce: 0), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
            )
    }
}

struct GlassCard: ViewModifier {
    var isActive: Bool = false

    func body(content: Content) -> some View {
        content
            .background(
                Theme.ColorPalette.glassSurface
                    .background(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .stroke(isActive ? Theme.ColorPalette.primary : Theme.ColorPalette.glassBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            .shadow(color: isActive ? Theme.ColorPalette.primary.opacity(0.2) : Color.black.opacity(0.05),
                    radius: isActive ? 12 : 6,
                    x: 0,
                    y: 4)
    }
}

struct RankView: View {
    @State var rank: Int
    @State private var tilt = false
    var isUp: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            Text("#\(rank)")
                .font(Theme.Typography.mono)
                .fontWeight(.bold)
                .rotation3DEffect(.degrees(tilt ? 0 : 8),
                                  axis: (x: 0, y: 1, z: 0))
                .animation(.spring(duration: 0.16, bounce: 0), value: tilt)

            Image(systemName: isUp ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .foregroundColor(isUp ? Theme.ColorPalette.success : Theme.ColorPalette.error)
                .font(.system(size: 10))
                .scaleEffect(tilt ? 1.0 : 0.8)
                .animation(.spring(duration: 0.14, bounce: 0.1), value: tilt)
        }
        .onChange(of: rank) { _ in
            tilt.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { tilt.toggle() }
        }
    }
}

struct MetricNumber: View {
    let value: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(String(value)), id: \.self) { ch in
                Text(String(ch))
                    .font(Theme.Typography.mono)
                    .fontWeight(.bold)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .animation(.spring(duration: 0.12, bounce: 0.05), value: value)
            }
        }
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    @State private var success = false
    @State private var isHovered = false

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()

            withAnimation(Theme.Animation.pressIn) {
                success = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                success = false
            }
        }) {
            Text(title)
                .font(Theme.Typography.button)
                .foregroundColor(.white)
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.vertical, Theme.Spacing.md)
                .frame(maxWidth: .infinity)
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
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                .scaleEffect(isPressed ? 0.98 : (success ? 1.04 : (isHovered ? 1.02 : 1.0)))
                .shadow(
                    color: success ? Theme.ColorPalette.shadowGlowPressed : Theme.ColorPalette.shadowGlow,
                    radius: success ? 20 : (isHovered ? 16 : 8),
                    x: 0,
                    y: success ? 8 : 4
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity,
                            pressing: { pressing in
                                withAnimation(pressing ? Theme.Animation.pressIn : Theme.Animation.pressOut) {
                                    isPressed = pressing
                                }
                            },
                            perform: {})
        .onHover { hovering in
            withAnimation(hovering ? Theme.Animation.hoverIn : Theme.Animation.hoverOut) {
                isHovered = hovering
            }
        }
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var isAnimating = false
    let colors = [
        Color.gray.opacity(0.2),
        Theme.ColorPalette.primary.opacity(0.1),
        Color.gray.opacity(0.2)
    ]

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(colors: colors,
                               startPoint: .leading,
                               endPoint: .trailing)
                    .rotationEffect(.degrees(15))
                    .offset(x: isAnimating ? 400 : -400)
                    .animation(.linear(duration: 0.9).repeatForever(autoreverses: false),
                               value: isAnimating)
            )
            .clipped()
            .onAppear {
                isAnimating = true
            }
    }
}

struct SponsorLogoView: View {
    let sponsorName: String
    let size: CGSize
    
    init(sponsorName: String, size: CGSize = CGSize(width: 24, height: 24)) {
        self.sponsorName = sponsorName
        self.size = size
    }
    
    var body: some View {
        Group {
            if let logoName = localImageName {
                // Use local asset image if available
                Image(logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: size.width * 0.1))
            } else {
                // Fallback to branded circular icon
                ZStack {
                    Circle()
                        .fill(logoBackgroundColor)
                        .frame(width: size.width, height: size.height)
                    
                    Image(systemName: logoIcon)
                        .font(.system(size: size.width * 0.5, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var localImageName: String? {
        switch sponsorName.lowercased() {
        case "hyperion":
            return "hyperion-logo"
        case "merkle", "merkle trade":
            return "merkle-logo"
        case "tapp", "tapp exchange", "tapp network":
            return "tapp-logo"
        case "panora":
            return "panora-logo"
        case "circle":
            return "circle-logo"
        case "kana", "kana labs":
            return "kana-logo"
        case "nodit":
            return "nodit-logo"
        case "ekiden":
            return "ekiden-logo"
        case "aptos":
            return "aptos-logo"
        case "panama predictions":
            return "panama-logo"
        case "politics", "presidential":
            return "presidential-logo"
        case "sports":
            return "sports-logo"
        default:
            return nil
        }
    }
    
    private var logoBackgroundColor: Color {
        switch sponsorName.lowercased() {
        case "circle":
            return Color(hex: "007AFF") // USDC Blue
        case "hyperion":
            return Color(hex: "6366F1") // Hyperion Purple
        case "merkle", "merkle trade":
            return Color(hex: "10B981") // Merkle Green
        case "tapp", "tapp exchange", "tapp network":
            return Color(hex: "F59E0B") // Tapp Orange
        case "panora":
            return Color(hex: "8B5CF6") // Panora Purple
        case "kana", "kana labs":
            return Color(hex: "06B6D4") // Kana Cyan
        case "nodit":
            return Color(hex: "374151") // Nodit Gray
        case "ekiden":
            return Color(hex: "DC2626") // Ekiden Red
        case "aptos":
            return Color(hex: "000000") // Aptos Black
        case "panama predictions":
            return Color(hex: "3B82F6") // Panama Blue
        case "politics", "presidential":
            return Color(hex: "DC2626") // Political Red
        case "sports":
            return Color(hex: "059669") // Sports Green
        default:
            return Theme.ColorPalette.primary
        }
    }
    
    private var logoIcon: String {
        switch sponsorName.lowercased() {
        case "circle":
            return "dollarsign.circle.fill"
        case "hyperion":
            return "chart.line.uptrend.xyaxis"
        case "merkle", "merkle trade":
            return "chart.bar.xaxis"
        case "tapp", "tapp exchange", "tapp network":
            return "link.circle.fill"
        case "panora":
            return "chart.xyaxis.line"
        case "kana", "kana labs":
            return "arrow.triangle.swap"
        case "nodit":
            return "server.rack"
        case "ekiden":
            return "function"
        case "aptos":
            return "hexagon.fill"
        case "panama predictions":
            return "chart.line.uptrend.xyaxis"
        case "politics", "presidential":
            return "person.3.fill"
        case "sports":
            return "sportscourt.fill"
        default:
            return "building.2.crop.circle"
        }
    }
}

// Extension to make it easier to use in other views
extension SponsorLogoView {
    static func small(_ sponsorName: String) -> SponsorLogoView {
        SponsorLogoView(sponsorName: sponsorName, size: CGSize(width: 16, height: 16))
    }
    
    static func medium(_ sponsorName: String) -> SponsorLogoView {
        SponsorLogoView(sponsorName: sponsorName, size: CGSize(width: 24, height: 24))
    }
    
    static func large(_ sponsorName: String) -> SponsorLogoView {
        SponsorLogoView(sponsorName: sponsorName, size: CGSize(width: 32, height: 32))
    }
    
    static func xlarge(_ sponsorName: String) -> SponsorLogoView {
        SponsorLogoView(sponsorName: sponsorName, size: CGSize(width: 48, height: 48))
    }
}

extension View {
    func sharpPageTransition() -> some View {
        modifier(PageTransition())
    }

    func glassCard(isActive: Bool = false) -> some View {
        modifier(GlassCard(isActive: isActive))
    }

    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

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
    let fontSize: Font
    @State private var value: Double = 0

    init(target: Double, formatter: NumberFormatter? = nil, fontSize: Font = Theme.Typography.heading2) {
        self.target = target
        self.formatter = formatter
        self.fontSize = fontSize
    }

    var body: some View {
        Text(formattedValue)
            .font(fontSize)
            .fontWeight(.bold)
            .tracking(-0.5)
            .onAppear {
                // Removed animation - show value immediately
                value = target
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

// MARK: - Custom Segment Toggle
struct CustomSegmentToggle<T: Hashable>: View {
    let options: [T]
    let optionLabels: [T: String]
    @Binding var selection: T

    init(options: [T], optionLabels: [T: String], selection: Binding<T>) {
        self.options = options
        self.optionLabels = optionLabels
        self._selection = selection
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.element) { index, option in
                Button(action: {
                    withAnimation(Theme.Animation.fast) {
                        selection = option
                    }
                }) {
                    Text(optionLabels[option] ?? "")
                        .font(Theme.Typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(selection == option ? .white : Theme.ColorPalette.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            selection == option ?
                            AnyShapeStyle(Theme.ColorPalette.gradientPrimary) :
                            AnyShapeStyle(Color.clear)
                        )
                }
            }
        }
        .background(Theme.ColorPalette.surface)
        .cornerRadius(Theme.Radius.full)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.full)
                .stroke(
                    Theme.ColorPalette.primary,
                    lineWidth: 2
                )
                .shadow(
                    color: Theme.ColorPalette.primary.opacity(0.3),
                    radius: 4
                )
        )
    }
}

// MARK: - Additional View Extensions
extension View {
    func reveal(delay: Double = 0) -> some View {
        self.modifier(RevealModifier(delay: delay))
    }

    func optimizedGlassCard(isActive: Bool = false, style: OptimizedGlassCard.CardStyle = .glass) -> some View {
        self.modifier(OptimizedGlassCard(isActive: isActive, style: style))
    }
}