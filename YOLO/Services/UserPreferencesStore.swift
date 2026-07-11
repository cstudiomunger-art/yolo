import Foundation
import Observation

@Observable
final class UserPreferencesStore {
    private typealias Keys = UserDefaultsKeys

    /// Called when profile-syncable fields change (debounced push in `ProfileSyncService`).
    var onSyncableChange: (() -> Void)?

    private var suppressSyncNotification = false
    private var skipItineraryPersistence = false

    var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.onboardingDone)
            notifySyncableChange()
        }
    }

    /// Empty until the user picks a nationality in onboarding.
    var countryCode: String {
        didSet {
            UserDefaults.standard.set(countryCode, forKey: Keys.countryCode)
            if oldValue != countryCode, !oldValue.isEmpty {
                clearEntryChecklistStatuses()
            }
            notifySyncableChange()
        }
    }

    var hasSelectedCountry: Bool { !countryCode.isEmpty }

    var hasCompletedIntroOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedIntroOnboarding, forKey: Keys.introOnboardingDone)
        }
    }

    var hasCompletedNotificationOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedNotificationOnboarding, forKey: Keys.notificationOnboardingDone)
        }
    }

    /// True when the user chose "Explore as guest" and is browsing without an account.
    /// Cleared on sign-out via `resetAll()`; irrelevant once `auth.isAuthenticated` is true.
    var isGuestMode: Bool {
        didSet {
            UserDefaults.standard.set(isGuestMode, forKey: Keys.guestMode)
        }
    }

    /// True after the user confirms nationality on the onboarding screen (v2+).
    var needsNationalityOnboarding: Bool {
        !hasCompletedOnboarding || countryCode.isEmpty
    }

    var needsIntroOnboarding: Bool { !hasCompletedIntroOnboarding }

    var needsNotificationOnboarding: Bool {
        hasCompletedOnboarding && hasSelectedCountry && !hasCompletedNotificationOnboarding
    }

    private static let nationalityOnboardingVersion = 2

    var departureDate: Date {
        didSet {
            UserDefaults.standard.set(departureDate.timeIntervalSince1970, forKey: Keys.departureDate)
            notifySyncableChange()
        }
    }

    var selectedCityIds: [String] {
        didSet {
            UserDefaults.standard.set(selectedCityIds, forKey: Keys.selectedCityIds)
            notifySyncableChange()
        }
    }

    var completedChecklistIds: Set<String> {
        Set(checklistStatuses.compactMap { key, entry in
            guard entry.status == .done else { return nil }
            return Self.itemId(fromStorageKey: key)
        })
    }

    static func storageKey(itemId: String, type: ChecklistItemType, itineraryId: String?) -> String {
        if type == .city, let itineraryId, !itineraryId.isEmpty {
            return "\(itemId)#\(itineraryId)"
        }
        return itemId
    }

    static func itemId(fromStorageKey key: String) -> String {
        key.split(separator: "#", maxSplits: 1).first.map(String.init) ?? key
    }

    private(set) var checklistStatuses: [String: ChecklistStatusEntry] = [:] {
        didSet {
            persistChecklistStatuses()
            UserDefaults.standard.set(Array(completedChecklistIds), forKey: Keys.completedChecklistIds)
            notifySyncableChange()
        }
    }

    /// When set, itineraries are read/written under per-account UserDefaults keys.
    private(set) var storageUserId: String?

    var activeItineraryId: String? {
        didSet {
            if !skipItineraryPersistence {
                persistActiveItineraryId()
            }
            notifySyncableChange()
        }
    }

    var savedItineraries: [SampleItinerary] {
        didSet {
            if !skipItineraryPersistence {
                persistSavedItineraries()
            }
            notifySyncableChange()
        }
    }

    var purchasedAttractionIds: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(purchasedAttractionIds), forKey: Keys.purchasedAttractionIds)
            notifySyncableChange()
        }
    }

    /// Saved attractions, newest first.
    private(set) var favoriteAttractions: [FavoriteAttractionRecord] = [] {
        didSet {
            persistFavoriteAttractions()
        }
    }

    var subscriptionPlanId: String? {
        didSet {
            UserDefaults.standard.set(subscriptionPlanId, forKey: Keys.subscriptionPlanId)
            notifySyncableChange()
        }
    }

    var subscriptionExpiresAt: Date? {
        didSet {
            UserDefaults.standard.set(subscriptionExpiresAt?.timeIntervalSince1970, forKey: Keys.subscriptionExpiresAt)
            notifySyncableChange()
        }
    }

    /// Admin membership override (beats RevenueCat). nil = follow RC, "grant", "ban".
    /// Set only from the remote profile; the App never originates this value.
    var membershipOverride: String? {
        didSet {
            UserDefaults.standard.set(membershipOverride, forKey: Keys.membershipOverride)
        }
    }

    var membershipOverrideExpiresAt: Date? {
        didSet {
            UserDefaults.standard.set(membershipOverrideExpiresAt?.timeIntervalSince1970, forKey: Keys.membershipOverrideExpiresAt)
        }
    }

    /// Admin-only note synced from server; `invite:` prefix marks invite-code grants.
    var membershipOverrideNote: String? {
        didSet {
            UserDefaults.standard.set(membershipOverrideNote, forKey: Keys.membershipOverrideNote)
        }
    }

    /// Incremented when admin override is applied from the server — use to refresh paywalled UI.
    private(set) var membershipStateVersion = 0

    /// Called after `membershipStateVersion` changes (bound in AppEnvironment).
    var onMembershipStateChanged: (() -> Void)?

    var displayName: String? {
        didSet {
            UserDefaults.standard.set(displayName, forKey: Keys.displayName)
            notifySyncableChange()
        }
    }

    var avatarUrl: String? {
        didSet {
            UserDefaults.standard.set(avatarUrl, forKey: Keys.avatarUrl)
            notifySyncableChange()
        }
    }

    var avatarStatus: String {
        didSet {
            UserDefaults.standard.set(avatarStatus, forKey: Keys.avatarStatus)
        }
    }

    /// Filled from CMS via `AppEnvironment.refreshVisaRule()`.
    var cachedVisaRule: VisaRule?

    /// Last-selected narration voice per content owner (`ownerType:ownerId` → variant id).
    private(set) var preferredAudioVoiceVariantIds: [String: String] = [:] {
        didSet {
            if let data = try? JSONEncoder().encode(preferredAudioVoiceVariantIds) {
                UserDefaults.standard.set(data, forKey: Keys.preferredAudioVoiceVariantIds)
            }
        }
    }

    func preferredVoiceVariantId(for owner: AudioVoiceOwner) -> String? {
        preferredAudioVoiceVariantIds[owner.preferenceKey]
    }

    func setPreferredVoiceVariantId(_ variantId: String, for owner: AudioVoiceOwner) {
        var map = preferredAudioVoiceVariantIds
        map[owner.preferenceKey] = variantId
        preferredAudioVoiceVariantIds = map
    }

    var daysUntilDeparture: Int {
        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.startOfDay(for: departureDate)
        return max(Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0, 0)
    }

    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.onboardingDone)
        countryCode = UserDefaults.standard.string(forKey: Keys.countryCode) ?? ""
        if let interval = UserDefaults.standard.object(forKey: Keys.departureDate) as? TimeInterval {
            departureDate = Date(timeIntervalSince1970: interval)
        } else {
            departureDate = Calendar.current.date(byAdding: .day, value: 18, to: .now) ?? .now
        }
        selectedCityIds = UserDefaults.standard.stringArray(forKey: Keys.selectedCityIds) ?? ["beijing"]
        checklistStatuses = Self.loadInitialChecklistStatuses()
        storageUserId = nil
        let itineraryLoad = Self.loadItinerariesFromDisk(storageUserId: nil)
        activeItineraryId = itineraryLoad.activeId
        savedItineraries = itineraryLoad.itineraries
        purchasedAttractionIds = Set(UserDefaults.standard.stringArray(forKey: Keys.purchasedAttractionIds) ?? [])
        favoriteAttractions = Self.loadFavoriteAttractions(storageUserId: nil)
        subscriptionPlanId = UserDefaults.standard.string(forKey: Keys.subscriptionPlanId)
        if let exp = UserDefaults.standard.object(forKey: Keys.subscriptionExpiresAt) as? TimeInterval {
            subscriptionExpiresAt = Date(timeIntervalSince1970: exp)
        } else {
            subscriptionExpiresAt = nil
        }
        membershipOverride = UserDefaults.standard.string(forKey: Keys.membershipOverride)
        if let ovExp = UserDefaults.standard.object(forKey: Keys.membershipOverrideExpiresAt) as? TimeInterval {
            membershipOverrideExpiresAt = Date(timeIntervalSince1970: ovExp)
        } else {
            membershipOverrideExpiresAt = nil
        }
        membershipOverrideNote = UserDefaults.standard.string(forKey: Keys.membershipOverrideNote)
        displayName = UserDefaults.standard.string(forKey: Keys.displayName)
        avatarUrl = UserDefaults.standard.string(forKey: Keys.avatarUrl)
        avatarStatus = UserDefaults.standard.string(forKey: Keys.avatarStatus) ?? "none"
        preferredAudioVoiceVariantIds = Self.loadPreferredVoiceVariantIds()
        hasCompletedIntroOnboarding = UserDefaults.standard.bool(forKey: Keys.introOnboardingDone)
        hasCompletedNotificationOnboarding = UserDefaults.standard.bool(forKey: Keys.notificationOnboardingDone)
        isGuestMode = UserDefaults.standard.bool(forKey: Keys.guestMode)
        migrateNationalityOnboardingIfNeeded()
        if countryCode.isEmpty {
            hasCompletedOnboarding = false
        }
        if hasCompletedOnboarding && hasSelectedCountry {
            if !hasCompletedIntroOnboarding { hasCompletedIntroOnboarding = true }
            if !hasCompletedNotificationOnboarding { hasCompletedNotificationOnboarding = true }
        }
    }

    // MARK: - Reset

    /// Clears all local preferences (e.g. on sign-out). Does not touch Supabase.
    func resetAll() {
        suppressSyncNotification = true
        defer { suppressSyncNotification = false }

        for key in [
            Keys.onboardingDone,
            Keys.nationalityOnboardingVersion,
            Keys.countryCode,
            Keys.departureDate,
            Keys.selectedCityIds,
            Keys.completedChecklistIds,
            Keys.checklistStatuses,
            Keys.purchasedAttractionIds,
            Keys.subscriptionPlanId,
            Keys.subscriptionExpiresAt,
            Keys.membershipOverride,
            Keys.membershipOverrideExpiresAt,
            Keys.membershipOverrideNote,
            Keys.displayName,
            Keys.avatarUrl,
            Keys.avatarStatus,
            Keys.introOnboardingDone,
            Keys.notificationOnboardingDone,
            Keys.guestMode,
            Keys.favoriteAttractions,
            Keys.preferredAudioVoiceVariantIds,
        ] {
            UserDefaults.standard.removeObject(forKey: key)
        }

        isGuestMode = false
        hasCompletedIntroOnboarding = false
        hasCompletedNotificationOnboarding = false
        hasCompletedOnboarding = false
        countryCode = ""
        departureDate = Calendar.current.date(byAdding: .day, value: 18, to: .now) ?? .now
        selectedCityIds = ["beijing"]
        checklistStatuses = [:]
        subscriptionPlanId = nil
        subscriptionExpiresAt = nil
        membershipOverride = nil
        membershipOverrideExpiresAt = nil
        membershipOverrideNote = nil
        displayName = nil
        avatarUrl = nil
        avatarStatus = "none"
        clearItinerarySessionState()
        purchasedAttractionIds = []
        favoriteAttractions = []
        preferredAudioVoiceVariantIds = [:]
        cachedVisaRule = nil
    }

    // MARK: - Favorite attractions

    func isFavorite(attractionId: String) -> Bool {
        favoriteAttractions.contains { $0.attractionId == attractionId }
    }

    var onFavoriteChanged: ((String, String, Bool) -> Void)?

    func toggleFavorite(attraction: Attraction) {
        if let index = favoriteAttractions.firstIndex(where: { $0.attractionId == attraction.id }) {
            favoriteAttractions.remove(at: index)
            onFavoriteChanged?(attraction.id, attraction.cityId, false)
        } else {
            let record = FavoriteAttractionRecord(
                attractionId: attraction.id,
                cityId: attraction.cityId,
                createdAt: .now
            )
            favoriteAttractions.insert(record, at: 0)
            onFavoriteChanged?(attraction.id, attraction.cityId, true)
        }
    }

    func applyRemoteFavoriteAttractions(_ records: [FavoriteAttractionRecord]) {
        suppressSyncNotification = true
        favoriteAttractions = records
        suppressSyncNotification = false
    }

    private static func loadFavoriteAttractions(storageUserId: String?) -> [FavoriteAttractionRecord] {
        let key = favoriteAttractionsStorageKey(for: storageUserId)
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([FavoriteAttractionRecord].self, from: data)
        else { return [] }
        return decoded
    }

    private func persistFavoriteAttractions() {
        let key = Self.favoriteAttractionsStorageKey(for: storageUserId)
        if let data = try? JSONEncoder().encode(favoriteAttractions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func reloadFavoritesFromDisk() {
        suppressSyncNotification = true
        defer { suppressSyncNotification = false }
        favoriteAttractions = Self.loadFavoriteAttractions(storageUserId: storageUserId)
    }

    private static func favoriteAttractionsStorageKey(for storageUserId: String?) -> String {
        guard let storageUserId else { return Keys.favoriteAttractions }
        return Keys.favoriteAttractions + "." + storageUserId
    }

    // MARK: - Onboarding

    func markIntroOnboardingCompleted() {
        hasCompletedIntroOnboarding = true
    }

    func markNotificationOnboardingCompleted() {
        hasCompletedNotificationOnboarding = true
    }

    func markNationalityOnboardingCompleted() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(
            Self.nationalityOnboardingVersion,
            forKey: Keys.nationalityOnboardingVersion
        )
    }

    private func migrateNationalityOnboardingIfNeeded() {
        let storedVersion = UserDefaults.standard.integer(forKey: Keys.nationalityOnboardingVersion)
        guard storedVersion < Self.nationalityOnboardingVersion else { return }
        countryCode = ""
        hasCompletedOnboarding = false
    }

    // MARK: - Checklist

    var onChecklistStatusChanged: ((String, ChecklistItemType, ChecklistItemStatus) -> Void)?

    func checklistStatus(for itemId: String, type: ChecklistItemType) -> ChecklistItemStatus {
        let key = Self.storageKey(itemId: itemId, type: type, itineraryId: activeItineraryId)
        return checklistStatuses[key]?.status ?? .pending
    }

    func setChecklistStatus(itemId: String, type: ChecklistItemType, status: ChecklistItemStatus) {
        let key = Self.storageKey(itemId: itemId, type: type, itineraryId: activeItineraryId)
        var map = checklistStatuses
        if status == .pending {
            map.removeValue(forKey: key)
        } else {
            map[key] = ChecklistStatusEntry(status: status, type: type)
        }
        checklistStatuses = map
        onChecklistStatusChanged?(itemId, type, status)
    }

    func toggleChecklistItem(_ id: String, type: ChecklistItemType) {
        let current = checklistStatus(for: id, type: type)
        let next: ChecklistItemStatus = current == .done ? .pending : .done
        setChecklistStatus(itemId: id, type: type, status: next)
    }

    func skipChecklistItem(_ id: String, type: ChecklistItemType) {
        setChecklistStatus(itemId: id, type: type, status: .skipped)
    }

    func restoreChecklistItem(_ id: String, type: ChecklistItemType) {
        setChecklistStatus(itemId: id, type: type, status: .pending)
    }

    func clearEntryChecklistStatuses() {
        checklistStatuses = checklistStatuses.filter { $0.value.type != .entry }
    }

    func clearEntryChecklistStatuses(entryItemIds: Set<String>) {
        var map = checklistStatuses
        for id in entryItemIds {
            map.removeValue(forKey: id)
        }
        checklistStatuses = map
    }

    func itineraryIdForCompletion(type: ChecklistItemType) -> String? {
        type == .city ? activeItineraryId : nil
    }

    private static func loadInitialChecklistStatuses() -> [String: ChecklistStatusEntry] {
        if let data = UserDefaults.standard.data(forKey: Keys.checklistStatuses),
           let decoded = try? JSONDecoder().decode([String: ChecklistStatusEntry].self, from: data) {
            return decoded
        }
        let legacyDone = Set(UserDefaults.standard.stringArray(forKey: Keys.completedChecklistIds) ?? [])
        if !legacyDone.isEmpty {
            return Dictionary(
                uniqueKeysWithValues: legacyDone.map { ($0, ChecklistStatusEntry(status: .done, type: .universal)) }
            )
        }
        return [:]
    }

    private func persistChecklistStatuses() {
        if let data = try? JSONEncoder().encode(checklistStatuses) {
            UserDefaults.standard.set(data, forKey: Keys.checklistStatuses)
        } else {
            UserDefaults.standard.removeObject(forKey: Keys.checklistStatuses)
        }
    }

    // MARK: - Itineraries

    var activeItinerary: SampleItinerary? {
        if let id = activeItineraryId {
            return savedItineraries.first { $0.id == id }
        }
        return savedItineraries.first
    }

    static let maxSavedItineraries = 10

    func saveItinerary(_ itinerary: SampleItinerary) {
        var list = savedItineraries.filter { $0.id != itinerary.id }
        list.insert(itinerary, at: 0)
        if list.count > Self.maxSavedItineraries {
            list = Array(list.prefix(Self.maxSavedItineraries))
        }
        savedItineraries = list
        activeItineraryId = itinerary.id
        showPrepareGuideAfterSave = true
        onItinerarySaved?()
    }

    func updateItineraryShareState(_ itinerary: SampleItinerary) {
        guard let index = savedItineraries.firstIndex(where: { $0.id == itinerary.id }) else { return }
        var list = savedItineraries
        list[index] = itinerary
        savedItineraries = list
        onItinerarySaved?()
    }

    var canSaveMoreItineraries: Bool {
        savedItineraries.count < Self.maxSavedItineraries
    }

    var onItineraryDeleted: ((String) -> Void)?
    var onItinerarySaved: (() -> Void)?
    var showPrepareGuideAfterSave = false

    func deleteItinerary(id: String) {
        var list = savedItineraries
        list.removeAll { $0.id == id }
        savedItineraries = list
        purgeChecklistStatuses(forItineraryId: id)
        if activeItineraryId == id {
            activeItineraryId = list.first?.id
        }
        onItineraryDeleted?(id)
    }

    /// Removes local done/skipped for items that only apply to a deleted trip’s city list.
    func purgeChecklistStatuses(forItineraryId itineraryId: String) {
        let suffix = "#\(itineraryId)"
        checklistStatuses = checklistStatuses.filter { !$0.key.hasSuffix(suffix) }
    }

    func applyRemoteChecklistStatuses(_ map: [String: ChecklistStatusEntry]) {
        suppressSyncNotification = true
        checklistStatuses = map
        suppressSyncNotification = false
    }

    /// Merges synced trips into local storage (always persisted to disk for the active account).
    func applyRemoteItineraries(_ trips: [SampleItinerary], activeId: String?) {
        suppressSyncNotification = true
        defer { suppressSyncNotification = false }
        savedItineraries = trips
        if let activeId, trips.contains(where: { $0.id == activeId }) {
            activeItineraryId = activeId
        } else {
            activeItineraryId = trips.first?.id
        }
    }

    /// Switches the on-disk itinerary cache to the signed-in account (or legacy guest key when nil).
    func setStorageUserId(_ userId: UUID?) {
        let normalized = userId?.uuidString.lowercased()
        guard storageUserId != normalized else { return }
        if let normalized {
            migrateLegacyItinerariesIfNeeded(toUserId: normalized)
            migrateLegacyFavoritesIfNeeded(toUserId: normalized)
        }
        storageUserId = normalized
        reloadItinerariesFromDisk()
        reloadFavoritesFromDisk()
    }

    /// Clears in-memory itinerary state after sign-out without deleting per-account local caches.
    func clearItinerarySession() {
        suppressSyncNotification = true
        defer { suppressSyncNotification = false }
        clearItinerarySessionState()
    }

    private func clearItinerarySessionState() {
        skipItineraryPersistence = true
        defer { skipItineraryPersistence = false }
        storageUserId = nil
        savedItineraries = []
        activeItineraryId = nil
    }

    // MARK: - Purchases & subscription

    func hasAccessToAttraction(_ attractionId: String, iapProductId: String?) -> Bool {
        if isMembershipBanned { return false }
        if isMembershipActive { return true }
        if purchasedAttractionIds.contains(attractionId) { return true }
        return false
    }

    /// A subscription counts as active only with a plan id AND a future expiry. A dangling
    /// `subscriptionPlanId` without an expiry must NOT grant lifetime access (one-time attraction
    /// purchases are tracked via `purchasedAttractionIds`, not here).
    var isSubscriptionActive: Bool {
        guard subscriptionPlanId != nil, let exp = subscriptionExpiresAt else { return false }
        return exp > .now
    }

    // MARK: - Membership override (admin, beats RevenueCat)

    enum MembershipOverrideKind {
        case grant, ban, none
    }

    var membershipOverrideKind: MembershipOverrideKind {
        switch membershipOverride?.lowercased() {
        case "grant": return .grant
        case "ban", "block", "banned": return .ban
        default: return .none
        }
    }

    /// True when an admin has explicitly banned this user (locks all paid content).
    var isMembershipBanned: Bool { membershipOverrideKind == .ban }

    /// True when an admin grant is currently in effect (nil expiry = lifetime grant).
    var isOverrideGrantActive: Bool {
        guard membershipOverrideKind == .grant else { return false }
        if let exp = membershipOverrideExpiresAt { return exp > .now }
        return true
    }

    /// Effective membership: admin override wins, otherwise fall back to the RevenueCat subscription.
    var isMembershipActive: Bool {
        switch membershipOverrideKind {
        case .ban: return false
        case .grant: return isOverrideGrantActive
        case .none: return isSubscriptionActive
        }
    }

    /// Expiry date to show in profile UI (grant override expiry takes precedence over RC).
    var effectiveMembershipExpiry: Date? {
        if membershipOverrideKind == .grant { return membershipOverrideExpiresAt }
        return subscriptionExpiresAt
    }

    func purchaseAttraction(_ attractionId: String) {
        var set = purchasedAttractionIds
        set.insert(attractionId)
        purchasedAttractionIds = set
    }

    func visaRule() -> VisaRule? {
        guard !countryCode.isEmpty else { return nil }
        return cachedVisaRule
    }

    // MARK: - Profile sync

    func applyRemoteProfile(_ row: UserProfileRow) {
        suppressSyncNotification = true
        defer { suppressSyncNotification = false }

        countryCode = row.countryCode
        hasCompletedOnboarding = row.hasCompletedOnboarding
        if let dateString = row.departureDate,
           let date = Self.parseDateOnly(dateString) {
            departureDate = date
        }
        if !row.selectedCityIds.isEmpty {
            selectedCityIds = row.selectedCityIds
        }
        let done = Set(row.completedChecklistIds)
        if !done.isEmpty, checklistStatuses.isEmpty {
            checklistStatuses = Dictionary(
                uniqueKeysWithValues: done.map { ($0, ChecklistStatusEntry(status: .done, type: .universal)) }
            )
        }
        applyRemoteMembershipOverride(row)
        // Subscription truth on device is RevenueCat when configured; remote subscription_*
        // columns are admin/webhook-only and must not clobber local RC state on profile pull.
        if !AppConfig.isRevenueCatConfigured {
            subscriptionPlanId = row.subscriptionPlanId
            if let expStr = row.subscriptionExpiresAt {
                subscriptionExpiresAt = Self.parseISO8601(expStr)
            }
        }
        if let name = row.displayName, !name.isEmpty { displayName = name }
        if let url = row.avatarUrl, !url.isEmpty { avatarUrl = url }
        avatarStatus = row.avatarStatus
        // Trips are synced via `user_itineraries` (021), not profiles.saved_itineraries JSON.
        if let activeId = row.activeItineraryId {
            activeItineraryId = activeId
        }
    }

    /// Applies admin membership override from the server. Beats RevenueCat on the device.
    func applyRemoteMembershipOverride(_ row: UserProfileRow) {
        suppressSyncNotification = true
        defer { suppressSyncNotification = false }

        let prevOverride = membershipOverride
        let prevExp = membershipOverrideExpiresAt
        let prevNote = membershipOverrideNote
        let wasActive = isMembershipActive

        let (override, overrideExpires) = Self.resolveRemoteMembershipOverride(row)
        membershipOverride = override
        membershipOverrideExpiresAt = overrideExpires
        membershipOverrideNote = row.membershipOverrideNote
        purchasedAttractionIds = Set(row.purchasedAttractionIds)

        let changed = membershipOverride != prevOverride
            || membershipOverrideExpiresAt != prevExp
            || membershipOverrideNote != prevNote
            || isMembershipActive != wasActive
        if changed {
            membershipStateVersion += 1
            onMembershipStateChanged?()
        }
    }

    func makeClientPushRow(userId: UUID, email: String?) -> ClientProfilePushRow {
        ClientProfilePushRow(
            id: userId,
            email: email,
            displayName: displayName,
            avatarUrl: avatarUrl,
            avatarStatus: avatarStatus,
            countryCode: countryCode.isEmpty ? "GB" : countryCode,
            hasCompletedOnboarding: hasCompletedOnboarding,
            departureDate: Self.formatDateOnly(departureDate),
            selectedCityIds: selectedCityIds,
            completedChecklistIds: Array(completedChecklistIds),
            subscriptionPlanId: subscriptionPlanId,
            subscriptionExpiresAt: subscriptionExpiresAt.map { Self.formatISO8601($0) },
            rcCustomerId: userId.uuidString,
            activeItineraryId: activeItineraryId
        )
    }

    func makeProfileRow(userId: UUID, email: String?) -> UserProfileRow {
        UserProfileRow(
            id: userId,
            email: email,
            displayName: displayName,
            avatarUrl: avatarUrl,
            avatarStatus: avatarStatus,
            countryCode: countryCode.isEmpty ? "GB" : countryCode,
            hasCompletedOnboarding: hasCompletedOnboarding,
            departureDate: Self.formatDateOnly(departureDate),
            selectedCityIds: selectedCityIds,
            completedChecklistIds: Array(completedChecklistIds),
            purchasedAttractionIds: Array(purchasedAttractionIds),
            subscriptionPlanId: subscriptionPlanId,
            subscriptionExpiresAt: subscriptionExpiresAt.map { Self.formatISO8601($0) },
            rcCustomerId: nil,
            // override columns are admin-owned & DB-protected; we round-trip the last-known
            // values so the App never blanks them, but the trigger ignores client writes anyway.
            membershipOverride: membershipOverride,
            membershipOverrideExpiresAt: membershipOverrideExpiresAt.map { Self.formatISO8601($0) },
            membershipOverrideNote: membershipOverrideNote,
            savedItineraries: [],
            activeItineraryId: activeItineraryId
        )
    }

    /// Maps server profile → local override. Only explicit admin override columns apply;
    /// remote `subscription_*` is an RC mirror for the CMS and must not imply grant.
    private static func resolveRemoteMembershipOverride(_ row: UserProfileRow) -> (String?, Date?) {
        let kind = row.membershipOverride?.lowercased()
        if kind == "ban" {
            return ("ban", nil)
        }
        if kind == "grant" {
            let exp = row.membershipOverrideExpiresAt.flatMap { parseISO8601($0) }
            return ("grant", exp)
        }
        return (nil, nil)
    }

    private static func parseISO8601(_ string: String) -> Date? {
        ISO8601DateFormatter().date(from: string)
    }

    private static func formatISO8601(_ date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }

    static func formatISO8601ForSync(_ date: Date) -> String {
        formatISO8601(date)
    }

    private func notifySyncableChange() {
        guard !suppressSyncNotification else { return }
        onSyncableChange?()
    }

    private static func loadPreferredVoiceVariantIds() -> [String: String] {
        guard let data = UserDefaults.standard.data(forKey: Keys.preferredAudioVoiceVariantIds),
              let decoded = try? JSONDecoder().decode([String: String].self, from: data)
        else { return [:] }
        return decoded
    }

    private static func formatDateOnly(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func parseDateOnly(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }

    // MARK: - Itinerary persistence

    private func reloadItinerariesFromDisk() {
        suppressSyncNotification = true
        skipItineraryPersistence = true
        defer {
            skipItineraryPersistence = false
            suppressSyncNotification = false
        }

        let loaded = Self.loadItinerariesFromDisk(storageUserId: storageUserId)
        activeItineraryId = loaded.activeId
        savedItineraries = loaded.itineraries
    }

    private static func loadItinerariesFromDisk(storageUserId: String?) -> (activeId: String?, itineraries: [SampleItinerary]) {
        let tripsKey = savedItinerariesStorageKey(for: storageUserId)
        let activeKey = activeItineraryStorageKey(for: storageUserId)
        let activeId = UserDefaults.standard.string(forKey: activeKey)
        let itineraries: [SampleItinerary]
        if let data = UserDefaults.standard.data(forKey: tripsKey),
           let items = try? JSONDecoder().decode([SampleItinerary].self, from: data) {
            itineraries = items
        } else {
            itineraries = []
        }
        return (activeId, itineraries)
    }

    private func savedItinerariesStorageKey() -> String {
        Self.savedItinerariesStorageKey(for: storageUserId)
    }

    private static func savedItinerariesStorageKey(for storageUserId: String?) -> String {
        guard let storageUserId else { return Keys.savedItineraries }
        return Keys.savedItineraries + "." + storageUserId
    }

    private func activeItineraryStorageKey() -> String {
        Self.activeItineraryStorageKey(for: storageUserId)
    }

    private static func activeItineraryStorageKey(for storageUserId: String?) -> String {
        guard let storageUserId else { return Keys.activeItineraryId }
        return Keys.activeItineraryId + "." + storageUserId
    }

    private func persistActiveItineraryId() {
        let key = activeItineraryStorageKey()
        if let activeItineraryId {
            UserDefaults.standard.set(activeItineraryId, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    private func persistSavedItineraries() {
        let key = savedItinerariesStorageKey()
        if let data = try? JSONEncoder().encode(savedItineraries) {
            UserDefaults.standard.set(data, forKey: key)
            persistActiveItineraryId()
        } else if savedItineraries.isEmpty {
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.removeObject(forKey: activeItineraryStorageKey())
        }
    }

    /// One-time copy of pre-account-local trips into the first signed-in user's cache.
    private func migrateLegacyItinerariesIfNeeded(toUserId userId: String) {
        let userTripsKey = Keys.savedItineraries + "." + userId
        guard UserDefaults.standard.object(forKey: userTripsKey) == nil,
              let data = UserDefaults.standard.data(forKey: Keys.savedItineraries)
        else { return }

        UserDefaults.standard.set(data, forKey: userTripsKey)
        if let activeId = UserDefaults.standard.string(forKey: Keys.activeItineraryId) {
            UserDefaults.standard.set(activeId, forKey: Keys.activeItineraryId + "." + userId)
        }
    }

    private func migrateLegacyFavoritesIfNeeded(toUserId userId: String) {
        let userKey = Self.favoriteAttractionsStorageKey(for: userId)
        guard UserDefaults.standard.object(forKey: userKey) == nil,
              let data = UserDefaults.standard.data(forKey: Keys.favoriteAttractions)
        else { return }
        UserDefaults.standard.set(data, forKey: userKey)
    }
}
