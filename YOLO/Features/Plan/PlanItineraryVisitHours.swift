import Foundation

enum VisitWeekday: String {
    case mon, tue, wed, thu, fri, sat, sun
}

enum HalfDaySlot: String {
    case morning
    case afternoon
}

enum VisitPeriod: String {
    case morning
    case afternoon
    case evening
    case flexible
}

enum VisitTimeSlot: String {
    case morning
    case afternoon
    case evening
}

enum PlanItineraryVisitHours {
    static func normalizeVisitPeriod(_ raw: String?) -> VisitPeriod {
        let v = (raw ?? "flexible").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch v {
        case "morning": return .morning
        case "afternoon": return .afternoon
        case "evening": return .evening
        default: return .flexible
        }
    }

    static func isEveningOnly(_ attraction: Attraction) -> Bool {
        normalizeVisitPeriod(attraction.recommendedVisitPeriod) == .evening
    }

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

    static func isClosedOnDate(_ attraction: Attraction, date: Date, calendar: Calendar = .current) -> Bool {
        isClosedOnWeekday(attraction, weekday: weekday(from: date, calendar: calendar))
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

    static func visitTimeSlotLabel(_ slot: VisitTimeSlot?) -> String {
        switch slot {
        case .morning: return "Morning"
        case .afternoon: return "Afternoon"
        case .evening: return "Evening"
        case nil: return ""
        }
    }

    static func pickVisitTimeSlot(_ attraction: Attraction, preferred: VisitTimeSlot? = nil) -> VisitTimeSlot? {
        switch normalizeVisitPeriod(attraction.recommendedVisitPeriod) {
        case .evening:
            return .evening
        case .morning:
            return pickTimeSlot(attraction, preferred: .morning) != nil ? .morning : nil
        case .afternoon:
            return pickTimeSlot(attraction, preferred: .afternoon) != nil ? .afternoon : nil
        case .flexible:
            if preferred == .evening { return nil }
            if let half = pickTimeSlot(attraction, preferred: preferred == .afternoon ? .afternoon : preferred == .morning ? .morning : nil) {
                return half == .morning ? .morning : .afternoon
            }
            return nil
        }
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
