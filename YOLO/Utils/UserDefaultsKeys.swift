import Foundation

/// Central UserDefaults keys for YOLO HAPPY (migrated from legacy `chinago.*`).
enum UserDefaultsKeys {
    static let prefix = "yolohappy."

    static let onboardingDone = prefix + "onboardingCompleted"
    static let nationalityOnboardingVersion = prefix + "nationalityOnboardingVersion"
    static let countryCode = prefix + "countryCode"
    static let departureDate = prefix + "departureDate"
    static let selectedCityIds = prefix + "selectedCityIds"
    static let completedChecklistIds = prefix + "completedChecklistIds"
    static let checklistStatuses = prefix + "checklistStatuses"
    static let savedItineraries = prefix + "savedItineraries"
    static let activeItineraryId = prefix + "activeItineraryId"
    static let purchasedAttractionIds = prefix + "purchasedAttractionIds"
    static let appLanguage = prefix + "appLanguage"
    static let introOnboardingDone = prefix + "introOnboardingDone"
    static let notificationOnboardingDone = prefix + "notificationOnboardingDone"
    static let tripPrepRemindersEnabled = prefix + "tripPrepRemindersEnabled"
    static let prepAdvanceRemindersEnabled = prefix + "prepAdvanceRemindersEnabled"
    static let cachedAppSettings = prefix + "cachedAppSettings.v6"
    static let offlineCacheMigrated = prefix + "offlineCacheMigratedToAppSupport.v1"
    static let downloadedAudioGuideIds = prefix + "downloadedAudioGuideIds"
    static let subscriptionPlanId = prefix + "subscriptionPlanId"
    static let subscriptionExpiresAt = prefix + "subscriptionExpiresAt"
    static let displayName = prefix + "displayName"
    static let avatarUrl = prefix + "avatarUrl"
    static let avatarStatus = prefix + "avatarStatus"
    static let guestMode = prefix + "guestMode"
    static let favoriteAttractions = prefix + "favoriteAttractions"

    private static let legacyMap: [(new: String, old: String)] = [
        (onboardingDone, "chinago.onboardingCompleted"),
        (nationalityOnboardingVersion, "chinago.nationalityOnboardingVersion"),
        (countryCode, "chinago.countryCode"),
        (departureDate, "chinago.departureDate"),
        (selectedCityIds, "chinago.selectedCityIds"),
        (completedChecklistIds, "chinago.completedChecklistIds"),
        (checklistStatuses, "chinago.checklistStatuses"),
        (savedItineraries, "chinago.savedItineraries"),
        (activeItineraryId, "chinago.activeItineraryId"),
        (purchasedAttractionIds, "chinago.purchasedAttractionIds"),
        (appLanguage, "chinago.appLanguage"),
        (introOnboardingDone, "chinago.introOnboardingDone"),
        (notificationOnboardingDone, "chinago.notificationOnboardingDone"),
        (tripPrepRemindersEnabled, "chinago.tripPrepRemindersEnabled"),
        (downloadedAudioGuideIds, "chinago.downloadedAudioGuideIds"),
        (offlineCacheMigrated, "chinago.offlineCacheMigratedToAppSupport.v1"),
    ]

    private static let legacySettingsKeys = [
        "chinago.cachedAppSettings.v5",
        "chinago.cachedAppSettings.v4",
        "chinago.cachedAppSettings.v2",
        "chinago.cachedAppSettings",
    ]

    /// Copies legacy `chinago.*` values into `yolohappy.*` once per key.
    static func migrateLegacyKeysIfNeeded() {
        let defaults = UserDefaults.standard
        for pair in legacyMap {
            guard defaults.object(forKey: pair.new) == nil,
                  let legacy = defaults.object(forKey: pair.old)
            else { continue }
            defaults.set(legacy, forKey: pair.new)
        }
        if defaults.object(forKey: cachedAppSettings) == nil {
            for old in legacySettingsKeys {
                if let data = defaults.data(forKey: old) {
                    defaults.set(data, forKey: cachedAppSettings)
                    break
                }
            }
        }
    }
}
