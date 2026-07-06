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
        return mins >= 14 * 60 && mins < 17 * 60
    }

    static func isMorningDeparture(_ departureTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(departureTime) else { return false }
        return mins < 12 * 60
    }

    static func isEveningArrival(_ arrivalTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(arrivalTime) else { return false }
        return mins >= 17 * 60
    }

    /// 00:00–06:59 — red-eye / very early landing.
    static func isEarlyMorningArrival(_ arrivalTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(arrivalTime) else { return false }
        return mins < 7 * 60
    }

    /// 10:00–13:59 — late morning commute; origin-city morning sights unlikely.
    static func isLateMorningCommuteArrival(_ arrivalTime: String?) -> Bool {
        guard let mins = parseMinuteOfDay(arrivalTime) else { return false }
        return mins >= 10 * 60 && mins < 14 * 60
    }

    /// Non-nil, non-empty, parseable HH:mm.
    static func hasMeaningfulTime(_ time: String?) -> Bool {
        parseMinuteOfDay(time) != nil
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
        isTravelDay: Bool,
        hopKind: String? = nil
    ) -> Double {
        destinationWindows(
            arrivalAtDestination: arrivalAtDestination,
            travelHours: nil,
            pace: pace,
            isTravelDay: isTravelDay,
            hopKind: hopKind
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
        isTravelDay: Bool,
        hopKind: String? = nil
    ) -> DestinationWindows {
        let resolved = arrivalAtDestination?.trimmingCharacters(in: .whitespacesAndNewlines)
        let arrival = (resolved?.isEmpty == false) ? resolved : travelHours.map { suggestedArrivalAtDestination(travelHours: $0) }
        let base = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: pace)

        guard let mins = parseMinuteOfDay(arrival) else {
            let allowsMorning = travelHours.map {
                allowsMorningInOriginCity(travelHours: $0, arrivalAtDestination: nil)
            } ?? true
            return DestinationWindows(daytimeCap: base, eveningCap: 1, allowsMorningOrigin: allowsMorning, resolvedArrival: arrival)
        }

        var daytimeCap: Double
        var eveningCap: Int
        var allowsMorningOrigin: Bool

        switch mins {
        case 0..<(7 * 60):
            // Red-eye: full destination day after settling in.
            daytimeCap = base
            eveningCap = 1
            allowsMorningOrigin = false
        case (7 * 60)..<(10 * 60):
            daytimeCap = base
            eveningCap = 1
            allowsMorningOrigin = !isTravelDay
        case (10 * 60)..<(12 * 60):
            daytimeCap = max(1, base - 1)
            eveningCap = 1
            allowsMorningOrigin = false
        case (12 * 60)..<(14 * 60):
            daytimeCap = 1
            eveningCap = 0
            allowsMorningOrigin = false
        case (14 * 60)..<(17 * 60):
            daytimeCap = isTravelDay ? 0 : 0.5
            eveningCap = 1
            allowsMorningOrigin = false
        default:
            daytimeCap = 0
            eveningCap = 1
            allowsMorningOrigin = false
        }

        if isTravelDay, mins < 14 * 60, daytimeCap < 1 {
            daytimeCap = max(1, base - 1)
        }

        if let kind = hopKind,
           CityTravelHints.isIntercityHopKind(kind),
           kind != "travel",
           mins < 17 * 60,
           daytimeCap > 0 {
            daytimeCap = max(1, daytimeCap)
        }

        return DestinationWindows(
            daytimeCap: daytimeCap,
            eveningCap: eveningCap,
            allowsMorningOrigin: allowsMorningOrigin,
            resolvedArrival: arrival
        )
    }

    /// Single source of truth for hop-day destination sight capacity (scheduler + validate + replan).
    static func hopDaySightBudget(
        hopKind: String,
        pace: TripPace,
        arrivalAtDestination: String?,
        travelHours: Double?,
        slotDayCapacity: Double
    ) -> (destDaytimeCap: Double, eveningCap: Int, allowsMorningOrigin: Bool, commuteCost: Double) {
        let hours = travelHours ?? 0
        let commute = Double(CityTravelHints.commuteSlots(hours))
        let isTravel = hopKind == "travel"
        let windows = destinationWindows(
            arrivalAtDestination: arrivalAtDestination,
            travelHours: travelHours,
            pace: pace,
            isTravelDay: isTravel,
            hopKind: hopKind
        )

        if isTravel {
            return (windows.daytimeCap, windows.eveningCap, windows.allowsMorningOrigin, commute)
        }
        if hopKind == "short_hop" {
            return (min(slotDayCapacity, windows.daytimeCap), windows.eveningCap, windows.allowsMorningOrigin, 0)
        }

        let destCap = windows.daytimeCap
        return (min(slotDayCapacity, destCap), windows.eveningCap, windows.allowsMorningOrigin, commute)
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

#if DEBUG
enum PlanItineraryFlightTimesSelfTest {
    static func runAll() {
        let pace = TripPace.standard
        let early = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: "03:26",
            travelHours: 6,
            pace: pace,
            isTravelDay: true,
            hopKind: "travel"
        )
        assert(early.daytimeCap >= 2, "03:26 travel day should allow full sightseeing capacity")
        assert(!early.allowsMorningOrigin)

        let commute = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: "10:27",
            travelHours: 2,
            pace: pace,
            isTravelDay: false,
            hopKind: "short_hop"
        )
        assert(commute.daytimeCap == 1)
        assert(!commute.allowsMorningOrigin, "10:27 should not keep origin morning sights")

        let afternoon = PlanItineraryFlightTimes.destinationWindows(
            arrivalAtDestination: "15:27",
            travelHours: 2,
            pace: pace,
            isTravelDay: false,
            hopKind: "short_hop"
        )
        assert(afternoon.daytimeCap <= 1)
        assert(afternoon.eveningCap == 1)
        assert(!afternoon.allowsMorningOrigin)
    }
}
#endif
