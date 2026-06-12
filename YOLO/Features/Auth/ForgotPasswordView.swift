import Combine
import SwiftUI

struct ForgotPasswordView: View {
    var initialEmail: String = ""

    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var infoMessage: String?
    @State private var resetLinkSent = false
    @State private var retryAfter: Date?

    private let resendCooldownSeconds = 60

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if resetLinkSent {
                    resetSentContent
                } else {
                    requestResetContent
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .background(Theme.ColorToken.background)
        .navigationTitle(String(localized: "Forgot password"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if email.isEmpty, !initialEmail.isEmpty {
                email = initialEmail
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { now in
            if let retryAfter, retryAfter <= now {
                self.retryAfter = nil
            }
        }
    }

    @ViewBuilder
    private var requestResetContent: some View {
        Text(String(localized: "Enter your account email. We will send a link to reset your password."))
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 16)

        TextField(String(localized: "Email"), text: $email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .authFieldStyle()

        Button {
            sendReset()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(String(localized: "Send reset link"))
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(!canSubmit || isInCooldown)
        .padding(.top, 20)

        statusContent
    }

    @ViewBuilder
    private var resetSentContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "Check your email for a password reset link."))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(trimmedEmail)
                .font(Theme.FontToken.inter(13, weight: .medium))
            Text(String(localized: "If you don't see the email, check your spam folder or try resending."))
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Theme.ColorToken.border, lineWidth: 1)
        )

        Button {
            sendReset()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(String(localized: "Resend reset link"))
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(isLoading || AppConfig.useMock || isInCooldown)
        .padding(.top, 20)

        Button(String(localized: "Use a different email")) {
            resetLinkSent = false
            clearMessages()
        }
        .font(Theme.FontToken.inter(13, weight: .medium))
        .foregroundStyle(Theme.ColorToken.accent)
        .padding(.top, 16)

        statusContent
    }

    @ViewBuilder
    private var statusContent: some View {
        if let infoMessage {
            Text(infoMessage)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.accent)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
        }

        if let errorMessage {
            Text(errorMessage)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
        } else if let cooldownHint {
            Text(cooldownHint)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
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

    private var isInCooldown: Bool {
        guard let retryAfter else { return false }
        return retryAfter > .now
    }

    private var cooldownHint: String? {
        guard let retryAfter, retryAfter > .now else { return nil }
        let seconds = max(1, Int(retryAfter.timeIntervalSinceNow.rounded(.up)))
        return String(
            format: String(localized: "Please wait %lld seconds before requesting another email."),
            seconds
        )
    }

    private func sendReset() {
        clearMessages()

        if isInCooldown, let cooldownHint {
            errorMessage = cooldownHint
            return
        }

        guard AuthFormSupport.isValidEmail(trimmedEmail) else {
            errorMessage = String(localized: "Enter a valid email address.")
            return
        }

        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                try await PasswordRecoveryEmailService.sendResetEmail(to: trimmedEmail)
                resetLinkSent = true
                infoMessage = String(localized: "Password reset email sent. Check your inbox.")
                retryAfter = Date().addingTimeInterval(TimeInterval(resendCooldownSeconds))
                TelemetryService.shared.logEvent("password_reset_requested")
            } catch {
                errorMessage = AuthFormSupport.errorMessage(for: error)
                if AuthFormSupport.isRateLimitError(error) {
                    retryAfter = Date().addingTimeInterval(TimeInterval(resendCooldownSeconds * 2))
                }
            }
        }
    }

    private func clearMessages() {
        errorMessage = nil
        infoMessage = nil
    }
}
