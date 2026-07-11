import Foundation

/// Injects intercity hop cards when adjacent days change city without scheduler metadata.
enum PlanItineraryIntercityAnnotator {
    static func annotate(
        _ days: [ItineraryDay],
        visitOrder: [String] = [],
        cityIdByDayIndex: [Int: String]? = nil,
        suppressedDayIndexes: Set<Int> = []
    ) -> [ItineraryDay] {
        let sorted = days.sorted { $0.dayIndex < $1.dayIndex }
        let baselineMap = cityIdByDayIndex ?? inferCityIdByDayIndex(from: sorted, visitOrder: visitOrder)

        return sorted.enumerated().map { index, day in
            if suppressedDayIndexes.contains(day.dayIndex) { return day }
            if day.intercityHop != nil { return day }
            guard index > 0 else { return day }
            let prev = sorted[index - 1]

            let activityFrom = trailingCityId(prev)
            let activityTo = leadingCityId(day)
            let timelineFrom = baselineMap[prev.dayIndex]
            let timelineTo = baselineMap[day.dayIndex]

            let fromCity: String?
            let toCity: String?
            if let activityFrom, let activityTo, activityFrom != activityTo {
                fromCity = activityFrom
                toCity = activityTo
            } else if let timelineFrom, let timelineTo, timelineFrom != timelineTo {
                fromCity = timelineFrom
                toCity = timelineTo
            } else {
                return day
            }

            let hours = CityTravelHints.travelHours(fromCity!, toCity!)
            let items = hopCardItems(fromCity: fromCity!, toCity: toCity!, hours: hours)
            let hop = ItineraryIntercityHop(
                fromCityId: fromCity!,
                toCityId: toCity!,
                travelHours: hours,
                items: items
            )
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: CityTravelHints.hopDayRouteLabel(fromCityId: fromCity!, toCityId: toCity!),
                costEstimate: day.costEstimate,
                activities: day.activities,
                dayKind: day.dayKind,
                experienceItems: day.experienceItems,
                experienceCityId: day.experienceCityId ?? toCity!,
                intercityHop: hop
            )
        }
    }

    /// Scheduler timeline city per day (prefer pre-normalize days for visit-order transitions).
    static func inferCityIdByDayIndex(
        from days: [ItineraryDay],
        visitOrder: [String]
    ) -> [Int: String] {
        var map: [Int: String] = [:]
        for day in days.sorted(by: { $0.dayIndex < $1.dayIndex }) {
            if let hop = day.intercityHop {
                map[day.dayIndex] = hop.toCityId.lowercased()
            } else if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty {
                map[day.dayIndex] = cid
            } else if let cid = day.activities.compactMap(\.cityId).first?.lowercased(), !cid.isEmpty {
                map[day.dayIndex] = cid
            }
        }
        if map.isEmpty, !visitOrder.isEmpty {
            for (i, day) in days.enumerated() {
                let idx = min(i, visitOrder.count - 1)
                map[day.dayIndex] = visitOrder[idx].lowercased()
            }
        }
        return map
    }

    /// Fills gaps between hop/activity anchors so blank middle days inherit the correct city block.
    static func completeCityIdByDayIndex(
        from days: [ItineraryDay],
        visitOrder: [String],
        seed: [Int: String] = [:]
    ) -> [Int: String] {
        var map = inferCityIdByDayIndex(from: days, visitOrder: visitOrder)
        for (dayIndex, cityId) in seed {
            let normalized = cityId.lowercased()
            guard !normalized.isEmpty else { continue }
            map[dayIndex] = normalized
        }
        let sorted = days.sorted { $0.dayIndex < $1.dayIndex }
        var trailing: String?
        for day in sorted {
            if let cityId = map[day.dayIndex] {
                trailing = cityId
            } else if let trailing {
                map[day.dayIndex] = trailing
            }
        }
        var leading: String?
        for day in sorted.reversed() {
            if let cityId = map[day.dayIndex] {
                leading = cityId
            } else if let leading {
                map[day.dayIndex] = leading
            }
        }
        return map
    }

    private static func hopCardItems(fromCity: String, toCity: String, hours: Double) -> [String] {
        if CityTravelHints.commuteSlots(hours) >= 2 {
            return CityTravelHints.buildTravelDayContent(fromCityId: fromCity, toCityId: toCity, hours: hours)
        }
        return CityTravelHints.buildHopCardContent(fromCityId: fromCity, toCityId: toCity, hours: hours)
    }

    private static func activityCityIds(_ day: ItineraryDay) -> [String] {
        var out: [String] = []
        for act in day.activities {
            guard let cid = act.cityId?.lowercased(), !cid.isEmpty else { continue }
            if !out.contains(cid) { out.append(cid) }
        }
        return out
    }

    private static func trailingCityId(_ day: ItineraryDay) -> String? {
        for act in day.activities.reversed() {
            if let cid = act.cityId?.lowercased(), !cid.isEmpty { return cid }
        }
        if let hop = day.intercityHop { return hop.toCityId.lowercased() }
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        return nil
    }

    private static func leadingCityId(_ day: ItineraryDay) -> String? {
        let actCities = activityCityIds(day)
        if let first = actCities.first { return first }
        if let hop = day.intercityHop { return hop.toCityId.lowercased() }
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        return nil
    }
}
