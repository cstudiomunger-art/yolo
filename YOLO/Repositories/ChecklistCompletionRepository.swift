import Foundation
import Supabase

struct ChecklistCompletionRepository: Sendable {
    private var client: SupabaseClient { SupabaseManager.shared }

    func fetchAll(userId: UUID) async throws -> [ChecklistCompletionRow] {
        try await client
            .from("checklist_completion")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
    }

    func setStatus(
        userId: UUID,
        checklistItemId: String,
        itineraryId: String?,
        status: String
    ) async throws {
        struct UpsertRow: Encodable {
            let userId: UUID
            let checklistItemId: String
            let itineraryId: String?
            let status: String
            let completedAt: String?

            enum CodingKeys: String, CodingKey {
                case status
                case userId = "user_id"
                case checklistItemId = "checklist_item_id"
                case itineraryId = "itinerary_id"
                case completedAt = "completed_at"
            }
        }
        let completedAt = status == "done" ? ISO8601DateFormatter().string(from: Date()) : nil
        let row = UpsertRow(
            userId: userId,
            checklistItemId: checklistItemId,
            itineraryId: itineraryId,
            status: status,
            completedAt: completedAt
        )
        try await client
            .from("checklist_completion")
            .upsert(row, onConflict: "user_id,checklist_item_id,itinerary_id")
            .execute()
    }

    func deleteForItinerary(userId: UUID, itineraryId: String) async throws {
        try await client
            .from("checklist_completion")
            .delete()
            .eq("user_id", value: userId.uuidString)
            .eq("itinerary_id", value: itineraryId)
            .execute()
    }
}
