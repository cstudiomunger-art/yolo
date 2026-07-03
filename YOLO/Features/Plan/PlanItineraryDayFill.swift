import Foundation

/// Ensures every calendar activity day has visible content (never blank in UI).
enum PlanItineraryDayFill {
    static func fillEmptyDays(
        _ days: [ItineraryDay],
        visitOrder: [String],
        pace: TripPace = .standard,
        arrivalTime: String? = nil,
        departureTime: String? = nil
    ) -> [ItineraryDay] {
        let dayIndices = days.map(\.dayIndex).sorted()
        let firstTripDay = dayIndices.first
        let lastTripDay = dayIndices.last
        let order = visitOrder.map { $0.lowercased() }.filter { !$0.isEmpty }

        return days.map { day in
            if day.intercityHop != nil { return day }
            guard isBlank(day) else { return day }
            let cityId = resolveCityId(for: day, visitOrder: order)
            let items = experienceItems(
                dayIndex: day.dayIndex,
                cityId: cityId,
                firstTripDay: firstTripDay,
                lastTripDay: lastTripDay,
                tripDayCount: dayIndices.count,
                arrivalTime: arrivalTime,
                departureTime: departureTime
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

    private static func experienceItems(
        dayIndex: Int,
        cityId: String,
        firstTripDay: Int?,
        lastTripDay: Int?,
        tripDayCount: Int,
        arrivalTime: String?,
        departureTime: String?
    ) -> [String] {
        // Trip-wide flight profile: only calendar day 1 / last activity day — not
        // "first blank sightseeing row" after day 1 became an experience card.
        if dayIndex == firstTripDay, PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            return CityTravelHints.arrivalAfternoonExperienceItems(cityId: cityId)
        }
        if dayIndex == lastTripDay, tripDayCount > 1,
           PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            return CityTravelHints.departureMorningExperienceItems(cityId: cityId)
        }
        return CityTravelHints.flexibleRestDayItems(cityId: cityId)
    }

    private static func resolveCityId(for day: ItineraryDay, visitOrder: [String]) -> String {
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        if let cid = day.activities.compactMap(\.cityId).first, !cid.isEmpty { return cid.lowercased() }
        let normalizedName = day.cityName.lowercased()
        if !normalizedName.isEmpty {
            for cid in visitOrder {
                if CityTravelHints.displayName(for: cid).lowercased() == normalizedName { return cid }
            }
        }
        let idx = max(0, day.dayIndex - 1)
        if idx < visitOrder.count { return visitOrder[idx] }
        return visitOrder.first ?? "beijing"
    }
}
