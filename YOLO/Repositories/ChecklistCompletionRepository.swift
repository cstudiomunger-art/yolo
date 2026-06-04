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
        try await setStatusBatch(userId: userId, rows: [(checklistItemId: checklistItemId, itineraryId: itineraryId, status: status)])
    }

    func setStatusBatch(
        userId: UUID,
        rows: [(checklistItemId: String, itineraryId: String?, status: String)]
    ) async throws {
        // camelCase fields — the Supabase encoder uses .convertToSnakeCase, so
        // userId is written as user_id automatically (no explicit CodingKeys needed).
        struct UpsertRow: Encodable {
            let userId: UUID
            let checklistItemId: String
            let itineraryId: String?
            let status: String
            let completedAt: String?
        }
        let formatter = ISO8601DateFormatter()
        let upsertRows = rows.map { row in
            UpsertRow(
                userId: userId,
                checklistItemId: row.checklistItemId,
                itineraryId: row.itineraryId,
                status: row.status,
                completedAt: row.status == "done" ? formatter.string(from: Date()) : nil
            )
        }
        try await client
            .from("checklist_completion")
            .upsert(upsertRows, onConflict: "user_id,checklist_item_id,itinerary_id")
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
