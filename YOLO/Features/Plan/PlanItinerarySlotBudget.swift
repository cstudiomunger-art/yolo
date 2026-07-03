import Foundation

/// Duration-slot budget helpers shared by scheduler, normalizer, and tests.
enum PlanItinerarySlotBudget {
    /// Intense same-day hop (morning origin + afternoon destination), not standard travel-lite.
    static func isIntenseHopDay(_ day: ItineraryDay, pace: TripPace) -> Bool {
        guard let hop = day.intercityHop, !day.isExperienceSuggestions else { return false }
        guard pace == .intense else { return false }
        return CityTravelHints.canIntenseSameDayHop(hop.fromCityId, hop.toCityId)
    }

    /// Infer pace from itinerary shape when trip metadata has no stored pace.
    static func inferTripPace(from days: [ItineraryDay]) -> TripPace {
        let intense = days.contains { day in
            guard let hop = day.intercityHop, !day.isExperienceSuggestions else { return false }
            let from = hop.fromCityId.lowercased()
            let hasOriginSight = day.activities.contains { $0.cityId?.lowercased() == from }
            return hasOriginSight && CityTravelHints.canIntenseSameDayHop(hop.fromCityId, hop.toCityId)
        }
        return intense ? .intense : .standard
    }

    /// Daytime slot budget for hop / travel-lite days (matches scheduler timeline).
    static func hopDaytimeSlotBudget(for day: ItineraryDay, pace: TripPace) -> Double {
        guard let hop = day.intercityHop, !day.isExperienceSuggestions else { return 0 }
        if pace == .intense,
           CityTravelHints.canIntenseSameDayHop(hop.fromCityId, hop.toCityId) {
            return PlanItineraryPace.hopDaySlotCapacity
        }
        return 1
    }

    static func isEveningActivity(_ activity: ItineraryActivity, catalogById: [String: Attraction]) -> Bool {
        if activity.timeSlot == "Evening" { return true }
        guard let aid = activity.attractionId, let row = catalogById[aid] else { return false }
        return row.isEveningOnly
    }

    static func durationSlots(for activity: ItineraryActivity, catalogById: [String: Attraction]) -> Double {
        guard let aid = activity.attractionId, let row = catalogById[aid] else { return 1 }
        return PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
    }

    static func usedDaytimeSlots(
        activities: [ItineraryActivity],
        catalogById: [String: Attraction]
    ) -> Double {
        activities.reduce(0) { used, act in
            guard !isEveningActivity(act, catalogById: catalogById) else { return used }
            return used + durationSlots(for: act, catalogById: catalogById)
        }
    }

    static func fitsDaytime(
        activity: ItineraryActivity,
        into used: Double,
        capacity: Double,
        catalogById: [String: Attraction]
    ) -> Bool {
        if isEveningActivity(activity, catalogById: catalogById) { return true }
        let slots = durationSlots(for: activity, catalogById: catalogById)
        return used + slots <= capacity
    }

    static func trimDaytimeToCapacity(
        activities: [ItineraryActivity],
        capacity: Double,
        catalogById: [String: Attraction]
    ) -> (keep: [ItineraryActivity], overflow: [ItineraryActivity]) {
        var keep = activities
        var overflow: [ItineraryActivity] = []

        while PlanItinerarySlotBudget.usedDaytimeSlots(activities: keep, catalogById: catalogById) > capacity {
            guard let idx = keep.lastIndex(where: { !isEveningActivity($0, catalogById: catalogById) }) else {
                break
            }
            overflow.insert(keep.remove(at: idx), at: 0)
        }

        return (keep, overflow)
    }

    /// Assert helper for golden tests: daytime slot usage must not exceed capacity.
    static func daytimeWithinCapacity(
        activities: [ItineraryActivity],
        capacity: Double,
        catalogById: [String: Attraction]
    ) -> Bool {
        usedDaytimeSlots(activities: activities, catalogById: catalogById) <= capacity
    }

    /// Mirrors scheduler flight/pace profiles for normalize overflow placement.
    static func daytimeCapacity(
        dayIndex: Int,
        days: [ItineraryDay],
        pace: TripPace,
        arrivalTime: String? = nil,
        departureTime: String? = nil
    ) -> Double {
        let sightseeingIndices = days
            .filter { !$0.isExperienceSuggestions && $0.intercityHop == nil }
            .map(\.dayIndex)
            .sorted()
        guard sightseeingIndices.contains(dayIndex) else {
            if let hopDay = days.first(where: { $0.dayIndex == dayIndex }) {
                return hopDaytimeSlotBudget(for: hopDay, pace: pace)
            }
            return 0
        }

        let firstSight = sightseeingIndices.first
        let lastSight = sightseeingIndices.last

        var profile: DayScheduleProfile = .fullDay
        if dayIndex == firstSight { profile = .arrivalDay }
        if dayIndex == lastSight, sightseeingIndices.count > 1 { profile = .departureDay }

        var capacity = PlanItineraryPace.daySlotCapacity(profile: profile, pace: pace)

        if dayIndex == firstSight, PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            capacity = 0
        }
        if dayIndex == lastSight, PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            capacity = min(capacity, PlanItineraryPace.daySlotCapacity(profile: .departureDay, pace: pace))
        }

        return capacity
    }
}
