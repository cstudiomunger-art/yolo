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
            ScrollView {
                VStack(spacing: 0) {
                    if didUpdate {
                        Text(String(localized: "Password updated successfully."))
                            .font(Theme.FontToken.inter(13, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 24)
                    } else {
                        inputContent
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .background(Theme.ColorToken.background)
            .navigationTitle(String(localized: "New password"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheetDragToDismiss()
    }

    @ViewBuilder
    private var inputContent: some View {
        Text(String(localized: "Choose a new password for your account."))
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 16)

        VStack(spacing: 10) {
            SecureField(String(localized: "New password"), text: $password)
                .textContentType(.newPassword)
                .authFieldStyle()
            SecureField(String(localized: "Confirm password"), text: $confirmPassword)
                .textContentType(.newPassword)
                .authFieldStyle()
        }

        Button {
            updatePassword()
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Text(String(localized: "Update password"))
            }
        }
        .buttonStyle(AuthPrimaryButtonStyle())
        .disabled(!canSubmit)
        .padding(.top, 20)

        if let errorMessage {
            Text(errorMessage)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
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
