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

    static func isEveningArrival(_ arrivalTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(arrivalTime) else { return false }
        return mins >= 17 * 60
    }

    /// Default assume 09:00 departure from origin + travel hours.
    static func suggestedArrivalAtDestination(travelHours: Double) -> String {
        let depart = 9 * 60
        let arrive = depart + Int(travelHours * 60)
        let h = min(23, arrive / 60)
        let m = arrive % 60
        return String(format: "%02d:%02d", h, m)
    }

    /// Hop day: keep morning sights in origin city only if 09:00 + travel still before noon.
    static func allowsMorningInOriginCity(travelHours: Double, arrivalAtDestination: String?) -> Bool {
        if isAfternoonArrival(arrivalAtDestination) { return false }
        if let arrival = parseMinuteOfDay(arrivalAtDestination) {
            return arrival < 12 * 60
        }
        return (9 * 60) + Int(travelHours * 60) <= 12 * 60
    }

    static func remainingDaytimeCapacity(
        arrivalAtDestination: String?,
        pace: TripPace,
        isTravelDay: Bool
    ) -> Double {
        guard let mins = parseMinuteOfDay(arrivalAtDestination) else {
            return PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
        }
        if mins >= 17 * 60 { return 0 }
        if mins >= 14 * 60 { return isTravelDay ? 0 : 1 }
        if mins >= 12 * 60 { return 1 }
        let base = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
        if isTravelDay { return max(1, base - 1) }
        return max(0, base - 1)
    }

    static func formatHHMM(from date: Date, calendar: Calendar = .current) -> String {
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        return String(format: "%02d:%02d", h, m)
    }
}
