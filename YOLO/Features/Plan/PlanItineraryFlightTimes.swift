import Foundation

enum PlanItineraryFlightTimes {
    static func parseMinuteOfDay(_ hhmm: String?) -> Int? {
        let raw = (hhmm ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return nil }
        let parts = raw.split(separator: ":")
        guard parts.count == 2,
              let h = Int(parts[0]), let m = Int(parts[1]),
              (0...23).contains(h), (0...59).contains(m) else { return nil }
        return h * 60 + m
    }

    static func isAfternoonArrival(_ arrivalTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(arrivalTime) else { return false }
        return mins >= 14 * 60
    }

    static func isMorningDeparture(_ departureTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(departureTime) else { return false }
        return mins < 12 * 60
    }

    static func formatHHMM(from date: Date, calendar: Calendar = .current) -> String {
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        return String(format: "%02d:%02d", h, m)
    }
}
