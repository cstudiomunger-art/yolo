import Foundation

/// Travel feasibility hints for itinerary planning (mirrors Edge `city-travel-hints.ts`).
enum CityTravelHints {
    private static let pairHours: [String: Double] = [
        "beijing|shanghai": 5.5,
        "beijing|nanjing": 4,
        "beijing|hangzhou": 5,
        "beijing|suzhou": 5.5,
        "beijing|chengdu": 7.5,
        "beijing|chongqing": 8,
        "shanghai|nanjing": 1.5,
        "shanghai|hangzhou": 1,
        "shanghai|suzhou": 0.5,
        "shanghai|chengdu": 12,
        "shanghai|chongqing": 11,
        "nanjing|hangzhou": 2.5,
        "nanjing|suzhou": 2,
        "hangzhou|suzhou": 1.5,
        "shanghai|guangzhou": 7,
        "beijing|guangzhou": 8,
        "chengdu|chongqing": 1.5,
    ]

    private static let cityRegionFallback: [String: String] = [
        "beijing": "north_china",
        "shanghai": "yangtze_delta",
        "nanjing": "yangtze_delta",
        "hangzhou": "yangtze_delta",
        "suzhou": "yangtze_delta",
        "guangzhou": "pearl_delta",
        "chengdu": "southwest",
        "chongqing": "southwest",
    ]

    private static let nearRegionPairs: Set<String> = [
        "north_china|yangtze_delta",
        "north_china|central_china",
        "yangtze_delta|central_china",
        "yangtze_delta|southwest",
        "central_china|southwest",
        "central_china|pearl_delta",
        "yangtze_delta|pearl_delta",
    ]

    private static func pairKey(_ a: String, _ b: String) -> String {
        [a.lowercased(), b.lowercased()].sorted().joined(separator: "|")
    }

    private static func regionPairKey(_ a: String, _ b: String) -> String {
        [a, b].sorted().joined(separator: "|")
    }

    static func travelHours(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Double {
        let x = a.lowercased()
        let y = b.lowercased()
        if x == y { return 0 }
        if let known = pairHours[pairKey(x, y)] { return known }
        let rx = (regionByCity[x] ?? nil) ?? cityRegionFallback[x]
        let ry = (regionByCity[y] ?? nil) ?? cityRegionFallback[y]
        if let rx, let ry {
            if rx == ry { return 2 }
            if nearRegionPairs.contains(regionPairKey(rx, ry)) { return 4 }
            return 6
        }
        return 6
    }

    static func commuteSlots(_ travelHours: Double) -> Int {
        if travelHours <= 2 { return 0 }
        if travelHours <= 4 { return 1 }
        return 2
    }

    static func canVisitSameDay(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Bool {
        commuteSlots(travelHours(a, b, regionByCity: regionByCity)) == 0
    }

    static func needsTravelDay(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Bool {
        commuteSlots(travelHours(a, b, regionByCity: regionByCity)) >= 2
    }

    /// Intense pace: same-day hop when commute is at most one slot (≤4h travel).
    static func canIntenseSameDayHop(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Bool {
        commuteSlots(travelHours(a, b, regionByCity: regionByCity)) <= 1
    }

    /// Compact intercity hop card (between morning and afternoon sights).
    static func buildHopCardContent(fromCityId: String, toCityId: String, hours: Double) -> [String] {
        let from = displayName(for: fromCityId)
        let to = displayName(for: toCityId)
        let slots = commuteSlots(hours)
        let journey = hours.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(hours))h"
            : String(format: "~%.1fh", hours)
        var lines = [
            "Travel from \(from) to \(to)",
            "Estimated journey: \(journey) (HSR / flight)",
        ]
        if slots == 0 {
            lines.append("Short hop — afternoon sightseeing in \(to)")
        } else {
            lines.append("Morning commute — afternoon sightseeing window")
        }
        return lines
    }

    static func buildHopCardContentWithArrival(
        fromCityId: String,
        toCityId: String,
        hours: Double,
        arrivalAtDestination: String?
    ) -> [String] {
        let from = displayName(for: fromCityId)
        let to = displayName(for: toCityId)
        let journey = hours.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(hours))h"
            : String(format: "~%.1fh", hours)
        var lines = [
            "Travel from \(from) to \(to)",
            "Estimated journey: \(journey) (HSR / flight)",
        ]
        if let arrival = arrivalAtDestination, !arrival.isEmpty {
            lines.append("Arrive in \(to) at \(arrival)")
            if PlanItineraryFlightTimes.isEveningArrival(arrival) {
                lines.append("Evening arrival — check in and rest")
            } else if PlanItineraryFlightTimes.isAfternoonArrival(arrival) {
                lines.append("Afternoon arrival — light sightseeing window")
            } else {
                lines.append("Morning commute — afternoon sightseeing window")
            }
        } else {
            let suggested = PlanItineraryFlightTimes.suggestedArrivalAtDestination(travelHours: hours)
            lines.append("Estimated arrival in \(to): \(suggested)")
            lines.append("Set your actual arrival time below")
        }
        return lines
    }

    static func hopDayRouteLabel(fromCityId: String, toCityId: String) -> String {
        routeLabel(from: [fromCityId, toCityId])
    }

    static func displayName(for cityId: String) -> String {
        cityId.prefix(1).uppercased() + cityId.dropFirst().replacingOccurrences(of: "_", with: " ")
    }

    static func routeLabel(from cityIds: [String]) -> String {
        cityIds.map { displayName(for: $0) }.joined(separator: " → ")
    }

    static func travelExperienceItems(toCityId: String) -> [String] {
        let name = displayName(for: toCityId)
        return [
            "Intercity travel",
            "Travel to \(name)",
            "Rest and check in",
            "Neighborhood walk near hotel",
        ]
    }

    static func buildTravelDayContent(fromCityId: String, toCityId: String, hours: Double) -> [String] {
        let from = displayName(for: fromCityId)
        let to = displayName(for: toCityId)
        let slots = commuteSlots(hours)
        let journey = hours.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(hours))h"
            : String(format: "~%.1fh", hours)
        var lines = [
            "Travel from \(from) to \(to)",
            "Estimated journey: \(journey) (HSR / flight)",
        ]
        if slots >= 2 {
            lines.append("Full travel day — check in and rest")
            lines.append("Optional light evening stroll after arrival")
        } else if slots == 1 {
            lines.append("Morning commute — afternoon sightseeing window")
        }
        lines.append("Explore \(to) near your hotel")
        return lines
    }

    static func arrivalAfternoonExperienceItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "Afternoon arrival in \(name)",
            "Check in and settle at your hotel",
            "Light neighborhood walk if you have energy",
            "Optional evening street food or night market",
            "Major sights start on the next full day",
        ]
    }

    static func departureMorningExperienceItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "Morning departure from \(name)",
            "Pack and hotel checkout",
            "Breakfast near your hotel",
            "Allow extra time for airport or train station transfer",
        ]
    }

    static func flexibleRestDayItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "Flexible day in \(name)",
            "Rest or explore at your own pace",
            "Neighborhood café, park, or local market",
            "Tap + Add attraction to schedule a specific sight",
        ]
    }

    /// Nearest-neighbor visit order using travel hours and catalog weights.
    static func inferVisitOrder(
        cityIds: [String],
        catalogCountByCity: [String: Int],
        avgDaysByCity: [String: Int] = [:],
        regionByCity: [String: String?] = [:],
        entryCityId: String? = nil,
        exitCityId: String? = nil
    ) -> [String] {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard unique.count > 1 else { return unique.isEmpty ? ["beijing"] : unique }

        func weight(_ id: String) -> Int {
            let count = catalogCountByCity[id] ?? 1
            let avg = avgDaysByCity[id] ?? 2
            return count + avg
        }

        let entry = entryCityId?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let exit = exitCityId?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var remaining = Set(unique)
        var order: [String] = []
        var current = (entry != nil && remaining.contains(entry!))
            ? entry!
            : unique.sorted { weight($0) > weight($1) }[0]
        order.append(current)
        remaining.remove(current)

        while !remaining.isEmpty {
            let best = remaining.min {
                travelHours(current, $0, regionByCity: regionByCity) < travelHours(current, $1, regionByCity: regionByCity)
            }!
            order.append(best)
            remaining.remove(best)
            current = best
        }
        if let exit, order.contains(exit), order.last != exit {
            return order.filter { $0 != exit } + [exit]
        }
        return order
    }

    struct EndpointSuggestion {
        let entryCityId: String
        let exitCityId: String
        let visitOrder: [String]
    }

    /// Suggest international landing/return cities from selected stops using shortest route order.
    static func suggestEntryExit(cityIds: [String], cities: [City]) -> EndpointSuggestion {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard !unique.isEmpty else {
            return EndpointSuggestion(entryCityId: "beijing", exitCityId: "beijing", visitOrder: ["beijing"])
        }
        if unique.count == 1 {
            let only = unique[0]
            return EndpointSuggestion(entryCityId: only, exitCityId: only, visitOrder: [only])
        }

        var catalogCountByCity: [String: Int] = [:]
        var avgDaysByCity: [String: Int] = [:]
        for city in cities {
            let cid = city.id.lowercased()
            guard unique.contains(cid) else { continue }
            catalogCountByCity[cid] = city.attractionCount
            if let avg = city.avgDaysRecommended {
                avgDaysByCity[cid] = avg
            }
        }
        for cid in unique {
            catalogCountByCity[cid, default: 1] = catalogCountByCity[cid, default: 1]
        }

        let visitOrder = inferVisitOrder(
            cityIds: unique,
            catalogCountByCity: catalogCountByCity,
            avgDaysByCity: avgDaysByCity
        )
        return EndpointSuggestion(
            entryCityId: visitOrder.first ?? unique[0],
            exitCityId: visitOrder.last ?? unique[0],
            visitOrder: visitOrder
        )
    }
}
