import Foundation

enum VisitWeekday: String {
    case mon, tue, wed, thu, fri, sat, sun
}

enum HalfDaySlot: String {
    case morning
    case afternoon
}

enum PlanItineraryVisitHours {
    static func weekday(from date: Date, calendar: Calendar = .current) -> VisitWeekday {
        let value = calendar.component(.weekday, from: date)
        switch value {
        case 2: return .mon
        case 3: return .tue
        case 4: return .wed
        case 5: return .thu
        case 6: return .fri
        case 7: return .sat
        default: return .sun
        }
    }

    static func isClosedOnWeekday(_ attraction: Attraction, weekday: VisitWeekday) -> Bool {
        attraction.closedWeekdays.contains(weekday.rawValue)
    }

    static func allowedHalfDaySlots(_ attraction: Attraction) -> [HalfDaySlot] {
        guard let open = parseMinute(attraction.openTime), let close = parseMinute(attraction.closeTime) else {
            return [.morning, .afternoon]
        }
        let lastEntry = parseMinute(attraction.lastEntryTime) ?? max(open, close - 30)
        let morning = open <= (10 * 60 + 30) && (lastEntry >= 12 * 60 || close >= 13 * 60)
        let afternoon = open <= 14 * 60 && close >= 16 * 60
        if morning && afternoon { return [.morning, .afternoon] }
        if morning { return [.morning] }
        if afternoon { return [.afternoon] }
        return []
    }

    static func pickTimeSlot(_ attraction: Attraction, preferred: HalfDaySlot?) -> HalfDaySlot? {
        let allowed = allowedHalfDaySlots(attraction)
        if allowed.isEmpty { return nil }
        if let preferred, allowed.contains(preferred) { return preferred }
        return allowed.first
    }

    private static func parseMinute(_ value: String?) -> Int? {
        let raw = (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return nil }
        let parts = raw.split(separator: ":")
        guard parts.count == 2, let h = Int(parts[0]), let m = Int(parts[1]), (0...23).contains(h), (0...59).contains(m) else {
            return nil
        }
        return h * 60 + m
    }
}
