import SwiftUI
import UIKit

struct MembershipCenterView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var showHistory = false
    @State private var showRefund = false
    @State private var showUpgrade = false

    private var purchase: PurchaseService { appEnv.purchase }
    private var prefs: UserPreferencesStore { appEnv.preferences }

    private var displayPlan: MembershipPlan? {
        if let planId = prefs.subscriptionPlanId,
           let plan = purchase.availablePlans.first(where: { $0.id == planId }) {
            return plan
        }
        if prefs.isOverrideGrantActive || prefs.isMembershipActive {
            return purchase.availablePlans.first(where: { $0.planType == .subscription })
        }
        return nil
    }

    /// Expiry to display: an admin grant uses its own expiry (nil = lifetime), otherwise the
    /// RevenueCat subscription expiry.
    private var effectiveMembershipExpiry: Date? {
        prefs.effectiveMembershipExpiry
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                subscriptionStatusCard
                if let plan = displayPlan, !plan.featureLines.isEmpty {
                    benefitsSection(plan: plan)
                }
                actionsSection
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle(String(localized: "Membership"))
        .navigationBarTitleDisplayMode(.inline)
        .task { await appEnv.refreshRemoteMembershipState() }
        .onChange(of: appEnv.membershipRevision) { _, _ in }
        .navigationDestination(isPresented: $showHistory) {
            PurchaseHistoryView()
                .environment(appEnv)
        }
        .sheet(isPresented: $showRefund) {
            RefundRequestView()
                .environment(appEnv)
        }
        .sheet(isPresented: $showUpgrade) {
            // Generic upgrade sheet — no specific attraction context
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Text(String(localized: "Choose a membership plan"))
                            .font(Theme.FontToken.playfair(20, weight: .semibold))
                            .padding(.top, 20)
                        ForEach(purchase.availablePlans.filter { $0.planType == .subscription }) { plan in
                            PlanSummaryRow(plan: plan) {
                                showUpgrade = false
                            }
                            .environment(appEnv)
                        }
                    }
                    .padding(Theme.screenPadding)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "Close")) { showUpgrade = false }
                    }
                }
            }
        }
    }

    // MARK: - Subscription status

    private var subscriptionStatusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            if purchase.isMembershipBanned {
                Text(String(localized: "Membership suspended"))
                    .font(Theme.FontToken.inter(14, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.warning)
                Text(String(localized: "Your access has been suspended. Contact support if you believe this is a mistake."))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            } else if purchase.isProActive {
                HStack(spacing: 8) {
                    Text("✨")
                    Text(displayPlan?.displayName
                         ?? purchase.displayMembershipPlanName())
                        .font(Theme.FontToken.playfair(18, weight: .semibold))
                }

                if let expires = effectiveMembershipExpiry {
                    Text(String(localized: "Valid until: ") + expires.formatted(date: .long, time: .omitted))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    if let days = Calendar.current.dateComponents([.day], from: .now, to: expires).day, days <= 7 {
                        Text(String(format: String(localized: "Renews in %lld days"), days))
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.warning)
                    }
                } else {
                    Text(String(localized: "Lifetime access"))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.accent)
                }

                if prefs.membershipOverrideKind != .grant {
                    Button {
                        if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text(String(localized: "Manage in App Store →"))
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text(String(localized: "No active membership"))
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Text(String(localized: "Unlock all attraction guides, text content, and more."))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Button {
                    showUpgrade = true
                } label: {
                    Text(String(localized: "View Plans →"))
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Theme.ColorToken.accent)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.ColorToken.backgroundSubtle)
    }

    // MARK: - Benefits

    private func benefitsSection(plan: MembershipPlan) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "Your benefits"))
                .font(Theme.FontToken.inter(13, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textMuted)
            ForEach(plan.featureLines, id: \.self) { line in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.ColorToken.accent)
                        .font(.system(size: 14))
                    Text(line)
                        .font(Theme.FontToken.inter(13))
                }
            }
        }
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(spacing: 0) {
            Button {
                showHistory = true
            } label: {
                settingsRow(String(localized: "Purchase History"))
            }
            .buttonStyle(.plain)

            Button {
                showRefund = true
            } label: {
                settingsRow(String(localized: "Request a Refund"))
            }
            .buttonStyle(.plain)
        }
        .overlay(Rectangle().stroke(Theme.ColorToken.borderLight, lineWidth: 1))
    }

    private func settingsRow(_ label: String) -> some View {
        HStack {
            Text(label)
                .font(Theme.FontToken.inter(14))
            Spacer()
            Text("›")
                .foregroundStyle(Theme.ColorToken.textGhost)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}

// Simple plan row for the upgrade sheet (no specific attraction context)
private struct PlanSummaryRow: View {
    @Environment(AppEnvironment.self) private var appEnv
    let plan: MembershipPlan
    let onPurchased: () -> Void

    @State private var showLogin = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(plan.displayName)
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Spacer()
                Text(plan.priceLabel)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Button {
                if !appEnv.auth.isAuthenticated, !AppConfig.useMock {
                    showLogin = true
                    return
                }
                Task {
                    await appEnv.purchase.purchase(plan: plan)
                    onPurchased()
                }
            } label: {
                Text(String(localized: "Subscribe"))
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(plan.isBestValue ? Theme.ColorToken.textPrimary : Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)
            .disabled(appEnv.purchase.isPurchasing)
        }
        .padding(14)
        .overlay(Rectangle().stroke(
            plan.isBestValue ? Theme.ColorToken.accent : Theme.ColorToken.borderLight, lineWidth: 1
        ))
        .loginSheet(isPresented: $showLogin, appEnv: appEnv)
    }
}
