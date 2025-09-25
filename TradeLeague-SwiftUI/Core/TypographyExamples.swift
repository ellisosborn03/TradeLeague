import SwiftUI

// MARK: - Typography Usage Examples
// This file demonstrates how to properly use the refined typography system

struct TypographyExamplesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {

                // MARK: Display/Hero Examples
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Display Typography")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    // Display XL with proper tracking
                    Text("1,234")
                        .font(Theme.Typography.displayXL)
                        .tracking(Theme.Typography.Tracking.display)
                        .lineSpacing(Theme.Typography.LineHeight.display)
                        .foregroundColor(Theme.ColorPalette.primary)

                    // Display L for secondary metrics
                    Text("567")
                        .font(Theme.Typography.displayL)
                        .tracking(Theme.Typography.Tracking.display)
                        .lineSpacing(Theme.Typography.LineHeight.display)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                }

                Divider()

                // MARK: Heading Hierarchy
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Heading Hierarchy")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Main Section Title")
                        .font(Theme.Typography.heading1)
                        .lineSpacing(Theme.Typography.LineHeight.heading)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .padding(.bottom, Theme.Spacing.headingMargin)

                    Text("Subsection Title")
                        .font(Theme.Typography.heading2)
                        .lineSpacing(Theme.Typography.LineHeight.heading)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .padding(.bottom, Theme.Spacing.headingMargin)

                    Text("Sub-subsection Title")
                        .font(Theme.Typography.heading3)
                        .lineSpacing(Theme.Typography.LineHeight.heading)
                        .foregroundColor(Theme.ColorPalette.textPrimary)
                        .padding(.bottom, Theme.Spacing.headingMargin)
                }

                Divider()

                // MARK: Body Text Examples
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Body Text Hierarchy")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Large body text for content-heavy screens with improved readability. This size works well for important instructions or feature descriptions.")
                        .font(Theme.Typography.bodyL)
                        .lineSpacing(Theme.Typography.LineHeight.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Default body text for general copy, instructions, and UI text. This is the standard reading size for most content in the app.")
                        .font(Theme.Typography.body)
                        .lineSpacing(Theme.Typography.LineHeight.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Small body text for secondary information or compact layouts.")
                        .font(Theme.Typography.bodyS)
                        .lineSpacing(Theme.Typography.LineHeight.body)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }

                Divider()

                // MARK: Interactive Elements
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Interactive Elements")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    // Button examples
                    HStack(spacing: Theme.Spacing.sm) {
                        Text("PRIMARY ACTION")
                            .font(Theme.Typography.button)
                            .tracking(Theme.Typography.Tracking.allCaps)
                            .foregroundColor(.white)
                            .padding(.horizontal, Theme.Spacing.lg)
                            .padding(.vertical, Theme.Spacing.sm)
                            .background(Theme.ColorPalette.primary)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))

                        Text("SECONDARY")
                            .font(Theme.Typography.buttonS)
                            .tracking(Theme.Typography.Tracking.allCaps)
                            .foregroundColor(Theme.ColorPalette.primary)
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.xs)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                    .stroke(Theme.ColorPalette.primary, lineWidth: 1)
                            )
                    }

                    // Chip examples
                    HStack(spacing: Theme.Spacing.xs) {
                        Text("ACTIVE CHIP")
                            .font(Theme.Typography.chip)
                            .tracking(Theme.Typography.Tracking.allCaps)
                            .foregroundColor(.white)
                            .padding(.horizontal, Theme.Spacing.chipHorizontal)
                            .padding(.vertical, Theme.Spacing.chipVertical)
                            .background(Theme.ColorPalette.primary)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.full))

                        Text("SMALL CHIP")
                            .font(Theme.Typography.chipS)
                            .tracking(Theme.Typography.Tracking.allCaps)
                            .foregroundColor(Theme.ColorPalette.primary)
                            .padding(.horizontal, Theme.Spacing.chipHorizontalS)
                            .padding(.vertical, Theme.Spacing.chipVerticalS)
                            .background(Theme.ColorPalette.surface)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.full))
                    }
                }

                Divider()

                // MARK: Text Treatments
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Text Treatments")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("This text has ")
                        .font(Theme.Typography.body)
                        .lineSpacing(Theme.Typography.LineHeight.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary) +
                    Text("emphasized content")
                        .font(Theme.Typography.body)
                        .fontWeight(Theme.Typography.Treatment.emphasis)
                        .foregroundColor(Theme.Typography.Treatment.emphasisColor) +
                    Text(" mixed with regular text.")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("This is a link")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Typography.Treatment.linkColor)
                        .underline()

                    Text("This text is disabled")
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                        .opacity(Theme.Typography.Treatment.disabledOpacity)
                }

                Divider()

                // MARK: Data/Numbers
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Data & Numbers")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Large mono: 1,234.56")
                        .font(Theme.Typography.monoL)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Default mono: 789.01")
                        .font(Theme.Typography.mono)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }

                Divider()

                // MARK: Supporting Text
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Supporting Text")
                        .font(Theme.Typography.heading2)
                        .foregroundColor(Theme.ColorPalette.textPrimary)

                    Text("Caption text for image descriptions or secondary information")
                        .font(Theme.Typography.caption)
                        .lineSpacing(Theme.Typography.LineHeight.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)

                    Text("Small caption for fine print or metadata")
                        .font(Theme.Typography.captionS)
                        .lineSpacing(Theme.Typography.LineHeight.caption)
                        .foregroundColor(Theme.ColorPalette.textSecondary)
                }
            }
            .padding(Theme.Spacing.lg)
        }
        .navigationTitle("Typography System")
    }
}

// MARK: - Usage Guidelines
/*
TYPOGRAPHY USAGE GUIDELINES:

1. **Display Text**: Use for hero numbers, statistics, onboarding highlights
   - Always apply tracking(Theme.Typography.Tracking.display)
   - Use lineSpacing(Theme.Typography.LineHeight.display)

2. **Headings**: Create clear information hierarchy
   - H1: Main section titles, page titles
   - H2: Subsections, feature categories
   - H3: Sub-categories, fills gap between H2 and body

3. **Body Text**: Default for most content
   - bodyL: Content-heavy screens, important instructions
   - body: Standard reading content
   - bodyS: Secondary information, compact layouts
   - Always use lineSpacing(Theme.Typography.LineHeight.body)

4. **Interactive Elements**:
   - Buttons: Use tracking(Theme.Typography.Tracking.allCaps) for all caps
   - Chips: Always use all caps with proper tracking
   - Links: Use Theme.Typography.Treatment.linkColor with underline

5. **Line Spacing**:
   - Display/Headings: 110% (tighter for impact)
   - Body: 140% (optimal readability)
   - Captions: 130% (balanced for smaller text)

6. **Letter Spacing**:
   - Display: -1% (tighter for large text)
   - Body: 0% (neutral)
   - All Caps: +2% (improved readability)

Example usage:
Text("Your Score")
    .font(Theme.Typography.displayXL)
    .tracking(Theme.Typography.Tracking.display)
    .lineSpacing(Theme.Typography.LineHeight.display)
    .foregroundColor(Theme.ColorPalette.primary)
*/

#Preview {
    NavigationView {
        TypographyExamplesView()
    }
}