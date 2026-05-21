import Foundation

/// Trip span uses arrival + departure calendar days; activity days exclude both endpoints.
enum PlanTripDateMath {
    static let minActivityDays = 1
    static let maxActivityDays = 21

    /// Inclusive calendar span from arrival through departure.
    static func calendarSpanDays(arrival: Date, departure: Date) -> Int {
        let cal = Calendar.current
        let a = cal.startOfDay(for: arrival)
        let d = cal.startOfDay(for: departure)
        return max((cal.dateComponents([.day], from: a, to: d).day ?? 0) + 1, 1)
    }

    /// Days to plan (excludes arrival and departure).
    static func activityDayCount(arrival: Date, departure: Date) -> Int {
        let span = calendarSpanDays(arrival: arrival, departure: departure)
        return min(max(span - 2, minActivityDays), maxActivityDays)
    }

    static func departureRange(forArrival arrival: Date) -> ClosedRange<Date> {
        let cal = Calendar.current
        let start = cal.startOfDay(for: arrival)
        let minDeparture = cal.date(byAdding: .day, value: minActivityDays + 1, to: start) ?? start
        let maxDeparture = cal.date(byAdding: .day, value: maxActivityDays + 1, to: start) ?? start
        return minDeparture...maxDeparture
    }

    static func clampDeparture(_ departure: Date, arrival: Date) -> Date {
        let range = departureRange(forArrival: arrival)
        if departure < range.lowerBound { return range.lowerBound }
        if departure > range.upperBound { return range.upperBound }
        return departure
    }

    static func formatDisplayDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    static func formatTripMeta(arrival: Date, departure: Date) -> String {
        "\(formatDisplayDate(arrival)) – \(formatDisplayDate(departure))"
    }

    /// Labels for each activity day between arrival and departure.
    static func activityDateLabels(arrival: Date, count: Int) -> [String] {
        let cal = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        guard count > 0,
              let first = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: arrival)) else {
            return []
        }
        return (0..<count).compactMap { offset in
            guard let day = cal.date(byAdding: .day, value: offset, to: first) else { return nil }
            return formatter.string(from: day)
        }
    }
}
