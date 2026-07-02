import Foundation

enum DayScheduleProfile {
    case fullDay
    case arrivalDay
    case departureDay
}

enum PlanItineraryDuration {
    static func parseDurationSlots(_ recommendedDuration: String?) -> Double {
        let raw = (recommendedDuration ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if raw.isEmpty { return 1 }

        if raw.contains("full day") || raw.contains("all day") || raw.contains("whole day") {
            return 2
        }

        if let hours = extractHours(raw) {
            if hours <= 3 { return 0.5 }
            if hours >= 5 { return 2 }
            return 1
        }

        if raw.contains("half day") { return 1 }
        return 1
    }

    static func daySlotCapacity(_ profile: DayScheduleProfile) -> Double {
        switch profile {
        case .arrivalDay, .departureDay:
            return 1
        case .fullDay:
            return 2
        }
    }

    static func maxAttractionsPerDay(catalogDurations: [Double], tripDays: Int, hardMax: Int = 3) -> Int {
        let days = max(1, tripDays)
        guard !catalogDurations.isEmpty else { return 1 }
        let totalSlots = catalogDurations.reduce(0, +)
        let avg = totalSlots / Double(days)
        if avg <= 1 { return 1 }
        if avg <= 1.5 { return min(2, hardMax) }
        return min(3, hardMax)
    }

    private static func extractHours(_ raw: String) -> Double? {
        let pattern = #"(\d+(?:\.\d+)?)\s*(h|hour)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }
        let range = NSRange(raw.startIndex..<raw.endIndex, in: raw)
        guard let match = regex.firstMatch(in: raw, options: [], range: range),
              match.numberOfRanges >= 2,
              let r = Range(match.range(at: 1), in: raw)
        else { return nil }
        return Double(raw[r])
    }
}
