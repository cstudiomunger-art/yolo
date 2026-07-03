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
        let sightseeing = days.filter { !$0.isExperienceSuggestions }.map(\.dayIndex).sorted()
        let firstSight = sightseeing.first
        let lastSight = sightseeing.last
        let order = visitOrder.map { $0.lowercased() }.filter { !$0.isEmpty }

        return days.map { day in
            guard isBlank(day) else { return day }
            let cityId = resolveCityId(for: day, visitOrder: order)
            let items = experienceItems(
                dayIndex: day.dayIndex,
                cityId: cityId,
                firstSight: firstSight,
                lastSight: lastSight,
                sightseeingCount: sightseeing.count,
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
        !day.isExperienceSuggestions && day.activities.isEmpty && day.experienceItems.isEmpty
    }

    private static func experienceItems(
        dayIndex: Int,
        cityId: String,
        firstSight: Int?,
        lastSight: Int?,
        sightseeingCount: Int,
        arrivalTime: String?,
        departureTime: String?
    ) -> [String] {
        if dayIndex == firstSight, PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            return CityTravelHints.arrivalAfternoonExperienceItems(cityId: cityId)
        }
        if dayIndex == lastSight, sightseeingCount > 1,
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
