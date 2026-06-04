import Foundation
import Supabase

struct ItineraryRepository: Sendable {
    private var client: SupabaseClient { SupabaseManager.shared }

    func fetchAll(userId: UUID) async throws -> [UserItineraryRow] {
        try await client
            .from("user_itineraries")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("is_deleted", value: false)
            .order("updated_at", ascending: false)
            .execute()
            .value
    }

    func upsert(_ row: UserItineraryRow) async throws {
        try await client
            .from("user_itineraries")
            .upsert(row)
            .execute()
    }

    func fetchByShareSlug(_ slug: String) async throws -> UserItineraryRow? {
        let rows: [UserItineraryRow] = try await client
            .from("user_itineraries")
            .select()
            .eq("share_slug", value: slug)
            .eq("is_shared", value: true)
            .eq("is_deleted", value: false)
            .limit(1)
            .execute()
            .value
        return rows.first
    }

    func markDeleted(id: String, userId: UUID) async throws {
        // camelCase — encoder uses .convertToSnakeCase (isDeleted → is_deleted).
        struct Patch: Encodable {
            let isDeleted: Bool
        }
        try await client
            .from("user_itineraries")
            .update(Patch(isDeleted: true))
            .eq("id", value: id)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }
}
