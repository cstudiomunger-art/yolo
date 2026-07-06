import Foundation

enum PlanItineraryPickAttractions {
    struct TimelineSlotRef {
        let dayIndex: Int
        let kind: String
        let cityId: String
        let fromCityId: String?
    }

    struct Result {
        let candidatesByCity: [String: [String]]
        let preDropped: [String]
        let hopReservedByDayIndex: [Int: String]
    }

    static func pick(
        catalogByCity: [String: [Attraction]],
        cityDays: [String: Int],
        mustSeeIds: Set<String> = [],
        pace: TripPace = .standard,
        timeline: [TimelineSlotRef] = []
    ) -> Result {
        var hopReservedByDayIndex: [Int: String] = [:]
        var reservedIds = Set<String>()

        for slot in timeline where CityTravelHints.isIntercityHopKind(slot.kind) && slot.kind != "travel" {
            let dest = slot.cityId.lowercased()
            let pool = (catalogByCity[dest] ?? []).sorted {
                let pa = priorityRank($0.priority)
                let pb = priorityRank($1.priority)
                if pa != pb { return pa < pb }
                return $0.displayOrder < $1.displayOrder
            }
            guard let row = pool.first(where: { candidate in
                !reservedIds.contains(candidate.id)
                    && !PlanItineraryVisitHours.isEveningOnly(candidate)
                    && PlanItineraryDuration.parseDurationSlots(candidate.recommendedDurationText) <= 1
            }) else { continue }
            hopReservedByDayIndex[slot.dayIndex] = row.id
            reservedIds.insert(row.id)
        }

        var candidatesByCity: [String: [String]] = [:]
        var preDropped: [String] = []

        let hopSlotsByDest = Dictionary(grouping: timeline.filter {
            CityTravelHints.isIntercityHopKind($0.kind) && $0.kind != "travel"
        }, by: { $0.cityId.lowercased() })

        let sightseeingOnlyDays: [String: Int] = {
            var counts = cityDays
            for (dest, slots) in hopSlotsByDest {
                counts[dest, default: 0] = max(0, (counts[dest] ?? 0) - slots.count)
            }
            return counts
        }()

        let visitOrder = timeline.map { $0.cityId.lowercased() }
            + cityDays.keys.sorted()
        var orderedCities: [String] = []
        var seen = Set<String>()
        for cid in visitOrder where !seen.contains(cid) {
            seen.insert(cid)
            orderedCities.append(cid)
        }
        for cid in cityDays.keys.sorted() where !seen.contains(cid) {
            orderedCities.append(cid)
        }

        for cityId in orderedCities {
            guard let totalDays = cityDays[cityId], totalDays > 0 else { continue }
            let fullDays = max(0, sightseeingOnlyDays[cityId] ?? totalDays)
            let hopDays = hopSlotsByDest[cityId]?.count ?? 0

            let pool = (catalogByCity[cityId] ?? []).sorted {
                let pa = priorityRank($0.priority)
                let pb = priorityRank($1.priority)
                if pa != pb { return pa < pb }
                return $0.displayOrder < $1.displayOrder
            }

            let slotsPerDay = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
            let hopSlotsPerDay = PlanItineraryPace.hopDaySlotBudget(pace: pace)
            let slotBudget = Double(fullDays) * slotsPerDay + Double(hopDays) * hopSlotsPerDay
            let dayPool = pool.filter { !PlanItineraryVisitHours.isEveningOnly($0) && !reservedIds.contains($0.id) }
            let eveningPool = pool.filter { PlanItineraryVisitHours.isEveningOnly($0) && !reservedIds.contains($0.id) }
            let mustIds = Set(dayPool.filter {
                priorityRank($0.priority) == 0 || mustSeeIds.contains($0.id)
            }.map(\.id))

            var picked: [String] = []
            var pickedSet = Set<String>()
            var usedSlots = 0.0
            var daytimeCount = 0
            let minDaytime = fullDays + hopDays

            func tryPick(_ row: Attraction, force: Bool = false) -> Bool {
                let slots = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                if !force, usedSlots + slots > slotBudget, !picked.isEmpty { return false }
                picked.append(row.id)
                pickedSet.insert(row.id)
                usedSlots += slots
                if !PlanItineraryVisitHours.isEveningOnly(row) { daytimeCount += 1 }
                return true
            }

            for row in dayPool where !pickedSet.contains(row.id) {
                guard daytimeCount < minDaytime else { break }
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

            if daytimeCount < minDaytime,
               let extra = dayPool.first(where: { row in
                   !pickedSet.contains(row.id)
                       && priorityRank(row.priority) <= 1
                       && PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText) <= 1
               }) {
                _ = tryPick(extra, force: true)
            }

            let eveningBudget = min(1, totalDays)
            for row in eveningPool.prefix(eveningBudget) where !pickedSet.contains(row.id) {
                picked.append(row.id)
                pickedSet.insert(row.id)
            }
            for row in eveningPool.dropFirst(eveningBudget) where !pickedSet.contains(row.id) {
                preDropped.append(row.id)
            }

            for id in hopReservedByDayIndex.values where catalogByCity[cityId]?.contains(where: { $0.id == id }) == true {
                if !pickedSet.contains(id) {
                    picked.insert(id, at: 0)
                    pickedSet.insert(id)
                }
            }

            candidatesByCity[cityId] = picked
        }

        return Result(
            candidatesByCity: candidatesByCity,
            preDropped: preDropped,
            hopReservedByDayIndex: hopReservedByDayIndex
        )
    }

    private static func priorityRank(_ p: String) -> Int {
        switch p.uppercased() {
        case "P0": return 0
        case "P2": return 2
        default: return 1
        }
    }
}
