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

    static func reservedHopTransitionDays(
        visitOrder: [String],
        pace: TripPace = .standard
    ) -> Int {
        var count = 0
        for i in 1..<visitOrder.count {
            let a = visitOrder[i - 1]
            let b = visitOrder[i]
            let slots = CityTravelHints.commuteSlots(CityTravelHints.travelHours(a, b))
            if slots >= 2 { continue }
            if pace == .intense, CityTravelHints.canIntenseSameDayHop(a, b) {
                count += 1
                continue
            }
            if slots <= 1 { count += 1 }
        }
        return count
    }

    static func reservedIntercityDays(visitOrder: [String], pace: TripPace = .standard) -> Int {
        reservedFullTravelDays(visitOrder: visitOrder)
            + reservedHopTransitionDays(visitOrder: visitOrder, pace: pace)
    }

    static func minDemandDays(for pool: [Attraction], pace: TripPace) -> Int {
        let slotsPerDay = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
        let demand = pool.reduce(0.0) {
            $0 + PlanItineraryDuration.parseDurationSlots($1.recommendedDurationText)
        }
        return max(1, Int(ceil(demand / slotsPerDay)))
    }

    static func simulateTimelineSlotCount(
        tripDays: Int,
        visitOrder: [String],
        cityDays: [String: Int],
        pace: TripPace = .standard
    ) -> Int {
        var dayPtr = 1
        var count = 0

        for (i, city) in visitOrder.enumerated() {
            let cityId = city.lowercased()
            if i > 0 {
                let prev = visitOrder[i - 1]
                if CityTravelHints.needsTravelDay(prev, cityId),
                   CityTravelHints.commuteSlots(CityTravelHints.travelHours(prev, cityId)) >= 2,
                   dayPtr <= tripDays {
                    count += 1
                    dayPtr += 1
                }
            }

            let budget = cityDays[cityId] ?? 1
            for _ in 0..<budget where dayPtr <= tripDays {
                count += 1
                dayPtr += 1
            }
        }

        return min(count, tripDays)
    }

    /// Per-city min/max when multi-city trips have enough calendar days.
    private static func perCityBoundsActive(tripDays: Int, cityCount: Int) -> Bool {
        tripDays >= 10 && cityCount >= 4
    }

    private static func perCityMinDays(tripDays: Int, cityCount: Int) -> Int {
        perCityBoundsActive(tripDays: tripDays, cityCount: cityCount) ? 2 : 1
    }

    private static func cityDayCap(
        cityId: String,
        entryCityId: String?,
        fairShare: Double
    ) -> Int {
        if cityId == entryCityId?.lowercased() {
            return max(3, Int(ceil(fairShare * 1.75)))
        }
        return max(2, Int(ceil(fairShare * 1.5)))
    }

    private static func cityDayWeight(
        cityId: String,
        catalogByCity: [String: [Attraction]],
        pace: TripPace
    ) -> Double {
        let pool = catalogByCity[cityId] ?? []
        let minD = Double(minDemandDays(for: pool, pace: pace))
        return max(1, minD, 2)
    }

    /// Clamp city day budgets so no destination monopolizes a long multi-city trip.
    private static func applyPerCityBounds(
        _ map: [String: Int],
        visitOrder: [String],
        tripDays: Int,
        availableCityDays: Int,
        catalogByCity: [String: [Attraction]],
        pace: TripPace
    ) -> [String: Int] {
        guard perCityBoundsActive(tripDays: tripDays, cityCount: visitOrder.count) else { return map }

        let entry = visitOrder.first?.lowercased()
        let fairShare = Double(availableCityDays) / Double(visitOrder.count)
        let floor = perCityMinDays(tripDays: tripDays, cityCount: visitOrder.count)
        var result = map

        for city in visitOrder {
            let cid = city.lowercased()
            result[cid] = max(result[cid] ?? 1, floor)
        }

        func totalDays() -> Int { result.values.reduce(0, +) }

        var guardLoops = 0
        while totalDays() > availableCityDays, guardLoops < 64 {
            guardLoops += 1
            let donor = visitOrder
                .map { $0.lowercased() }
                .filter { (result[$0] ?? 0) > floor }
                .max { a, b in
                    let overA = (result[a] ?? 0) - cityDayCap(cityId: a, entryCityId: entry, fairShare: fairShare)
                    let overB = (result[b] ?? 0) - cityDayCap(cityId: b, entryCityId: entry, fairShare: fairShare)
                    if overA != overB { return overA < overB }
                    if a == entry { return true }
                    if b == entry { return false }
                    return slotDemand(for: catalogByCity[a] ?? [], cityId: a)
                        < slotDemand(for: catalogByCity[b] ?? [], cityId: b)
                }
            guard let donor else { break }
            result[donor, default: 1] -= 1
        }

        guardLoops = 0
        while guardLoops < 64 {
            guardLoops += 1
            let overCap = visitOrder
                .map { $0.lowercased() }
                .first { (result[$0] ?? 0) > cityDayCap(cityId: $0, entryCityId: entry, fairShare: fairShare) }
            guard let donor = overCap else { break }

            let cap = cityDayCap(cityId: donor, entryCityId: entry, fairShare: fairShare)
            result[donor, default: 1] = cap

            let recipient = visitOrder
                .map { $0.lowercased() }
                .min { a, b in
                    let allocA = result[a] ?? 1
                    let allocB = result[b] ?? 1
                    if allocA != allocB { return allocA > allocB }
                    let capA = cityDayCap(cityId: a, entryCityId: entry, fairShare: fairShare)
                    let capB = cityDayCap(cityId: b, entryCityId: entry, fairShare: fairShare)
                    let headroomA = capA - allocA
                    let headroomB = capB - allocB
                    return headroomA < headroomB
                }
            guard let recipient else { break }
            let recipientCap = cityDayCap(cityId: recipient, entryCityId: entry, fairShare: fairShare)
            guard (result[recipient] ?? 1) < recipientCap else { break }
            result[recipient, default: 1] += 1
        }

        return result
    }

    /// Rebalance cityDays until simulated timeline matches tripDays (hop days live inside city budget).
    static func closeTimelineSlotCount(
        cityDays: [String: Int],
        visitOrder: [String],
        catalogByCity: [String: [Attraction]],
        tripDays: Int,
        availableCityDays: Int,
        pace: TripPace
    ) -> [String: Int] {
        var result = cityDays
        let exit = visitOrder.last?.lowercased()
        let boundsActive = perCityBoundsActive(tripDays: tripDays, cityCount: visitOrder.count)
        let floor = perCityMinDays(tripDays: tripDays, cityCount: visitOrder.count)
        let entry = visitOrder.first?.lowercased()
        let fairShare = Double(availableCityDays) / Double(max(1, visitOrder.count))

        func slotCount() -> Int {
            simulateTimelineSlotCount(tripDays: tripDays, visitOrder: visitOrder, cityDays: result, pace: pace)
        }

        func cap(for city: String) -> Int {
            cityDayCap(cityId: city, entryCityId: entry, fairShare: fairShare)
        }

        var guardLoops = 0
        while slotCount() < tripDays, guardLoops < 64 {
            guardLoops += 1
            let recipient: String?
            if boundsActive {
                let belowFloor = visitOrder
                    .map { $0.lowercased() }
                    .filter { (result[$0] ?? 0) < floor }
                if !belowFloor.isEmpty {
                    recipient = belowFloor.min { (result[$0] ?? 0) < (result[$1] ?? 0) }
                } else {
                    recipient = visitOrder
                        .map { $0.lowercased() }
                        .filter { (result[$0] ?? 0) < cap(for: $0) }
                        .min { a, b in
                            let weightA = cityDayWeight(cityId: a, catalogByCity: catalogByCity, pace: pace)
                            let weightB = cityDayWeight(cityId: b, catalogByCity: catalogByCity, pace: pace)
                            let ratioA = Double(result[a] ?? 1) / weightA
                            let ratioB = Double(result[b] ?? 1) / weightB
                            return ratioA > ratioB
                        }
                }
            } else {
                recipient = visitOrder
                    .map { $0.lowercased() }
                    .max { a, b in
                        let gapA = minDemandDays(for: catalogByCity[a] ?? [], pace: pace) - (result[a] ?? 0)
                        let gapB = minDemandDays(for: catalogByCity[b] ?? [], pace: pace) - (result[b] ?? 0)
                        if gapA != gapB { return gapA < gapB }
                        if a == exit, gapA <= 0 { return true }
                        if b == exit, gapB <= 0 { return false }
                        return slotDemand(for: catalogByCity[a] ?? [], cityId: a)
                            < slotDemand(for: catalogByCity[b] ?? [], cityId: b)
                    }
            }
            guard let recipient else { break }
            if boundsActive, (result[recipient] ?? 0) >= cap(for: recipient) { break }
            result[recipient, default: 1] += 1
        }

        let minDonorDays = boundsActive ? floor : 1
        guardLoops = 0
        while slotCount() > tripDays, guardLoops < 64 {
            guardLoops += 1
            let donor = visitOrder
                .map { $0.lowercased() }
                .filter { (result[$0] ?? 0) > minDonorDays }
                .max { a, b in
                    let surplusA = (result[a] ?? 0) - minDemandDays(for: catalogByCity[a] ?? [], pace: pace)
                    let surplusB = (result[b] ?? 0) - minDemandDays(for: catalogByCity[b] ?? [], pace: pace)
                    if surplusA != surplusB { return surplusA < surplusB }
                    if a == exit { return true }
                    if b == exit { return false }
                    return (result[a] ?? 0) < (result[b] ?? 0)
                }
            guard let donor else { break }
            result[donor, default: 1] -= 1
        }

        return result
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
            avgDaysByCity: avgDaysByCity,
            pace: pace
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
            cityDays = rebalanceCityDaysSum(
                merged,
                visitOrder: visitOrder,
                catalogByCity: catalogByCity,
                pace: pace,
                available: available
            )
        } else {
            cityDays = rule
        }

        cityDays = applyEntryCityMinDays(
            cityDays,
            visitOrder: visitOrder,
            tripDays: tripDays,
            catalogByCity: catalogByCity
        )

        cityDays = applyPerCityBounds(
            cityDays,
            visitOrder: visitOrder,
            tripDays: tripDays,
            availableCityDays: available,
            catalogByCity: catalogByCity,
            pace: pace
        )

        cityDays = closeTimelineSlotCount(
            cityDays: cityDays,
            visitOrder: visitOrder,
            catalogByCity: catalogByCity,
            tripDays: tripDays,
            availableCityDays: available,
            pace: pace
        )

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
        avgDaysByCity: [String: Int] = [:],
        pace: TripPace
    ) -> [String: Int] {
        guard !visitOrder.isEmpty else { return [:] }

        var weights: [String: Double] = [:]
        for city in visitOrder {
            let cid = city.lowercased()
            let pool = catalogByCity[cid] ?? []
            let minD = Double(minDemandDays(for: pool, pace: pace))
            let avg = Double(max(1, avgDaysByCity[cid] ?? 2))
            weights[cid] = max(1, minD, avg)
        }

        let totalWeight = weights.values.reduce(0, +)
        var map: [String: Int] = [:]

        for city in visitOrder {
            let cid = city.lowercased()
            let w = weights[cid] ?? 1
            let share = max(1, Int((Double(availableCityDays) * w / totalWeight).rounded()))
            map[cid] = share
        }

        return rebalanceCityDaysSum(map, visitOrder: visitOrder, catalogByCity: catalogByCity, pace: pace, available: availableCityDays)
    }

    private static func rebalanceCityDaysSum(
        _ map: [String: Int],
        visitOrder: [String],
        catalogByCity: [String: [Attraction]],
        pace: TripPace,
        available: Int
    ) -> [String: Int] {
        var result = map
        var assigned = result.values.reduce(0, +)

        while assigned > available {
            let exit = visitOrder.last?.lowercased()
            let donor = visitOrder
                .map { $0.lowercased() }
                .filter { (result[$0] ?? 0) > 1 }
                .max { a, b in
                    let surplusA = (result[a] ?? 0) - minDemandDays(for: catalogByCity[a] ?? [], pace: pace)
                    let surplusB = (result[b] ?? 0) - minDemandDays(for: catalogByCity[b] ?? [], pace: pace)
                    if surplusA != surplusB { return surplusA < surplusB }
                    if a == exit { return true }
                    if b == exit { return false }
                    return (result[a] ?? 0) < (result[b] ?? 0)
                }
            guard let donor else { break }
            result[donor, default: 1] -= 1
            assigned -= 1
        }

        while assigned < available {
            let exit = visitOrder.last?.lowercased()
            let recipient = visitOrder
                .map { $0.lowercased() }
                .max { a, b in
                    let gapA = minDemandDays(for: catalogByCity[a] ?? [], pace: pace) - (result[a] ?? 0)
                    let gapB = minDemandDays(for: catalogByCity[b] ?? [], pace: pace) - (result[b] ?? 0)
                    if gapA != gapB { return gapA < gapB }
                    if a == exit, gapA <= 0 { return true }
                    if b == exit, gapB <= 0 { return false }
                    let demandA = slotDemand(for: catalogByCity[a] ?? [], cityId: a)
                    let demandB = slotDemand(for: catalogByCity[b] ?? [], cityId: b)
                    return demandA < demandB
                }
            guard let recipient else { break }
            let gap = minDemandDays(for: catalogByCity[recipient] ?? [], pace: pace) - (result[recipient] ?? 0)
            let exitDemand = exit.map { slotDemand(for: catalogByCity[$0] ?? [], cityId: $0) } ?? 0
            let recipientDemand = slotDemand(for: catalogByCity[recipient] ?? [], cityId: recipient)
            if gap <= 0, recipient == exit, exitDemand <= recipientDemand {
                break
            }
            result[recipient, default: 1] += 1
            assigned += 1
        }

        return result
    }

    /// Long multi-city trips: entry city keeps at least 2 sightseeing budget days when possible.
    private static func applyEntryCityMinDays(
        _ map: [String: Int],
        visitOrder: [String],
        tripDays: Int,
        catalogByCity: [String: [Attraction]]
    ) -> [String: Int] {
        guard tripDays >= 8, visitOrder.count >= 3,
              let entry = visitOrder.first?.lowercased() else { return map }
        let exit = visitOrder.last?.lowercased()
        let minEntry = 2
        var result = map
        var current = result[entry, default: 1]
        guard current < minEntry else { return map }

        let donors = visitOrder.dropFirst().map { $0.lowercased() }.sorted { a, b in
            let demandA = slotDemand(for: catalogByCity[a] ?? [], cityId: a)
            let demandB = slotDemand(for: catalogByCity[b] ?? [], cityId: b)
            if demandA != demandB { return demandA < demandB }
            return (result[a] ?? 1) > (result[b] ?? 1)
        }
        for donor in donors where current < minEntry {
            if donor == exit, (result[donor] ?? 1) <= minDemandDays(for: catalogByCity[donor] ?? [], pace: .standard) {
                continue
            }
            let spare = (result[donor] ?? 1) - 1
            guard spare > 0 else { continue }
            let take = min(minEntry - current, spare)
            result[entry, default: 1] += take
            result[donor, default: 1] -= take
            current += take
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
        var minDemandDaysTotal = 0.0
        for city in visitOrder {
            let cid = city.lowercased()
            let demand = slotDemand(for: catalogByCity[cid] ?? [], cityId: cid)
            minDemandDaysTotal += ceil(demand / slotsPerDay)
        }

        let calendarNeed = simulateTimelineSlotCount(
            tripDays: tripDays,
            visitOrder: visitOrder,
            cityDays: cityDays,
            pace: pace
        )
        if calendarNeed > tripDays {
            let msg = "行程 \(tripDays) 天偏紧：按景点体量建议至少 \(Int(minDemandDaysTotal)) 个观光日，已压缩分配。"
            hints.append(msg)
            adjustments.append(msg)
        } else if minDemandDaysTotal > Double(availableCityDays) + 0.5 {
            let msg = "景点较多，\(availableCityDays) 个观光日可能装不下全部推荐景点，部分将自动取舍。"
            hints.append(msg)
            adjustments.append(msg)
        }

        return (hints, adjustments)
    }
}
