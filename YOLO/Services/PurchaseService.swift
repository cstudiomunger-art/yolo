import Foundation
import Observation
import RevenueCat
import Supabase
import UIKit

/// Manages IAP purchases, entitlement state, and membership plan data.
///
/// When `AppConfig.isRevenueCatConfigured` is true, subscription purchases go through
/// RevenueCat / StoreKit. Otherwise the service runs in simulation mode for local dev.
@Observable
@MainActor
final class PurchaseService {

    // MARK: - State

    private(set) var availablePlans: [MembershipPlan] = []
    private(set) var isPurchasing = false
    private(set) var isLoadingPlans = false
    private(set) var lastError: String?

    // MARK: - Private

    private static let proEntitlementID = "pro"

    private weak var preferences: UserPreferencesStore?
    private weak var profileSync: ProfileSyncService?
    private weak var auth: AuthSessionStore?

    func bind(preferences: UserPreferencesStore, auth: AuthSessionStore, profileSync: ProfileSyncService) {
        self.preferences = preferences
        self.auth = auth
        self.profileSync = profileSync
    }

    // MARK: - Plan Loading

    private static let plansCacheKey = "yolohappy.cachedMembershipPlans.v1"

    /// Loads membership plans from Supabase (the source of truth for names / prices /
    /// features / access flags / trial). On success the result is cached locally so that
    /// later offline launches keep showing the real backend config — not the hardcoded
    /// bundled plans. bundledFallbackPlans is only the last resort when nothing was ever
    /// fetched (fresh install, no network).
    func loadPlans() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            availablePlans = cachedPlans() ?? Self.bundledFallbackPlans
            await refreshCustomerInfoIfNeeded()
            await profileSync?.refreshRemoteMembershipState()
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
            if plans.isEmpty {
                availablePlans = cachedPlans() ?? Self.bundledFallbackPlans
            } else {
                availablePlans = plans
                cachePlans(plans)
            }
        } catch {
            availablePlans = cachedPlans() ?? Self.bundledFallbackPlans
        }
        await refreshCustomerInfoIfNeeded()
        await profileSync?.refreshRemoteMembershipState()
    }

    private func cachePlans(_ plans: [MembershipPlan]) {
        if let data = try? JSONEncoder().encode(plans) {
            UserDefaults.standard.set(data, forKey: Self.plansCacheKey)
        }
    }

    private func cachedPlans() -> [MembershipPlan]? {
        guard let data = UserDefaults.standard.data(forKey: Self.plansCacheKey),
              let plans = try? JSONDecoder().decode([MembershipPlan].self, from: data),
              !plans.isEmpty else { return nil }
        return plans
    }

    // MARK: - Access Flags

    /// The access flags for the user's current entitlement. An admin override wins over RC:
    /// a ban revokes everything; a grant unlocks the full subscription feature set.
    var currentAccessFlags: MembershipPlan.AccessFlags {
        if let prefs = preferences {
            switch prefs.membershipOverrideKind {
            case .ban:
                return .none
            case .grant:
                guard prefs.isOverrideGrantActive else { break }
                return grantAccessFlags()
            case .none:
                break
            }
        }
        guard let planId = preferences?.subscriptionPlanId else { return .none }
        return availablePlans.first(where: { $0.id == planId })?.accessFlags ?? .none
    }

    /// Flags granted by an admin "grant" override — use the first active subscription plan's
    /// flags (the annual plan), falling back to full access if plans aren't loaded yet.
    private func grantAccessFlags() -> MembershipPlan.AccessFlags {
        availablePlans.first(where: { $0.planType == .subscription })?.accessFlags ?? .full
    }

    /// Whether the user has an active entitlement (admin override beats RevenueCat).
    var isProActive: Bool {
        preferences?.isMembershipActive ?? false
    }

    var isMembershipBanned: Bool {
        preferences?.isMembershipBanned ?? false
    }

    /// Plan name for profile UI — uses RC plan id, or the annual plan when admin-granted.
    func displayMembershipPlanName(preferChinese: Bool) -> String {
        if let planId = preferences?.subscriptionPlanId,
           let plan = availablePlans.first(where: { $0.id == planId }) {
            return plan.localizedName(preferChinese: preferChinese)
        }
        if preferences?.isOverrideGrantActive == true,
           let plan = availablePlans.first(where: { $0.planType == .subscription }) {
            return plan.localizedName(preferChinese: preferChinese)
        }
        return String(localized: "Active Membership")
    }

    /// Whether a content type is unlocked for an attraction or sub-area.
    func hasContentAccess(
        _ flag: KeyPath<MembershipPlan.AccessFlags, Bool>,
        requiresPurchase: Bool,
        contentId: String,
        parentId: String? = nil
    ) -> Bool {
        if !requiresPurchase { return true }
        // An admin ban hard-locks all paid content, including past single-attraction unlocks.
        if preferences?.isMembershipBanned == true { return false }
        if isProActive && currentAccessFlags[keyPath: flag] { return true }
        guard let prefs = preferences else { return false }
        if prefs.purchasedAttractionIds.contains(contentId) { return Self.singleUnlocks(flag) }
        if let parentId, prefs.purchasedAttractionIds.contains(parentId) { return Self.singleUnlocks(flag) }
        return false
    }

    private static func singleUnlocks(_ flag: KeyPath<MembershipPlan.AccessFlags, Bool>) -> Bool {
        let singleFlags: [KeyPath<MembershipPlan.AccessFlags, Bool>] = [
            \.audioGuides, \.textContent, \.visitorTips,
        ]
        return singleFlags.contains(flag)
    }

    func singlePlan(forTier tierId: String?) -> MembershipPlan? {
        if let tierId,
           let p = availablePlans.first(where: { $0.id == tierId && $0.planType == .oneTimeAttraction }) {
            return p
        }
        return availablePlans.first { $0.planType == .oneTimeAttraction }
    }

    func priceLabel(forTier tierId: String?) -> String {
        singlePlan(forTier: tierId)?.priceLabel ?? ""
    }

    // MARK: - Purchase

    func purchase(plan: MembershipPlan) async {
        guard !isPurchasing else { return }
        isPurchasing = true
        lastError = nil
        defer { isPurchasing = false }

        guard AppConfig.isRevenueCatConfigured else {
            await simulateSubscriptionPurchase(plan: plan)
            return
        }

        do {
            let package = try await rcPackage(for: plan)
            let result = try await Purchases.shared.purchase(package: package)
            guard !result.userCancelled else { return }
            await applyCustomerInfo(result.customerInfo)
        } catch {
            if Self.isPurchaseCancelled(error) { return }
            lastError = error.localizedDescription
            TelemetryService.shared.recordError(error, context: "revenuecat_purchase")
        }
    }

    func purchaseSingleAttraction(_ attractionId: String, plan: MembershipPlan) async {
        guard !isPurchasing else { return }
        isPurchasing = true
        lastError = nil
        defer { isPurchasing = false }

        guard AppConfig.isRevenueCatConfigured else {
            preferences?.purchaseAttraction(attractionId)
            profileSync?.schedulePush()
            return
        }

        do {
            let package = try await rcPackage(for: plan)
            let result = try await Purchases.shared.purchase(package: package)
            guard !result.userCancelled else { return }
            preferences?.purchaseAttraction(attractionId)
            profileSync?.schedulePush()
        } catch {
            if Self.isPurchaseCancelled(error) { return }
            lastError = error.localizedDescription
            TelemetryService.shared.recordError(error, context: "revenuecat_single_purchase")
        }
    }

    func restorePurchases() async throws {
        if AppConfig.isRevenueCatConfigured {
            let info = try await Purchases.shared.restorePurchases()
            await applyCustomerInfo(info)
        }
        guard let auth, auth.isAuthenticated else { return }
        await profileSync?.syncAfterSignIn()
    }

    // MARK: - Refund

    func beginRefundRequest(windowScene: UIWindowScene) async throws {
        if AppConfig.isRevenueCatConfigured {
            do {
                _ = try await Purchases.shared.beginRefundRequest(forEntitlement: Self.proEntitlementID)
                return
            } catch {
                TelemetryService.shared.recordError(error, context: "revenuecat_refund")
            }
        }
        _ = windowScene
        if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
            await UIApplication.shared.open(url)
        }
    }

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

    // MARK: - RevenueCat Login / Logout

    func login(userId: UUID) async {
        guard AppConfig.isRevenueCatConfigured else { return }
        do {
            let (info, _) = try await Purchases.shared.logIn(userId.uuidString)
            await applyCustomerInfo(info)
        } catch {
            TelemetryService.shared.recordError(error, context: "revenuecat_login")
        }
    }

    func logout() async {
        guard AppConfig.isRevenueCatConfigured else { return }
        _ = try? await Purchases.shared.logOut()
    }

    // MARK: - RevenueCat helpers

    private func applyCustomerInfo(_ info: CustomerInfo) async {
        guard let prefs = preferences else { return }
        if let pro = info.entitlements[Self.proEntitlementID], pro.isActive {
            let plan = availablePlans.first { $0.appleProductId == pro.productIdentifier }
            prefs.subscriptionPlanId = plan?.id ?? prefs.subscriptionPlanId ?? "annual"
            prefs.subscriptionExpiresAt = pro.expirationDate
        } else {
            prefs.subscriptionPlanId = nil
            prefs.subscriptionExpiresAt = nil
        }
        await profileSync?.refreshRemoteMembershipState()
        await profileSync?.pushMembershipMirrorToRemote()
    }

    private func refreshCustomerInfoIfNeeded() async {
        guard AppConfig.isRevenueCatConfigured else { return }
        do {
            let info = try await Purchases.shared.customerInfo()
            await applyCustomerInfo(info)
        } catch {
            TelemetryService.shared.recordError(error, context: "revenuecat_customer_info")
        }
    }

    private func rcPackage(for plan: MembershipPlan) async throws -> Package {
        let offerings = try await Purchases.shared.offerings()
        guard let packages = offerings.current?.availablePackages, !packages.isEmpty else {
            throw PurchaseError.packageNotFound(plan.rcPackageId ?? plan.appleProductId)
        }
        if let rcId = plan.rcPackageId,
           let package = packages.first(where: { $0.identifier == rcId }) {
            return package
        }
        if let package = packages.first(where: { $0.storeProduct.productIdentifier == plan.appleProductId }) {
            return package
        }
        throw PurchaseError.packageNotFound(plan.rcPackageId ?? plan.appleProductId)
    }

    // MARK: - Simulation helpers

    private func simulateSubscriptionPurchase(plan: MembershipPlan) async {
        guard let prefs = preferences else { return }
        prefs.subscriptionPlanId = plan.id
        prefs.subscriptionExpiresAt = expiryDate(for: plan)
        profileSync?.schedulePush()
    }

    private func expiryDate(for plan: MembershipPlan) -> Date? {
        guard let days = plan.durationDays else { return nil }
        return Calendar.current.date(byAdding: .day, value: days, to: .now)
    }

    private static func isPurchaseCancelled(_ error: Error) -> Bool {
        (error as? RevenueCat.ErrorCode) == .purchaseCancelledError
    }

    // MARK: - Bundled fallback plans (shown when Supabase is not reachable)

    static let bundledFallbackPlans: [MembershipPlan] = [
        MembershipPlan(
            id: "annual",
            rcPackageId: "$rc_annual",
            appleProductId: "com.yolohappy.sub.annual",
            nameEn: "Annual Membership",
            nameZh: "年度会员",
            priceLabel: "$9.99/year",
            durationDays: 365,
            freeTrialDays: 0,
            planType: .subscription,
            accessFlags: MembershipPlan.AccessFlags(audioGuides: true, textContent: true, visitorTips: true),
            featureLines: [
                "Unlimited audio guides for all attractions",
                "Full text content for every attraction",
                "All visitor tips unlocked",
                "AI-powered itinerary planning",
            ],
            isBestValue: true,
            displayOrder: 0,
            isActive: true
        ),
    ]
}

private enum PurchaseError: LocalizedError {
    case packageNotFound(String)

    var errorDescription: String? {
        switch self {
        case .packageNotFound(let id):
            "Subscription package not found (\(id)). Check RevenueCat offering configuration."
        }
    }
}
