import SwiftUI

/// Paywall sheet — shown when user tries to access locked audio/text content.
/// Displays CMS-driven membership plans, then a single-attraction fallback.
struct MembershipPlansView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let attraction: Attraction
    var guide: AudioGuide?
    var onPurchaseComplete: (() -> Void)?

    @State private var showRefund = false
    @State private var errorMessage: String?

    private var plans: [MembershipPlan] {
        appEnv.purchase.availablePlans.filter { $0.planType == .subscription }
    }

    private var singleAttractionPlan: MembershipPlan? {
        appEnv.purchase.availablePlans.first { $0.planType == .oneTimeAttraction }
    }

    private var branding: AppBranding { appEnv.contentMode.branding }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    plansSection
                    if singleAttractionPlan != nil {
                        singleAttractionSection
                    }
                    if let errorMessage {
                        Text(errorMessage)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(.red)
                    }
                    footerActions
                }
                .padding(Theme.screenPadding)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
            .sheet(isPresented: $showRefund) {
                RefundRequestView()
                    .environment(appEnv)
            }
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(branding.paywall.title(for: attraction.name))
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text(branding.paywall.previewLine(duration: guideDurationLabel))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
    }

    private var plansSection: some View {
        VStack(spacing: 12) {
            if appEnv.purchase.isLoadingPlans {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else if plans.isEmpty {
                Text(String(localized: "No plans available. Please try again later."))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                Button(String(localized: "Retry")) {
                    Task { await appEnv.purchase.loadPlans() }
                }
                .font(Theme.FontToken.inter(12, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
            } else {
                ForEach(plans) { plan in
                    PlanCard(plan: plan) {
                        await purchase(plan: plan)
                    }
                    .disabled(appEnv.purchase.isPurchasing)
                }
            }
        }
    }

    @ViewBuilder
    private var singleAttractionSection: some View {
        if let plan = singleAttractionPlan {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Rectangle()
                        .fill(Theme.ColorToken.borderLight)
                        .frame(height: 1)
                    Text(String(localized: "or"))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .padding(.horizontal, 8)
                    Rectangle()
                        .fill(Theme.ColorToken.borderLight)
                        .frame(height: 1)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "Just this attraction"))
                        .font(Theme.FontToken.inter(13, weight: .medium))
                    Text(plan.priceLabel)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }

                Button {
                    Task { await purchaseSingle(plan: plan) }
                } label: {
                    Text(branding.paywall.singleCta)
                        .font(Theme.FontToken.inter(13, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .disabled(appEnv.purchase.isPurchasing)
            }
        }
    }

    private var footerActions: some View {
        VStack(spacing: 12) {
            Button(branding.paywall.restore) {
                Task { try? await appEnv.purchase.restorePurchases() }
            }
            .font(Theme.FontToken.inter(11))
            .foregroundStyle(Theme.ColorToken.textMuted)

            Button(String(localized: "Request a refund")) {
                showRefund = true
            }
            .font(Theme.FontToken.inter(11))
            .foregroundStyle(Theme.ColorToken.textMuted)

            Button(branding.paywall.maybeLater) { dismiss() }
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .frame(maxWidth: .infinity)

            Text(branding.paywall.footnote)
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textGhost)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Actions

    private func purchase(plan: MembershipPlan) async {
        errorMessage = nil
        await appEnv.purchase.purchase(plan: plan)
        if appEnv.purchase.lastError == nil {
            dismiss()
            onPurchaseComplete?()
        } else {
            errorMessage = appEnv.purchase.lastError
        }
    }

    private func purchaseSingle(plan: MembershipPlan) async {
        errorMessage = nil
        await appEnv.purchase.purchaseSingleAttraction(attraction.id, plan: plan)
        if appEnv.purchase.lastError == nil {
            dismiss()
            onPurchaseComplete?()
        } else {
            errorMessage = appEnv.purchase.lastError
        }
    }

    // MARK: - Helpers

    private var guideDurationLabel: String {
        if let guide { return "\(max(guide.durationSeconds / 60, 1)) min" }
        return "\(max(attraction.audioGuideCount * 12, 12)) min"
    }
}

// MARK: - Plan Card

private struct PlanCard: View {
    @Environment(AppEnvironment.self) private var appEnv
    let plan: MembershipPlan
    let onPurchase: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                if plan.isBestValue {
                    Text(String(localized: "★ Best Value"))
                        .font(Theme.FontToken.inter(9, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
                Spacer()
                Text(plan.priceLabel)
                    .font(Theme.FontToken.inter(12, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }

            Text(plan.localizedName(preferChinese: appEnv.preferences.appLanguage == .chinese))
                .font(Theme.FontToken.playfair(16, weight: .semibold))

            VStack(alignment: .leading, spacing: 3) {
                ForEach(plan.featureLines, id: \.self) { line in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                            .foregroundStyle(Theme.ColorToken.accent)
                        Text(line)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                    }
                }
            }

            Button {
                Task { await onPurchase() }
            } label: {
                if appEnv.purchase.isPurchasing {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                } else {
                    Text(String(localized: "Subscribe →"))
                        .font(Theme.FontToken.inter(13, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(plan.isBestValue ? Theme.ColorToken.textPrimary : Theme.ColorToken.accent)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .overlay(
            Rectangle().stroke(
                plan.isBestValue ? Theme.ColorToken.accent : Theme.ColorToken.borderLight,
                lineWidth: plan.isBestValue ? 1.5 : 1
            )
        )
    }
}
