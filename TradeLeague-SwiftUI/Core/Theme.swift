import SwiftUI

struct Theme {
    enum ColorPalette {
        static let primary = Color(hex: "FC5200")
        static let secondary = Color(hex: "FF7A33")
        static let background = Color.white
        static let surface = Color.white.opacity(0.6)
        static let textPrimary = Color(hex: "111111")
        static let textSecondary = Color(hex: "666666")
        static let divider = Color(hex: "E0E0E0")
        static let success = Color(hex: "00C851")
        static let error = Color(hex: "FF4444")

        static let gradientPrimary = LinearGradient(
            colors: [primary, secondary],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let glassSurface = Color.white.opacity(0.5)
        static let glassBorder = Color.white.opacity(0.4)
    }

    enum Typography {
        static let heading1 = Font.system(size: 32, weight: .bold, design: .default)
        static let heading2 = Font.system(size: 24, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 14, weight: .regular, design: .default)
        static let mono = Font.system(size: 14, weight: .medium, design: .monospaced)
        static let button = Font.system(size: 16, weight: .semibold, design: .default)
    }

    enum Animation {
        static let xfast = SwiftUI.Animation.spring(response: 0.12, dampingRatio: 1.0)
        static let fast = SwiftUI.Animation.spring(response: 0.18, dampingRatio: 0.9)
        static let base = SwiftUI.Animation.spring(response: 0.24, dampingRatio: 0.82)
        static let slow = SwiftUI.Animation.spring(response: 0.32, dampingRatio: 0.78)

        static let sharpSpring = SwiftUI.Animation.spring(response: 0.42, dampingRatio: 0.82)
        static let glide = SwiftUI.Animation.spring(response: 0.30, dampingRatio: 0.78)
        static let settle = SwiftUI.Animation.spring(response: 0.22, dampingRatio: 0.90)
    }

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 999
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}