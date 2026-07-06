import Foundation

/// Re-sorts hop and travel days when the user sets an arrival time at the destination city.
enum PlanItineraryIntercityReplanner {
    struct Options {
        let pace: TripPace
        let catalogById: [String: Attraction]
        var droppedAttractionIds: [String] = []
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

        let tripScheduledIds = scheduledAttractionIds(in: result)
        var overflow: [ItineraryActivity] = []

        if day.isExperienceSuggestions {
            let (updatedDay, travelAdj, travelOverflow) = replanTravelDay(
                day: day,
                hop: hop,
                arrivalTime: resolvedArrival,
                allDays: result,
                tripScheduledIds: tripScheduledIds,
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
                tripScheduledIds: tripScheduledIds,
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

        let (rebalanced, rebalanceAdj) = rebalanceSameCityAfterHop(
            days: result,
            hopDayIndex: dayIndex,
            hop: hop,
            arrivalTime: resolvedArrival,
            options: options
        )
        result = rebalanced
        adjustments.append(contentsOf: rebalanceAdj)

        return (result, adjustments)
    }

    private static func scheduledAttractionIds(in days: [ItineraryDay]) -> Set<String> {
        Set(days.flatMap { $0.activities.compactMap(\.attractionId) })
    }

    private static func replanHopDay(
        day: ItineraryDay,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
        allDays: [ItineraryDay],
        tripScheduledIds: Set<String>,
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
        let capacity = windows.daytimeCap
        let eveningCap = windows.eveningCap

        var morningActs: [ItineraryActivity] = []
        var destActs: [ItineraryActivity] = []
        var eveningActs: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []

        for act in day.activities {
            let city = act.cityId?.lowercased()
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            if city == from {
                if allowsMorning, !isEvening { morningActs.append(act) }
                else { overflow.append(act) }
            } else if isEvening {
                destActs.append(act)
            } else {
                destActs.append(act)
            }
        }

        var keptDest: [ItineraryActivity] = []
        var used = 0.0
        for act in destActs {
            let dur = activityDuration(act, catalogById: options.catalogById)
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            if isEvening {
                if eveningActs.count < eveningCap { eveningActs.append(act) }
                else { overflow.append(act) }
                continue
            }
            if capacity <= 0 {
                overflow.append(act)
                continue
            }
            if used + dur <= capacity || (keptDest.isEmpty && capacity > 0) {
                used += dur
                keptDest.append(act)
            } else {
                overflow.append(act)
            }
        }

        if !allowsMorning && !morningActs.isEmpty {
            overflow.insert(contentsOf: morningActs, at: 0)
            morningActs = []
        }

        var adjustments: [String] = []
        if !allowsMorning && !overflow.filter({ $0.cityId?.lowercased() == from }).isEmpty {
            adjustments.append("Moved morning sights in \(CityTravelHints.displayName(for: from)) to an earlier day")
        }

        let borrowable = borrowableAttractionIds(
            cityId: to,
            afterDayIndex: day.dayIndex,
            catalogById: options.catalogById,
            days: allDays
        )
        let backfillExclude = tripScheduledIds.subtracting(borrowable)

        let backfill = backfillActivities(
            cityId: to,
            daytimeCap: capacity,
            eveningCap: eveningCap,
            usedDaytime: used,
            eveningCount: eveningActs.count,
            excludeIds: backfillExclude,
            dayIndex: day.dayIndex,
            startActIndex: morningActs.count + keptDest.count + eveningActs.count,
            options: options
        )
        keptDest.append(contentsOf: backfill.daytime)
        eveningActs.append(contentsOf: backfill.evening)
        if !backfill.daytime.isEmpty || !backfill.evening.isEmpty {
            adjustments.append("Added \(backfill.daytime.count + backfill.evening.count) sight(s) for arrival window")
        }

        let reslottedMorning = morningActs.enumerated().map { i, act in
            reslot(act, preferred: .morning, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
        }
        let afternoonStart = reslottedMorning.count
        let reslottedDest = keptDest.enumerated().map { i, act in
            let pref: VisitTimeSlot = (act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById))
                ? .evening
                : .afternoon
            return reslot(act, preferred: pref, dayIndex: day.dayIndex, actIndex: afternoonStart + i, catalogById: options.catalogById)
        }
        let eveningStart = afternoonStart + reslottedDest.count
        let reslottedEvening = eveningActs.enumerated().map { i, act in
            reslot(act, preferred: .evening, dayIndex: day.dayIndex, actIndex: eveningStart + i, catalogById: options.catalogById)
        }

        let updated = day
            .withActivities(reslottedMorning + reslottedDest + reslottedEvening)
            .withIntercityHop(hop)
        return (updated, adjustments, overflow)
    }

    private static func replanTravelDay(
        day: ItineraryDay,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
        allDays: [ItineraryDay],
        tripScheduledIds: Set<String>,
        options: Options
    ) -> (day: ItineraryDay, adjustments: [String], overflow: [ItineraryActivity]) {
        let to = hop.toCityId.lowercased()
        var adjustments: [String] = []
        var experienceItems = day.experienceItems

        let windows = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: arrivalTime,
            travelHours: hop.travelHours,
            pace: options.pace,
            isTravelDay: true,
            hopKind: "travel"
        )

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

        var kept: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        let capacity = windows.daytimeCap
        let eveningCap = windows.eveningCap
        var daytimeUsed = 0.0
        var eveningCount = 0

        for act in day.activities {
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            let dur = activityDuration(act, catalogById: options.catalogById)
            if isEvening {
                if eveningCount < eveningCap {
                    kept.append(act)
                    eveningCount += 1
                } else {
                    overflow.append(act)
                }
                continue
            }
            if capacity > 0, daytimeUsed + dur <= capacity || (kept.isEmpty && capacity > 0) {
                kept.append(act)
                daytimeUsed += dur
            } else {
                overflow.append(act)
            }
        }

        let borrowable = borrowableAttractionIds(
            cityId: to,
            afterDayIndex: day.dayIndex,
            catalogById: options.catalogById,
            days: allDays
        )
        let backfillExclude = tripScheduledIds.subtracting(borrowable)

        let backfill = backfillActivities(
            cityId: to,
            daytimeCap: capacity,
            eveningCap: eveningCap,
            usedDaytime: daytimeUsed,
            eveningCount: eveningCount,
            excludeIds: backfillExclude,
            dayIndex: day.dayIndex,
            startActIndex: kept.count,
            options: options
        )
        kept.append(contentsOf: backfill.daytime + backfill.evening)
        if !backfill.daytime.isEmpty || !backfill.evening.isEmpty {
            adjustments.append("Added \(backfill.daytime.count + backfill.evening.count) sight(s) for arrival window")
        }

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

    /// Pull sights onto the hop/travel day or fill the next same-city day when arrival window allows.
    private static func rebalanceSameCityAfterHop(
        days: [ItineraryDay],
        hopDayIndex: Int,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
        options: Options
    ) -> (days: [ItineraryDay], adjustments: [String]) {
        guard let hopIdx = days.firstIndex(where: { $0.dayIndex == hopDayIndex }) else {
            return (days, [])
        }

        var result = days
        var adjustments: [String] = []
        let to = hop.toCityId.lowercased()
        let hopKind = inferredHopKind(from: hop.fromCityId, to: to, pace: options.pace)
        let isTravel = result[hopIdx].isExperienceSuggestions
        let windows = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: arrivalTime,
            travelHours: hop.travelHours,
            pace: options.pace,
            isTravelDay: isTravel,
            hopKind: isTravel ? "travel" : hopKind
        )

        let hopDay = result[hopIdx]
        var daytimeUsed = hopDay.activities.reduce(0.0) { sum, act in
            guard !isEveningOnly(act, catalogById: options.catalogById) else { return sum }
            return sum + activityDuration(act, catalogById: options.catalogById)
        }
        var eveningCount = hopDay.activities.filter {
            $0.timeSlot == "Evening" || isEveningOnly($0, catalogById: options.catalogById)
        }.count

        let daytimeRoom = max(0, windows.daytimeCap - daytimeUsed)
        let eveningRoom = max(0, windows.eveningCap - eveningCount)

        if daytimeRoom > 0 || eveningRoom > 0 {
            let (pulled, pullAdj, updatedDays) = pullSightsOntoDay(
                days: result,
                targetDayIndex: hopDayIndex,
                cityId: to,
                daytimeRoom: daytimeRoom,
                eveningRoom: eveningRoom,
                options: options
            )
            if !pulled.isEmpty {
                result = updatedDays
                var activities = result[hopIdx].activities
                activities.append(contentsOf: pulled)
                result[hopIdx] = result[hopIdx].withActivities(activities)
                adjustments.append(contentsOf: pullAdj)
            }
        }

        if result[hopIdx].activities.isEmpty, windows.daytimeCap > 0 || windows.eveningCap > 0 {
            if let nextIdx = result.indices.first(where: { index in
                let d = result[index]
                guard d.dayIndex > hopDayIndex, d.intercityHop == nil, !d.isExperienceSuggestions else { return false }
                let city = d.experienceCityId?.lowercased()
                    ?? d.activities.compactMap(\.cityId).first?.lowercased()
                return city == to
            }) {
                let moved = min(2, result[nextIdx].activities.count)
                if moved > 0 {
                    let toMove = Array(result[nextIdx].activities.prefix(moved))
                    let remaining = Array(result[nextIdx].activities.dropFirst(moved))
                    result[nextIdx] = result[nextIdx].withActivities(remaining)
                    result[hopIdx] = result[hopIdx].withActivities(toMove)
                    adjustments.append(
                        "Moved \(moved) sight(s) from day \(result[nextIdx].dayIndex) onto travel day after early arrival"
                    )
                }
            }
        }

        return (result, adjustments)
    }

    private static func pullSightsOntoDay(
        days: [ItineraryDay],
        targetDayIndex: Int,
        cityId: String,
        daytimeRoom: Double,
        eveningRoom: Int,
        options: Options
    ) -> (pulled: [ItineraryActivity], adjustments: [String], days: [ItineraryDay]) {
        var result = days
        var pulled: [ItineraryActivity] = []
        var adjustments: [String] = []
        let city = cityId.lowercased()
        var dayBudget = daytimeRoom
        var eveBudget = eveningRoom

        for dayIdx in result.indices {
            let day = result[dayIdx]
            guard day.dayIndex > targetDayIndex else { continue }
            let dayCity = day.experienceCityId?.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()
            guard dayCity == city else { continue }

            var keep: [ItineraryActivity] = []
            for act in day.activities {
                guard let aid = act.attractionId,
                      let row = options.catalogById[aid],
                      priorityRank(row.priority) > 0 else {
                    keep.append(act)
                    continue
                }
                let isEvening = act.timeSlot == "Evening" || row.isEveningOnly
                let dur = activityDuration(act, catalogById: options.catalogById)
                if isEvening, eveBudget > 0 {
                    pulled.append(act)
                    eveBudget -= 1
                } else if !isEvening, dayBudget > 0, dur <= dayBudget || pulled.isEmpty {
                    pulled.append(act)
                    dayBudget -= dur
                } else {
                    keep.append(act)
                }
                if dayBudget <= 0, eveBudget <= 0 { break }
            }
            if keep.count != day.activities.count {
                result[dayIdx] = day.withActivities(keep)
                adjustments.append("Borrowed sight(s) from day \(day.dayIndex) for arrival window")
            }
            if dayBudget <= 0, eveBudget <= 0 { break }
        }

        return (pulled, adjustments, result)
    }

    private static func borrowableAttractionIds(
        cityId: String,
        afterDayIndex: Int,
        catalogById: [String: Attraction],
        days allDays: [ItineraryDay]
    ) -> Set<String> {
        let city = cityId.lowercased()
        var ids = Set<String>()
        for day in allDays where day.dayIndex > afterDayIndex {
            let dayCity = day.experienceCityId?.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()
            guard dayCity == city else { continue }
            for act in day.activities {
                guard let aid = act.attractionId, let row = catalogById[aid] else { continue }
                if priorityRank(row.priority) > 0 { ids.insert(aid) }
            }
        }
        return ids
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

        let pool = options.droppedAttractionIds + options.catalogById.values
            .filter { $0.cityId.lowercased() == to }
            .sorted {
                let pa = priorityRank($0.priority)
                let pb = priorityRank($1.priority)
                if pa != pb { return pa < pb }
                return $0.displayOrder < $1.displayOrder
            }
            .map(\.id)

        var seen = Set<String>()
        for id in pool {
            guard !seen.contains(id), !excludeIds.contains(id) else { continue }
            seen.insert(id)
            guard let row = options.catalogById[id], row.cityId.lowercased() == to else { continue }
            let dur = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
            if row.isEveningOnly {
                guard evening.count + eveningCount < eveningCap else { continue }
                evening.append(makeActivity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .evening))
                actIndex += 1
            } else if used + dur <= daytimeCap || (daytime.isEmpty && daytimeCap > 0) {
                daytime.append(makeActivity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .afternoon))
                used += dur
                actIndex += 1
            }
            if used >= daytimeCap && evening.count + eveningCount >= eveningCap { break }
        }

        return BackfillResult(daytime: daytime, evening: evening)
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

    private static func inferredHopKind(from: String, to: String, pace: TripPace) -> String {
        let hours = CityTravelHints.travelHours(from, to)
        let slots = CityTravelHints.commuteSlots(hours)
        if pace == .intense, CityTravelHints.canIntenseSameDayHop(from, to) { return "hop" }
        if slots == 0 { return "short_hop" }
        if slots == 1 { return "travel_lite" }
        return "travel"
    }
}
