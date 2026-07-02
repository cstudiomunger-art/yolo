import SwiftUI

/// Paywall sheet — editorial "Unlock the Guide" design.
/// Plans are selectable (radio); a single dynamic CTA reflects the selected option.
struct MembershipPlansView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let attraction: Attraction
    var guide: AudioGuide?
    /// Single-purchase price tier (membership_plans id of a one_time_attraction). nil → default tier.
    var priceTierId: String?
    /// Id to unlock on single purchase. nil → attraction.id (sub-areas pass their own id).
    var purchaseTargetId: String?
    /// Title shown in the sheet header. nil → attraction.name (sub-areas pass their name).
    var displayTitle: String?
    var onPurchaseComplete: (() -> Void)?

    @State private var selectedId: String?
    @State private var showLogin = false
    @State private var errorMessage: String?

    // MARK: - Derived plan lists

    private var subscriptions: [MembershipPlan] {
        appEnv.purchase.availablePlans.filter { $0.planType == .subscription }
    }

    private var singleAttractionPlan: MembershipPlan? {
        appEnv.purchase.singlePlan(forTier: priceTierId)
    }

    private var headerTitle: String { displayTitle ?? attraction.name }
    private var unlockTargetId: String { purchaseTargetId ?? attraction.id }

    /// Ordered options shown as selectable cards: subscriptions first, then single-attraction.
    /// The single-attraction plan is a universal product that unlocks whichever attraction is open.
    private var options: [MembershipPlan] {
        var list = subscriptions
        if let single = singleAttractionPlan {
            list.append(single)
        }
        return list
    }

    private var selectedPlan: MembershipPlan? {
        options.first { $0.id == selectedId }
    }

    private var branding: AppBranding { appEnv.contentMode.branding }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        previewBar
                        header
                        if appEnv.purchase.isLoadingPlans && options.isEmpty {
                            loadingView
                        } else if options.isEmpty {
                            emptyView
                        } else {
                            optionsList
                        }
                        if let errorMessage {
                            Text(errorMessage)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(.red)
                                .padding(.horizontal, Theme.screenPadding)
                                .padding(.top, 8)
                        }
                        footerLinks
                        // bottom spacer so content isn't hidden behind the sticky CTA
                        Color.clear.frame(height: 96)
                    }
                }
                stickyCTA
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }
            }
            .loginSheet(isPresented: $showLogin, appEnv: appEnv)
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                guard isAuthenticated else { return }
                showLogin = false
            }
            .task {
                if options.isEmpty { await appEnv.purchase.loadPlans() }
                ensureSelection()
            }
            .onChange(of: appEnv.purchase.availablePlans.count) { _, _ in ensureSelection() }
        }
        .presentationDetents([.large])
    }

    // MARK: - Preview-ended bar

    private var previewBar: some View {
        HStack(spacing: 9) {
            Text("🔒").font(.system(size: 13))
            Text(previewBarText)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.vertical, 10)
        .background(Theme.ColorToken.warningBackground)
        .overlay(alignment: .leading) {
            Rectangle().fill(Theme.ColorToken.warning).frame(width: 3)
        }
        .padding(.bottom, 18)
    }

    private var previewBarText: AttributedString {
        var s = AttributedString(String(localized: "Free preview ended. ") )
        s.foregroundColor = Theme.ColorToken.textPrimary
        var rest = AttributedString(String(localized: "Unlock the full Guide to keep listening & reading."))
        rest.foregroundColor = Theme.ColorToken.textSecondary
        return s + rest
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(String(localized: "UNLOCK THE GUIDE"))
                .font(Theme.FontToken.inter(9, weight: .medium))
                .tracking(1.2)
                .foregroundStyle(Theme.ColorToken.accent)
            Text(headerTitle)
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text(branding.paywall.previewLine(duration: guideDurationLabel))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .padding(.top, 1)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.bottom, 18)
    }

    // MARK: - Options

    private var optionsList: some View {
        VStack(spacing: 10) {
            ForEach(options) { plan in
                PlanOptionCard(
                    plan: plan,
                    isSelected: plan.id == selectedId,
                    isSingle: plan.planType == .oneTimeAttraction
                ) {
                    selectedId = plan.id
                }
            }
        }
        .padding(.horizontal, Theme.screenPadding)
    }

    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
    }

    private var emptyView: some View {
        VStack(spacing: 10) {
            Text(String(localized: "No plans available. Please try again later."))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
            Button(String(localized: "Retry")) {
                Task { await appEnv.purchase.loadPlans(); ensureSelection() }
            }
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }

    // MARK: - Footer links

    private var footerLinks: some View {
        VStack(spacing: 10) {
            Button(branding.paywall.restore) {
                if appEnv.mustSignInForAccountAction {
                    showLogin = true
                    return
                }
                Task { try? await appEnv.purchase.restorePurchases() }
            }
            .font(Theme.FontToken.inter(11))
            .foregroundStyle(Theme.ColorToken.textMuted)

            Text(branding.paywall.footnote)
                .font(Theme.FontToken.inter(9))
                .foregroundStyle(Theme.ColorToken.textGhost)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 16)
    }

    // MARK: - Sticky dynamic CTA

    private var stickyCTA: some View {
        VStack(spacing: 0) {
            Button {
                Task { await purchaseSelected() }
            } label: {
                VStack(spacing: 3) {
                    if appEnv.purchase.isPurchasing {
                        ProgressView().tint(.white)
                    } else {
                        Text(ctaMain)
                            .font(Theme.FontToken.inter(13, weight: .medium))
                            .tracking(0.6)
                            .foregroundStyle(.white)
                        if !ctaSub.isEmpty {
                            Text(ctaSub)
                                .font(Theme.FontToken.inter(9))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)
            .disabled(appEnv.purchase.isPurchasing || selectedPlan == nil)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 10)
            .padding(.bottom, 12)
        }
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private var ctaMain: String {
        guard let p = selectedPlan else { return String(localized: "Continue") }
        if p.planType == .oneTimeAttraction {
            return String(format: String(localized: "Unlock Guide · %@"), p.priceLabel)
        }
        if p.freeTrialDays > 0 {
            return String(localized: "Start Free Trial")
        }
        return String(format: String(localized: "Subscribe · %@"), p.priceLabel)
    }

    private var ctaSub: String {
        guard let p = selectedPlan else { return "" }
        if p.planType == .oneTimeAttraction {
            return String(format: String(localized: "one-time · %@"), headerTitle)
        }
        if p.freeTrialDays > 0 {
            return String(format: String(localized: "then %@ · cancel anytime"), p.priceLabel)
        }
        return String(localized: "cancel anytime")
    }

    // MARK: - Actions

    private func ensureSelection() {
        guard selectedId == nil || !options.contains(where: { $0.id == selectedId }) else { return }
        selectedId = options.first(where: { $0.isBestValue })?.id
            ?? subscriptions.first?.id
            ?? options.first?.id
    }

    private func purchaseSelected() async {
        guard let plan = selectedPlan else { return }
        if !appEnv.auth.isAuthenticated, !AppConfig.useMock {
            showLogin = true
            return
        }
        errorMessage = nil
        if plan.planType == .oneTimeAttraction {
            await appEnv.purchase.purchaseSingleAttraction(unlockTargetId, plan: plan)
        } else {
            await appEnv.purchase.purchase(plan: plan)
        }
        if appEnv.purchase.lastError == nil {
            dismiss()
            onPurchaseComplete?()
        } else {
            errorMessage = appEnv.purchase.lastError
        }
    }

    private var guideDurationLabel: String {
        if let guide { return "\(max(guide.durationSeconds / 60, 1)) min" }
        return "\(max(attraction.audioGuideCount * 12, 12)) min"
    }
}

// MARK: - Plan Option Card (selectable radio)

private struct PlanOptionCard: View {
    let plan: MembershipPlan
    let isSelected: Bool
    let isSingle: Bool
    let onTap: () -> Void

    private var accent: Color {
        isSingle ? Theme.ColorToken.textPrimary : Theme.ColorToken.accent
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 11) {
                    radio
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(plan.displayName)
                                .font(Theme.FontToken.playfair(16, weight: .semibold))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                            Spacer()
                            Text(plan.priceLabel)
                                .font(Theme.FontToken.playfair(17, weight: .semibold))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                                .layoutPriority(1)
                        }
                        if let desc = subtitle {
                            Text(desc)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        if plan.freeTrialDays > 0 {
                            Text(String(format: String(localized: "%lld-day free trial"), plan.freeTrialDays))
                                .font(Theme.FontToken.inter(8, weight: .medium))
                                .tracking(0.5)
                                .foregroundStyle(Theme.ColorToken.success)
                                .padding(.horizontal, 6).padding(.vertical, 1)
                                .overlay(Rectangle().stroke(Theme.ColorToken.success, lineWidth: 1))
                                .padding(.top, 4)
                        }
                    }
                }

                // Expanded feature rows when selected
                if isSelected, !plan.featureLines.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(plan.featureLines, id: \.self) { line in
                            HStack(alignment: .top, spacing: 8) {
                                Text("✓")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Theme.ColorToken.accent)
                                Text(line)
                                    .font(Theme.FontToken.inter(11))
                                    .foregroundStyle(Theme.ColorToken.textSecondary)
                            }
                        }
                    }
                    .padding(.top, 13)
                    .padding(.leading, 26)
                }
            }
            .padding(14)
            .overlay(
                Rectangle().stroke(
                    isSelected ? accent : Theme.ColorToken.borderLight,
                    lineWidth: isSelected ? 1.5 : 1
                )
            )
            .overlay(alignment: .topTrailing) {
                if plan.isBestValue {
                    Text(String(localized: "BEST VALUE"))
                        .font(Theme.FontToken.inter(8, weight: .medium))
                        .tracking(0.8)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7).padding(.vertical, 2)
                        .background(Theme.ColorToken.accent)
                        .offset(x: -14, y: -8)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var radio: some View {
        Circle()
            .strokeBorder(isSelected ? accent : Theme.ColorToken.textGhost, lineWidth: 1)
            .frame(width: 16, height: 16)
            .overlay {
                if isSelected {
                    Circle().fill(accent).frame(width: 8, height: 8)
                }
            }
            .padding(.top, 2)
    }

    private var subtitle: String? {
        if isSingle {
            return String(localized: "One-time · this attraction · yours forever")
        }
        // For subscriptions, prefer a 1-line value hint from featureLines when collapsed
        if !isSelected, let first = plan.featureLines.first {
            return first
        }
        return nil
    }
}
