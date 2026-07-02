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
        "chengdu|chongqing": 1.5,
    ]

    private static let cityRegionFallback: [String: String] = [
        "beijing": "north_china",
        "shanghai": "yangtze_delta",
        "nanjing": "yangtze_delta",
        "hangzhou": "yangtze_delta",
        "suzhou": "yangtze_delta",
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
}
