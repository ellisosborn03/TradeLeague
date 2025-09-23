import SwiftUI

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

    var body: some View {
        Button(action: {
            action()
            withAnimation(.spring(duration: 0.18, bounce: 0.4)) {
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
                .background(Theme.ColorPalette.gradientPrimary)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                .scaleEffect(isPressed ? 0.98 : (success ? 1.04 : 1.0))
                .shadow(color: Theme.ColorPalette.primary.opacity(0.3),
                        radius: success ? 16 : 8,
                        x: 0,
                        y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity,
                            pressing: { pressing in
                                withAnimation(Theme.Animation.xfast) {
                                    isPressed = pressing
                                }
                            },
                            perform: {})
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