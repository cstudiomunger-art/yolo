import Supabase
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var message: String?
    @State private var isSuccess = false

    var body: some View {
        Form {
            Section {
                Text(String(localized: "Enter your account email. We will send a link to reset your password."))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            Section {
                TextField(String(localized: "Email"), text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section {
                Button(String(localized: "Send reset link")) {
                    sendReset()
                }
                .disabled(email.isEmpty || isLoading || AppConfig.useMock)
            }

            if isLoading {
                Section { ProgressView() }
            }

            if let message {
                Section {
                    Text(message)
                        .foregroundStyle(isSuccess ? Theme.ColorToken.accent : .red)
                }
            }
        }
        .navigationTitle(String(localized: "Forgot password"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendReset() {
        Task {
            isLoading = true
            message = nil
            defer { isLoading = false }
            do {
                try await SupabaseManager.shared.auth.resetPasswordForEmail(
                    email,
                    redirectTo: AppConfig.authRedirectURL
                )
                isSuccess = true
                message = String(localized: "Check your email for a password reset link.")
            } catch {
                isSuccess = false
                message = error.localizedDescription
            }
        }
    }
}
