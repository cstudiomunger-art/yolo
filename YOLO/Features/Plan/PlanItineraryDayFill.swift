import Foundation

/// Ensures every calendar activity day has visible content (never blank in UI).
enum PlanItineraryDayFill {
    static func fillEmptyDays(
        _ days: [ItineraryDay],
        visitOrder: [String],
        pace: TripPace = .standard,
        arrivalTime: String? = nil,
        departureTime: String? = nil,
        cityIdByDayIndex: [Int: String] = [:],
        activityDaysExcludeCalendarEndpoints: Bool = true,
        schedulingGapDayIndices: Set<Int> = []
    ) -> [ItineraryDay] {
        let dayIndices = days.map(\.dayIndex).sorted()
        let firstTripDay = dayIndices.first
        let lastTripDay = dayIndices.last
        let order = visitOrder.map { $0.lowercased() }.filter { !$0.isEmpty }

        return days.map { day in
            if day.intercityHop != nil { return day }
            guard isBlank(day) else { return day }
            let cityId = resolveCityId(
                for: day,
                visitOrder: order,
                cityIdByDayIndex: cityIdByDayIndex
            )
            let items = experienceItems(
                dayIndex: day.dayIndex,
                cityId: cityId,
                firstTripDay: firstTripDay,
                lastTripDay: lastTripDay,
                tripDayCount: dayIndices.count,
                arrivalTime: arrivalTime,
                departureTime: departureTime,
                activityDaysExcludeCalendarEndpoints: activityDaysExcludeCalendarEndpoints,
                isSchedulingGap: schedulingGapDayIndices.contains(day.dayIndex)
            )
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: day.cityName.isEmpty ? CityTravelHints.displayName(for: cityId) : day.cityName,
                costEstimate: day.costEstimate,
                activities: [],
                dayKind: .experienceSuggestions,
                experienceItems: items,
                experienceCityId: cityId
            )
        }
    }

    static func isBlank(_ day: ItineraryDay) -> Bool {
        if day.intercityHop != nil { return false }
        return !day.isExperienceSuggestions && day.activities.isEmpty && day.experienceItems.isEmpty
    }

    /// Schedules catalog sights into blank standard days (e.g. Beijing day 7/19 after replan).
    static func replenishBlankSightseeingDays(
        _ days: [ItineraryDay],
        visitOrder: [String],
        pace: TripPace = .standard,
        catalogById: [String: Attraction],
        droppedAttractionIds: [String] = [],
        cityIdByDayIndex: [Int: String] = [:]
    ) -> [ItineraryDay] {
        let order = visitOrder.map { $0.lowercased() }.filter { !$0.isEmpty }
        let cityMap = PlanItineraryIntercityAnnotator.completeCityIdByDayIndex(
            from: days,
            visitOrder: visitOrder,
            seed: cityIdByDayIndex
        )
        var scheduledIds = Set(days.flatMap { $0.activities.compactMap(\.attractionId) })
        var result = days

        for index in result.indices {
            let day = result[index]
            guard isBlank(day), day.intercityHop == nil else { continue }

            let cityId = resolveCityId(for: day, visitOrder: order, cityIdByDayIndex: cityMap)
            let daytimeCap = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
            let backfill = backfillActivities(
                cityId: cityId,
                daytimeCap: daytimeCap,
                eveningCap: 1,
                excludeIds: scheduledIds,
                dayIndex: day.dayIndex,
                catalogById: catalogById,
                droppedAttractionIds: droppedAttractionIds
            )
            let activities = backfill.daytime + backfill.evening
            guard !activities.isEmpty else { continue }

            for activity in activities {
                if let attractionId = activity.attractionId {
                    scheduledIds.insert(attractionId)
                }
            }

            result[index] = ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: day.cityName.isEmpty ? CityTravelHints.displayName(for: cityId) : day.cityName,
                costEstimate: day.costEstimate,
                activities: activities,
                dayKind: .standard,
                experienceItems: [],
                experienceCityId: cityId
            )
        }

        return result
    }

    private struct BackfillResult {
        let daytime: [ItineraryActivity]
        let evening: [ItineraryActivity]
    }

    private static func backfillActivities(
        cityId: String,
        daytimeCap: Double,
        eveningCap: Int,
        excludeIds: Set<String>,
        dayIndex: Int,
        catalogById: [String: Attraction],
        droppedAttractionIds: [String]
    ) -> BackfillResult {
        let city = cityId.lowercased()
        var daytime: [ItineraryActivity] = []
        var evening: [ItineraryActivity] = []
        var usedDaytime = 0.0
        var actIndex = 0

        let pool = droppedAttractionIds + catalogById.values
            .filter { $0.cityId.lowercased() == city }
            .sorted {
                let left = priorityRank($0.priority)
                let right = priorityRank($1.priority)
                if left != right { return left < right }
                return $0.displayOrder < $1.displayOrder
            }
            .map(\.id)

        var seen = Set<String>()
        for attractionId in pool {
            guard !seen.contains(attractionId), !excludeIds.contains(attractionId) else { continue }
            seen.insert(attractionId)
            guard let row = catalogById[attractionId], row.cityId.lowercased() == city else { continue }
            let duration = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
            if row.isEveningOnly {
                guard evening.count < eveningCap else { continue }
                evening.append(makeActivity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .evening))
                actIndex += 1
            } else if usedDaytime + duration <= daytimeCap || (daytime.isEmpty && daytimeCap > 0) {
                daytime.append(makeActivity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .afternoon))
                usedDaytime += duration
                actIndex += 1
            }
            if usedDaytime >= daytimeCap, evening.count >= eveningCap { break }
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

    private static func priorityRank(_ priority: String) -> Int {
        switch priority.uppercased() {
        case "P0": return 0
        case "P2": return 2
        default: return 1
        }
    }

    private static func experienceItems(
        dayIndex: Int,
        cityId: String,
        firstTripDay: Int?,
        lastTripDay: Int?,
        tripDayCount: Int,
        arrivalTime: String?,
        departureTime: String?,
        activityDaysExcludeCalendarEndpoints: Bool,
        isSchedulingGap: Bool
    ) -> [String] {
        if isSchedulingGap {
            return CityTravelHints.unfilledSchedulingGapItems(cityId: cityId)
        }
        if dayIndex == firstTripDay,
           PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            return CityTravelHints.arrivalAfternoonExperienceItems(cityId: cityId)
        }
        if dayIndex == lastTripDay, tripDayCount > 1,
           PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            return CityTravelHints.departureMorningExperienceItems(cityId: cityId)
        }
        return CityTravelHints.flexibleRestDayItems(cityId: cityId)
    }

    private static func resolveCityId(
        for day: ItineraryDay,
        visitOrder: [String],
        cityIdByDayIndex: [Int: String]
    ) -> String {
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        if let cid = day.activities.compactMap(\.cityId).first, !cid.isEmpty { return cid.lowercased() }
        let normalizedName = day.cityName.lowercased()
        if !normalizedName.isEmpty {
            for cid in visitOrder {
                if CityTravelHints.displayName(for: cid).lowercased() == normalizedName { return cid }
            }
        }
        if let timelineCity = cityIdByDayIndex[day.dayIndex]?.lowercased(), !timelineCity.isEmpty {
            return timelineCity
        }
        let idx = day.dayIndex - 1
        if idx >= 0, idx < visitOrder.count { return visitOrder[idx] }
        return visitOrder.last ?? "beijing"
    }
}
