import AuthenticationServices
import Supabase
import SwiftUI

/// Google sign-in via Supabase's OAuth web flow (ASWebAuthenticationSession).
/// Requires the Google provider to be enabled in Supabase Dashboard and
/// `yoloapp://auth-callback` to be whitelisted under Auth → URL Configuration → Redirect URLs.
struct GoogleSignInButton: View {
    static let redirectURL = URL(string: "yoloapp://auth-callback")

    var onStart: () -> Void = {}
    var onSuccess: () -> Void = {}
    var onCancel: () -> Void = {}
    var onError: (String) -> Void = { _ in }

    var body: some View {
        Button {
            signIn()
        } label: {
            HStack(spacing: 8) {
                Text(verbatim: "G")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x4285F4))
                Text(String(localized: "Continue with Google"))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            .socialButtonChrome()
        }
        .buttonStyle(.plain)
    }

    private func signIn() {
        onStart()
        Task {
            do {
                _ = try await SupabaseManager.shared.auth.signInWithOAuth(
                    provider: .google,
                    redirectTo: Self.redirectURL
                )
                TelemetryService.shared.logEvent("sign_in_google")
                onSuccess()
            } catch {
                if isCancellation(error) {
                    onCancel()
                } else {
                    onError(AuthFormSupport.errorMessage(for: error))
                }
            }
        }
    }

    private func isCancellation(_ error: Error) -> Bool {
        if let sessionError = error as? ASWebAuthenticationSessionError,
           sessionError.code == .canceledLogin {
            return true
        }
        return error is CancellationError
    }
}

#Preview {
    GoogleSignInButton()
        .padding()
}
