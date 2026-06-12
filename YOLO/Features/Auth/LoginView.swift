import SwiftUI

/// First-screen account chooser: Apple / Google / email. Each opens its own flow,
/// but only after the user has agreed to the legal terms via the checkbox.
struct LoginView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var acceptedLegal = false
    @State private var presentedLegal: LegalDocumentKind?
    @State private var showEmailSheet = false

    var body: some View {
        VStack(spacing: 0) {
            if AppConfig.useMock {
                mockNotice
            } else {
                socialButtons
                    .disabled(!acceptedLegal)
                    .opacity(acceptedLegal ? 1 : 0.4)

                legalConsentRow
                    .padding(.top, 18)

                if let errorMessage {
                    Text(errorMessage)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                }
            }
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.bottom, 8)
        .legalDocumentSheet(item: $presentedLegal)
        .sheet(isPresented: $showEmailSheet) {
            EmailAuthSheet(onAuthenticated: {
                showEmailSheet = false
                dismiss()
            })
        }
    }

    private var legalConsentRow: some View {
        HStack(alignment: .top, spacing: 10) {
            Button {
                acceptedLegal.toggle()
            } label: {
                Image(systemName: acceptedLegal ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(acceptedLegal ? Theme.ColorToken.accent : Theme.ColorToken.textMuted)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                acceptedLegal
                    ? String(localized: "Agreed to terms and privacy policy")
                    : String(localized: "Agree to terms and privacy policy")
            )

            LegalLinksText(
                text: "I agree to the [Terms of Service](yolo://legal/terms) and [Privacy Policy](yolo://legal/privacy)",
                presentedLegal: $presentedLegal,
                fontSize: 12
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)
        }
    }

    private var socialButtons: some View {
        VStack(spacing: 12) {
            AppleSignInButton(
                onStart: {
                    errorMessage = nil
                    isLoading = true
                },
                onSuccess: {
                    isLoading = false
                    dismiss()
                },
                onError: { message in
                    isLoading = false
                    errorMessage = message
                }
            )

            GoogleSignInButton(
                onStart: {
                    errorMessage = nil
                    isLoading = true
                },
                onSuccess: {
                    isLoading = false
                    dismiss()
                },
                onCancel: {
                    isLoading = false
                },
                onError: { message in
                    isLoading = false
                    errorMessage = message
                }
            )

            Button {
                errorMessage = nil
                showEmailSheet = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "envelope")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text(String(localized: "Continue with email"))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                }
                .socialButtonChrome()
            }
            .buttonStyle(.plain)
        }
    }

    private var mockNotice: some View {
        Text(String(localized: "Mock mode is active. Configure SUPABASE_URL and SUPABASE_ANON_KEY in Secrets.xcconfig."))
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(.orange)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Theme.ColorToken.warningBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Theme.ColorToken.border, lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(AppEnvironment())
    }
}
