import Supabase
import SwiftUI

struct SetNewPasswordView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var didUpdate = false

    var body: some View {
        NavigationStack {
            Form {
                if didUpdate {
                    Section {
                        Text(String(localized: "Password updated successfully."))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                } else {
                    inputSections
                }
            }
            .navigationTitle(String(localized: "New password"))
        }
    }

    @ViewBuilder
    private var inputSections: some View {
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

    private var canSubmit: Bool {
        password.count >= AuthFormSupport.minimumPasswordLength
            && password == confirmPassword
            && !isLoading
    }

    private func updatePassword() {
        guard password == confirmPassword else {
            errorMessage = String(localized: "Passwords do not match.")
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
            errorMessage = nil
            defer { isLoading = false }

            do {
                try await SupabaseManager.shared.auth.update(
                    user: UserAttributes(password: password)
                )
                didUpdate = true
                TelemetryService.shared.logEvent("password_reset_complete")
                try? await Task.sleep(for: .seconds(1.2))
                appEnv.auth.clearPasswordRecoveryPending()
            } catch {
                errorMessage = AuthFormSupport.errorMessage(for: error)
            }
        }
    }
}
