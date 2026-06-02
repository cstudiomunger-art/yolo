import Foundation
import Observation

@Observable
final class UserPreferencesStore {
    private typealias Keys = UserDefaultsKeys

    /// Called when profile-syncable fields change (debounced push in `ProfileSyncService`).
    var onSyncableChange: (() -> Void)?

    private var suppressSyncNotification = false
    private var skipItineraryPersistence = false

    var appLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(appLanguage.rawValue, forKey: Keys.appLanguage)
        }
    }

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

    var simulateProPurchase: Bool {
        didSet {
            UserDefaults.standard.set(simulateProPurchase, forKey: Keys.simulateProPurchase)
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
        simulateProPurchase = UserDefaults.standard.bool(forKey: Keys.simulateProPurchase)
        storageUserId = nil
        let itineraryLoad = Self.loadItinerariesFromDisk(storageUserId: nil)
        activeItineraryId = itineraryLoad.activeId
        savedItineraries = itineraryLoad.itineraries
        purchasedAttractionIds = Set(UserDefaults.standard.stringArray(forKey: Keys.purchasedAttractionIds) ?? [])
        subscriptionPlanId = UserDefaults.standard.string(forKey: Keys.subscriptionPlanId)
        if let exp = UserDefaults.standard.object(forKey: Keys.subscriptionExpiresAt) as? TimeInterval {
            subscriptionExpiresAt = Date(timeIntervalSince1970: exp)
        } else {
            subscriptionExpiresAt = nil
        }
        displayName = UserDefaults.standard.string(forKey: Keys.displayName)
        avatarUrl = UserDefaults.standard.string(forKey: Keys.avatarUrl)
        avatarStatus = UserDefaults.standard.string(forKey: Keys.avatarStatus) ?? "none"
        appLanguage = AppLanguage.resolved(fromStoredValue: UserDefaults.standard.string(forKey: Keys.appLanguage))
        hasCompletedIntroOnboarding = UserDefaults.standard.bool(forKey: Keys.introOnboardingDone)
        hasCompletedNotificationOnboarding = UserDefaults.standard.bool(forKey: Keys.notificationOnboardingDone)
        migrateNationalityOnboardingIfNeeded()
        if countryCode.isEmpty {
            hasCompletedOnboarding = false
        }
        if hasCompletedOnboarding && hasSelectedCountry {
            if !hasCompletedIntroOnboarding { hasCompletedIntroOnboarding = true }
            if !hasCompletedNotificationOnboarding { hasCompletedNotificationOnboarding = true }
        }
    }

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
            Keys.simulateProPurchase,
            Keys.purchasedAttractionIds,
            Keys.subscriptionPlanId,
            Keys.subscriptionExpiresAt,
            Keys.displayName,
            Keys.avatarUrl,
            Keys.avatarStatus,
            Keys.appLanguage,
            Keys.introOnboardingDone,
            Keys.notificationOnboardingDone,
        ] {
            UserDefaults.standard.removeObject(forKey: key)
        }

        hasCompletedIntroOnboarding = false
        hasCompletedNotificationOnboarding = false
        hasCompletedOnboarding = false
        countryCode = ""
        departureDate = Calendar.current.date(byAdding: .day, value: 18, to: .now) ?? .now
        selectedCityIds = ["beijing"]
        checklistStatuses = [:]
        subscriptionPlanId = nil
        subscriptionExpiresAt = nil
        displayName = nil
        avatarUrl = nil
        avatarStatus = "none"
        simulateProPurchase = false
        clearItinerarySessionState()
        purchasedAttractionIds = []
        appLanguage = AppLanguage.resolved(fromStoredValue: nil)
        cachedVisaRule = nil
    }

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
        }
        storageUserId = normalized
        reloadItinerariesFromDisk()
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

    func hasAccessToAttraction(_ attractionId: String, iapProductId: String?) -> Bool {
        // simulateProPurchase is only honoured in mock / development builds, never in production
        // (AppConfig.useMock is true when Supabase is not configured or USE_MOCK=true in xcconfig)
        if simulateProPurchase && AppConfig.useMock { return true }
        if isSubscriptionActive { return true }
        if purchasedAttractionIds.contains(attractionId) { return true }
        return false
    }

    var isSubscriptionActive: Bool {
        guard subscriptionPlanId != nil else { return false }
        if let exp = subscriptionExpiresAt { return exp > .now }
        return true
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
        purchasedAttractionIds = Set(row.purchasedAttractionIds)
        simulateProPurchase = row.isPro
        subscriptionPlanId = row.subscriptionPlanId
        if let expStr = row.subscriptionExpiresAt {
            subscriptionExpiresAt = Self.parseISO8601(expStr)
        }
        if let name = row.displayName, !name.isEmpty { displayName = name }
        if let url = row.avatarUrl, !url.isEmpty { avatarUrl = url }
        avatarStatus = row.avatarStatus
        // Trips are synced via `user_itineraries` (021), not profiles.saved_itineraries JSON.
        if let activeId = row.activeItineraryId {
            activeItineraryId = activeId
        }
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
            isPro: simulateProPurchase || isSubscriptionActive,
            subscriptionPlanId: subscriptionPlanId,
            subscriptionExpiresAt: subscriptionExpiresAt.map { Self.formatISO8601($0) },
            rcCustomerId: nil,
            savedItineraries: [],
            activeItineraryId: activeItineraryId
        )
    }

    private static func parseISO8601(_ string: String) -> Date? {
        ISO8601DateFormatter().date(from: string)
    }

    private static func formatISO8601(_ date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }

    private func notifySyncableChange() {
        guard !suppressSyncNotification else { return }
        onSyncableChange?()
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
}
