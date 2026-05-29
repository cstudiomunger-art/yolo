import Supabase
import SwiftUI

struct ForgotPasswordView: View {
    var initialEmail: String = ""

    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var infoMessage: String?
    @State private var resetLinkSent = false

    var body: some View {
        Form {
            if resetLinkSent {
                resetSentSections
            } else {
                requestResetSections
            }
        }
        .navigationTitle(String(localized: "Forgot password"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if email.isEmpty, !initialEmail.isEmpty {
                email = initialEmail
            }
        }
    }

    @ViewBuilder
    private var requestResetSections: some View {
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
            .disabled(!canSubmit)
        }

        statusSections
    }

    @ViewBuilder
    private var resetSentSections: some View {
        Section {
            Text(String(localized: "Check your email for a password reset link."))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(trimmedEmail)
                .font(Theme.FontToken.inter(13, weight: .medium))
            Text(String(localized: "If you don't see the email, check your spam folder or try resending."))
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }

        Section {
            Button(String(localized: "Resend reset link")) {
                sendReset()
            }
            .disabled(isLoading || AppConfig.useMock)

            Button(String(localized: "Use a different email")) {
                resetLinkSent = false
                clearMessages()
            }
        }

        statusSections
    }

    @ViewBuilder
    private var statusSections: some View {
        if isLoading {
            Section { ProgressView() }
        }

        if let infoMessage {
            Section {
                Text(infoMessage)
                    .foregroundStyle(Theme.ColorToken.accent)
            }
        }

        if let errorMessage {
            Section {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
    }

    private var trimmedEmail: String {
        AuthFormSupport.trimmedEmail(email)
    }

    private var canSubmit: Bool {
        !isLoading
            && !AppConfig.useMock
            && AuthFormSupport.isValidEmail(trimmedEmail)
    }

    private func sendReset() {
        clearMessages()

        guard AuthFormSupport.isValidEmail(trimmedEmail) else {
            errorMessage = String(localized: "Enter a valid email address.")
            return
        }

        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                try await SupabaseManager.shared.auth.resetPasswordForEmail(
                    trimmedEmail,
                    redirectTo: AppConfig.authRedirectURL
                )
                resetLinkSent = true
                infoMessage = String(localized: "Password reset email sent. Check your inbox.")
                TelemetryService.shared.logEvent("password_reset_requested")
            } catch {
                errorMessage = AuthFormSupport.errorMessage(for: error)
            }
        }
    }

    private func clearMessages() {
        errorMessage = nil
        infoMessage = nil
    }
}
