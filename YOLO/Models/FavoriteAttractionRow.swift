import Foundation

struct FavoriteAttractionRow: Codable, Sendable, Identifiable {
    var id: String { attractionId }
    let userId: UUID
    let attractionId: String
    let cityId: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case userId, attractionId, cityId, createdAt
    }

    func asRecord() -> FavoriteAttractionRecord {
        FavoriteAttractionRecord(
            attractionId: attractionId,
            cityId: cityId,
            createdAt: createdAt.flatMap { Self.parseISO8601($0) }
        )
    }

    private static func parseISO8601(_ string: String) -> Date? {
        ISO8601DateFormatter().date(from: string)
    }
}
