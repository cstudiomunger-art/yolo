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

    enum CodingKeys: String, CodingKey {
        case id, title, cities, payload
        case userId = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case isDeleted = "is_deleted"
    }

    static func from(trip: SampleItinerary, userId: UUID, isDeleted: Bool = false) -> UserItineraryRow {
        UserItineraryRow(
            id: trip.id,
            userId: userId,
            title: trip.title,
            startDate: nil,
            endDate: nil,
            cities: Self.extractCityIds(from: trip),
            payload: trip,
            isDeleted: isDeleted
        )
    }

    var asSampleItinerary: SampleItinerary { payload }

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

    enum CodingKeys: String, CodingKey {
        case id, status
        case userId = "user_id"
        case checklistItemId = "checklist_item_id"
        case itineraryId = "itinerary_id"
        case completedAt = "completed_at"
    }
}

struct EmergencyHelpPhrase: Codable, Hashable, Identifiable {
    var id: String { chinese }
    let chinese: String
    let pinyin: String
    let english: String
}
