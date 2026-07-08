import SwiftUI
import UIKit

enum Theme {
    enum ColorToken {
        static let background = Color.adaptive(light: 0xFFFFFF, dark: 0x000000)
        static let backgroundSubtle = Color.adaptive(light: 0xFAF7F2, dark: 0x1C1C1E)
        static let border = Color.adaptive(light: 0xE8E4DC, dark: 0x38383A)
        static let borderLight = Color.adaptive(light: 0xF0ECE8, dark: 0x2C2C2E)
        static let textPrimary = Color.adaptive(light: 0x111111, dark: 0xF5F5F5)
        static let textSecondary = Color.adaptive(light: 0x666666, dark: 0xABABAB)
        static let textMuted = Color.adaptive(light: 0x888888, dark: 0x8E8E93)
        static let textDisabled = Color.adaptive(light: 0xBBBBBB, dark: 0x636366)
        static let textGhost = Color.adaptive(light: 0xCCCCCC, dark: 0x48484A)
        static let accent = Color(hex: 0xC8A97E)
        static let success = Color(hex: 0x27AE60)
        static let warning = Color(hex: 0xF5A623)
        static let warningBackground = Color.adaptive(light: 0xFFFBF2, dark: 0x2C2419)
        static let urgent = Color(hex: 0xC8572C)
        static let surfaceEmphasis = Color.adaptive(light: 0x111111, dark: 0xF5F5F5)
        static let onSurfaceEmphasis = Color.adaptive(light: 0xFFFFFF, dark: 0x111111)
        static let surfaceFloating = Color.adaptive(light: 0xFFFFFF, dark: 0x2C2C2E)
        static let chatUser = Color.adaptive(light: 0x111111, dark: 0xFFFFFF)
        static let chatAI = Color.adaptive(light: 0xFAF7F2, dark: 0x2C2C2E)
    }

    enum CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
    }

    enum FontToken {
        static func playfair(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .system(size: size, weight: weight, design: .serif)
        }

        static func inter(_ size: CGFloat, weight: Font.Weight = .light) -> Font {
            .system(size: size, weight: weight, design: .default)
        }
    }

    static let screenPadding: CGFloat = 28
    static let tabBarHeight: CGFloat = 76

    enum DisplayScale {
        @MainActor
        static var primary: CGFloat {
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.screen.scale }
                .first ?? 2.0
        }
    }
}

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    static func adaptive(light: UInt32, dark: UInt32) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(Color(hex: dark))
                : UIColor(Color(hex: light))
        })
    }

    /// Resolves a dynamic SwiftUI color to hex for HTML/CSS injection.
    func resolvedHex(colorScheme: ColorScheme) -> String {
        let traits = UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .dark : .light)
        let uiColor = UIColor(self).resolvedColor(with: traits)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

struct SectionTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.FontToken.inter(10, weight: .medium))
            .foregroundStyle(Theme.ColorToken.textDisabled)
            .textCase(.uppercase)
            .kerning(1.2)
    }
}

struct GuideContentCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium, style: .continuous)
                    .stroke(Theme.ColorToken.border, lineWidth: 1)
            )
    }
}

struct CardBorderStyle: ViewModifier {
    var radius: CGFloat = Theme.CornerRadius.medium
    var borderColor: Color = Theme.ColorToken.border

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

struct EmphasisButtonStyle: ViewModifier {
    var horizontalPadding: CGFloat = 20
    var verticalPadding: CGFloat = 11

    func body(content: Content) -> some View {
        content
            .font(Theme.FontToken.inter(12, weight: .medium))
            .tracking(0.8)
            .foregroundStyle(Theme.ColorToken.onSurfaceEmphasis)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(Theme.ColorToken.surfaceEmphasis)
    }
}

struct SelectedChipStyle: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .font(Theme.FontToken.inter(11, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.ColorToken.surfaceEmphasis : Theme.ColorToken.backgroundSubtle)
            .foregroundStyle(isSelected ? Theme.ColorToken.onSurfaceEmphasis : Theme.ColorToken.textSecondary)
    }
}

extension View {
    func sectionTitleStyle() -> some View {
        modifier(SectionTitleStyle())
    }

    func guideContentCardStyle() -> some View {
        modifier(GuideContentCardStyle())
    }

    func cardBorderStyle(radius: CGFloat = Theme.CornerRadius.medium, borderColor: Color = Theme.ColorToken.border) -> some View {
        modifier(CardBorderStyle(radius: radius, borderColor: borderColor))
    }

    func emphasisButtonStyle(horizontalPadding: CGFloat = 20, verticalPadding: CGFloat = 11) -> some View {
        modifier(EmphasisButtonStyle(horizontalPadding: horizontalPadding, verticalPadding: verticalPadding))
    }

    func selectedChipStyle(isSelected: Bool) -> some View {
        modifier(SelectedChipStyle(isSelected: isSelected))
    }
}
