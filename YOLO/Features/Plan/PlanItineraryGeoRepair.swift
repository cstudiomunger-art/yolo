import Foundation

/// Geographic sanity for day assignments (mirrors Edge `itinerary-geo-repair.ts`).
enum PlanItineraryGeoRepair {
    static func apply(
        assignments: [Int: [String]],
        catalogById: [String: Attraction],
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
            let split = splitIncompatibleSameDay(result[day] ?? [], catalogById: catalogById)
            if !split.overflow.isEmpty {
                adjustments.append(
                    "Split incompatible cities on day \(day): \(split.overflow.joined(separator: ", "))"
                )
            }
            result[day] = split.keep
            overflow.append(contentsOf: split.overflow)
        }

        for id in overflow {
            guard let city = catalogById[id]?.cityId else { continue }
            var placed = false
            for day in result.keys.sorted() {
                let existing = citiesOnAssignment(result[day] ?? [], catalogById: catalogById)
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
