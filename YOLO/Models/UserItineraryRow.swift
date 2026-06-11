import Foundation

/// Row shape for Supabase `user_itineraries` (021).
struct UserItineraryRow: Codable, Sendable {
    let id: String
    let userId: UUID
    var title: String
    var startDate: String?
    var endDate: String?
    var cities: [String]
    var payload: SampleItinerary
    var isDeleted: Bool
    var shareSlug: String?
    var isShared: Bool = false

    // camelCase keys — Supabase codec uses .convert*SnakeCase, so these auto-map
    // to/from snake_case columns (user_id ↔ userId). Snake_case raw values here
    // would break decoding (fields read as nil → fetch fails).
    enum CodingKeys: String, CodingKey {
        case id, title, cities, payload
        case userId, startDate, endDate, isDeleted, shareSlug, isShared
    }

    static func from(trip: SampleItinerary, userId: UUID, isDeleted: Bool = false) -> UserItineraryRow {
        UserItineraryRow(
            id: trip.id,
            userId: userId,
            title: trip.title,
            startDate: trip.startDate.map(Self.formatDateOnly),
            endDate: trip.endDate.map(Self.formatDateOnly),
            cities: Self.extractCityIds(from: trip),
            payload: trip,
            isDeleted: isDeleted,
            shareSlug: trip.shareSlug,
            isShared: trip.isShared
        )
    }

    var asSampleItinerary: SampleItinerary {
        var trip = payload
        trip.shareSlug = shareSlug
        trip.isShared = isShared
        // payload 通常已带日期；老行程从 DATE 列兜底回填。
        if trip.startDate == nil, let s = startDate { trip.startDate = Self.parseDateOnly(s) }
        if trip.endDate == nil, let e = endDate { trip.endDate = Self.parseDateOnly(e) }
        return trip
    }

    private static func dateOnlyFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private static func formatDateOnly(_ date: Date) -> String {
        dateOnlyFormatter().string(from: date)
    }

    private static func parseDateOnly(_ string: String) -> Date? {
        dateOnlyFormatter().date(from: string)
    }

    private static func extractCityIds(from trip: SampleItinerary) -> [String] {
        var ids = Set<String>()
        for day in trip.days {
            for act in day.activities {
                if let cid = act.cityId, !cid.isEmpty { ids.insert(cid) }
            }
            let legacy = day.cityName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !legacy.isEmpty {
                ids.insert(legacy.lowercased().replacingOccurrences(of: " ", with: "_"))
            }
        }
        if !ids.isEmpty { return Array(ids) }
        return trip.routeSummary
            .split(separator: "·")
            .map { $0.trimmingCharacters(in: .whitespaces).lowercased().replacingOccurrences(of: " ", with: "_") }
            .filter { !$0.isEmpty }
    }
}

struct ChecklistCompletionRow: Codable, Sendable, Identifiable {
    let id: UUID?
    let userId: UUID
    let checklistItemId: String
    let itineraryId: String?
    let status: String
    let completedAt: String?

    // camelCase keys — see UserItineraryRow note. .convert*SnakeCase handles the mapping.
    enum CodingKeys: String, CodingKey {
        case id, status
        case userId, checklistItemId, itineraryId, completedAt
    }
}

struct EmergencyHelpPhrase: Codable, Hashable, Identifiable {
    var id: String { chinese }
    let chinese: String
    let pinyin: String
    let english: String
}
