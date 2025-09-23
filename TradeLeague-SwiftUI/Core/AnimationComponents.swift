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
            return nil // Will use fallback for now
        case "kana", "kana labs":
            return nil // Will use fallback for now
        case "nodit":
            return nil // Will use fallback for now
        case "ekiden":
            return nil // Will use fallback for now
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