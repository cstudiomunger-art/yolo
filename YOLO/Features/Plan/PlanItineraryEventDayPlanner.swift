import Foundation

/// Plans event days (international arrival, intercity hop arrival) from arrival window + unscheduled catalog only.
enum PlanItineraryEventDayPlanner {
    struct Options {
        let pace: TripPace
        let catalogById: [String: Attraction]
        var droppedAttractionIds: [String] = []
    }

    struct Caps {
        let daytimeCap: Double
        let eveningCap: Int
    }

    /// International bookend caps (afternoon arrival → evening only).
    static func internationalArrivalCaps(arrivalTime: String?, pace: TripPace) -> Caps {
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
        return Caps(daytimeCap: daytimeCap, eveningCap: windows.eveningCap)
    }

    static func intercityCaps(
        arrivalTime: String?,
        travelHours: Double,
        pace: TripPace,
        isTravelDay: Bool,
        hopKind: String?
    ) -> Caps {
        let windows = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: arrivalTime,
            travelHours: travelHours,
            pace: pace,
            isTravelDay: isTravelDay,
            hopKind: hopKind
        )
        return Caps(daytimeCap: windows.daytimeCap, eveningCap: windows.eveningCap)
    }

    static func replanInternationalArrival(
        days: [ItineraryDay],
        eventDayIndex: Int,
        cityId: String,
        arrivalTime: String?,
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        guard let idx = days.firstIndex(where: { $0.dayIndex == eventDayIndex }) else {
            return (days, [])
        }
        let caps = internationalArrivalCaps(arrivalTime: arrivalTime, pace: options.pace)
        var result = days
        var day = result[idx]
        var adjustments: [String] = []

        if arrivalTime != nil {
            day = day.withExperienceItems(
                CityTravelHints.internationalArrivalItems(cityId: cityId, arrivalTime: arrivalTime!)
            )
            adjustments.append("Updated arrival event day for international landing")
        }
        if day.experienceCityId?.isEmpty != false {
            day = ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: day.cityName.isEmpty ? CityTravelHints.displayName(for: cityId) : day.cityName,
                costEstimate: day.costEstimate,
                activities: day.activities,
                dayKind: day.dayKind,
                experienceItems: day.experienceItems,
                experienceCityId: cityId,
                intercityHop: day.intercityHop
            )
        }

        let (trimmed, overflow, trimAdj) = trimActivities(
            day.activities,
            daytimeCap: caps.daytimeCap,
            eveningCap: caps.eveningCap,
            dayIndex: day.dayIndex,
            catalogById: options.catalogById
        )
        adjustments.append(contentsOf: trimAdj)

        var kept = trimmed
        let scheduled = PlanItineraryAttractionLedger.scheduledIds(in: result)
            .subtracting(Set(trimmed.compactMap(\.attractionId)))
        let backfill = backfillFromCatalog(
            cityId: cityId,
            daytimeCap: caps.daytimeCap,
            eveningCap: caps.eveningCap,
            usedDaytime: usedDaytime(kept, catalogById: options.catalogById),
            eveningCount: eveningCount(kept, catalogById: options.catalogById),
            excludeIds: scheduled,
            dayIndex: day.dayIndex,
            startActIndex: kept.count,
            options: options
        )
        kept.append(contentsOf: backfill.daytime + backfill.evening)
        if !backfill.daytime.isEmpty || !backfill.evening.isEmpty {
            adjustments.append("Scheduled \(backfill.daytime.count + backfill.evening.count) sight(s) for arrival window")
        }

        result[idx] = day.withActivities(kept)

        if !overflow.isEmpty {
            let (relocated, relocateAdj, _) = relocateOverflowForward(
                overflow,
                cityId: cityId,
                fromDayIndex: eventDayIndex,
                days: result,
                options: options
            )
            result = relocated
            adjustments.append(contentsOf: relocateAdj)
        }

        let deduped = PlanItineraryAttractionLedger.enforceUnique(result)
        result = deduped.days
        adjustments.append(contentsOf: deduped.adjustments)
        return (result, adjustments)
    }

    static func replanIntercityEvent(
        days: [ItineraryDay],
        eventDayIndex: Int,
        cityId: String,
        arrivalTime: String?,
        travelHours: Double,
        isTravelDay: Bool,
        hopKind: String?,
        existingActivities: [ItineraryActivity],
        options: Options
    ) -> (activities: [ItineraryActivity], overflow: [ItineraryActivity], adjustments: [String]) {
        let caps = intercityCaps(
            arrivalTime: arrivalTime,
            travelHours: travelHours,
            pace: options.pace,
            isTravelDay: isTravelDay,
            hopKind: hopKind
        )
        var adjustments: [String] = []

        let (trimmed, overflow, trimAdj) = trimActivities(
            existingActivities,
            daytimeCap: caps.daytimeCap,
            eveningCap: caps.eveningCap,
            dayIndex: eventDayIndex,
            catalogById: options.catalogById
        )
        adjustments.append(contentsOf: trimAdj)

        var kept = trimmed
        let othersScheduled = PlanItineraryAttractionLedger.scheduledIds(in: days)
            .subtracting(Set(existingActivities.compactMap(\.attractionId)))
        let backfill = backfillFromCatalog(
            cityId: cityId,
            daytimeCap: caps.daytimeCap,
            eveningCap: caps.eveningCap,
            usedDaytime: usedDaytime(kept, catalogById: options.catalogById),
            eveningCount: eveningCount(kept, catalogById: options.catalogById),
            excludeIds: othersScheduled,
            dayIndex: eventDayIndex,
            startActIndex: kept.count,
            options: options
        )
        kept.append(contentsOf: backfill.daytime + backfill.evening)
        if !backfill.daytime.isEmpty || !backfill.evening.isEmpty {
            adjustments.append("Scheduled \(backfill.daytime.count + backfill.evening.count) sight(s) for hop arrival window")
        }

        return (kept, overflow, adjustments)
    }

    static func finalizeAfterIntercityReplan(
        days: [ItineraryDay],
        adjustments: [String]
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        let deduped = PlanItineraryAttractionLedger.enforceUnique(days)
        let merged = adjustments + deduped.adjustments
        return (deduped.days, merged)
    }

    // MARK: - Private

    private struct BackfillResult {
        let daytime: [ItineraryActivity]
        let evening: [ItineraryActivity]
    }

    private static func trimActivities(
        _ activities: [ItineraryActivity],
        daytimeCap: Double,
        eveningCap: Int,
        dayIndex: Int,
        catalogById: [String: Attraction]
    ) -> (kept: [ItineraryActivity], overflow: [ItineraryActivity], adjustments: [String]) {
        var daytimeActs: [ItineraryActivity] = []
        var eveningActs: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        var daytimeUsed = 0.0

        for act in activities {
            let isEvening = isEveningActivity(act, catalogById: catalogById)
            let dur = activityDuration(act, catalogById: catalogById)
            if isEvening {
                if eveningActs.count < eveningCap {
                    eveningActs.append(act)
                } else {
                    overflow.append(act)
                }
                continue
            }
            if daytimeCap <= 0 {
                overflow.append(act)
                continue
            }
            if daytimeUsed + dur <= daytimeCap || (daytimeActs.isEmpty && daytimeCap > 0) {
                daytimeUsed += dur
                daytimeActs.append(act)
            } else {
                overflow.append(act)
            }
        }

        var adjustments: [String] = []
        if !overflow.isEmpty {
            adjustments.append("Trimmed \(overflow.count) sight(s) outside arrival window")
        }
        return (daytimeActs + eveningActs, overflow, adjustments)
    }

    private static func backfillFromCatalog(
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
        var daytime: [ItineraryActivity] = []
        var evening: [ItineraryActivity] = []
        var used = usedDaytime
        var evCount = eveningCount
        var actIndex = startActIndex

        let excluded = Set(excludeIds.map { $0.lowercased() })
        let pool = PlanItineraryAttractionLedger.unscheduledPool(
            cityId: cityId,
            catalogById: options.catalogById,
            days: [],
            droppedIds: options.droppedAttractionIds
        ).filter { !excluded.contains($0.id.lowercased()) }

        for row in pool {
            let dur = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
            if row.isEveningOnly {
                guard evCount < eveningCap else { continue }
                evening.append(makeActivity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .evening))
                actIndex += 1
                evCount += 1
            } else if used + dur <= daytimeCap || (daytime.isEmpty && daytimeCap > 0) {
                daytime.append(makeActivity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .afternoon))
                used += dur
                actIndex += 1
            }
            if used >= daytimeCap, evCount >= eveningCap { break }
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
        let city = cityId.lowercased()
        let cityMap = PlanItineraryIntercityAnnotator.completeCityIdByDayIndex(from: days, visitOrder: [])

        for dayIdx in result.indices {
            let day = result[dayIdx]
            guard day.dayIndex > fromDayIndex else { continue }
            guard day.intercityHop == nil else { continue }

            let dayCity = day.experienceCityId?.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()
                ?? cityMap[day.dayIndex]
            guard dayCity == city else { continue }

            let cap = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: options.pace)
            var used = usedDaytime(day.activities, catalogById: options.catalogById)
            let existingIds = Set(day.activities.compactMap(\.attractionId))
            var placed: [ItineraryActivity] = []
            var remaining: [ItineraryActivity] = []

            for act in queue {
                if let aid = act.attractionId {
                    let key = aid.lowercased()
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
            adjustments.append("Moved \(placed.count) sight(s) to day \(day.dayIndex)")
            if queue.isEmpty { break }
        }

        return (result, adjustments, queue)
    }

    private static func usedDaytime(_ activities: [ItineraryActivity], catalogById: [String: Attraction]) -> Double {
        activities.reduce(0.0) { sum, act in
            guard !isEveningActivity(act, catalogById: catalogById) else { return sum }
            return sum + activityDuration(act, catalogById: catalogById)
        }
    }

    private static func eveningCount(_ activities: [ItineraryActivity], catalogById: [String: Attraction]) -> Int {
        activities.filter { isEveningActivity($0, catalogById: catalogById) }.count
    }

    private static func isEveningActivity(_ act: ItineraryActivity, catalogById: [String: Attraction]) -> Bool {
        if act.timeSlot == "Evening" { return true }
        guard let aid = act.attractionId, let row = catalogById[aid] else { return false }
        return row.isEveningOnly
    }

    private static func activityDuration(_ act: ItineraryActivity, catalogById: [String: Attraction]) -> Double {
        guard let aid = act.attractionId, let row = catalogById[aid] else { return 1 }
        return PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
    }

    private static func makeActivity(
        from row: Attraction,
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

    private static func reslot(
        _ act: ItineraryActivity,
        preferred: VisitTimeSlot,
        dayIndex: Int,
        actIndex: Int,
        catalogById: [String: Attraction]
    ) -> ItineraryActivity {
        guard let aid = act.attractionId, let row = catalogById[aid] else { return act }
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
