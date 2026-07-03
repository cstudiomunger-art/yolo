import Foundation

enum PlanItineraryCityDays {
    struct Calibration {
        let cityDays: [String: Int]
        let availableCityDays: Int
        let reservedTravelDays: Int
        let tightTripHints: [String]
        let schedulingAdjustments: [String]
    }

    static func slotDemand(for attractions: [Attraction], cityId: String) -> Double {
        let cid = cityId.lowercased()
        return attractions
            .filter { $0.cityId.lowercased() == cid }
            .reduce(0) { $0 + PlanItineraryDuration.parseDurationSlots($1.recommendedDurationText) }
    }

    static func reservedFullTravelDays(visitOrder: [String]) -> Int {
        var count = 0
        for i in 1..<visitOrder.count {
            let h = CityTravelHints.travelHours(visitOrder[i - 1], visitOrder[i])
            if CityTravelHints.commuteSlots(h) >= 2 { count += 1 }
        }
        return count
    }

    static func calibrateCityDays(
        visitOrder: [String],
        aiWeights: [String: Int]?,
        catalogByCity: [String: [Attraction]],
        tripDays: Int,
        pace: TripPace = .standard,
        avgDaysByCity: [String: Int] = [:]
    ) -> Calibration {
        let travelReserved = reservedFullTravelDays(visitOrder: visitOrder)
        let available = max(visitOrder.count, tripDays - travelReserved)

        let rule = distributeDaysAcrossCitiesV2(
            availableCityDays: available,
            visitOrder: visitOrder,
            catalogByCity: catalogByCity,
            avgDaysByCity: avgDaysByCity
        )

        var cityDays: [String: Int]
        if let aiWeights, !aiWeights.isEmpty {
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
            cityDays = clampCityDaysSum(merged, visitOrder: visitOrder, available: available)
        } else {
            cityDays = rule
        }

        let (hints, adjustments) = assessTightTrip(
            visitOrder: visitOrder,
            cityDays: cityDays,
            catalogByCity: catalogByCity,
            tripDays: tripDays,
            availableCityDays: available,
            pace: pace
        )

        return Calibration(
            cityDays: cityDays,
            availableCityDays: available,
            reservedTravelDays: travelReserved,
            tightTripHints: hints,
            schedulingAdjustments: adjustments
        )
    }

    private static func distributeDaysAcrossCitiesV2(
        availableCityDays: Int,
        visitOrder: [String],
        catalogByCity: [String: [Attraction]],
        avgDaysByCity: [String: Int] = [:]
    ) -> [String: Int] {
        guard !visitOrder.isEmpty else { return [:] }

        var weights: [String: Double] = [:]
        for city in visitOrder {
            let cid = city.lowercased()
            let pool = catalogByCity[cid] ?? []
            let slotDemand = pool.reduce(0.0) {
                $0 + PlanItineraryDuration.parseDurationSlots($1.recommendedDurationText)
            }
            let avg = Double(max(1, avgDaysByCity[cid] ?? 2))
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
                share = max(1, availableCityDays - assigned)
            } else {
                share = max(1, Int((Double(availableCityDays) * w / totalWeight).rounded()))
            }
            map[cid] = share
            assigned += share
        }

        return clampCityDaysSum(map, visitOrder: visitOrder, available: availableCityDays)
    }

    private static func clampCityDaysSum(
        _ map: [String: Int],
        visitOrder: [String],
        available: Int
    ) -> [String: Int] {
        var result = map
        var assigned = result.values.reduce(0, +)
        while assigned > available {
            guard let richest = visitOrder.max(by: { (result[$0.lowercased()] ?? 0) < (result[$1.lowercased()] ?? 0) })?.lowercased(),
                  result[richest, default: 1] > 1 else {
                break
            }
            result[richest, default: 1] -= 1
            assigned -= 1
        }
        while assigned < available, let last = visitOrder.last?.lowercased() {
            result[last, default: 1] += 1
            assigned += 1
        }
        return result
    }

    private static func assessTightTrip(
        visitOrder: [String],
        cityDays: [String: Int],
        catalogByCity: [String: [Attraction]],
        tripDays: Int,
        availableCityDays: Int,
        pace: TripPace
    ) -> (hints: [String], adjustments: [String]) {
        var hints: [String] = []
        var adjustments: [String] = []

        let slotsPerDay = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
        var minDemandDays = 0.0
        for city in visitOrder {
            let cid = city.lowercased()
            let demand = slotDemand(for: catalogByCity[cid] ?? [], cityId: cid)
            minDemandDays += ceil(demand / slotsPerDay)
        }

        let calendarNeed = cityDays.values.reduce(0, +) + reservedFullTravelDays(visitOrder: visitOrder)
        if calendarNeed > tripDays {
            let msg = "行程 \(tripDays) 天偏紧：按景点体量建议至少 \(Int(minDemandDays)) 个观光日，已压缩分配。"
            hints.append(msg)
            adjustments.append(msg)
        } else if minDemandDays > Double(availableCityDays) + 0.5 {
            let msg = "景点较多，\(availableCityDays) 个观光日可能装不下全部推荐景点，部分将自动取舍。"
            hints.append(msg)
            adjustments.append(msg)
        }

        return (hints, adjustments)
    }
}
