import Supabase
import SwiftUI

/// Email auth presented as a sheet from the first-screen "Continue with email" button.
/// Single "Continue" flow: existing users sign in, new users are auto-registered.
struct EmailAuthSheet: View {
    /// Called after a session is established so the caller can dismiss the whole login gate.
    var onAuthenticated: () -> Void

    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var infoMessage: String?
    @State private var pendingEmailConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if pendingEmailConfirmation {
                        pendingConfirmationContent
                    } else {
                        formContent
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .background(Theme.ColorToken.background)
            .navigationTitle(String(localized: "Continue with email"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
            }
        }
        .sheetDragToDismiss()
        .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
            guard isAuthenticated else { return }
            finishAuthenticated()
        }
        .onAppear {
            if appEnv.auth.isAuthenticated {
                finishAuthenticated()
            }
        }
    }

    // MARK: - Form

    @ViewBuilder
    private var formContent: some View {
        Text(String(localized: "Enter your email and password. We'll create your account if you're new."))
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 16)

        VStack(spacing: 10) {
            TextField(String(localized: "Email"), text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .authFieldStyle()

            AuthPasswordField(placeholder: String(localized: "Password"), text: $password)
        }

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

        Button {
            submit()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(String(localized: "Continue"))
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(!canSubmit)
        .padding(.top, 28)

        statusMessages
    }

    @ViewBuilder
    private var pendingConfirmationContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "Check your email to confirm your account before signing in."))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text("The confirmation link expires after a limited time. If it expires, tap Resend confirmation email.")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(String(localized: "After confirming in the browser, tap I've confirmed — Sign in, or use Open YOLO App on that page."))
                .font(Theme.FontToken.inter(11))
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
            signInAfterConfirmation()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(String(localized: "I've confirmed — Sign in"))
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(isLoading || AppConfig.useMock || password.count < AuthFormSupport.minimumPasswordLength)
        .padding(.top, 20)

        Button {
            resendConfirmation()
        } label: {
            Text(String(localized: "Resend confirmation email"))
                .font(Theme.FontToken.inter(13, weight: .medium))
        }
        .foregroundStyle(Theme.ColorToken.accent)
        .disabled(isLoading || AppConfig.useMock)
        .padding(.top, 16)

        Button(String(localized: "Back")) {
            pendingEmailConfirmation = false
            clearMessages()
        }
        .font(Theme.FontToken.inter(13, weight: .medium))
        .foregroundStyle(Theme.ColorToken.textMuted)
        .padding(.top, 12)

        statusMessages
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

    // MARK: - Derived

    private var trimmedEmail: String {
        AuthFormSupport.trimmedEmail(email)
    }

    private var canSubmit: Bool {
        !isLoading
            && !AppConfig.useMock
            && AuthFormSupport.isValidEmail(trimmedEmail)
            && password.count >= AuthFormSupport.minimumPasswordLength
    }

    // MARK: - Actions

    private func submit() {
        clearMessages()

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

        Task {
            isLoading = true
            defer { isLoading = false }

            // 1. Try to sign in an existing account.
            do {
                _ = try await SupabaseManager.shared.auth.signIn(email: trimmedEmail, password: password)
                TelemetryService.shared.logEvent("sign_in")
                finishAuthenticated()
                return
            } catch {
                let description = error.localizedDescription.lowercased()
                if description.contains("email not confirmed") {
                    pendingEmailConfirmation = true
                    infoMessage = String(localized: "Check your email and tap the confirmation link to finish signing in.")
                    return
                }
                // Only "invalid credentials" means the account may not exist yet — fall through to sign-up.
                guard description.contains("invalid login credentials") else {
                    errorMessage = AuthFormSupport.errorMessage(for: error)
                    return
                }
            }

            // 2. No existing session: auto-register.
            await autoRegister()
        }
    }

    private func autoRegister() async {
        do {
            let response = try await SupabaseManager.shared.auth.signUp(
                email: trimmedEmail,
                password: password,
                redirectTo: AppConfig.emailConfirmationRedirectURL
            )

            // Obfuscated user with no identities → email already registered, so the earlier
            // sign-in failure was a wrong password rather than a missing account.
            if AuthFormSupport.isAlreadyRegisteredUser(response.user) {
                errorMessage = String(localized: "Incorrect email or password. Please try again.")
                return
            }

            TelemetryService.shared.logEvent("sign_up")

            if response.session != nil {
                finishAuthenticated()
                return
            }

            pendingEmailConfirmation = true
            infoMessage = String(localized: "Account created. Check your email and tap the confirmation link.")
        } catch {
            errorMessage = AuthFormSupport.errorMessage(for: error)
        }
    }

    /// After confirming on the web page, user can sign in with the same password without deep link.
    private func signInAfterConfirmation() {
        clearMessages()
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                _ = try await SupabaseManager.shared.auth.signIn(email: trimmedEmail, password: password)
                TelemetryService.shared.logEvent("sign_in_after_email_confirm")
                finishAuthenticated()
            } catch {
                let description = error.localizedDescription.lowercased()
                if description.contains("email not confirmed") {
                    errorMessage = String(localized: "Email not confirmed yet. Open the confirmation link in your email, then try again.")
                } else {
                    errorMessage = AuthFormSupport.errorMessage(for: error)
                }
            }
        }
    }

    private func resendConfirmation() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                try await SupabaseManager.shared.auth.resend(
                    email: trimmedEmail,
                    type: .signup,
                    emailRedirectTo: AppConfig.emailConfirmationRedirectURL
                )
                infoMessage = String(localized: "Confirmation email sent. Check your inbox.")
            } catch {
                errorMessage = AuthFormSupport.errorMessage(for: error)
            }
        }
    }

    private func finishAuthenticated() {
        onAuthenticated()
        dismiss()
    }

    private func clearMessages() {
        errorMessage = nil
        infoMessage = nil
    }
}

#Preview {
    EmailAuthSheet(onAuthenticated: {})
        .environment(AppEnvironment())
}
