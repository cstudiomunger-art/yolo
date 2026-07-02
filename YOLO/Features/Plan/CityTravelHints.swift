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

    private static let deltaCities: Set<String> = ["shanghai", "nanjing", "hangzhou", "suzhou"]
    private static let swCities: Set<String> = ["chengdu", "chongqing"]

    private static func pairKey(_ a: String, _ b: String) -> String {
        [a.lowercased(), b.lowercased()].sorted().joined(separator: "|")
    }

    static func travelHours(_ a: String, _ b: String) -> Double {
        let x = a.lowercased()
        let y = b.lowercased()
        if x == y { return 0 }
        if let known = pairHours[pairKey(x, y)] { return known }
        if deltaCities.contains(x), deltaCities.contains(y) { return 2 }
        if swCities.contains(x), swCities.contains(y) { return 2 }
        return 6
    }

    static func canVisitSameDay(_ a: String, _ b: String) -> Bool {
        travelHours(a, b) <= 2
    }

    static func needsTravelDay(_ a: String, _ b: String) -> Bool {
        travelHours(a, b) > 2.5
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
        avgDaysByCity: [String: Int] = [:]
    ) -> [String] {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard unique.count > 1 else { return unique.isEmpty ? ["beijing"] : unique }

        func weight(_ id: String) -> Int {
            let count = catalogCountByCity[id] ?? 1
            let avg = avgDaysByCity[id] ?? 2
            return count + avg
        }

        var remaining = Set(unique)
        var order: [String] = []
        var current = unique.sorted { weight($0) > weight($1) }[0]
        order.append(current)
        remaining.remove(current)

        while !remaining.isEmpty {
            let best = remaining.min { travelHours(current, $0) < travelHours(current, $1) }!
            order.append(best)
            remaining.remove(best)
            current = best
        }
        return order
    }
}
