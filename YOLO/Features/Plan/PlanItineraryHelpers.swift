import Foundation

struct PlanAddAttractionContext: Identifiable {
    enum InternationalBookend {
        case arrival
        case departure
    }

    let id = UUID()
    let dayIndex: Int
    let cityIds: [String]
    let bookend: InternationalBookend?

    init(dayIndex: Int, cityIds: [String], bookend: InternationalBookend? = nil) {
        self.dayIndex = dayIndex
        self.cityIds = cityIds
        self.bookend = bookend
    }
}

enum PlanTripCities {
    static func cityIds(
        itinerary: SampleItinerary,
        selectedCityIds: [String],
        attractionCache: [String: Attraction] = [:]
    ) -> [String] {
        var ids = Set(selectedCityIds)
        for day in itinerary.days {
            for act in day.activities {
                if let cid = act.cityId, !cid.isEmpty { ids.insert(cid) }
                if let aid = act.attractionId, let cityId = attractionCache[aid]?.cityId {
                    ids.insert(cityId)
                }
            }
            let legacy = day.cityName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !legacy.isEmpty {
                ids.insert(legacy.lowercased().replacingOccurrences(of: " ", with: "_"))
            }
        }
        if ids.isEmpty, !itinerary.routeSummary.isEmpty {
            itinerary.routeSummary
                .components(separatedBy: CharacterSet(charactersIn: "→·,"))
                .map { $0.trimmingCharacters(in: .whitespaces).lowercased().replacingOccurrences(of: " ", with: "_") }
                .filter { !$0.isEmpty }
                .forEach { ids.insert($0) }
        }
        return ids.sorted()
    }

    static func visitedCityNames(
        day: ItineraryDay,
        cityNameById: [String: String],
        attractionCache: [String: Attraction]
    ) -> String {
        var seen: [String] = []
        for act in day.activities {
            let cid = act.cityId ?? act.attractionId.flatMap { attractionCache[$0]?.cityId }
            guard let cid, let name = cityNameById[cid], !seen.contains(name) else { continue }
            seen.append(name)
        }
        return seen.joined(separator: " · ")
    }
}

enum PlanItineraryHelpers {
    /// Builds the attractionId → Attraction lookup used to resolve covers and city ids
    /// for every activity in a trip.
    static func attractionCache(
        for trip: SampleItinerary,
        content: any ContentRepositoryProtocol
    ) async -> [String: Attraction] {
        var cache: [String: Attraction] = [:]
        var ids = Set(trip.days.flatMap(\.activities).compactMap(\.attractionId))
        ids.formUnion((trip.internationalArrivalActivities ?? []).compactMap(\.attractionId))
        ids.formUnion((trip.internationalDepartureActivities ?? []).compactMap(\.attractionId))
        for id in ids {
            if let a = try? await content.fetchAttraction(id: id) {
                cache[id] = a
            }
        }
        return cache
    }

    static func catalogById(
        forCityIds cityIds: [String],
        content: any ContentRepositoryProtocol
    ) async -> [String: Attraction] {
        var catalog: [String: Attraction] = [:]
        for cityId in cityIds {
            let list = (try? await content.fetchAttractions(cityId: cityId)) ?? []
            for attraction in list {
                catalog[attraction.id] = attraction
            }
        }
        return catalog
    }

    static func activity(from attraction: Attraction) -> ItineraryActivity {
        let slot = PlanItineraryVisitHours.pickVisitTimeSlot(attraction, preferred: .morning)
        return ItineraryActivity(
            id: UUID().uuidString,
            timeSlot: PlanItineraryVisitHours.visitTimeSlotLabel(slot),
            name: attraction.name,
            detail: MarkdownContentView.plainText(from: attraction.summary ?? attraction.shortDescription ?? ""),
            attractionId: attraction.id,
            cityId: attraction.cityId,
            hasAudio: attraction.audioGuideCount > 0
        )
    }
}
