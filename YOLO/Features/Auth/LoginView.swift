import Supabase
import SwiftUI

struct LoginView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var infoMessage: String?
    @State private var acceptedLegal = false

    var body: some View {
        Form {
            if AppConfig.useMock {
                Section {
                    Text("当前为 Mock 模式，未连接 Supabase。请在 Secrets.xcconfig 中配置 SUPABASE_URL 与 SUPABASE_ANON_KEY。")
                        .foregroundStyle(.orange)
                }
            }

            Section {
                TextField("邮箱", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("密码", text: $password)
                    .textContentType(.password)

                if !AppConfig.useMock {
                    NavigationLink(String(localized: "Forgot password?")) {
                        ForgotPasswordView()
                    }
                    .font(Theme.FontToken.inter(12))
                }
            }

            Section {
                Toggle(isOn: $acceptedLegal) {
                    legalConsentLabel
                }
            }

            Section {
                Button("登录") {
                    signIn()
                }
                .disabled(cannotSubmitSignIn)

                Button("注册") {
                    signUp()
                }
                .disabled(cannotSubmitSignUp)
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
        .navigationTitle("登录")
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

    private var cannotSubmitSignIn: Bool {
        email.isEmpty || password.isEmpty || isLoading || AppConfig.useMock
    }

    private var cannotSubmitSignUp: Bool {
        cannotSubmitSignIn || !acceptedLegal
    }

    private func signIn() {
        runAuth {
            _ = try await SupabaseManager.shared.auth.signIn(email: email, password: password)
            TelemetryService.shared.logEvent("sign_in")
            dismiss()
        }
    }

    private func signUp() {
        runAuth {
            let response = try await SupabaseManager.shared.auth.signUp(email: email, password: password)
            if response.session != nil {
                TelemetryService.shared.logEvent("sign_up")
                dismiss()
            } else {
                infoMessage = "注册成功。请查收确认邮件并点击链接后，再使用「登录」。"
            }
        }
    }

    private func runAuth(_ action: @escaping () async throws -> Void) {
        Task {
            isLoading = true
            errorMessage = nil
            infoMessage = nil
            defer { isLoading = false }

            do {
                try await action()
            } catch {
                errorMessage = authErrorMessage(for: error)
            }
        }
    }

    private func authErrorMessage(for error: Error) -> String {
        let description = error.localizedDescription
        if description.localizedCaseInsensitiveContains("email not confirmed") {
            return "邮箱尚未确认。请查收注册确认邮件后再登录。"
        }
        if description.localizedCaseInsensitiveContains("invalid login credentials") {
            return "邮箱或密码错误，请重试。"
        }
        if description.localizedCaseInsensitiveContains("rate limit") {
            return "操作过于频繁，请稍后再试。"
        }
        return description
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(AppEnvironment())
    }
}
