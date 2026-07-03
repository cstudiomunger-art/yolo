import Foundation

enum PlanSeasonHints {
    private static let monthMap: [String: Int] = [
        "jan": 1, "feb": 2, "mar": 3, "apr": 4, "may": 5, "jun": 6,
        "jul": 7, "aug": 8, "sep": 9, "oct": 10, "nov": 11, "dec": 12,
    ]

    static func hints(cities: [City], selectedCityIds: Set<String>, tripMonth: Int) -> [String] {
        var lines: [String] = []
        for city in cities where selectedCityIds.contains(city.id) {
            guard let best = city.bestTimeToVisit?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !best.isEmpty else { continue }
            let ranges = parseBestTimeMonths(best)
            guard !ranges.isEmpty, !monthInRanges(tripMonth, ranges: ranges) else { continue }
            lines.append(String(
                localized: "\(city.name): best time is \(best); your month may be off-peak for weather or crowds."
            ))
        }
        return lines
    }

    static func parseBestTimeMonths(_ text: String) -> [(Int, Int)] {
        var ranges: [(Int, Int)] = []
        for part in text.split(whereSeparator: { ",;".contains($0) }) {
            let chunk = part.trimmingCharacters(in: .whitespacesAndNewlines)
            if chunk.isEmpty { continue }
            let span = chunk.split(whereSeparator: { "–-—".contains($0) })
            if span.count >= 2,
               let a = parseMonth(String(span.first!)),
               let b = parseMonth(String(span.last!)) {
                ranges.append(a <= b ? (a, b) : (b, a))
                continue
            }
            if let single = parseMonth(chunk) {
                ranges.append((single, single))
            }
        }
        return ranges
    }

    private static func parseMonth(_ token: String) -> Int? {
        let key = token.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().prefix(3)
        return monthMap[String(key)]
    }

    private static func monthInRanges(_ month: Int, ranges: [(Int, Int)]) -> Bool {
        ranges.contains { month >= $0.0 && month <= $0.1 }
    }
}

enum PlanTripFeasibility {
    /// Rough minimum activity days: sum(avg_days) + intercity travel buffer.
    static func estimatedActivityDays(cities: [City], selectedCityIds: Set<String>) -> Int {
        let selected = cities.filter { selectedCityIds.contains($0.id) }
        let daySum = selected.compactMap(\.avgDaysRecommended).reduce(0, +)
        let travelBuffer = max(0, selected.count - 1)
        return max(daySum + travelBuffer, selected.count)
    }

    static func tightTripWarning(
        cities: [City],
        selectedCityIds: Set<String>,
        activityDays: Int
    ) -> String? {
        let needed = estimatedActivityDays(cities: cities, selectedCityIds: selectedCityIds)
        guard activityDays < needed else { return nil }
        return String(
            localized: "This route typically needs about \(needed) activity days; you have \(activityDays). Some sights may be dropped."
        )
    }
}
