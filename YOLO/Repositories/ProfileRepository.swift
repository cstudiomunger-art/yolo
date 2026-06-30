import Foundation
import Supabase

struct ProfileRepository: Sendable {
    private var client: SupabaseClient { SupabaseManager.shared }

    func fetch(userId: UUID) async throws -> UserProfileRow? {
        try await client
            .from("profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
    }

    func upsert(_ row: UserProfileRow) async throws {
        try await client
            .from("profiles")
            .upsert(row)
            .execute()
    }

    /// Upsert only client-writable profile fields (no entitlements).
    func upsertClientProfile(_ row: ClientProfilePushRow) async throws {
        try await client
            .from("profiles")
            .upsert(row)
            .execute()
    }
}
