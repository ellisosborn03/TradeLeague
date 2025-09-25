import SwiftUI

struct Theme {
    enum ColorPalette {
        static let primary: Color = Color(hex: "FC5200")
        static let secondary: Color = Color(hex: "FF7A33")
        static let background: Color = Color.white
        static let surface: Color = Color.white.opacity(0.6)
        static let textPrimary: Color = Color(hex: "111111")
        static let textSecondary: Color = Color(hex: "666666")
        static let divider: Color = Color(hex: "E0E0E0")
        static let success: Color = Color(hex: "00C851")
        static let error: Color = Color(hex: "FF4444")

        // Additional colors for compatibility
        static let successGreen: Color = success
        static let dangerRed: Color = error
        static let primaryBlue: Color = Color(hex: "007AFF")
        static let warningYellow: Color = Color(hex: "FFCC00")
        static let chartPurple: Color = Color(hex: "AF52DE")
        static let darkBackground: Color = Color(hex: "1C1C1E")

        // Enhanced orange palette
        static let orangeLight: Color = Color(hex: "FF8A3D")
        static let orangeDark: Color = Color(hex: "FF6B00")
        static let orangeAccessible: Color = Color(hex: "EA580C")  // High contrast for text

        // Shadow colors
        static let shadowAmbient: Color = Color(red: 15/255, green: 23/255, blue: 42/255).opacity(0.06)
        static let shadowKey: Color = Color(red: 15/255, green: 23/255, blue: 42/255).opacity(0.12)
        static let shadowGlow: Color = Color(hex: "F97316").opacity(0.28)
        static let shadowGlowPressed: Color = Color(hex: "F97316").opacity(0.45)

        // Border colors
        static let border: Color = Color(red: 15/255, green: 23/255, blue: 42/255).opacity(0.08)
        static let borderFocus: Color = Color(hex: "F97316").opacity(0.18)

        static let gradientPrimary = LinearGradient(
            colors: [primary, secondary],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let glassSurface: Color = Color.white.opacity(0.5)
        static let glassBorder: Color = Color.white.opacity(0.4)
    }

    enum Typography {
        // Display / Hero numbers (for big numbers, dashboards, onboarding highlights)
        static let displayXL = Font.system(size: 56, weight: .bold, design: .default)
        static let displayL = Font.system(size: 48, weight: .bold, design: .default)
        static let displayM = Font.system(size: 40, weight: .bold, design: .default)
        static let displayS = Font.system(size: 36, weight: .bold, design: .default)

        // Headings (section titles, feature highlights)
        static let heading1 = Font.system(size: 32, weight: .semibold, design: .default)
        static let heading2 = Font.system(size: 28, weight: .semibold, design: .default)
        static let heading3 = Font.system(size: 24, weight: .medium, design: .default)

        // Body text (general copy, instructions, UI text)
        static let bodyL = Font.system(size: 17, weight: .regular, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let bodyS = Font.system(size: 15, weight: .regular, design: .default)

        // Supporting text
        static let caption = Font.system(size: 14, weight: .regular, design: .default)
        static let captionS = Font.system(size: 12, weight: .regular, design: .default)

        // Interactive elements
        static let button = Font.system(size: 17, weight: .semibold, design: .default)
        static let buttonS = Font.system(size: 15, weight: .semibold, design: .default)
        static let chip = Font.system(size: 14, weight: .medium, design: .default)
        static let chipS = Font.system(size: 12, weight: .medium, design: .default)

        // Numbers / Data
        static let monoL = Font.system(size: 16, weight: .medium, design: .monospaced)
        static let mono = Font.system(size: 14, weight: .medium, design: .monospaced)

        // Line Heights (multipliers for lineSpacing)
        enum LineHeight {
            static let display: CGFloat = 0.1      // 110% (use with lineSpacing)
            static let heading: CGFloat = 0.1      // 110%
            static let body: CGFloat = 0.4         // 140%
            static let caption: CGFloat = 0.3      // 130%
        }

        // Letter Spacing (tracking values)
        enum Tracking {
            static let display: CGFloat = -0.56    // -1% for display text
            static let body: CGFloat = 0           // neutral for body text
            static let allCaps: CGFloat = 0.32     // +2% for chips, buttons
        }

        // Text Treatments
        enum Treatment {
            static let emphasis: Font.Weight = .bold
            static let emphasisColor: Color = ColorPalette.primary
            static let linkColor: Color = ColorPalette.primaryBlue
            static let disabledOpacity: CGFloat = 0.6
        }
    }

    enum Animation {
        // Legacy animations
        static let xfast = SwiftUI.Animation.spring(duration: 0.12, bounce: 0.0)
        static let fast = SwiftUI.Animation.spring(duration: 0.18, bounce: 0.1)
        static let base = SwiftUI.Animation.spring(duration: 0.24, bounce: 0.18)
        static let slow = SwiftUI.Animation.spring(duration: 0.32, bounce: 0.22)

        // Optimized animations with cubic-bezier timing
        static let reveal = SwiftUI.Animation.spring(duration: 0.55, bounce: 0.0)
        static let revealSlow = SwiftUI.Animation.spring(duration: 0.75, bounce: 0.0)

        // Hover/press interactions
        static let hoverIn = SwiftUI.Animation.spring(duration: 0.15, bounce: 0.0)
        static let hoverOut = SwiftUI.Animation.spring(duration: 0.22, bounce: 0.0)
        static let pressIn = SwiftUI.Animation.spring(duration: 0.12, bounce: 0.0)
        static let pressOut = SwiftUI.Animation.spring(duration: 0.24, bounce: 0.0)

        // Count-up animations
        static let countUp = SwiftUI.Animation.easeOut(duration: 1.4)
        static let countUpFast = SwiftUI.Animation.easeOut(duration: 1.2)

        // Smooth interactions
        static let sharpSpring = SwiftUI.Animation.spring(duration: 0.42, bounce: 0.18)
        static let glide = SwiftUI.Animation.spring(duration: 0.30, bounce: 0.22)
        static let settle = SwiftUI.Animation.spring(duration: 0.22, bounce: 0.10)
    }

    enum Spacing {
        // Basic spacing
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48

        // Vertical rhythm
        static let sectionGap: CGFloat = 64  // Between major sections
        static let sectionGapL: CGFloat = 88  // Large section gaps
        static let headingToBody: CGFloat = 24  // Heading to body spacing
        static let headingMargin: CGFloat = 12  // Bottom margin for headings

        // Chip padding
        static let chipVertical: CGFloat = 12
        static let chipHorizontal: CGFloat = 18
        static let chipVerticalS: CGFloat = 10
        static let chipHorizontalS: CGFloat = 16
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