import Foundation
import Observation
import Supabase
import UIKit

/// Manages IAP purchases, entitlement state, and membership plan data.
///
/// Current implementation runs in "simulation mode" — purchases are recorded
/// locally and synced to Supabase without going through a payment sheet.
/// When the RevenueCat SDK is added, replace the bodies of `purchase()`,
/// `purchaseSingleAttraction()`, and `restorePurchases()` with RC calls.
/// All callers and UI code are written against this service's interface and
/// require no changes after the RC swap.
@Observable
@MainActor
final class PurchaseService {

    // MARK: - State

    private(set) var availablePlans: [MembershipPlan] = []
    private(set) var isPurchasing = false
    private(set) var isLoadingPlans = false
    private(set) var lastError: String?

    // MARK: - Private

    private weak var preferences: UserPreferencesStore?
    private weak var profileSync: ProfileSyncService?
    private weak var auth: AuthSessionStore?

    func bind(preferences: UserPreferencesStore, auth: AuthSessionStore, profileSync: ProfileSyncService) {
        self.preferences = preferences
        self.auth = auth
        self.profileSync = profileSync
    }

    // MARK: - Plan Loading

    /// Loads membership plans from Supabase (if configured) with local fallback.
    func loadPlans() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            availablePlans = Self.bundledFallbackPlans
            return
        }
        isLoadingPlans = true
        defer { isLoadingPlans = false }
        do {
            let plans: [MembershipPlan] = try await SupabaseManager.shared
                .from("membership_plans")
                .select()
                .eq("is_active", value: true)
                .order("display_order", ascending: true)
                .execute()
                .value
            availablePlans = plans.isEmpty ? Self.bundledFallbackPlans : plans
        } catch {
            availablePlans = Self.bundledFallbackPlans
        }
    }

    // MARK: - Access Flags

    /// The access flags for the user's current subscription plan, if any.
    var currentAccessFlags: MembershipPlan.AccessFlags {
        guard let planId = preferences?.subscriptionPlanId else { return .none }
        return availablePlans.first(where: { $0.id == planId })?.accessFlags ?? .none
    }

    /// Whether the user has an active (non-expired) subscription.
    var isProActive: Bool {
        guard let prefs = preferences else { return false }
        // simulateProPurchase is only effective in mock/dev mode, never in production
        if prefs.simulateProPurchase && AppConfig.useMock { return true }
        return prefs.isSubscriptionActive
    }

    func hasAccess(to flag: KeyPath<MembershipPlan.AccessFlags, Bool>, for attractionId: String? = nil) -> Bool {
        if isProActive { return currentAccessFlags[keyPath: flag] }
        if let id = attractionId, preferences?.purchasedAttractionIds.contains(id) == true {
            // Single-attraction purchases get: audio + text + visitor tips
            let singleFlags: [KeyPath<MembershipPlan.AccessFlags, Bool>] = [
                \.audioGuides, \.textContent, \.visitorTips
            ]
            return singleFlags.contains(flag)
        }
        return false
    }

    // MARK: - Purchase (simulation — swap bodies for RevenueCat calls)

    /// Purchase a subscription plan.
    /// - When RevenueCat is integrated: call `Purchases.shared.purchase(package:)`.
    func purchase(plan: MembershipPlan) async {
        guard !isPurchasing else { return }
        isPurchasing = true
        lastError = nil
        defer { isPurchasing = false }

        // MARK: RevenueCat hook
        // Replace this block with:
        //   let result = try await Purchases.shared.purchase(package: rcPackage)
        //   applyCustomerInfo(result.customerInfo)
        //   return
        // ─────────────────────────────────────────
        guard let prefs = preferences else { return }
        prefs.subscriptionPlanId = plan.id
        prefs.subscriptionExpiresAt = expiryDate(for: plan)
        // Only set simulateProPurchase in mock/dev mode — production uses isSubscriptionActive
        if AppConfig.useMock {
            prefs.simulateProPurchase = true
        }
        await profileSync?.schedulePush()
    }

    /// Purchase access to a single attraction (non-consumable).
    /// - When RevenueCat is integrated: call `Purchases.shared.purchase(package:)`.
    func purchaseSingleAttraction(_ attractionId: String, plan: MembershipPlan) async {
        guard !isPurchasing else { return }
        isPurchasing = true
        lastError = nil
        defer { isPurchasing = false }

        // MARK: RevenueCat hook
        // Replace this block with RC purchase + post attractionId to Supabase.
        // ─────────────────────────────────────────
        preferences?.purchaseAttraction(attractionId)
        await profileSync?.schedulePush()
    }

    /// Restore previous purchases.
    /// - When RevenueCat is integrated: call `Purchases.shared.restorePurchases()`.
    func restorePurchases() async throws {
        // MARK: RevenueCat hook
        // Replace with: let info = try await Purchases.shared.restorePurchases()
        //               applyCustomerInfo(info)
        // ─────────────────────────────────────────
        // Simulation: reload from Supabase profile
        guard let auth, auth.isAuthenticated else { return }
        await profileSync?.syncAfterSignIn()
    }

    // MARK: - Refund

    /// Initiates a refund request via Apple / RevenueCat (iOS 15+).
    /// - When RevenueCat is integrated: call `Purchases.shared.beginRefundRequest(forEntitlement:)`.
    func beginRefundRequest(windowScene: UIWindowScene) async throws {
        // MARK: RevenueCat hook
        // Replace with: try await Purchases.shared.beginRefundRequest(forEntitlement: "pro_access")
        // ─────────────────────────────────────────
        // Fallback: open App Store manage subscriptions
        if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
            await UIApplication.shared.open(url)
        }
    }

    /// Submits an in-app refund request record to Supabase.
    func submitRefundRequest(planId: String?, reason: String) async {
        guard let userId = auth?.userId else { return }
        guard AppConfig.isSupabaseConfigured else { return }
        let row: [String: String?] = [
            "user_id": userId.uuidString,
            "plan_id": planId,
            "reason": reason,
            "status": "pending",
        ]
        _ = try? await SupabaseManager.shared
            .from("user_refund_requests")
            .insert(row)
            .execute()
    }

    // MARK: - RevenueCat Login / Logout hooks

    /// Called after Supabase sign-in to associate the RC customer with the user.
    /// - When RevenueCat is integrated: call `Purchases.shared.logIn(userId.uuidString)`.
    func login(userId: UUID) async {
        // MARK: RevenueCat hook
        // let (info, _) = try await Purchases.shared.logIn(userId.uuidString)
        // applyCustomerInfo(info)
    }

    /// Called on sign-out to clear RC state.
    /// - When RevenueCat is integrated: call `Purchases.shared.logOut()`.
    func logout() async {
        // MARK: RevenueCat hook
        // customerInfo = try await Purchases.shared.logOut()
    }

    // MARK: - Private helpers

    private func expiryDate(for plan: MembershipPlan) -> Date? {
        guard let days = plan.durationDays else { return nil }
        return Calendar.current.date(byAdding: .day, value: days, to: .now)
    }

    // MARK: - Bundled fallback plans (shown when Supabase is not reachable)

    static let bundledFallbackPlans: [MembershipPlan] = [
        MembershipPlan(
            id: "annual",
            rcPackageId: "$rc_annual",
            appleProductId: "com.yolohappy.sub.annual",
            nameEn: "Annual Membership",
            nameZh: "年度会员",
            priceLabel: "$19.99/year",
            durationDays: 365,
            freeTrialDays: 7,
            planType: .subscription,
            accessFlags: MembershipPlan.AccessFlags(
                audioGuides: true, textContent: true, offlineDownload: true,
                visitorTips: true, aiAdvanced: true
            ),
            featureLines: [
                "Unlimited audio guides for all attractions",
                "Full text content for every attraction",
                "Offline audio downloads",
                "All visitor tips unlocked",
                "Advanced AI travel assistant",
            ],
            isBestValue: true,
            displayOrder: 0,
            isActive: true
        ),
        MembershipPlan(
            id: "quarterly",
            rcPackageId: "$rc_three_month",
            appleProductId: "com.yolohappy.sub.quarterly",
            nameEn: "Quarterly Membership",
            nameZh: "季度会员",
            priceLabel: "$7.99/quarter",
            durationDays: 90,
            freeTrialDays: 0,
            planType: .subscription,
            accessFlags: MembershipPlan.AccessFlags(
                audioGuides: true, textContent: true, offlineDownload: false,
                visitorTips: true, aiAdvanced: false
            ),
            featureLines: [
                "Unlimited audio guides for all attractions",
                "Full text content for every attraction",
                "All visitor tips unlocked",
            ],
            isBestValue: false,
            displayOrder: 1,
            isActive: true
        ),
        MembershipPlan(
            id: "monthly",
            rcPackageId: "$rc_monthly",
            appleProductId: "com.yolohappy.sub.monthly",
            nameEn: "Monthly Membership",
            nameZh: "月度会员",
            priceLabel: "$3.99/month",
            durationDays: 30,
            freeTrialDays: 0,
            planType: .subscription,
            accessFlags: MembershipPlan.AccessFlags(
                audioGuides: true, textContent: false, offlineDownload: false,
                visitorTips: false, aiAdvanced: false
            ),
            featureLines: [
                "Unlimited audio guides for all attractions",
            ],
            isBestValue: false,
            displayOrder: 2,
            isActive: true
        ),
    ]
}
