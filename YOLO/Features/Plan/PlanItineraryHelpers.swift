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
    /// When true, append to `intercityManualActivities` instead of `days[].activities`.
    let intercityManual: Bool

    init(dayIndex: Int, cityIds: [String], bookend: InternationalBookend? = nil, intercityManual: Bool = false) {
        self.dayIndex = dayIndex
        self.cityIds = cityIds
        self.bookend = bookend
        self.intercityManual = intercityManual
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
        if let manualMap = trip.intercityManualActivities {
            for manual in manualMap.values {
                ids.formUnion(manual.compactMap(\.attractionId))
            }
        }
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
        await withTaskGroup(of: [String: Attraction].self) { group in
            for cityId in cityIds {
                group.addTask {
                    var chunk: [String: Attraction] = [:]
                    let list = (try? await content.fetchAttractions(cityId: cityId)) ?? []
                    for attraction in list {
                        chunk[attraction.id] = attraction
                    }
                    return chunk
                }
            }
            var catalog: [String: Attraction] = [:]
            for await chunk in group {
                catalog.merge(chunk) { _, new in new }
            }
            return catalog
        }
    }

    /// Merge catalog rows; only fetch ids missing from `existing`.
    static func supplementAttractionCache(
        existing: [String: Attraction],
        attractionIds: [String],
        content: any ContentRepositoryProtocol
    ) async -> [String: Attraction] {
        var cache = existing
        let missing = attractionIds.filter { cache[$0] == nil }
        guard !missing.isEmpty else { return cache }
        await withTaskGroup(of: (String, Attraction?).self) { group in
            for id in missing {
                group.addTask {
                    let row = try? await content.fetchAttraction(id: id)
                    return (id, row)
                }
            }
            for await (id, row) in group {
                if let row { cache[id] = row }
            }
        }
        return cache
    }

    static func isIntercityDay(_ day: ItineraryDay) -> Bool {
        day.intercityHop != nil
    }

    static func appendIntercityManual(
        _ activity: ItineraryActivity,
        dayIndex: Int,
        to trip: SampleItinerary
    ) -> SampleItinerary {
        var manual = trip.intercityManualActivities ?? [:]
        let key = String(dayIndex)
        manual[key] = (manual[key] ?? []) + [activity]
        return SampleItinerary(
            id: trip.id,
            title: trip.title,
            meta: trip.meta,
            routeSummary: trip.routeSummary,
            estimatedBudget: trip.estimatedBudget,
            days: trip.days,
            shareSlug: trip.shareSlug,
            isShared: trip.isShared,
            startDate: trip.startDate,
            endDate: trip.endDate,
            visitOrder: trip.visitOrder,
            userEdited: true,
            droppedAttractionIds: trip.droppedAttractionIds,
            schedulingAdjustments: trip.schedulingAdjustments,
            seasonHints: trip.seasonHints,
            pace: trip.pace,
            internationalArrivalTime: trip.internationalArrivalTime,
            internationalDepartureTime: trip.internationalDepartureTime,
            endpointScheduleBaselineDays: trip.endpointScheduleBaselineDays,
            internationalArrivalActivities: trip.internationalArrivalActivities,
            internationalDepartureActivities: trip.internationalDepartureActivities,
            intercityManualActivities: manual,
            intercityScheduleBaselineByDayIndex: trip.intercityScheduleBaselineByDayIndex
        )
    }

    static func protectedIntercityManualIds(from trip: SampleItinerary) -> Set<String> {
        trip.protectedIntercityManualAttractionIds
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
