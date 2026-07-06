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

    static func remainingDaytimeCapacity(
        arrivalAtDestination: String?,
        pace: TripPace,
        isTravelDay: Bool
    ) -> Double {
        destinationWindows(
            arrivalAtDestination: arrivalAtDestination,
            travelHours: nil,
            pace: pace,
            isTravelDay: isTravelDay
        ).daytimeCap
    }

    struct DestinationWindows {
        let daytimeCap: Double
        let eveningCap: Int
        let allowsMorningOrigin: Bool
        let resolvedArrival: String?
    }

    /// Unified arrival-window rules for scheduler generation and Review replan.
    static func destinationWindows(
        arrivalAtDestination: String?,
        travelHours: Double?,
        pace: TripPace,
        isTravelDay: Bool
    ) -> DestinationWindows {
        let resolved = arrivalAtDestination?.trimmingCharacters(in: .whitespacesAndNewlines)
        let arrival = (resolved?.isEmpty == false) ? resolved : travelHours.map { suggestedArrivalAtDestination(travelHours: $0) }

        guard let mins = parseMinuteOfDay(arrival) else {
            let base = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
            let allowsMorning = travelHours.map {
                allowsMorningInOriginCity(travelHours: $0, arrivalAtDestination: nil)
            } ?? true
            return DestinationWindows(daytimeCap: base, eveningCap: 1, allowsMorningOrigin: allowsMorning, resolvedArrival: arrival)
        }

        if mins >= 17 * 60 {
            return DestinationWindows(daytimeCap: 0, eveningCap: 1, allowsMorningOrigin: false, resolvedArrival: arrival)
        }
        if mins >= 14 * 60 {
            return DestinationWindows(
                daytimeCap: isTravelDay ? 0 : 1,
                eveningCap: 1,
                allowsMorningOrigin: false,
                resolvedArrival: arrival
            )
        }
        if mins >= 12 * 60 {
            return DestinationWindows(daytimeCap: 1, eveningCap: 0, allowsMorningOrigin: false, resolvedArrival: arrival)
        }

        let base = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)
        let daytimeCap = isTravelDay ? max(1, base - 1) : max(0, base - 1)
        return DestinationWindows(daytimeCap: daytimeCap, eveningCap: 1, allowsMorningOrigin: true, resolvedArrival: arrival)
    }

    static func allowsMorningInOriginCity(travelHours: Double, arrivalAtDestination: String?) -> Bool {
        destinationWindows(
            arrivalAtDestination: arrivalAtDestination,
            travelHours: travelHours,
            pace: .standard,
            isTravelDay: false
        ).allowsMorningOrigin
    }

    static func formatHHMM(from date: Date, calendar: Calendar = .current) -> String {
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        return String(format: "%02d:%02d", h, m)
    }
}
