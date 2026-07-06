import Foundation

/// Tracks unique attraction scheduling across all itinerary days (one sight, one day).
enum PlanItineraryAttractionLedger {
    static func scheduledMap(in days: [ItineraryDay]) -> [String: Int] {
        var map: [String: Int] = [:]
        for day in days {
            for activity in day.activities {
                guard let id = activity.attractionId, !id.isEmpty else { continue }
                let key = id.lowercased()
                if map[key] == nil {
                    map[key] = day.dayIndex
                }
            }
        }
        return map
    }

    static func scheduledIds(in days: [ItineraryDay]) -> Set<String> {
        Set(scheduledMap(in: days).keys)
    }

    static func remove(attractionId: String, from days: [ItineraryDay]) -> [ItineraryDay] {
        let target = attractionId.lowercased()
        return days.map { day in
            let filtered = day.activities.filter {
                $0.attractionId?.lowercased() != target
            }
            guard filtered.count != day.activities.count else { return day }
            return day.withActivities(filtered)
        }
    }

    static func assign(
        _ activities: [ItineraryActivity],
        toDayIndex: Int,
        days: [ItineraryDay]
    ) -> [ItineraryDay] {
        var result = days
        for activity in activities {
            guard let id = activity.attractionId else { continue }
            result = remove(attractionId: id, from: result)
        }
        guard let idx = result.firstIndex(where: { $0.dayIndex == toDayIndex }) else {
            return result
        }
        let day = result[idx]
        result[idx] = day.withActivities(day.activities + activities)
        return result
    }

    static func enforceUnique(_ days: [ItineraryDay]) -> (days: [ItineraryDay], adjustments: [String]) {
        var seen = Set<String>()
        var adjustments: [String] = []
        let sorted = days.sorted { $0.dayIndex < $1.dayIndex }
        var result = days

        for day in sorted {
            guard let dayIdx = result.firstIndex(where: { $0.id == day.id }) else { continue }
            var keep: [ItineraryActivity] = []
            for activity in day.activities {
                guard let id = activity.attractionId else {
                    keep.append(activity)
                    continue
                }
                let key = id.lowercased()
                if seen.contains(key) {
                    adjustments.append("Removed duplicate sight \(activity.name) on day \(day.dayIndex)")
                    continue
                }
                seen.insert(key)
                keep.append(activity)
            }
            if keep.count != day.activities.count {
                result[dayIdx] = day.withActivities(keep)
            }
        }

        return (result, adjustments)
    }

    static func unscheduledPool(
        cityId: String,
        catalogById: [String: Attraction],
        days: [ItineraryDay],
        droppedIds: [String] = []
    ) -> [Attraction] {
        let city = cityId.lowercased()
        let scheduled = scheduledIds(in: days)
        var seen = Set<String>()
        var pool: [Attraction] = []

        for id in droppedIds + catalogById.values.sorted(by: {
            let pa = priorityRank($0.priority)
            let pb = priorityRank($1.priority)
            if pa != pb { return pa < pb }
            return $0.displayOrder < $1.displayOrder
        }).map(\.id) {
            let key = id.lowercased()
            guard !seen.contains(key), !scheduled.contains(key) else { continue }
            guard let row = catalogById[id], row.cityId.lowercased() == city else { continue }
            seen.insert(key)
            pool.append(row)
        }
        return pool
    }

    private static func priorityRank(_ priority: String) -> Int {
        switch priority.uppercased() {
        case "P0": return 0
        case "P2": return 2
        default: return 1
        }
    }
}

#if DEBUG
enum PlanItineraryAttractionLedgerSelfTest {
    static func runAll() {
        let act1 = ItineraryActivity(
            id: "a1", timeSlot: "Morning", name: "A", detail: "", attractionId: "s1", cityId: "beijing", hasAudio: false
        )
        let act2 = ItineraryActivity(
            id: "a2", timeSlot: "Afternoon", name: "B", detail: "", attractionId: "s1", cityId: "beijing", hasAudio: false
        )
        let days = [
            ItineraryDay(id: "d1", dayIndex: 1, dateLabel: "D1", cityName: "", costEstimate: nil, activities: [act1]),
            ItineraryDay(id: "d2", dayIndex: 2, dateLabel: "D2", cityName: "", costEstimate: nil, activities: [act2]),
        ]
        let (deduped, adj) = PlanItineraryAttractionLedger.enforceUnique(days)
        assert(deduped[1].activities.isEmpty)
        assert(deduped[0].activities.count == 1)
        assert(!adj.isEmpty)
    }
}
#endif
