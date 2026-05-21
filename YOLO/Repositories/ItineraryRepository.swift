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

    func markDeleted(id: String, userId: UUID) async throws {
        struct Patch: Encodable {
            let isDeleted: Bool
            enum CodingKeys: String, CodingKey {
                case isDeleted = "is_deleted"
            }
        }
        try await client
            .from("user_itineraries")
            .update(Patch(isDeleted: true))
            .eq("id", value: id)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }
}
