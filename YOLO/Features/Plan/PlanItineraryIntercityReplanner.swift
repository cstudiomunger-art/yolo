import Foundation

/// Re-sorts hop and travel days when the user sets an arrival time at the destination city.
enum PlanItineraryIntercityReplanner {
    struct Options {
        let pace: TripPace
        let catalogById: [String: Attraction]
        var droppedAttractionIds: [String] = []
        /// Attraction ids the user manually pinned on intercity days — never auto-backfilled or relocated.
        var protectedAttractionIds: Set<String> = []
    }

    static func replan(
        days: [ItineraryDay],
        dayIndex: Int,
        arrivalTime: String?,
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        guard let idx = days.firstIndex(where: { $0.dayIndex == dayIndex }) else { return (days, []) }
        var result = days
        let day = result[idx]
        guard var hop = day.intercityHop else { return (days, []) }

        var adjustments: [String] = []
        let trimmed = arrivalTime?.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedArrival = (trimmed?.isEmpty == false) ? trimmed : nil

        hop = hop.withArrivalTime(resolvedArrival)
        let cardItems = CityTravelHints.buildHopCardContentWithArrival(
            fromCityId: hop.fromCityId,
            toCityId: hop.toCityId,
            hours: hop.travelHours,
            arrivalAtDestination: resolvedArrival
        )
        hop = ItineraryIntercityHop(
            fromCityId: hop.fromCityId,
            toCityId: hop.toCityId,
            travelHours: hop.travelHours,
            items: cardItems,
            arrivalTimeAtDestination: resolvedArrival
        )

        var overflow: [ItineraryActivity] = []

        if day.isExperienceSuggestions {
            let (updatedDay, travelAdj, travelOverflow) = replanTravelDay(
                day: day,
                hop: hop,
                arrivalTime: resolvedArrival,
                allDays: result,
                options: options
            )
            result[idx] = updatedDay
            adjustments.append(contentsOf: travelAdj)
            overflow = travelOverflow
        } else {
            let (updatedDay, hopAdj, hopOverflow) = replanHopDay(
                day: day,
                hop: hop,
                arrivalTime: resolvedArrival,
                allDays: result,
                options: options
            )
            result[idx] = updatedDay
            adjustments.append(contentsOf: hopAdj)
            overflow = hopOverflow
        }

        let fromCity = hop.fromCityId.lowercased()
        let toCity = hop.toCityId.lowercased()
        let originOverflow = overflow.filter { $0.cityId?.lowercased() == fromCity }
        let destOverflow = overflow.filter { $0.cityId?.lowercased() != fromCity }

        if !originOverflow.isEmpty {
            let (relocated, relocateAdj) = relocateOverflowBackward(
                originOverflow,
                toCityId: fromCity,
                beforeDayIndex: dayIndex,
                days: result,
                options: options
            )
            result = relocated
            adjustments.append(contentsOf: relocateAdj)
        }

        if !destOverflow.isEmpty {
            let (relocated, relocateAdj) = relocateOverflow(
                destOverflow,
                toCityId: toCity,
                fromDayIndex: dayIndex,
                days: result,
                options: options
            )
            result = relocated
            adjustments.append(contentsOf: relocateAdj)
        }

        let deduped = PlanItineraryEventDayPlanner.finalizeAfterIntercityReplan(
            days: result,
            adjustments: adjustments
        )
        return deduped
    }

    private static func plannerOptions(from options: Options) -> PlanItineraryEventDayPlanner.Options {
        PlanItineraryEventDayPlanner.Options(
            pace: options.pace,
            catalogById: options.catalogById,
            droppedAttractionIds: options.droppedAttractionIds,
            protectedAttractionIds: options.protectedAttractionIds
        )
    }

    private static func replanHopDay(
        day: ItineraryDay,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
        allDays: [ItineraryDay],
        options: Options
    ) -> (day: ItineraryDay, adjustments: [String], overflow: [ItineraryActivity]) {
        let from = hop.fromCityId.lowercased()
        let to = hop.toCityId.lowercased()
        let hopKind = inferredHopKind(from: from, to: to, pace: options.pace)
        let windows = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: arrivalTime,
            travelHours: hop.travelHours,
            pace: options.pace,
            isTravelDay: false,
            hopKind: hopKind
        )
        let allowsMorning = windows.allowsMorningOrigin

        var morningActs: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []

        for act in day.activities {
            let city = act.cityId?.lowercased()
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            if city == from {
                if allowsMorning, !isEvening { morningActs.append(act) }
                else { overflow.append(act) }
            }
        }

        let destExisting = day.activities.filter { $0.cityId?.lowercased() != from }
        let (destKept, destOverflow, destAdj) = PlanItineraryEventDayPlanner.replanIntercityEvent(
            days: allDays,
            eventDayIndex: day.dayIndex,
            cityId: to,
            arrivalTime: arrivalTime,
            travelHours: hop.travelHours,
            isTravelDay: false,
            hopKind: hopKind,
            existingActivities: destExisting,
            options: plannerOptions(from: options)
        )
        overflow.append(contentsOf: destOverflow)

        var adjustments = destAdj
        if !allowsMorning && !overflow.filter({ $0.cityId?.lowercased() == from }).isEmpty {
            adjustments.append("Moved morning sights in \(CityTravelHints.displayName(for: from)) to an earlier day")
        }

        let reslottedMorning = morningActs.enumerated().map { i, act in
            reslot(act, preferred: .morning, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
        }
        let afternoonStart = reslottedMorning.count
        let reslottedDest = destKept.enumerated().map { i, act in
            let pref: VisitTimeSlot = (act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById))
                ? .evening
                : .afternoon
            return reslot(act, preferred: pref, dayIndex: day.dayIndex, actIndex: afternoonStart + i, catalogById: options.catalogById)
        }

        let updated = day
            .withActivities(reslottedMorning + reslottedDest)
            .withIntercityHop(hop)
        return (updated, adjustments, overflow)
    }

    private static func replanTravelDay(
        day: ItineraryDay,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
        allDays: [ItineraryDay],
        options: Options
    ) -> (day: ItineraryDay, adjustments: [String], overflow: [ItineraryActivity]) {
        let to = hop.toCityId.lowercased()
        var adjustments: [String] = []
        var experienceItems = day.experienceItems

        if let arrivalTime, PlanItineraryFlightTimes.isEveningArrival(arrivalTime) {
            experienceItems = [
                "Arrive in \(CityTravelHints.displayName(for: to)) at \(arrivalTime)",
                "Check in and rest at your hotel",
                "Optional light evening stroll if you have energy",
            ]
            adjustments.append("Evening arrival — travel day trimmed to check-in")
        } else if let arrivalTime, PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            experienceItems = CityTravelHints.arrivalAfternoonExperienceItems(cityId: to)
            adjustments.append("Afternoon arrival — shortened travel day")
        } else if arrivalTime != nil {
            experienceItems = hop.items
        }

        let (kept, overflow, eventAdj) = PlanItineraryEventDayPlanner.replanIntercityEvent(
            days: allDays,
            eventDayIndex: day.dayIndex,
            cityId: to,
            arrivalTime: arrivalTime,
            travelHours: hop.travelHours,
            isTravelDay: true,
            hopKind: "travel",
            existingActivities: day.activities,
            options: plannerOptions(from: options)
        )
        adjustments.append(contentsOf: eventAdj)

        let reslotted = kept.enumerated().map { i, act in
            let pref: VisitTimeSlot = (act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById))
                ? .evening
                : .afternoon
            return reslot(act, preferred: pref, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
        }

        let updated = day
            .withExperienceItems(experienceItems)
            .withActivities(reslotted)
            .withIntercityHop(hop)

        return (updated, adjustments, overflow)
    }

    private static func relocateOverflow(
        _ overflow: [ItineraryActivity],
        toCityId: String,
        fromDayIndex: Int,
        days: [ItineraryDay],
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        guard !overflow.isEmpty else { return (days, []) }
        var result = days
        var queue = overflow
        var adjustments: [String] = []
        let to = toCityId.lowercased()
        let cityMap = PlanItineraryIntercityAnnotator.completeCityIdByDayIndex(from: days, visitOrder: [])

        for dayIdx in result.indices {
            let day = result[dayIdx]
            guard day.dayIndex > fromDayIndex else { continue }

            let dayCity = day.experienceCityId?.lowercased()
                ?? day.intercityHop?.toCityId.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()
                ?? cityMap[day.dayIndex]

            let acceptsDestination = dayCity == to
                || day.activities.contains(where: { $0.cityId?.lowercased() == to })
                || (day.activities.isEmpty
                    && day.intercityHop == nil
                    && dayAcceptsCityByName(day, cityId: to))
            guard acceptsDestination else { continue }

            let cap = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: options.pace)
            var used = day.activities.reduce(0.0) { sum, act in
                guard !isEveningOnly(act, catalogById: options.catalogById) else { return sum }
                return sum + activityDuration(act, catalogById: options.catalogById)
            }

            let existingIds = Set(day.activities.compactMap(\.attractionId))
            var placed: [ItineraryActivity] = []
            var remaining: [ItineraryActivity] = []
            for act in queue {
                if let aid = act.attractionId {
                    let key = aid.lowercased()
                    if options.protectedAttractionIds.contains(key) { continue }
                    if existingIds.contains(where: { $0.lowercased() == key }) { continue }
                    result = PlanItineraryAttractionLedger.remove(attractionId: aid, from: result)
                }
                let dur = activityDuration(act, catalogById: options.catalogById)
                if used + dur <= cap {
                    used += dur
                    placed.append(act)
                } else {
                    remaining.append(act)
                }
            }
            queue = remaining
            if placed.isEmpty { continue }

            let start = result[dayIdx].activities.count
            let newActs = placed.enumerated().map { i, act in
                reslot(act, preferred: .afternoon, dayIndex: day.dayIndex, actIndex: start + i, catalogById: options.catalogById)
            }
            result[dayIdx] = result[dayIdx].withActivities(result[dayIdx].activities + newActs)
            adjustments.append("Moved \(placed.count) sight(s) to day \(day.dayIndex) after arrival window change")
            if queue.isEmpty { break }
        }

        return (result, adjustments)
    }

    private static func relocateOverflowBackward(
        _ overflow: [ItineraryActivity],
        toCityId: String,
        beforeDayIndex: Int,
        days: [ItineraryDay],
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        guard !overflow.isEmpty else { return (days, []) }
        var result = days
        var queue = overflow
        var adjustments: [String] = []
        let to = toCityId.lowercased()
        let cityMap = PlanItineraryIntercityAnnotator.completeCityIdByDayIndex(from: days, visitOrder: [])

        for dayIdx in result.indices.reversed() {
            let day = result[dayIdx]
            guard day.dayIndex < beforeDayIndex else { continue }
            guard day.intercityHop == nil else { continue }

            let dayCity = day.experienceCityId?.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()
                ?? cityMap[day.dayIndex]
            guard dayCity == to || day.activities.contains(where: { $0.cityId?.lowercased() == to }) else { continue }

            let cap = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: options.pace)
            var used = day.activities.reduce(0.0) { sum, act in
                guard !isEveningOnly(act, catalogById: options.catalogById) else { return sum }
                return sum + activityDuration(act, catalogById: options.catalogById)
            }

            let existingIds = Set(day.activities.compactMap(\.attractionId))
            var placed: [ItineraryActivity] = []
            var remaining: [ItineraryActivity] = []
            for act in queue {
                if let aid = act.attractionId, existingIds.contains(aid) { continue }
                let dur = activityDuration(act, catalogById: options.catalogById)
                if used + dur <= cap {
                    used += dur
                    placed.append(act)
                } else {
                    remaining.append(act)
                }
            }
            queue = remaining
            if placed.isEmpty { continue }

            let start = day.activities.count
            let newActs = placed.enumerated().map { i, act in
                reslot(act, preferred: .morning, dayIndex: day.dayIndex, actIndex: start + i, catalogById: options.catalogById)
            }
            result[dayIdx] = day.withActivities(day.activities + newActs)
            adjustments.append("Moved \(placed.count) sight(s) to day \(day.dayIndex) before hop day")
            if queue.isEmpty { break }
        }

        return (result, adjustments)
    }

    private static func dayAcceptsCityByName(_ day: ItineraryDay, cityId: String) -> Bool {
        let to = cityId.lowercased()
        let label = day.cityName.lowercased()
        if label.isEmpty { return true }
        if label.contains(to) { return true }
        return label.contains(CityTravelHints.displayName(for: to).lowercased())
    }

    private static func activityDuration(_ act: ItineraryActivity, catalogById: [String: Attraction]) -> Double {
        guard let aid = act.attractionId, let row = catalogById[aid] else { return 1 }
        return PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
    }

    private static func isEveningOnly(_ act: ItineraryActivity, catalogById: [String: Attraction]) -> Bool {
        guard let aid = act.attractionId, let row = catalogById[aid] else { return act.timeSlot == "Evening" }
        return row.isEveningOnly
    }

    private static func reslot(
        _ act: ItineraryActivity,
        preferred: VisitTimeSlot,
        dayIndex: Int,
        actIndex: Int,
        catalogById: [String: Attraction]
    ) -> ItineraryActivity {
        guard let aid = act.attractionId, let row = catalogById[aid] else {
            return ItineraryActivity(
                id: act.id,
                timeSlot: PlanItineraryVisitHours.visitTimeSlotLabel(preferred),
                name: act.name,
                detail: act.detail,
                attractionId: act.attractionId,
                cityId: act.cityId,
                hasAudio: act.hasAudio,
                kind: act.kind,
                hotelId: act.hotelId,
                sourcePlatform: act.sourcePlatform
            )
        }
        let slot = PlanItineraryVisitHours.pickVisitTimeSlot(row, preferred: preferred)
        return ItineraryActivity(
            id: act.id,
            timeSlot: PlanItineraryVisitHours.visitTimeSlotLabel(slot),
            name: act.name,
            detail: act.detail,
            attractionId: act.attractionId,
            cityId: act.cityId,
            hasAudio: act.hasAudio,
            kind: act.kind,
            hotelId: act.hotelId,
            sourcePlatform: act.sourcePlatform
        )
    }

    private static func inferredHopKind(from: String, to: String, pace: TripPace) -> String {
        let hours = CityTravelHints.travelHours(from, to)
        let slots = CityTravelHints.commuteSlots(hours)
        if pace == .intense, CityTravelHints.canIntenseSameDayHop(from, to) { return "hop" }
        if slots == 0 { return "short_hop" }
        if slots == 1 { return "travel_lite" }
        return "travel"
    }
}
