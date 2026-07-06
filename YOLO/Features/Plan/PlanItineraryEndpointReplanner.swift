import Foundation

/// Re-plans entry/exit sightseeing days when the user sets international flight times on Review bookend cards.
enum PlanItineraryEndpointReplanner {
    struct Options {
        let pace: TripPace
        let catalogById: [String: Attraction]
        let visitOrder: [String]
        var droppedAttractionIds: [String] = []
    }

    struct ReplanResult {
        let days: [ItineraryDay]
        let adjustments: [String]
        let droppedAttractionIds: [String]
    }

    /// Chain entry then exit replan from baseline days; handles same-day entry/exit merge.
    static func replan(
        days: [ItineraryDay],
        entryCityId: String,
        exitCityId: String,
        arrivalTime: String?,
        departureTime: String?,
        options: Options
    ) -> ReplanResult {
        let resolvedArrival = resolveTime(arrivalTime)
        let resolvedDeparture = resolveTime(departureTime)
        let entryIdx = CityTravelHints.resolveEntrySightseeingDayIndex(days: days, visitOrder: options.visitOrder)
        let exitIdx = CityTravelHints.resolveExitSightseeingDayIndex(days: days, visitOrder: options.visitOrder)

        guard entryIdx != nil || exitIdx != nil else {
            return ReplanResult(days: days, adjustments: [], droppedAttractionIds: [])
        }

        if let entryIdx, let exitIdx, entryIdx == exitIdx,
           let idx = days.firstIndex(where: { $0.dayIndex == entryIdx }),
           resolvedArrival != nil || resolvedDeparture != nil {
            return replanSameDayEndpoint(
                days: days,
                dayIndex: entryIdx,
                dayArrayIndex: idx,
                cityId: entryCityId.lowercased(),
                arrivalTime: resolvedArrival,
                departureTime: resolvedDeparture,
                options: options
            )
        }

        var result = days
        var adjustments: [String] = []
        var dropped: [String] = []

        if resolvedArrival != nil {
            let arrivalResult = replanArrivalInternal(
                days: result,
                entryCityId: entryCityId,
                arrivalTime: resolvedArrival,
                options: options
            )
            result = arrivalResult.days
            adjustments.append(contentsOf: arrivalResult.adjustments)
            dropped.append(contentsOf: arrivalResult.droppedAttractionIds)
        }

        if resolvedDeparture != nil {
            let departureResult = replanDepartureInternal(
                days: result,
                exitCityId: exitCityId,
                departureTime: resolvedDeparture,
                options: options
            )
            result = departureResult.days
            adjustments.append(contentsOf: departureResult.adjustments)
            dropped.append(contentsOf: departureResult.droppedAttractionIds)
        }

        return ReplanResult(days: result, adjustments: adjustments, droppedAttractionIds: dropped)
    }

    static func replanArrival(
        days: [ItineraryDay],
        entryCityId: String,
        arrivalTime: String?,
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        let result = replanArrivalInternal(days: days, entryCityId: entryCityId, arrivalTime: resolveTime(arrivalTime), options: options)
        return (result.days, result.adjustments)
    }

    static func replanDeparture(
        days: [ItineraryDay],
        exitCityId: String,
        departureTime: String?,
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        let result = replanDepartureInternal(days: days, exitCityId: exitCityId, departureTime: resolveTime(departureTime), options: options)
        return (result.days, result.adjustments)
    }

    private static func resolveTime(_ raw: String?) -> String? {
        let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (trimmed?.isEmpty == false) ? trimmed : nil
    }

    private static func replanArrivalInternal(
        days: [ItineraryDay],
        entryCityId: String,
        arrivalTime: String?,
        options: Options
    ) -> ReplanResult {
        guard let dayIndex = CityTravelHints.resolveEntrySightseeingDayIndex(
            days: days,
            visitOrder: options.visitOrder
        ), let idx = days.firstIndex(where: { $0.dayIndex == dayIndex }) else {
            return ReplanResult(days: days, adjustments: [], droppedAttractionIds: [])
        }

        var result = days
        let entry = entryCityId.lowercased()
        let tripScheduledIds = scheduledAttractionIds(in: result)

        let (updatedDay, adjustments, overflow) = replanEntryDay(
            day: result[idx],
            entryCityId: entry,
            arrivalTime: arrivalTime,
            tripScheduledIds: tripScheduledIds,
            options: options
        )
        result[idx] = updatedDay

        guard !overflow.isEmpty else {
            return ReplanResult(days: result, adjustments: adjustments, droppedAttractionIds: [])
        }

        let (relocated, relocateAdj, remaining) = relocateOverflowForward(
            overflow,
            cityId: entry,
            fromDayIndex: dayIndex,
            days: result,
            options: options
        )
        let dropped = attractionIds(from: remaining)
        var allAdj = adjustments + relocateAdj
        if !dropped.isEmpty {
            allAdj.append("Dropped \(dropped.count) sight(s) that could not fit after international arrival")
        }
        return ReplanResult(days: relocated, adjustments: allAdj, droppedAttractionIds: dropped)
    }

    private static func replanDepartureInternal(
        days: [ItineraryDay],
        exitCityId: String,
        departureTime: String?,
        options: Options
    ) -> ReplanResult {
        guard let dayIndex = CityTravelHints.resolveExitSightseeingDayIndex(
            days: days,
            visitOrder: options.visitOrder
        ), let idx = days.firstIndex(where: { $0.dayIndex == dayIndex }) else {
            return ReplanResult(days: days, adjustments: [], droppedAttractionIds: [])
        }

        var result = days
        let exit = exitCityId.lowercased()
        let tripScheduledIds = scheduledAttractionIds(in: result)

        let (updatedDay, adjustments, overflow) = replanExitDay(
            day: result[idx],
            exitCityId: exit,
            departureTime: departureTime,
            tripScheduledIds: tripScheduledIds,
            options: options
        )
        result[idx] = updatedDay

        guard !overflow.isEmpty else {
            return ReplanResult(days: result, adjustments: adjustments, droppedAttractionIds: [])
        }

        let (relocated, relocateAdj, remaining) = relocateOverflowBackward(
            overflow,
            cityId: exit,
            fromDayIndex: dayIndex,
            days: result,
            options: options
        )
        let dropped = attractionIds(from: remaining)
        var allAdj = adjustments + relocateAdj
        if !dropped.isEmpty {
            allAdj.append("Dropped \(dropped.count) sight(s) that could not fit before international departure")
        }
        return ReplanResult(days: relocated, adjustments: allAdj, droppedAttractionIds: dropped)
    }

    private static func replanSameDayEndpoint(
        days: [ItineraryDay],
        dayIndex: Int,
        dayArrayIndex: Int,
        cityId: String,
        arrivalTime: String?,
        departureTime: String?,
        options: Options
    ) -> ReplanResult {
        let day = days[dayArrayIndex]
        let caps = combinedEndpointCaps(arrivalTime: arrivalTime, departureTime: departureTime, pace: options.pace)
        let tripScheduledIds = scheduledAttractionIds(in: days)

        var experienceItems = day.experienceItems
        if day.isExperienceSuggestions || isInternationalEndpointDay(day, kind: .arrival) || isInternationalEndpointDay(day, kind: .departure) {
            var lines: [String] = []
            if let arrivalTime {
                lines.append(contentsOf: CityTravelHints.internationalArrivalItems(cityId: cityId, arrivalTime: arrivalTime))
            } else {
                lines.append(contentsOf: CityTravelHints.internationalArrivalPlaceholder(cityId: cityId))
            }
            if let departureTime {
                lines.append(contentsOf: CityTravelHints.internationalDepartureItems(cityId: cityId, departureTime: departureTime).dropFirst())
            } else if arrivalTime != nil {
                lines.append(contentsOf: CityTravelHints.internationalDeparturePlaceholder(cityId: cityId).dropFirst())
            }
            experienceItems = lines
        }

        var adjustments: [String] = []
        if arrivalTime != nil || departureTime != nil {
            adjustments.append("Updated same-day international entry/exit schedule")
        }

        var daytimeActs: [ItineraryActivity] = []
        var eveningActs: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        var daytimeUsed = 0.0

        for act in day.activities {
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            let dur = activityDuration(act, catalogById: options.catalogById)
            if isEvening {
                if caps.eveningCap > 0, eveningActs.count < caps.eveningCap {
                    eveningActs.append(act)
                } else {
                    overflow.append(act)
                }
                continue
            }
            if caps.daytimeCap <= 0 {
                overflow.append(act)
                continue
            }
            if daytimeUsed + dur <= caps.daytimeCap {
                daytimeUsed += dur
                daytimeActs.append(act)
            } else {
                overflow.append(act)
            }
        }

        let backfill = backfillActivities(
            cityId: cityId,
            daytimeCap: caps.daytimeCap,
            eveningCap: caps.eveningCap,
            usedDaytime: daytimeUsed,
            eveningCount: eveningActs.count,
            excludeIds: tripScheduledIds,
            dayIndex: day.dayIndex,
            startActIndex: daytimeActs.count + eveningActs.count,
            options: options
        )
        daytimeActs.append(contentsOf: backfill.daytime)
        eveningActs.append(contentsOf: backfill.evening)

        let reslottedDaytime = daytimeActs.enumerated().map { i, act in
            reslot(act, preferred: .afternoon, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
        }
        let reslottedEvening = eveningActs.enumerated().map { i, act in
            reslot(act, preferred: .evening, dayIndex: day.dayIndex, actIndex: reslottedDaytime.count + i, catalogById: options.catalogById)
        }

        var result = days
        result[dayArrayIndex] = day
            .withExperienceItems(experienceItems)
            .withActivities(reslottedDaytime + reslottedEvening)

        guard !overflow.isEmpty else {
            return ReplanResult(days: result, adjustments: adjustments, droppedAttractionIds: [])
        }

        let (forwarded, fwdAdj, fwdRemaining) = relocateOverflowForward(
            overflow,
            cityId: cityId,
            fromDayIndex: dayIndex,
            days: result,
            options: options
        )
        let (backwarded, bwdAdj, finalRemaining) = relocateOverflowBackward(
            fwdRemaining,
            cityId: cityId,
            fromDayIndex: dayIndex,
            days: forwarded,
            options: options
        )
        let dropped = attractionIds(from: finalRemaining)
        var allAdj = adjustments + fwdAdj + bwdAdj
        if !dropped.isEmpty {
            allAdj.append("Dropped \(dropped.count) sight(s) on combined entry/exit day")
        }
        return ReplanResult(days: backwarded, adjustments: allAdj, droppedAttractionIds: dropped)
    }

    private struct CombinedCaps {
        let daytimeCap: Double
        let eveningCap: Int
    }

    private static func combinedEndpointCaps(
        arrivalTime: String?,
        departureTime: String?,
        pace: TripPace
    ) -> CombinedCaps {
        let windows = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: arrivalTime,
            travelHours: nil,
            pace: pace,
            isTravelDay: false,
            hopKind: nil
        )
        var daytimeCap = windows.daytimeCap
        if arrivalTime != nil, PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            daytimeCap = 0
        }
        if PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            daytimeCap = min(
                daytimeCap,
                PlanItineraryPace.daySlotCapacity(profile: .departureDay, pace: pace)
            )
        }
        var eveningCap = windows.eveningCap
        if PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            eveningCap = 0
        }
        return CombinedCaps(daytimeCap: daytimeCap, eveningCap: eveningCap)
    }

    private static func replanEntryDay(
        day: ItineraryDay,
        entryCityId: String,
        arrivalTime: String?,
        tripScheduledIds: Set<String>,
        options: Options
    ) -> (day: ItineraryDay, adjustments: [String], overflow: [ItineraryActivity]) {
        let caps = combinedEndpointCaps(arrivalTime: arrivalTime, departureTime: nil, pace: options.pace)
        var adjustments: [String] = []

        var experienceItems = day.experienceItems
        if day.isExperienceSuggestions || isInternationalEndpointDay(day, kind: .arrival) {
            experienceItems = arrivalTime.map {
                CityTravelHints.internationalArrivalItems(cityId: entryCityId, arrivalTime: $0)
            } ?? CityTravelHints.internationalArrivalPlaceholder(cityId: entryCityId)
            if arrivalTime != nil {
                adjustments.append("Updated entry day for international arrival")
            }
        }

        var daytimeActs: [ItineraryActivity] = []
        var eveningActs: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        var daytimeUsed = 0.0

        for act in day.activities {
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            let dur = activityDuration(act, catalogById: options.catalogById)
            if isEvening {
                if eveningActs.count < caps.eveningCap {
                    eveningActs.append(act)
                } else {
                    overflow.append(act)
                }
                continue
            }
            if caps.daytimeCap <= 0 {
                overflow.append(act)
                continue
            }
            if daytimeUsed + dur <= caps.daytimeCap {
                daytimeUsed += dur
                daytimeActs.append(act)
            } else {
                overflow.append(act)
            }
        }

        if arrivalTime != nil, caps.daytimeCap < PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: options.pace) {
            adjustments.append("Trimmed entry-day sights for international arrival window")
        }

        let backfill = backfillActivities(
            cityId: entryCityId,
            daytimeCap: caps.daytimeCap,
            eveningCap: caps.eveningCap,
            usedDaytime: daytimeUsed,
            eveningCount: eveningActs.count,
            excludeIds: tripScheduledIds,
            dayIndex: day.dayIndex,
            startActIndex: daytimeActs.count + eveningActs.count,
            options: options
        )
        daytimeActs.append(contentsOf: backfill.daytime)
        eveningActs.append(contentsOf: backfill.evening)
        if !backfill.daytime.isEmpty || !backfill.evening.isEmpty {
            adjustments.append("Added \(backfill.daytime.count + backfill.evening.count) sight(s) after earlier arrival")
        }

        let reslottedDaytime = daytimeActs.enumerated().map { i, act in
            reslot(act, preferred: .afternoon, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
        }
        let reslottedEvening = eveningActs.enumerated().map { i, act in
            reslot(act, preferred: .evening, dayIndex: day.dayIndex, actIndex: reslottedDaytime.count + i, catalogById: options.catalogById)
        }

        let updated = day
            .withExperienceItems(experienceItems)
            .withActivities(reslottedDaytime + reslottedEvening)
        return (updated, adjustments, overflow)
    }

    private static func replanExitDay(
        day: ItineraryDay,
        exitCityId: String,
        departureTime: String?,
        tripScheduledIds: Set<String>,
        options: Options
    ) -> (day: ItineraryDay, adjustments: [String], overflow: [ItineraryActivity]) {
        var capacity = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: options.pace)
        if PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            capacity = min(
                capacity,
                PlanItineraryPace.daySlotCapacity(profile: .departureDay, pace: options.pace)
            )
        }

        var adjustments: [String] = []
        var experienceItems = day.experienceItems
        if day.isExperienceSuggestions || isInternationalEndpointDay(day, kind: .departure) {
            experienceItems = departureTime.map {
                CityTravelHints.internationalDepartureItems(cityId: exitCityId, departureTime: $0)
            } ?? CityTravelHints.internationalDeparturePlaceholder(cityId: exitCityId)
            if departureTime != nil {
                adjustments.append("Updated exit day for international departure")
            }
        }

        var kept: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        var used = 0.0

        for act in day.activities {
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            let dur = activityDuration(act, catalogById: options.catalogById)
            if isEvening {
                if PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
                    overflow.append(act)
                } else {
                    kept.append(act)
                }
                continue
            }
            if used + dur <= capacity {
                used += dur
                kept.append(act)
            } else {
                overflow.append(act)
            }
        }

        if PlanItineraryFlightTimes.isMorningDeparture(departureTime), !overflow.isEmpty {
            adjustments.append("Trimmed exit-day sights for morning departure")
        }

        let reslotted = kept.enumerated().map { i, act in
            let pref: VisitTimeSlot = (act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById))
                ? .evening
                : .morning
            return reslot(act, preferred: pref, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
        }

        let updated = day
            .withExperienceItems(experienceItems)
            .withActivities(reslotted)
        return (updated, adjustments, overflow)
    }

    private enum EndpointKind { case arrival, departure }

    private static func isInternationalEndpointDay(_ day: ItineraryDay, kind: EndpointKind) -> Bool {
        guard let first = day.experienceItems.first?.lowercased() else { return false }
        switch kind {
        case .arrival:
            return first.contains("international arrival")
                || first.contains("afternoon arrival")
                || first.contains("land in")
        case .departure:
            return first.contains("international departure")
                || first.contains("morning departure")
                || first.contains("depart from")
        }
    }

    private static func scheduledAttractionIds(in days: [ItineraryDay]) -> Set<String> {
        Set(days.flatMap { $0.activities.compactMap(\.attractionId) })
    }

    private static func attractionIds(from activities: [ItineraryActivity]) -> [String] {
        activities.compactMap(\.attractionId)
    }

    private struct BackfillResult {
        let daytime: [ItineraryActivity]
        let evening: [ItineraryActivity]
    }

    private static func backfillActivities(
        cityId: String,
        daytimeCap: Double,
        eveningCap: Int,
        usedDaytime: Double,
        eveningCount: Int,
        excludeIds: Set<String>,
        dayIndex: Int,
        startActIndex: Int,
        options: Options
    ) -> BackfillResult {
        let to = cityId.lowercased()
        var daytime: [ItineraryActivity] = []
        var evening: [ItineraryActivity] = []
        var used = usedDaytime
        var actIndex = startActIndex
        var evCount = eveningCount

        let pool = options.droppedAttractionIds + options.catalogById.values
            .filter { $0.cityId.lowercased() == to }
            .sorted {
                let pa = priorityRank($0.priority)
                let pb = priorityRank($1.priority)
                if pa != pb { return pa < pb }
                return $0.displayOrder < $1.displayOrder
            }
            .map(\.id)

        for aid in pool {
            if excludeIds.contains(aid) { continue }
            guard let row = options.catalogById[aid] else { continue }
            let dur = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
            if row.isEveningOnly {
                if evCount < eveningCap {
                    evening.append(makeActivity(row, dayIndex: dayIndex, actIndex: actIndex, preferred: .evening))
                    actIndex += 1
                    evCount += 1
                }
                continue
            }
            if used + dur <= daytimeCap {
                used += dur
                daytime.append(makeActivity(row, dayIndex: dayIndex, actIndex: actIndex, preferred: .afternoon))
                actIndex += 1
            }
        }
        return BackfillResult(daytime: daytime, evening: evening)
    }

    private static func relocateOverflowForward(
        _ overflow: [ItineraryActivity],
        cityId: String,
        fromDayIndex: Int,
        days: [ItineraryDay],
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String], remaining: [ItineraryActivity]) {
        guard !overflow.isEmpty else { return (days, [], []) }
        var result = days
        var queue = overflow
        var adjustments: [String] = []
        let to = cityId.lowercased()

        for dayIdx in result.indices {
            let day = result[dayIdx]
            guard day.dayIndex > fromDayIndex else { continue }
            guard !day.isExperienceSuggestions else { continue }

            let dayCity = day.experienceCityId?.lowercased()
                ?? day.intercityHop?.toCityId.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()

            let acceptsDestination = dayCity == to
                || day.activities.contains(where: { $0.cityId?.lowercased() == to })
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
                reslot(act, preferred: .afternoon, dayIndex: day.dayIndex, actIndex: start + i, catalogById: options.catalogById)
            }
            result[dayIdx] = day.withActivities(day.activities + newActs)
            adjustments.append("Moved \(placed.count) sight(s) to day \(day.dayIndex) after international arrival")
            if queue.isEmpty { break }
        }

        return (result, adjustments, queue)
    }

    private static func relocateOverflowBackward(
        _ overflow: [ItineraryActivity],
        cityId: String,
        fromDayIndex: Int,
        days: [ItineraryDay],
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String], remaining: [ItineraryActivity]) {
        guard !overflow.isEmpty else { return (days, [], []) }
        var result = days
        var queue = overflow
        var adjustments: [String] = []
        let to = cityId.lowercased()

        for dayIdx in result.indices.reversed() {
            let day = result[dayIdx]
            guard day.dayIndex < fromDayIndex else { continue }
            guard !day.isExperienceSuggestions else { continue }

            let dayCity = day.experienceCityId?.lowercased()
                ?? day.intercityHop?.toCityId.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()
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
                reslot(act, preferred: .afternoon, dayIndex: day.dayIndex, actIndex: start + i, catalogById: options.catalogById)
            }
            result[dayIdx] = day.withActivities(day.activities + newActs)
            adjustments.append("Moved \(placed.count) sight(s) to day \(day.dayIndex) before international departure")
            if queue.isEmpty { break }
        }

        return (result, adjustments, queue)
    }

    private static func makeActivity(
        _ row: Attraction,
        dayIndex: Int,
        actIndex: Int,
        preferred: VisitTimeSlot
    ) -> ItineraryActivity {
        let slot = PlanItineraryVisitHours.pickVisitTimeSlot(row, preferred: preferred)
        return ItineraryActivity(
            id: "a_\(dayIndex)_\(actIndex)_\(row.id)",
            timeSlot: PlanItineraryVisitHours.visitTimeSlotLabel(slot),
            name: row.name,
            detail: row.recommendedDurationText ?? "Explore at your own pace",
            attractionId: row.id,
            cityId: row.cityId,
            hasAudio: row.audioGuideCount > 0
        )
    }

    private static func priorityRank(_ p: String) -> Int {
        switch p.uppercased() {
        case "P0": return 0
        case "P2": return 2
        default: return 1
        }
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
}
