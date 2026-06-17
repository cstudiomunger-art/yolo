import SwiftUI

/// Two-column quick access: Prep Checklist | Emergency (demo `quick-grid` structure).
struct HomeQuickAccessGrid: View {
    let prepCompleted: Int
    let prepTotal: Int
    var onOpenPrepare: () -> Void = {}
    var onOpenInfoHub: () -> Void = {}
    var onOpenGeniusBar: () -> Void = {}
    var onOpenPhrases: () -> Void = {}

    private var itemsLeft: Int {
        max(prepTotal - prepCompleted, 0)
    }

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "Quick Access"))
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
                .padding(.horizontal, Theme.screenPadding)

            LazyVGrid(columns: columns, spacing: 12) {
                quickCell(
                    icon: "📋",
                    label: String(localized: "Prep Checklist"),
                    subtitle: prepTotal > 0
                        ? String(localized: "\(itemsLeft) items left")
                        : String(localized: "Open checklist"),
                    action: onOpenPrepare
                )
                quickCell(
                    icon: "💬",
                    label: String(localized: "Talk to a Human"),
                    subtitle: String(localized: "Genius Bar · real people"),
                    action: onOpenGeniusBar
                )
                quickCell(
                    icon: "🗣",
                    label: String(localized: "Phrases & Dialect"),
                    subtitle: String(localized: "Say it right · 方言彩蛋"),
                    action: onOpenPhrases
                )
                quickCell(
                    icon: "🧭",
                    label: String(localized: "Practical Info"),
                    subtitle: String(localized: "Emergency · Visa · Pay · Transport"),
                    action: onOpenInfoHub
                )
            }
            .padding(.horizontal, Theme.screenPadding)
        }
        .padding(.top, 20)
    }

    private func quickCell(icon: String, label: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(icon)
                    .font(.system(size: 22))
                Text(label)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                Text(subtitle)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 124, maxHeight: 124, alignment: .topLeading)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Theme.ColorToken.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
