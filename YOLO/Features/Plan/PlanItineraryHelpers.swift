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

struct PlanAddIntercityHopContext: Identifiable {
    let id = UUID()
    let calendarDayIndex: Int
    let arrayDayIndex: Int
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
        return tripWith(
            trip,
            manual: .set(manual.isEmpty ? nil : manual),
            userEdited: true
        )
    }

    static func removeIntercityManual(
        activityId: String,
        calendarDayIndex: Int,
        from trip: SampleItinerary
    ) -> SampleItinerary {
        var manual = trip.intercityManualActivities ?? [:]
        let key = String(calendarDayIndex)
        guard var list = manual[key] else { return trip }
        list.removeAll { $0.id == activityId }
        if list.isEmpty {
            manual.removeValue(forKey: key)
        } else {
            manual[key] = list
        }
        return tripWith(
            trip,
            manual: .set(manual.isEmpty ? nil : manual),
            userEdited: true
        )
    }

    /// Removes from intercity manual metadata when present; otherwise from `days[arrayDayIndex].activities`.
    static func removeActivity(
        arrayDayIndex: Int,
        activityId: String,
        from trip: SampleItinerary
    ) -> SampleItinerary {
        guard trip.days.indices.contains(arrayDayIndex) else { return trip }
        let calendarDayIndex = trip.days[arrayDayIndex].dayIndex
        if trip.intercityManual(forDayIndex: calendarDayIndex).contains(where: { $0.id == activityId }) {
            return removeIntercityManual(
                activityId: activityId,
                calendarDayIndex: calendarDayIndex,
                from: trip
            )
        }
        var days = trip.days
        let day = days[arrayDayIndex]
        days[arrayDayIndex] = day.withActivities(day.activities.filter { $0.id != activityId })
        return tripWith(trip, days: days, userEdited: true)
    }

    static func isIntercityManualActivity(
        _ activityId: String,
        calendarDayIndex: Int,
        in trip: SampleItinerary
    ) -> Bool {
        trip.intercityManual(forDayIndex: calendarDayIndex).contains { $0.id == activityId }
    }

    private enum ManualActivitiesUpdate {
        case unchanged
        case set([String: [ItineraryActivity]]?)
    }

    private enum BaselineUpdate {
        case unchanged
        case set([String: [ItineraryActivity]]?)
    }

    private enum SuppressedUpdate {
        case unchanged
        case set([Int]?)
    }

    private static func tripWith(
        _ trip: SampleItinerary,
        days: [ItineraryDay]? = nil,
        manual: ManualActivitiesUpdate = .unchanged,
        baseline: BaselineUpdate = .unchanged,
        suppressed: SuppressedUpdate = .unchanged,
        userEdited: Bool? = nil
    ) -> SampleItinerary {
        let resolvedManual: [String: [ItineraryActivity]]? = switch manual {
        case .unchanged: trip.intercityManualActivities
        case .set(let value): value
        }
        let resolvedBaseline: [String: [ItineraryActivity]]? = switch baseline {
        case .unchanged: trip.intercityScheduleBaselineByDayIndex
        case .set(let value): value
        }
        let resolvedSuppressed: [Int]? = switch suppressed {
        case .unchanged: trip.suppressedIntercityDayIndexes
        case .set(let value): value
        }
        return SampleItinerary(
            id: trip.id,
            title: trip.title,
            meta: trip.meta,
            routeSummary: trip.routeSummary,
            estimatedBudget: trip.estimatedBudget,
            days: days ?? trip.days,
            shareSlug: trip.shareSlug,
            isShared: trip.isShared,
            startDate: trip.startDate,
            endDate: trip.endDate,
            visitOrder: trip.visitOrder,
            userEdited: userEdited ?? trip.userEdited,
            droppedAttractionIds: trip.droppedAttractionIds,
            schedulingAdjustments: trip.schedulingAdjustments,
            seasonHints: trip.seasonHints,
            pace: trip.pace,
            internationalArrivalTime: trip.internationalArrivalTime,
            internationalDepartureTime: trip.internationalDepartureTime,
            endpointScheduleBaselineDays: trip.endpointScheduleBaselineDays,
            internationalArrivalActivities: trip.internationalArrivalActivities,
            internationalDepartureActivities: trip.internationalDepartureActivities,
            intercityManualActivities: resolvedManual,
            intercityScheduleBaselineByDayIndex: resolvedBaseline,
            suppressedIntercityDayIndexes: resolvedSuppressed
        )
    }

    private static func tripWith(
        _ trip: SampleItinerary,
        days: [ItineraryDay]? = nil,
        manual: ManualActivitiesUpdate = .unchanged,
        userEdited: Bool? = nil
    ) -> SampleItinerary {
        tripWith(
            trip,
            days: days,
            manual: manual,
            baseline: .unchanged,
            suppressed: .unchanged,
            userEdited: userEdited
        )
    }

    /// Default from/to cities when manually adding an intercity hop on a day.
    static func inferDefaultFromTo(
        calendarDayIndex: Int,
        days: [ItineraryDay],
        visitOrder: [String]
    ) -> (from: String?, to: String?) {
        let sorted = days.sorted { $0.dayIndex < $1.dayIndex }
        guard let currentIdx = sorted.firstIndex(where: { $0.dayIndex == calendarDayIndex }) else {
            return (visitOrder.first, visitOrder.dropFirst().first ?? visitOrder.first)
        }
        let current = sorted[currentIdx]
        let to = primaryCityId(for: current) ?? visitOrder.last

        var from: String?
        if currentIdx > 0 {
            from = primaryCityId(for: sorted[currentIdx - 1])
        }
        if from == nil, let to, let pos = visitOrder.firstIndex(of: to), pos > 0 {
            from = visitOrder[pos - 1]
        }
        if from == nil { from = visitOrder.first }
        return (from, to ?? visitOrder.last)
    }

    static func removeIntercityHop(calendarDayIndex: Int, from trip: SampleItinerary) -> SampleItinerary {
        guard let arrayIdx = trip.days.firstIndex(where: { $0.dayIndex == calendarDayIndex }) else { return trip }
        var day = trip.days[arrayIdx]
        guard let hop = day.intercityHop else { return trip }

        let toCityId = hop.toCityId.lowercased()
        let key = String(calendarDayIndex)

        var activities = day.activities
        let manual = trip.intercityManual(forDayIndex: calendarDayIndex)
        if !manual.isEmpty {
            activities = mergeActivities(activities, with: manual)
        }

        day = ItineraryDay(
            id: day.id,
            dayIndex: day.dayIndex,
            dateLabel: day.dateLabel,
            cityName: CityTravelHints.displayName(for: toCityId),
            costEstimate: day.costEstimate,
            activities: activities,
            dayKind: .standard,
            experienceItems: [],
            experienceCityId: toCityId,
            intercityHop: nil
        )

        var days = trip.days
        days[arrayIdx] = day

        var manualMap = trip.intercityManualActivities ?? [:]
        manualMap.removeValue(forKey: key)

        var baselineMap = trip.intercityScheduleBaselineByDayIndex ?? [:]
        baselineMap.removeValue(forKey: key)

        var suppressed = trip.suppressedIntercityDayIndexes ?? []
        if !suppressed.contains(calendarDayIndex) {
            suppressed.append(calendarDayIndex)
        }

        return tripWith(
            trip,
            days: days,
            manual: .set(manualMap.isEmpty ? nil : manualMap),
            baseline: .set(baselineMap.isEmpty ? nil : baselineMap),
            suppressed: .set(suppressed.isEmpty ? nil : suppressed),
            userEdited: true
        )
    }

    static func insertIntercityHop(
        calendarDayIndex: Int,
        fromCityId: String,
        toCityId: String,
        allowedCityIds: [String],
        into trip: SampleItinerary
    ) -> SampleItinerary {
        let from = fromCityId.lowercased()
        let to = toCityId.lowercased()
        guard from != to else { return trip }
        let allowed = Set(allowedCityIds.map { $0.lowercased() })
        guard allowed.contains(from), allowed.contains(to) else { return trip }

        guard let arrayIdx = trip.days.firstIndex(where: { $0.dayIndex == calendarDayIndex }) else { return trip }
        var day = trip.days[arrayIdx]
        guard day.intercityHop == nil else { return trip }

        let hours = CityTravelHints.travelHours(from, to)
        let items = CityTravelHints.hopCardItems(fromCityId: from, toCityId: to, hours: hours)
        let hop = ItineraryIntercityHop(
            fromCityId: from,
            toCityId: to,
            travelHours: hours,
            items: items
        )

        let isFullTravel = CityTravelHints.commuteSlots(hours) >= 2
        if isFullTravel {
            day = ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: CityTravelHints.hopDayRouteLabel(fromCityId: from, toCityId: to),
                costEstimate: day.costEstimate,
                activities: day.activities,
                dayKind: .experienceSuggestions,
                experienceItems: CityTravelHints.buildTravelDayContent(fromCityId: from, toCityId: to, hours: hours),
                experienceCityId: to,
                intercityHop: hop
            )
        } else {
            let split = splitActivitiesForHop(day.activities, fromCityId: from, toCityId: to)
            day = ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: CityTravelHints.hopDayRouteLabel(fromCityId: from, toCityId: to),
                costEstimate: day.costEstimate,
                activities: split,
                dayKind: .standard,
                experienceItems: [],
                experienceCityId: to,
                intercityHop: hop
            )
        }

        var days = trip.days
        days[arrayIdx] = day

        var suppressed = trip.suppressedIntercityDayIndexes ?? []
        suppressed.removeAll { $0 == calendarDayIndex }

        return tripWith(
            trip,
            days: days,
            suppressed: .set(suppressed.isEmpty ? nil : suppressed),
            userEdited: true
        )
    }

    private static func primaryCityId(for day: ItineraryDay) -> String? {
        if let hop = day.intercityHop { return hop.toCityId.lowercased() }
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        return day.activities.compactMap { $0.cityId?.lowercased() }.first
    }

    private static func mergeActivities(
        _ base: [ItineraryActivity],
        with extra: [ItineraryActivity]
    ) -> [ItineraryActivity] {
        var merged = base
        var seenIds = Set(base.map(\.id))
        var seenAttractions = Set(base.compactMap { $0.attractionId?.lowercased() })
        for act in extra {
            if seenIds.contains(act.id) { continue }
            if let aid = act.attractionId?.lowercased(), seenAttractions.contains(aid) { continue }
            merged.append(act)
            seenIds.insert(act.id)
            if let aid = act.attractionId?.lowercased() { seenAttractions.insert(aid) }
        }
        return merged
    }

    private static func splitActivitiesForHop(
        _ activities: [ItineraryActivity],
        fromCityId: String,
        toCityId: String
    ) -> [ItineraryActivity] {
        let from = fromCityId.lowercased()
        let to = toCityId.lowercased()
        return activities.map { act in
            let cid = act.cityId?.lowercased()
            let slot: String
            if cid == from {
                slot = "Morning"
            } else if cid == to {
                slot = act.timeSlot == "Evening" ? "Evening" : "Afternoon"
            } else {
                slot = act.timeSlot == "Evening" ? "Evening" : "Afternoon"
            }
            return ItineraryActivity(
                id: act.id,
                timeSlot: slot,
                name: act.name,
                detail: act.detail,
                attractionId: act.attractionId,
                cityId: act.cityId ?? to,
                hasAudio: act.hasAudio,
                kind: act.kind,
                hotelId: act.hotelId,
                sourcePlatform: act.sourcePlatform
            )
        }
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
