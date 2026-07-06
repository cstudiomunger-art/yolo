import Foundation

enum TripPace: String, CaseIterable, Identifiable {
    case relaxed
    case standard
    case intense

    var id: String { rawValue }

    var label: String {
        switch self {
        case .relaxed: return String(localized: "Relaxed")
        case .standard: return String(localized: "Standard")
        case .intense: return String(localized: "Intense")
        }
    }

    var subtitle: String {
        switch self {
        case .relaxed: return String(localized: "~1 slot per day")
        case .standard: return String(localized: "~2 slots per day")
        case .intense: return String(localized: "Packed schedule")
        }
    }

    /// Compact label for menus; selected row shows `label` only.
    var menuTitle: String {
        switch self {
        case .relaxed: return String(localized: "Relaxed · 1/day")
        case .standard: return String(localized: "Standard · 2/day")
        case .intense: return String(localized: "Intense · packed")
        }
    }

    static func defaultPace(tripDays: Int, cityCount: Int) -> TripPace {
        guard cityCount > 0 else { return .standard }
        return Double(tripDays) / Double(cityCount) >= 3 ? .standard : .relaxed
    }
}

enum PlanItineraryPace {
    /// Hop days pack AM sight + commute + PM sight (intense only).
    static let hopDaySlotCapacity: Double = 3

    static func hopDaySlotBudget(pace: TripPace) -> Double {
        switch pace {
        case .intense: return hopDaySlotCapacity
        case .relaxed, .standard: return 1
        }
    }

    static func daySlotCapacity(profile: DayScheduleProfile, pace: TripPace) -> Double {
        if profile == .departureDay { return 1 }
        if profile == .arrivalDay { return 1 }
        switch pace {
        case .relaxed: return 1
        case .intense: return 2.5
        case .standard: return 2
        }
    }
}
