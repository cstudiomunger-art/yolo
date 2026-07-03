import Foundation

enum PlanItineraryPickAttractions {
    struct Result {
        let candidatesByCity: [String: [String]]
        let preDropped: [String]
    }

    static func pick(
        catalogByCity: [String: [Attraction]],
        cityDays: [String: Int],
        mustSeeIds: Set<String> = [],
        pace: TripPace = .standard
    ) -> Result {
        var candidatesByCity: [String: [String]] = [:]
        var preDropped: [String] = []

        for (cityId, days) in cityDays {
            let pool = (catalogByCity[cityId] ?? []).sorted {
                let pa = priorityRank($0.priority)
                let pb = priorityRank($1.priority)
                if pa != pb { return pa < pb }
                return $0.displayOrder < $1.displayOrder
            }

            let slotBudget = Double(max(1, days)) * PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
            let dayPool = pool.filter { !PlanItineraryVisitHours.isEveningOnly($0) }
            let eveningPool = pool.filter { PlanItineraryVisitHours.isEveningOnly($0) }
            let mustIds = Set(dayPool.filter {
                priorityRank($0.priority) == 0 || mustSeeIds.contains($0.id)
            }.map(\.id))

            var picked: [String] = []
            var pickedSet = Set<String>()
            var usedSlots = 0.0

            for row in dayPool where mustIds.contains(row.id) {
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                if usedSlots + slots > slotBudget, !picked.isEmpty {
                    preDropped.append(row.id)
                    continue
                }
                picked.append(row.id)
                pickedSet.insert(row.id)
                usedSlots += slots
            }

            for row in dayPool where !pickedSet.contains(row.id) {
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                if usedSlots + slots > slotBudget {
                    preDropped.append(row.id)
                    continue
                }
                picked.append(row.id)
                pickedSet.insert(row.id)
                usedSlots += slots
            }

            let eveningBudget = max(1, days)
            for row in eveningPool.prefix(eveningBudget) {
                picked.append(row.id)
                pickedSet.insert(row.id)
            }
            for row in eveningPool.dropFirst(eveningBudget) {
                preDropped.append(row.id)
            }

            candidatesByCity[cityId] = picked
        }

        return Result(candidatesByCity: candidatesByCity, preDropped: preDropped)
    }

    private static func priorityRank(_ p: String) -> Int {
        switch p.uppercased() {
        case "P0": return 0
        case "P2": return 2
        default: return 1
        }
    }
}
