import SwiftUI
import UIKit

enum Theme {
    enum ColorToken {
        static let background = Color(hex: 0xFFFFFF)
        static let backgroundSubtle = Color(hex: 0xFAF7F2)
        static let border = Color(hex: 0xE8E4DC)
        static let borderLight = Color(hex: 0xF0ECE8)
        static let textPrimary = Color(hex: 0x111111)
        static let textSecondary = Color(hex: 0x666666)
        static let textMuted = Color(hex: 0x888888)
        static let textDisabled = Color(hex: 0xBBBBBB)
        static let textGhost = Color(hex: 0xCCCCCC)
        static let accent = Color(hex: 0xC8A97E)
        static let success = Color(hex: 0x27AE60)
        static let warning = Color(hex: 0xF5A623)
        static let warningBackground = Color(hex: 0xFFFBF2)
        static let urgent = Color(hex: 0xC8572C)
        static let chatUser = Color(hex: 0x111111)
        static let chatAI = Color(hex: 0xFAF7F2)
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
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
    }
}

extension View {
    func sectionTitleStyle() -> some View {
        modifier(SectionTitleStyle())
    }

    func guideContentCardStyle() -> some View {
        modifier(GuideContentCardStyle())
    }
}
