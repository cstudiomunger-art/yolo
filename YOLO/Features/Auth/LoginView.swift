import Supabase
import SwiftUI

struct LoginView: View {
    private enum AuthMode {
        case signIn
        case signUp
    }

    @Environment(\.dismiss) private var dismiss

    @State private var mode: AuthMode = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var infoMessage: String?
    @State private var acceptedLegal = false
    @State private var pendingEmailConfirmation = false
    @State private var suggestSignIn = false
    @State private var presentedLegal: LegalDocumentKind?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if AppConfig.useMock {
                    mockNotice
                }

                if pendingEmailConfirmation {
                    pendingConfirmationContent
                } else {
                    authFormContent
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Theme.ColorToken.background)
        .legalDocumentSheet(item: $presentedLegal)
    }

    // MARK: - Form

    @ViewBuilder
    private var authFormContent: some View {
        if !AppConfig.useMock {
            AppleSignInButton(
                onStart: {
                    clearMessages()
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

            LegalLinksText(
                text: "By continuing, you agree to the [Terms of Service](yolo://legal/terms) and [Privacy Policy](yolo://legal/privacy)",
                presentedLegal: $presentedLegal
            )
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)

            AuthDivider(label: "or continue with email")
                .padding(.vertical, 22)
        }

        VStack(spacing: 10) {
            TextField(String(localized: "Email"), text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .authFieldStyle()

            SecureField(String(localized: "Password"), text: $password)
                .textContentType(mode == .signUp ? .newPassword : .password)
                .authFieldStyle()

            if mode == .signUp {
                SecureField(String(localized: "Confirm password"), text: $confirmPassword)
                    .textContentType(.newPassword)
                    .authFieldStyle()
            }
        }

        if mode == .signIn, !AppConfig.useMock {
            HStack {
                Spacer()
                NavigationLink {
                    ForgotPasswordView(initialEmail: trimmedEmail)
                } label: {
                    Text(String(localized: "Forgot password?"))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            .padding(.top, 12)
        }

        if mode == .signUp {
            HStack(alignment: .top, spacing: 10) {
                Button {
                    acceptedLegal.toggle()
                } label: {
                    Image(systemName: acceptedLegal ? "largecircle.fill.circle" : "circle")
                        .font(.system(size: 20))
                        .foregroundStyle(
                            acceptedLegal ? Theme.ColorToken.accent : Theme.ColorToken.textMuted
                        )
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
                .padding(.top, 2)
            }
            .padding(.top, 16)
        }

        Button {
            submit()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(primaryActionTitle)
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(!canSubmit)
        .padding(.top, 40)

        statusMessages

        if suggestSignIn {
            Button(String(localized: "Go to sign in")) {
                switchMode(to: .signIn)
            }
            .font(Theme.FontToken.inter(13, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
            .padding(.top, 12)
        }

        modeSwitchRow
            .padding(.top, 28)
    }

    private var modeSwitchRow: some View {
        HStack(spacing: 5) {
            Text(
                mode == .signIn
                    ? String(localized: "Don't have an account?")
                    : String(localized: "Already have an account?")
            )
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)

            Button {
                switchMode(to: mode == .signIn ? .signUp : .signIn)
            } label: {
                Text(mode == .signIn ? String(localized: "Sign Up") : String(localized: "Sign In"))
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var statusMessages: some View {
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
            .padding(.bottom, 20)
    }

    // MARK: - Pending email confirmation

    @ViewBuilder
    private var pendingConfirmationContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "Check your email to confirm your account before signing in."))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(trimmedEmail)
                .font(Theme.FontToken.inter(13, weight: .medium))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Theme.ColorToken.border, lineWidth: 1)
        )

        Button {
            resendConfirmation()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(String(localized: "Resend confirmation email"))
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(isLoading || AppConfig.useMock)
        .padding(.top, 20)

        Button(String(localized: "Back to sign in")) {
            pendingEmailConfirmation = false
            switchMode(to: .signIn)
        }
        .font(Theme.FontToken.inter(13, weight: .medium))
        .foregroundStyle(Theme.ColorToken.accent)
        .padding(.top, 16)

        statusMessages
    }

    // MARK: - State helpers

    private func switchMode(to newMode: AuthMode) {
        mode = newMode
        clearMessages()
        confirmPassword = ""
        suggestSignIn = false
    }

    private var primaryActionTitle: String {
        mode == .signIn ? String(localized: "Sign In") : String(localized: "Create Account")
    }

    private var trimmedEmail: String {
        AuthFormSupport.trimmedEmail(email)
    }

    private var canSubmit: Bool {
        guard !isLoading, !AppConfig.useMock else { return false }
        guard AuthFormSupport.isValidEmail(trimmedEmail) else { return false }
        guard password.count >= AuthFormSupport.minimumPasswordLength else { return false }

        switch mode {
        case .signIn:
            return !password.isEmpty
        case .signUp:
            return password == confirmPassword && acceptedLegal
        }
    }

    // MARK: - Actions

    private func submit() {
        clearMessages()
        suggestSignIn = false

        guard AuthFormSupport.isValidEmail(trimmedEmail) else {
            errorMessage = String(localized: "Enter a valid email address.")
            return
        }
        guard password.count >= AuthFormSupport.minimumPasswordLength else {
            errorMessage = String(
                format: String(localized: "Password must be at least %lld characters."),
                AuthFormSupport.minimumPasswordLength
            )
            return
        }

        switch mode {
        case .signIn:
            signIn()
        case .signUp:
            guard password == confirmPassword else {
                errorMessage = String(localized: "Passwords do not match.")
                return
            }
            signUp()
        }
    }

    private func signIn() {
        runAuth {
            _ = try await SupabaseManager.shared.auth.signIn(email: trimmedEmail, password: password)
            TelemetryService.shared.logEvent("sign_in")
            dismiss()
        }
    }

    private func signUp() {
        runAuth {
            let response = try await SupabaseManager.shared.auth.signUp(
                email: trimmedEmail,
                password: password,
                redirectTo: AppConfig.emailConfirmationRedirectURL
            )

            if AuthFormSupport.isAlreadyRegisteredUser(response.user) {
                suggestSignIn = true
                errorMessage = String(localized: "An account with this email already exists. Try signing in instead.")
                return
            }

            TelemetryService.shared.logEvent("sign_up")

            if response.session != nil {
                dismiss()
                return
            }

            try await completeSignInAfterSignUp()
        }
    }

    private func completeSignInAfterSignUp() async throws {
        do {
            _ = try await SupabaseManager.shared.auth.signIn(email: trimmedEmail, password: password)
            TelemetryService.shared.logEvent("sign_in")
            dismiss()
        } catch {
            let message = AuthFormSupport.errorMessage(for: error)
            if message == String(localized: "Email not confirmed. Check your sign-up confirmation email before signing in.") {
                pendingEmailConfirmation = true
                infoMessage = String(localized: "Sign up successful. Check your email and tap the confirmation link.")
            } else {
                throw error
            }
        }
    }

    private func resendConfirmation() {
        runAuth {
            try await SupabaseManager.shared.auth.resend(
                email: trimmedEmail,
                type: .signup,
                emailRedirectTo: AppConfig.emailConfirmationRedirectURL
            )
            infoMessage = String(localized: "Confirmation email sent. Check your inbox.")
        }
    }

    private func runAuth(_ action: @escaping () async throws -> Void) {
        Task {
            isLoading = true
            errorMessage = nil
            if !pendingEmailConfirmation {
                infoMessage = nil
            }
            defer { isLoading = false }

            do {
                try await action()
            } catch {
                let message = AuthFormSupport.errorMessage(for: error)
                errorMessage = message
                if message == String(localized: "An account with this email already exists. Try signing in instead.") {
                    suggestSignIn = true
                }
            }
        }
    }

    private func clearMessages() {
        errorMessage = nil
        infoMessage = nil
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(AppEnvironment())
    }
}
