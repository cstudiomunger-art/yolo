import Foundation

/// Geographic sanity for day assignments (mirrors Edge `itinerary-geo-repair.ts`).
enum PlanItineraryGeoRepair {
    static func apply(
        assignments: [Int: [String]],
        catalogById: [String: Attraction],
        allowedCitiesByDay: [Int: Set<String>],
        adjustments: inout [String]
    ) -> (assignments: [Int: [String]], dropped: [String]) {
        var result = assignments
        var dropped: [String] = []
        var seen = Set<String>()

        for day in result.keys.sorted() {
            let ids = result[day] ?? []
            var deduped: [String] = []
            for id in ids {
                if seen.contains(id) { continue }
                seen.insert(id)
                deduped.append(id)
            }
            result[day] = deduped
        }

        var overflow: [String] = []
        for day in result.keys.sorted() {
            let allowed = allowedCitiesByDay[day] ?? []
            let ids = result[day] ?? []
            var kept: [String] = []
            for id in ids {
                guard let city = catalogById[id]?.cityId.lowercased() else {
                    kept.append(id)
                    continue
                }
                if !allowed.isEmpty, !allowed.contains(city) {
                    overflow.append(id)
                    adjustments.append("Moved \(id) off day \(day) (allowed \(allowed.sorted().joined(separator: ", ")), got \(city))")
                    continue
                }
                kept.append(id)
            }
            result[day] = kept
        }

        for day in result.keys.sorted() {
            let allowed = allowedCitiesByDay[day] ?? []
            let isHopDay = allowed.count == 2
            if isHopDay { continue }
            let split = splitIncompatibleSameDay(result[day] ?? [], catalogById: catalogById)
            if !split.overflow.isEmpty {
                adjustments.append(
                    "Split incompatible cities on day \(day): \(split.overflow.joined(separator: ", "))"
                )
            }
            result[day] = split.keep
            overflow.append(contentsOf: split.overflow)
        }

        for day in result.keys.sorted() {
            let allowed = allowedCitiesByDay[day] ?? []
            if allowed.count == 2 { continue }
            let dayTripSplit = PlanItineraryDayTrip.splitDayTripFromUrban(
                result[day] ?? [],
                catalogById: catalogById
            )
            if !dayTripSplit.overflow.isEmpty {
                adjustments.append(
                    "Split day-trip sights from urban mix on day \(day): \(dayTripSplit.overflow.joined(separator: ", "))"
                )
            }
            result[day] = dayTripSplit.keep
            overflow.append(contentsOf: dayTripSplit.overflow)
        }

        for id in overflow {
            guard let city = catalogById[id]?.cityId.lowercased() else { continue }
            var placed = false
            for day in result.keys.sorted() {
                guard allowedCitiesByDay[day]?.contains(city) == true else { continue }
                let existingIds = result[day] ?? []
                if !canPlaceWithoutMixing(id, onDay: existingIds, catalogById: catalogById) { continue }
                let existing = citiesOnAssignment(existingIds, catalogById: catalogById)
                if existing.isEmpty || existing.allSatisfy({ CityTravelHints.canVisitSameDay($0, city) }) {
                    result[day, default: []].append(id)
                    placed = true
                    adjustments.append("Placed \(id) on day \(day) (geo repair)")
                    break
                }
            }
            if !placed {
                adjustments.append("Could not place \(id) after geo split")
                dropped.append(id)
            }
        }

        return (result, dropped)
    }

    private static func canPlaceWithoutMixing(
        _ id: String,
        onDay existing: [String],
        catalogById: [String: Attraction]
    ) -> Bool {
        if existing.isEmpty { return true }
        let incomingTrip = PlanItineraryDayTrip.isDayTrip(attractionId: id, catalogById: catalogById)
        let dayHasUrban = existing.contains {
            !PlanItineraryDayTrip.isDayTrip(attractionId: $0, catalogById: catalogById)
        }
        let dayHasTrip = existing.contains {
            PlanItineraryDayTrip.isDayTrip(attractionId: $0, catalogById: catalogById)
        }
        if incomingTrip && dayHasUrban { return false }
        if !incomingTrip && dayHasTrip { return false }
        return true
    }

    private static func splitIncompatibleSameDay(
        _ ids: [String],
        catalogById: [String: Attraction]
    ) -> (keep: [String], overflow: [String]) {
        guard ids.count > 1 else { return (ids, []) }
        var keep: [String] = []
        var overflow: [String] = []
        var anchor: String?

        for id in ids {
            guard let city = catalogById[id]?.cityId, !city.isEmpty else {
                keep.append(id)
                continue
            }
            if anchor == nil {
                anchor = city
                keep.append(id)
                continue
            }
            if city == anchor || CityTravelHints.canVisitSameDay(anchor!, city) {
                keep.append(id)
            } else {
                overflow.append(id)
            }
        }
        return (keep, overflow)
    }

    private static func citiesOnAssignment(
        _ ids: [String],
        catalogById: [String: Attraction]
    ) -> [String] {
        var seen = Set<String>()
        var out: [String] = []
        for id in ids {
            guard let cid = catalogById[id]?.cityId, !seen.contains(cid) else { continue }
            seen.insert(cid)
            out.append(cid)
        }
        return out
    }
}
