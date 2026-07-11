import SwiftUI

struct InviteCodeRedeemSheet: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var initialCode: String = ""

    @State private var code = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Enter your invite code to unlock complimentary membership access."))
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                TextField(String(localized: "Invite code"), text: $code)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .font(Theme.FontToken.inter(16, weight: .medium).monospaced())
                    .padding(12)
                    .background(Theme.ColorToken.backgroundSubtle)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.small, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small, style: .continuous)
                            .stroke(Theme.ColorToken.borderLight, lineWidth: 1)
                    )
                    .disabled(isSubmitting || successMessage != nil)
                    .onChange(of: code) { _, newValue in
                        let normalized = InviteCodeService.normalize(newValue)
                        if normalized != newValue { code = normalized }
                    }

                if let errorMessage {
                    Text(errorMessage)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(.red)
                }

                if let successMessage {
                    Text(successMessage)
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.success)
                }

                Button {
                    Task { await submit() }
                } label: {
                    Group {
                        if isSubmitting {
                            ProgressView().tint(Theme.ColorToken.onSurfaceEmphasis)
                        } else {
                            Text(String(localized: "Redeem"))
                                .font(Theme.FontToken.inter(13, weight: .medium))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.ColorToken.surfaceEmphasis)
                    .foregroundStyle(Theme.ColorToken.onSurfaceEmphasis)
                }
                .buttonStyle(.plain)
                .disabled(isSubmitting || code.count < 6 || successMessage != nil)

                Spacer()
            }
            .padding(Theme.screenPadding)
            .navigationTitle(String(localized: "Redeem Invite Code"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
            .loginSheet(isPresented: $showLogin, appEnv: appEnv)
            .onAppear {
                TelemetryService.shared.logEvent("invite_redeem_open")
                if !initialCode.isEmpty, code.isEmpty {
                    code = InviteCodeService.normalize(initialCode)
                }
            }
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                guard isAuthenticated else { return }
                showLogin = false
            }
        }
        .sheetDragToDismiss()
    }

    private func submit() async {
        if appEnv.mustSignInForAccountAction {
            showLogin = true
            return
        }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let result = try await InviteCodeService.redeem(code: code)
            await appEnv.refreshRemoteMembershipState()
            successMessage = successText(for: result)
            try? await Task.sleep(for: .seconds(1.2))
            dismiss()
        } catch let err as InviteCodeError {
            errorMessage = err.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func successText(for result: InviteCodeRedeemResult) -> String {
        if result.alreadyLifetime == true {
            return String(localized: "You already have lifetime access.")
        }
        if result.isLifetime == true || result.expiresAt == nil {
            return String(localized: "Lifetime access granted!")
        }
        if let expires = result.expiresAt {
            let formatted = expires.formatted(date: .long, time: .omitted)
            return String(localized: "Member until ") + formatted
        }
        return String(localized: "Invite code redeemed!")
    }
}
