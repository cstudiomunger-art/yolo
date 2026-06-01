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

struct GuideCityGuideRoute: Hashable {
    let guideId: String
    let cityId: String
    let cityName: String
}

enum GuideRoute: Hashable {
    case city(String)
    case cityGuide(GuideCityGuideRoute)
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
        return SampleItinerary.orderedCityIds(from: itinerary)
    }

    /// Date range and day count for a city segment within the active itinerary.
    static func tripDates(for cityId: String, itinerary: SampleItinerary) -> CityTripDates? {
        let normalized = cityId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return nil }

        var labels: [String] = []
        for day in itinerary.days where day.dayKind != .experienceSuggestions {
            if dayCityIds(day).contains(normalized) {
                let prefix = day.dateLabel
                    .components(separatedBy: " · ")
                    .first?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? day.dateLabel
                if !prefix.isEmpty { labels.append(prefix) }
            }
        }
        guard !labels.isEmpty else { return nil }

        let first = labels.first!
        let last = labels.last!
        let rangeText = labels.count == 1 ? first : "\(first) – \(last)"
        let tagText = compactDateTag(first: first, last: last, count: labels.count)
        return CityTripDates(rangeText: rangeText, dayCount: labels.count, tagText: tagText)
    }

    private static func dayCityIds(_ day: ItineraryDay) -> Set<String> {
        var ids = Set<String>()
        for act in day.activities {
            if let cid = act.cityId, !cid.isEmpty {
                ids.insert(cid.lowercased())
            }
        }
        if let exp = day.experienceCityId, !exp.isEmpty {
            ids.insert(exp.lowercased())
        }
        let legacy = day.cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !legacy.isEmpty {
            ids.insert(legacy.lowercased().replacingOccurrences(of: " ", with: "_"))
        }
        return ids
    }

    private static func compactDateTag(first: String, last: String, count: Int) -> String {
        guard count > 1 else { return first }
        let firstParts = first.split(separator: " ")
        let lastParts = last.split(separator: " ")
        if firstParts.count >= 2, lastParts.count >= 2, firstParts[0] == lastParts[0] {
            return "\(firstParts[0]) \(firstParts[1])–\(lastParts[1])"
        }
        return "\(first)–\(last)"
    }
}

struct CityTripDates {
    let rangeText: String
    let dayCount: Int
    let tagText: String
}
