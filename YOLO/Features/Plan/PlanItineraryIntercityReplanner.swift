import Foundation

/// Re-sorts hop and travel days when the user sets an arrival time at the destination city.
enum PlanItineraryIntercityReplanner {
    struct Options {
        let pace: TripPace
        let catalogById: [String: Attraction]
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

        if day.isExperienceSuggestions {
            let (updatedDay, travelAdj, overflow) = replanTravelDay(
                day: day,
                hop: hop,
                arrivalTime: resolvedArrival,
                options: options
            )
            result[idx] = updatedDay
            adjustments.append(contentsOf: travelAdj)
            if !overflow.isEmpty {
                let (relocated, relocateAdj) = relocateOverflow(
                    overflow,
                    toCityId: hop.toCityId,
                    fromDayIndex: dayIndex,
                    days: result,
                    options: options
                )
                result = relocated
                adjustments.append(contentsOf: relocateAdj)
            }
        } else {
            let (updatedDay, hopAdj, overflow) = replanHopDay(
                day: day,
                hop: hop,
                arrivalTime: resolvedArrival,
                options: options
            )
            result[idx] = updatedDay
            adjustments.append(contentsOf: hopAdj)
            if !overflow.isEmpty {
                let (relocated, relocateAdj) = relocateOverflow(
                    overflow,
                    toCityId: hop.toCityId,
                    fromDayIndex: dayIndex,
                    days: result,
                    options: options
                )
                result = relocated
                adjustments.append(contentsOf: relocateAdj)
            }
        }

        return (result, adjustments)
    }

    private static func replanHopDay(
        day: ItineraryDay,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
        options: Options
    ) -> (day: ItineraryDay, adjustments: [String], overflow: [ItineraryActivity]) {
        let from = hop.fromCityId.lowercased()
        let to = hop.toCityId.lowercased()
        let allowsMorning = PlanItineraryFlightTimes.allowsMorningInOriginCity(
            travelHours: hop.travelHours,
            arrivalAtDestination: arrivalTime
        )
        let capacity = PlanItineraryFlightTimes.remainingDaytimeCapacity(
            arrivalAtDestination: arrivalTime,
            pace: options.pace,
            isTravelDay: false
        )

        var morningActs: [ItineraryActivity] = []
        var destActs: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []

        for act in day.activities {
            let city = act.cityId?.lowercased()
            let isFrom = city == from
            if isFrom {
                if allowsMorning { morningActs.append(act) }
                else { overflow.append(act) }
            } else if city == to || city == nil {
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
            if PlanItineraryFlightTimes.isEveningArrival(arrivalTime) {
                if isEvening { keptDest.append(act) }
                else { overflow.append(act) }
                continue
            }
            if capacity <= 0 {
                if isEvening { keptDest.append(act) }
                else { overflow.append(act) }
                continue
            }
            if used + dur <= capacity {
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
        if !allowsMorning {
            adjustments.append("Removed morning sights in \(CityTravelHints.displayName(for: from)) due to late arrival")
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

        let updated = day
            .withActivities(reslottedMorning + reslottedDest)
            .withIntercityHop(hop)
        return (updated, adjustments, overflow)
    }

    private static func replanTravelDay(
        day: ItineraryDay,
        hop: ItineraryIntercityHop,
        arrivalTime: String?,
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

        var keptEvening: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        let capacity = PlanItineraryFlightTimes.remainingDaytimeCapacity(
            arrivalAtDestination: arrivalTime,
            pace: options.pace,
            isTravelDay: true
        )

        for act in day.activities {
            let isEvening = act.timeSlot == "Evening" || isEveningOnly(act, catalogById: options.catalogById)
            if PlanItineraryFlightTimes.isEveningArrival(arrivalTime) {
                if isEvening { keptEvening.append(act) }
                else { overflow.append(act) }
                continue
            }
            let dur = activityDuration(act, catalogById: options.catalogById)
            let daytimeUsed = keptEvening.reduce(0.0) { used, kept in
                let eve = kept.timeSlot == "Evening" || isEveningOnly(kept, catalogById: options.catalogById)
                guard !eve else { return used }
                return used + activityDuration(kept, catalogById: options.catalogById)
            }
            if isEvening {
                keptEvening.append(act)
            } else if capacity > 0 && daytimeUsed + dur <= capacity {
                keptEvening.append(act)
            } else {
                overflow.append(act)
            }
        }

        let reslotted = keptEvening.enumerated().map { i, act in
            reslot(act, preferred: .evening, dayIndex: day.dayIndex, actIndex: i, catalogById: options.catalogById)
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

        for dayIdx in result.indices {
            let day = result[dayIdx]
            guard day.dayIndex > fromDayIndex else { continue }
            guard !day.isExperienceSuggestions || day.intercityHop == nil else { continue }

            let dayCity = day.experienceCityId?.lowercased()
                ?? day.intercityHop?.toCityId.lowercased()
                ?? day.activities.compactMap(\.cityId).first?.lowercased()

            let acceptsDestination = dayCity == to
                || day.activities.contains(where: { $0.cityId?.lowercased() == to })
                || (day.dayIndex > fromDayIndex
                    && day.activities.isEmpty
                    && !day.isExperienceSuggestions
                    && day.intercityHop == nil)
            guard acceptsDestination else { continue }

            let cap = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: options.pace)
            var used = day.activities.reduce(0.0) { sum, act in
                guard !isEveningOnly(act, catalogById: options.catalogById) else { return sum }
                return sum + activityDuration(act, catalogById: options.catalogById)
            }

            var placed: [ItineraryActivity] = []
            var remaining: [ItineraryActivity] = []
            for act in queue {
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
            adjustments.append("Moved \(placed.count) sight(s) to day \(day.dayIndex) after late arrival")
            if queue.isEmpty { break }
        }

        return (result, adjustments)
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
