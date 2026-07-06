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
            let D = max(1, days)
            let pool = (catalogByCity[cityId] ?? []).sorted {
                let pa = priorityRank($0.priority)
                let pb = priorityRank($1.priority)
                if pa != pb { return pa < pb }
                return $0.displayOrder < $1.displayOrder
            }

            let slotsPerDay = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
            let slotBudget = Double(D) * slotsPerDay
            let dayPool = pool.filter { !PlanItineraryVisitHours.isEveningOnly($0) }
            let eveningPool = pool.filter { PlanItineraryVisitHours.isEveningOnly($0) }
            let mustIds = Set(dayPool.filter {
                priorityRank($0.priority) == 0 || mustSeeIds.contains($0.id)
            }.map(\.id))

            var picked: [String] = []
            var pickedSet = Set<String>()
            var usedSlots = 0.0
            var daytimeCount = 0

            func tryPick(_ row: Attraction, force: Bool = false) -> Bool {
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                if !force, usedSlots + slots > slotBudget, !picked.isEmpty { return false }
                picked.append(row.id)
                pickedSet.insert(row.id)
                usedSlots += slots
                if !PlanItineraryVisitHours.isEveningOnly(row) { daytimeCount += 1 }
                return true
            }

            // Guarantee ~1 daytime sight per sightseeing day (prefer short attractions).
            for row in dayPool where !pickedSet.contains(row.id) {
                guard daytimeCount < D else { break }
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                guard slots <= 1 else { continue }
                if usedSlots + slots <= slotBudget || daytimeCount == 0 {
                    _ = tryPick(row, force: daytimeCount == 0)
                }
            }

            for row in dayPool where mustIds.contains(row.id) && !pickedSet.contains(row.id) {
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                if usedSlots + slots > slotBudget, !picked.isEmpty {
                    preDropped.append(row.id)
                    continue
                }
                _ = tryPick(row)
            }

            for row in dayPool where !pickedSet.contains(row.id) {
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                if usedSlots + slots > slotBudget {
                    preDropped.append(row.id)
                    continue
                }
                _ = tryPick(row)
            }

            // P0 monopoly guard: if only one big P0 picked, try one more short P1.
            if daytimeCount < D,
               let extra = dayPool.first(where: { row in
                   !pickedSet.contains(row.id)
                       && priorityRank(row.priority) <= 1
                       && PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText) <= 1
               }) {
                _ = tryPick(extra, force: true)
            }

            let eveningBudget = min(1, D)
            for row in eveningPool.prefix(eveningBudget) where !pickedSet.contains(row.id) {
                picked.append(row.id)
                pickedSet.insert(row.id)
            }
            for row in eveningPool.dropFirst(eveningBudget) where !pickedSet.contains(row.id) {
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
