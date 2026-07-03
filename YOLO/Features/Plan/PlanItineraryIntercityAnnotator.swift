import Foundation

/// Injects intercity hop cards when adjacent days change city without scheduler metadata.
enum PlanItineraryIntercityAnnotator {
    static func annotate(_ days: [ItineraryDay]) -> [ItineraryDay] {
        let sorted = days.sorted { $0.dayIndex < $1.dayIndex }
        return sorted.enumerated().map { index, day in
            if day.intercityHop != nil { return day }
            guard index > 0 else { return day }
            let prev = sorted[index - 1]
            guard let fromCity = trailingCityId(prev),
                  let toCity = leadingCityId(day),
                  fromCity != toCity else { return day }
            let hours = CityTravelHints.travelHours(fromCity, toCity)
            let hop = ItineraryIntercityHop(
                fromCityId: fromCity,
                toCityId: toCity,
                travelHours: hours,
                items: CityTravelHints.buildHopCardContent(
                    fromCityId: fromCity,
                    toCityId: toCity,
                    hours: hours
                )
            )
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: day.cityName,
                costEstimate: day.costEstimate,
                activities: day.activities,
                dayKind: day.dayKind,
                experienceItems: day.experienceItems,
                experienceCityId: day.experienceCityId ?? toCity,
                intercityHop: hop
            )
        }
    }

    private static func trailingCityId(_ day: ItineraryDay) -> String? {
        if let hop = day.intercityHop { return hop.toCityId.lowercased() }
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        for act in day.activities.reversed() {
            if let cid = act.cityId?.lowercased(), !cid.isEmpty { return cid }
        }
        return nil
    }

    private static func leadingCityId(_ day: ItineraryDay) -> String? {
        if let hop = day.intercityHop { return hop.toCityId.lowercased() }
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        for act in day.activities {
            if let cid = act.cityId?.lowercased(), !cid.isEmpty { return cid }
        }
        return nil
    }
}
