import Foundation
import Observation

@Observable
final class UserPreferencesStore {
    private enum Keys {
        static let onboardingDone = "chinago.onboardingCompleted"
        static let countryCode = "chinago.countryCode"
        static let departureDate = "chinago.departureDate"
        static let selectedCityIds = "chinago.selectedCityIds"
        static let completedChecklistIds = "chinago.completedChecklistIds"
        static let simulateProPurchase = "chinago.simulateProPurchase"
        static let savedItineraries = "chinago.savedItineraries"
        static let activeItineraryId = "chinago.activeItineraryId"
        static let purchasedAttractionIds = "chinago.purchasedAttractionIds"
        static let appLanguage = "chinago.appLanguage"
    }

    var appLanguage: AppLanguage {
        didSet { UserDefaults.standard.set(appLanguage.rawValue, forKey: Keys.appLanguage) }
    }

    var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.onboardingDone) }
    }

    /// Empty until the user picks a country in onboarding.
    var countryCode: String {
        didSet { UserDefaults.standard.set(countryCode, forKey: Keys.countryCode) }
    }

    var departureDate: Date {
        didSet { UserDefaults.standard.set(departureDate.timeIntervalSince1970, forKey: Keys.departureDate) }
    }

    var selectedCityIds: [String] {
        didSet { UserDefaults.standard.set(selectedCityIds, forKey: Keys.selectedCityIds) }
    }

    var completedChecklistIds: Set<String> {
        didSet { UserDefaults.standard.set(Array(completedChecklistIds), forKey: Keys.completedChecklistIds) }
    }

    var simulateProPurchase: Bool {
        didSet { UserDefaults.standard.set(simulateProPurchase, forKey: Keys.simulateProPurchase) }
    }

    var activeItineraryId: String? {
        didSet { UserDefaults.standard.set(activeItineraryId, forKey: Keys.activeItineraryId) }
    }

    var savedItineraries: [SampleItinerary] {
        didSet { persistSavedItineraries() }
    }

    var purchasedAttractionIds: Set<String> {
        didSet { UserDefaults.standard.set(Array(purchasedAttractionIds), forKey: Keys.purchasedAttractionIds) }
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
    }

    func toggleChecklistItem(_ id: String) {
        var set = completedChecklistIds
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
        completedChecklistIds = set
    }

    var activeItinerary: SampleItinerary? {
        if let id = activeItineraryId {
            return savedItineraries.first { $0.id == id }
        }
        return savedItineraries.first
    }

    func saveItinerary(_ itinerary: SampleItinerary) {
        var list = savedItineraries.filter { $0.id != itinerary.id }
        list.insert(itinerary, at: 0)
        if list.count > 10 { list = Array(list.prefix(10)) }
        savedItineraries = list
        activeItineraryId = itinerary.id
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
        if !row.savedItineraries.isEmpty {
            savedItineraries = row.savedItineraries
        }
        activeItineraryId = row.activeItineraryId
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
            savedItineraries: savedItineraries,
            activeItineraryId: activeItineraryId
        )
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
        }
    }
}
