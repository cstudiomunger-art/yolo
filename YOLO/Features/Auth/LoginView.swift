import Supabase
import SwiftUI

struct LoginView: View {
    private enum AuthMode: String, CaseIterable, Identifiable {
        case signIn
        case signUp

        var id: String { rawValue }

        var title: String {
            switch self {
            case .signIn: String(localized: "Sign In")
            case .signUp: String(localized: "Sign Up")
            }
        }
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

    var body: some View {
        Form {
            if AppConfig.useMock {
                Section {
                    Text(String(localized: "Mock mode is active. Configure SUPABASE_URL and SUPABASE_ANON_KEY in Secrets.xcconfig."))
                        .foregroundStyle(.orange)
                }
            }

            if pendingEmailConfirmation {
                pendingConfirmationSection
            } else {
                authFormSections
            }
        }
        .navigationTitle(mode == .signIn ? String(localized: "Sign In") : String(localized: "Sign Up"))
    }

    @ViewBuilder
    private var authFormSections: some View {
        Section {
            Picker(String(localized: "Account"), selection: $mode) {
                ForEach(AuthMode.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: mode) { _, _ in
                clearMessages()
                confirmPassword = ""
                suggestSignIn = false
            }
        }

        Section {
            TextField(String(localized: "Email"), text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            SecureField(String(localized: "Password"), text: $password)
                .textContentType(mode == .signUp ? .newPassword : .password)

            if mode == .signUp {
                SecureField(String(localized: "Confirm password"), text: $confirmPassword)
                    .textContentType(.newPassword)
            }

            if mode == .signIn, !AppConfig.useMock {
                NavigationLink(String(localized: "Forgot password?")) {
                    ForgotPasswordView(initialEmail: trimmedEmail)
                }
                .font(Theme.FontToken.inter(12))
            }
        }

        if mode == .signUp {
            Section {
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

                    legalConsentLabel
                }
            }
        }

        Section {
            Button(primaryActionTitle) {
                submit()
            }
            .disabled(!canSubmit)
        }

        if suggestSignIn {
            Section {
                Button(String(localized: "Go to sign in")) {
                    mode = .signIn
                    suggestSignIn = false
                    clearMessages()
                }
            }
        }

        if isLoading {
            Section {
                ProgressView()
            }
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

    @ViewBuilder
    private var pendingConfirmationSection: some View {
        Section {
            Text(String(localized: "Check your email to confirm your account before signing in."))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(trimmedEmail)
                .font(Theme.FontToken.inter(13, weight: .medium))
        }

        Section {
            Button(String(localized: "Resend confirmation email")) {
                resendConfirmation()
            }
            .disabled(isLoading || AppConfig.useMock)

            Button(String(localized: "Back to sign in")) {
                pendingEmailConfirmation = false
                mode = .signIn
                clearMessages()
            }
        }

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

    private var legalConsentLabel: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(String(localized: "I agree to the "))
                .font(Theme.FontToken.inter(11))
            NavigationLink(String(localized: "Terms")) {
                LegalDocumentView(kind: .terms)
            }
            .font(Theme.FontToken.inter(11, weight: .medium))
            Text(String(localized: " and "))
                .font(Theme.FontToken.inter(11))
            NavigationLink(String(localized: "Privacy Policy")) {
                LegalDocumentView(kind: .privacy)
            }
            .font(Theme.FontToken.inter(11, weight: .medium))
        }
    }

    private var primaryActionTitle: String {
        mode == .signIn ? String(localized: "Sign In") : String(localized: "Sign Up")
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
