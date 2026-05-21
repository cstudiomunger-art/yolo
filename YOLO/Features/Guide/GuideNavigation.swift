import Foundation

enum GuidePresentationContext: Equatable, Hashable {
    case browse(cityName: String)
    case planDay(dayIndex: Int)
    case planAddToDay(dayIndex: Int)
}

struct GuideAttractionRoute: Hashable {
    let attractionId: String
    let cityId: String?
    let presentation: GuidePresentationContext
}

struct GuideSubAreaRoute: Hashable {
    let subAreaId: String
    let attractionId: String
    let attractionName: String
}

enum GuideRoute: Hashable {
    case city(String)
    case cultureTips
    case cultureTip(String)
    case attraction(GuideAttractionRoute)
    case subArea(GuideSubAreaRoute)
}

enum GuideTripHelpers {
    static func activeItinerary(from preferences: UserPreferencesStore) -> SampleItinerary? {
        let all = preferences.savedItineraries
        guard let activeId = preferences.activeItineraryId else {
            return all.first
        }
        return all.first { $0.id == activeId } ?? all.first
    }

    static func tripCityIds(from preferences: UserPreferencesStore) -> [String] {
        guard let itinerary = activeItinerary(from: preferences) else { return [] }
        return PlanTripCities.cityIds(
            itinerary: itinerary,
            selectedCityIds: preferences.selectedCityIds
        )
    }
}
