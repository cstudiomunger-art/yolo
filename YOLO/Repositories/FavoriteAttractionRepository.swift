import Foundation
import Supabase

struct FavoriteAttractionRepository: Sendable {
    private var client: SupabaseClient { SupabaseManager.shared }

    func fetchAll(userId: UUID) async throws -> [FavoriteAttractionRow] {
        try await client
            .from("favorite_attractions")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func upsert(
        userId: UUID,
        attractionId: String,
        cityId: String,
        createdAt: Date = .now
    ) async throws {
        struct UpsertRow: Encodable {
            let userId: UUID
            let attractionId: String
            let cityId: String
            let createdAt: String
        }
        let row = UpsertRow(
            userId: userId,
            attractionId: attractionId,
            cityId: cityId,
            createdAt: ISO8601DateFormatter().string(from: createdAt)
        )
        try await client
            .from("favorite_attractions")
            .upsert(row, onConflict: "user_id,attraction_id")
            .execute()
    }

    func delete(userId: UUID, attractionId: String) async throws {
        try await client
            .from("favorite_attractions")
            .delete()
            .eq("user_id", value: userId.uuidString)
            .eq("attraction_id", value: attractionId)
            .execute()
    }
}
