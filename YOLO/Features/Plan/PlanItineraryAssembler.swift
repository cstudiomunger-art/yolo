import Foundation

/// Deterministic DB-only itinerary assembly (mirrors Edge `buildItineraryPipeline`).
enum PlanItineraryAssembler {
    static func build(
        cities: [String],
        tripDays: Int,
        attractions: [Attraction],
        userNotes: String? = nil,
        pace: TripPace = .standard,
        arrivalTime: String? = nil,
        departureTime: String? = nil,
        startDate: Date? = nil,
        applyNormalizer: Bool = true
    ) -> SampleItinerary {
        let cityIds = Array(Set(cities.map { $0.lowercased() }.filter { !$0.isEmpty }))
        let resolvedCityIds = cityIds.isEmpty ? ["beijing"] : cityIds
        let days = max(1, min(tripDays, 21))

        let scheduled = PlanItineraryScheduler.run(
            cities: resolvedCityIds,
            tripDays: days,
            attractions: attractions,
            userNotes: userNotes,
            pace: pace,
            arrivalTime: arrivalTime,
            departureTime: departureTime,
            startDate: startDate,
            entryCityId: resolvedCityIds.sorted().first,
            exitCityId: resolvedCityIds.count > 1 ? resolvedCityIds.sorted().last : resolvedCityIds.sorted().first
        )

        let route = CityTravelHints.routeLabel(from: scheduled.visitOrder)
        let trip = SampleItinerary(
            id: UUID().uuidString,
            title: "\(days)-Day \(route) Trip",
            meta: userNotes.map { "Generated · \($0.prefix(120))" } ?? "Generated",
            routeSummary: route,
            estimatedBudget: "$800–$1,500",
            days: scheduled.days,
            visitOrder: scheduled.visitOrder,
            droppedAttractionIds: scheduled.droppedAttractionIds.isEmpty ? nil : scheduled.droppedAttractionIds,
            schedulingAdjustments: scheduled.schedulingAdjustments.isEmpty ? nil : scheduled.schedulingAdjustments
        )
        if !applyNormalizer {
            return trip
        }
        return PlanItineraryNormalizer.normalize(
            trip,
            selectedCityIds: resolvedCityIds,
            catalogById: Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) }),
            pace: pace,
            arrivalTime: arrivalTime,
            departureTime: departureTime
        )
    }
}
