import Foundation

enum PlanItineraryCityDays {
    static func slotDemand(for attractions: [Attraction], cityId: String) -> Double {
        let cid = cityId.lowercased()
        return attractions
            .filter { $0.cityId.lowercased() == cid }
            .reduce(0) { $0 + PlanItineraryDuration.parseDurationSlots($1.recommendedDurationText) }
    }

    static func distributeDaysAcrossCitiesV2(
        tripDays: Int,
        visitOrder: [String],
        catalogByCity: [String: [Attraction]]
    ) -> [String: Int] {
        guard !visitOrder.isEmpty else { return [:] }

        let travelReserved = countLongTravelDays(visitOrder: visitOrder)
        let available = max(visitOrder.count, tripDays - travelReserved)

        var weights: [String: Double] = [:]
        for city in visitOrder {
            let cid = city.lowercased()
            let pool = catalogByCity[cid] ?? []
            let avg = 2.0
            let slotDemand = pool.reduce(0.0) {
                $0 + PlanItineraryDuration.parseDurationSlots($1.recommendedDurationText)
            }
            weights[cid] = max(1, avg + 0.25 * ceil(slotDemand / 2))
        }

        let totalWeight = weights.values.reduce(0, +)
        var map: [String: Int] = [:]
        var assigned = 0

        for (index, city) in visitOrder.enumerated() {
            let cid = city.lowercased()
            let w = weights[cid] ?? 1
            let share: Int
            if index == visitOrder.count - 1 {
                share = max(1, available - assigned)
            } else {
                share = max(1, Int((Double(available) * w / totalWeight).rounded()))
            }
            map[cid] = share
            assigned += share
        }

        while assigned > available {
            guard let richest = map.max(by: { $0.value < $1.value })?.key, map[richest, default: 1] > 1 else {
                break
            }
            map[richest, default: 1] -= 1
            assigned -= 1
        }

        return map
    }

    static func calibrateCityDays(
        visitOrder: [String],
        aiWeights: [String: Int]?,
        catalogByCity: [String: [Attraction]],
        tripDays: Int
    ) -> [String: Int] {
        let rule = distributeDaysAcrossCitiesV2(
            tripDays: tripDays,
            visitOrder: visitOrder,
            catalogByCity: catalogByCity
        )
        guard let aiWeights, !aiWeights.isEmpty else { return rule }

        var merged: [String: Int] = [:]
        for city in visitOrder {
            let cid = city.lowercased()
            let ai = aiWeights[cid] ?? aiWeights[city]
            let r = rule[cid] ?? 1
            if let ai {
                merged[cid] = max(1, Int((0.6 * Double(ai) + 0.4 * Double(r)).rounded()))
            } else {
                merged[cid] = r
            }
        }

        let travelReserved = countLongTravelDays(visitOrder: visitOrder)
        let available = max(visitOrder.count, tripDays - travelReserved)
        var assigned = merged.values.reduce(0, +)
        while assigned > available {
            guard let richest = merged.max(by: { $0.value < $1.value })?.key, merged[richest, default: 1] > 1 else {
                break
            }
            merged[richest, default: 1] -= 1
            assigned -= 1
        }
        return merged
    }

    private static func countLongTravelDays(visitOrder: [String]) -> Int {
        var count = 0
        for i in 1..<visitOrder.count {
            let h = CityTravelHints.travelHours(visitOrder[i - 1], visitOrder[i])
            if CityTravelHints.commuteSlots(h) >= 2 { count += 1 }
        }
        return count
    }
}
