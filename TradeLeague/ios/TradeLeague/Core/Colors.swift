import SwiftUI

extension Color {
    // Primary colors - White and Orange theme
    static let primaryBlue = Color(hex: "FF6B35") // Orange (replaces blue)
    static let accentOrange = Color(hex: "FF6B35") // Primary orange
    static let accentPurple = Color(hex: "FF6B35") // Use orange for purple accents too
    static let successGreen = Color(hex: "4ECB71") // Bright green
    static let dangerRed = Color(hex: "FF6B6B")
    static let warningYellow = Color(hex: "FDCB6E")

    // Background colors - White/Light theme
    static let darkBackground = Color.white // White background
    static let surfaceColor = Color(hex: "FFFFFF") // White surface
    static let cardBackground = Color(hex: "F8F9FA") // Light gray for cards
    static let surfaceLight = Color(hex: "F8F9FA")
    static let borderColor = Color(hex: "E9ECEF")

    // Text colors - Dark text on light background
    static let primaryText = Color(hex: "1A1A1A") // Dark gray/black
    static let secondaryText = Color(hex: "6C757D") // Medium gray
    static let tertiaryText = Color(hex: "ADB5BD") // Light gray

    // Chart colors
    static let chartGreen = Color(hex: "4ECB71")
    static let chartRed = Color(hex: "FF6B6B")
    static let chartBlue = Color(hex: "74B9FF")
    static let chartPurple = Color(hex: "FF6B35") // Orange for purple charts

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
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