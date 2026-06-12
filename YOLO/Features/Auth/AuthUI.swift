import SwiftUI

/// Shared styling for the auth flow (login, sign-up, password reset).

/// Bordered input field matching the app's card language (subtle background + 1pt border).
struct AuthFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Theme.FontToken.inter(14))
            .padding(.horizontal, 12)
            .padding(.vertical, 13)
            .background(Theme.ColorToken.backgroundSubtle)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Theme.ColorToken.border, lineWidth: 1)
            )
    }
}

/// Full-width primary action button: white background, 1pt dark border.
struct AuthPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.FontToken.inter(15, weight: .medium))
            .foregroundStyle(isEnabled ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(configuration.isPressed ? Theme.ColorToken.backgroundSubtle : Theme.ColorToken.background)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(
                        isEnabled ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled,
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
    }
}

/// Thin divider with a centered label, e.g. "or continue with email".
struct AuthDivider: View {
    let label: LocalizedStringKey

    var body: some View {
        HStack(spacing: 12) {
            line
            Text(label)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .fixedSize()
            line
        }
    }

    private var line: some View {
        Rectangle()
            .fill(Theme.ColorToken.border)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

/// One-sentence legal text with inline tappable "Terms of Service" / "Privacy Policy" links.
/// The localized string embeds markdown links using the yolo://legal/{terms|privacy} scheme,
/// which are intercepted here and surfaced through `presentedLegal` (shown as a sheet by the caller).
struct LegalLinksText: View {
    let text: LocalizedStringKey
    @Binding var presentedLegal: LegalDocumentKind?
    var fontSize: CGFloat = 11

    var body: some View {
        Text(text)
            .font(Theme.FontToken.inter(fontSize))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .tint(Theme.ColorToken.accent)
            .environment(\.openURL, OpenURLAction { url in
                guard url.scheme == "yolo", url.host() == "legal" else { return .systemAction }
                switch url.lastPathComponent {
                case "terms":
                    presentedLegal = .terms
                case "privacy":
                    presentedLegal = .privacy
                default:
                    return .discarded
                }
                return .handled
            })
    }
}

extension View {
    func authFieldStyle() -> some View {
        modifier(AuthFieldStyle())
    }

    /// Presents the tapped legal document as a bottom sheet.
    func legalDocumentSheet(item: Binding<LegalDocumentKind?>) -> some View {
        sheet(item: item) { kind in
            NavigationStack {
                LegalDocumentView(kind: kind)
            }
        }
    }
}
