import Supabase
import SwiftUI

struct SetNewPasswordView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(String(localized: "Choose a new password for your account."))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }

                Section {
                    SecureField(String(localized: "New password"), text: $password)
                        .textContentType(.newPassword)
                    SecureField(String(localized: "Confirm password"), text: $confirmPassword)
                        .textContentType(.newPassword)
                }

                Section {
                    Button(String(localized: "Update password")) {
                        updatePassword()
                    }
                    .disabled(!canSubmit)
                }

                if isLoading {
                    Section { ProgressView() }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage).foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(String(localized: "New password"))
        }
    }

    private var canSubmit: Bool {
        password.count >= 6 && password == confirmPassword && !isLoading
    }

    private func updatePassword() {
        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            do {
                try await SupabaseManager.shared.auth.update(
                    user: UserAttributes(password: password)
                )
                appEnv.auth.clearPasswordRecoveryPending()
                TelemetryService.shared.logEvent("password_reset_complete")
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
