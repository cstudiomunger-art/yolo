import Foundation
import Observation

@Observable
final class UserPreferencesStore {
    private enum Keys {
        static let onboardingDone = "chinago.onboardingCompleted"
        static let nationalityOnboardingVersion = "chinago.nationalityOnboardingVersion"
        static let countryCode = "chinago.countryCode"
        static let departureDate = "chinago.departureDate"
        static let selectedCityIds = "chinago.selectedCityIds"
        static let completedChecklistIds = "chinago.completedChecklistIds"
        static let simulateProPurchase = "chinago.simulateProPurchase"
        static let savedItineraries = "chinago.savedItineraries"
        static let activeItineraryId = "chinago.activeItineraryId"
        static let purchasedAttractionIds = "chinago.purchasedAttractionIds"
        static let appLanguage = "chinago.appLanguage"
        static let introOnboardingDone = "chinago.introOnboardingDone"
        static let notificationOnboardingDone = "chinago.notificationOnboardingDone"
    }

    /// Called when profile-syncable fields change (debounced push in `ProfileSyncService`).
    var onSyncableChange: (() -> Void)?

    private var suppressSyncNotification = false

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
        didSet {
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

    var activeItineraryId: String? {
        didSet {
            UserDefaults.standard.set(activeItineraryId, forKey: Keys.activeItineraryId)
            notifySyncableChange()
        }
    }

    var savedItineraries: [SampleItinerary] {
        didSet {
            persistSavedItineraries()
            notifySyncableChange()
        }
    }

    var purchasedAttractionIds: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(purchasedAttractionIds), forKey: Keys.purchasedAttractionIds)
            notifySyncableChange()
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
        completedChecklistIds = Set(UserDefaults.standard.stringArray(forKey: Keys.completedChecklistIds) ?? [])
        simulateProPurchase = UserDefaults.standard.bool(forKey: Keys.simulateProPurchase)
        activeItineraryId = UserDefaults.standard.string(forKey: Keys.activeItineraryId)
        if let data = UserDefaults.standard.data(forKey: Keys.savedItineraries),
           let items = try? JSONDecoder().decode([SampleItinerary].self, from: data) {
            savedItineraries = items
        } else {
            savedItineraries = []
        }
        purchasedAttractionIds = Set(UserDefaults.standard.stringArray(forKey: Keys.purchasedAttractionIds) ?? [])
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
            Keys.simulateProPurchase,
            Keys.savedItineraries,
            Keys.activeItineraryId,
            Keys.purchasedAttractionIds,
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
        completedChecklistIds = []
        simulateProPurchase = false
        savedItineraries = []
        activeItineraryId = nil
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

    var onChecklistToggled: ((String, Bool) -> Void)?

    func toggleChecklistItem(_ id: String) {
        var set = completedChecklistIds
        let isDone: Bool
        if set.contains(id) {
            set.remove(id)
            isDone = false
        } else {
            set.insert(id)
            isDone = true
        }
        completedChecklistIds = set
        onChecklistToggled?(id, isDone)
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
        onItinerarySaved?()
    }

    var canSaveMoreItineraries: Bool {
        savedItineraries.count < Self.maxSavedItineraries
    }

    var onItineraryDeleted: ((String) -> Void)?
    var onItinerarySaved: (() -> Void)?

    func deleteItinerary(id: String) {
        var list = savedItineraries
        list.removeAll { $0.id == id }
        savedItineraries = list
        if activeItineraryId == id {
            activeItineraryId = list.first?.id
        }
        onItineraryDeleted?(id)
    }

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

    func hasAccessToAttraction(_ attractionId: String, iapProductId: String?) -> Bool {
        if simulateProPurchase { return true }
        if purchasedAttractionIds.contains(attractionId) { return true }
        return false
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
        completedChecklistIds = Set(row.completedChecklistIds)
        purchasedAttractionIds = Set(row.purchasedAttractionIds)
        simulateProPurchase = row.isPro
        // Trips are synced via `user_itineraries` (021), not profiles.saved_itineraries JSON.
        if let activeId = row.activeItineraryId {
            activeItineraryId = activeId
        }
    }

    func makeProfileRow(userId: UUID, email: String?) -> UserProfileRow {
        UserProfileRow(
            id: userId,
            email: email,
            displayName: nil,
            countryCode: countryCode.isEmpty ? "GB" : countryCode,
            hasCompletedOnboarding: hasCompletedOnboarding,
            departureDate: Self.formatDateOnly(departureDate),
            selectedCityIds: selectedCityIds,
            completedChecklistIds: Array(completedChecklistIds),
            purchasedAttractionIds: Array(purchasedAttractionIds),
            isPro: simulateProPurchase,
            savedItineraries: [],
            activeItineraryId: activeItineraryId
        )
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

    private func persistSavedItineraries() {
        if let data = try? JSONEncoder().encode(savedItineraries) {
            UserDefaults.standard.set(data, forKey: Keys.savedItineraries)
        } else if savedItineraries.isEmpty {
            UserDefaults.standard.removeObject(forKey: Keys.savedItineraries)
        }
    }
}
