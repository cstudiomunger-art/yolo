import SwiftUI
import UIKit

struct RefundRequestView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var reason = ""
    @State private var isSubmitting = false
    @State private var submitted = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                if submitted {
                    submittedSection
                } else {
                    refundOptionsSection
                    inAppRequestSection
                }
            }
            .navigationTitle(String(localized: "Refund Request"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
        }
    }

    // MARK: - Sections

    private var submittedSection: some View {
        Section {
            VStack(spacing: 12) {
                Text("✓")
                    .font(.system(size: 40))
                Text(String(localized: "Request submitted"))
                    .font(Theme.FontToken.playfair(17, weight: .semibold))
                Text(String(localized: "We've received your request. Refunds are typically processed by Apple within 48 hours."))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }

    private var refundOptionsSection: some View {
        Section {
            // Primary: Apple's official refund flow
            Button {
                Task {
                    if let scene = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene }).first {
                        try? await appEnv.purchase.beginRefundRequest(windowScene: scene)
                    }
                }
            } label: {
                Label(
                    String(localized: "Request refund via Apple"),
                    systemImage: "arrow.counterclockwise.circle"
                )
            }

            // Fallback: Apple's web refund page
            Link(
                // swiftlint:disable:next force_unwrapping
                destination: URL(string: "https://reportaproblem.apple.com")!
            ) {
                Label(
                    String(localized: "Report a Problem (Apple)"),
                    systemImage: "safari"
                )
            }
        } header: {
            Text(String(localized: "Official refund channels"))
        } footer: {
            Text(String(localized: "Refunds are processed by Apple. Most requests are resolved within 2 business days."))
                .font(Theme.FontToken.inter(10))
        }
    }

    private var inAppRequestSection: some View {
        Section {
            TextEditor(text: $reason)
                .frame(minHeight: 80)

            if let error {
                Text(error)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.red)
            }

            Button {
                Task { await submitInApp() }
            } label: {
                if isSubmitting {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text(String(localized: "Submit Request"))
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
        } header: {
            Text(String(localized: "Or tell us what happened"))
        } footer: {
            Text(String(localized: "We'll review your request and follow up by email."))
                .font(Theme.FontToken.inter(10))
        }
    }

    // MARK: - Actions

    private func submitInApp() async {
        isSubmitting = true
        error = nil
        defer { isSubmitting = false }
        await appEnv.purchase.submitRefundRequest(
            planId: appEnv.preferences.subscriptionPlanId,
            reason: reason.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        submitted = true
    }
}

