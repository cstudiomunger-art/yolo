import Foundation
import SwiftUI

/// Shared styling for the auth flow (login, sign-up, password reset).

/// Horizontal shake to draw attention to the legal consent row when a user tries to
/// sign in without agreeing first. Animate by bumping `animatableData`.
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * CGFloat(sin(Double(animatableData) * .pi * Double(shakesPerUnit)))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

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

/// Password field with a reveal/hide toggle, styled like `AuthFieldStyle`.
struct AuthPasswordField: View {
    let placeholder: String
    @Binding var text: String
    var textContentType: UITextContentType? = .password

    @State private var isRevealed = false

    var body: some View {
        HStack(spacing: 8) {
            Group {
                if isRevealed {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .font(Theme.FontToken.inter(14))
            .textContentType(textContentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button {
                isRevealed.toggle()
            } label: {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                isRevealed
                    ? String(localized: "Hide password")
                    : String(localized: "Show password")
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 13)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Theme.ColorToken.border, lineWidth: 1)
        )
    }
}

/// Shared chrome for the first-screen social buttons (white background + light 1pt border, 48 tall).
struct SocialButtonChrome: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Theme.ColorToken.background)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Theme.ColorToken.border, lineWidth: 1)
            )
            .contentShape(Rectangle())
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

    func socialButtonChrome() -> some View {
        modifier(SocialButtonChrome())
    }

    /// Presents the tapped legal document as a bottom sheet.
    func legalDocumentSheet(item: Binding<LegalDocumentKind?>) -> some View {
        sheet(item: item) { kind in
            NavigationStack {
                LegalDocumentView(kind: kind)
            }
        }
    }

    /// Presents the login screen as a sheet — used to gate account-only actions for guests.
    func loginSheet(isPresented: Binding<Bool>, appEnv: AppEnvironment) -> some View {
        sheet(isPresented: isPresented) {
            NavigationStack {
                LoginView()
                    .environment(appEnv)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(String(localized: "Close")) { isPresented.wrappedValue = false }
                        }
                    }
            }
        }
    }
}

// MARK: - Account feature gate

extension AppEnvironment {
    /// True when the user must sign in before account-linked actions (purchases, chat, cloud sync).
    var mustSignInForAccountAction: Bool {
        !auth.isAuthenticated && !AppConfig.useMock
    }
}

/// Centered prompt shown when a screen requires a signed-in account.
struct AccountSignInPrompt: View {
    let title: String
    let message: String
    var buttonTitle: String = String(localized: "Sign in →")
    let onSignIn: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(title)
                .font(Theme.FontToken.playfair(20, weight: .semibold))
                .multilineTextAlignment(.center)
            Text(message)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Button(action: onSignIn) {
                Text(buttonTitle)
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Theme.screenPadding)
    }
}
