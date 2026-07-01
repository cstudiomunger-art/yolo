import Foundation
import Supabase

/// Partial update: mirror RevenueCat subscription into profiles for admin display.
struct MembershipMirrorPatch: Codable, Sendable {
    let subscriptionPlanId: String?
    let subscriptionExpiresAt: String?
    let rcCustomerId: String?
}

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
            .upsert(row, onConflict: "id")
            .execute()
    }

    /// PATCH subscription mirror columns only (reliable path after RC purchase).
    func patchMembershipMirror(
        userId: UUID,
        planId: String?,
        expiresAt: String?,
        rcCustomerId: String
    ) async throws {
        let patch = MembershipMirrorPatch(
            subscriptionPlanId: planId,
            subscriptionExpiresAt: expiresAt,
            rcCustomerId: rcCustomerId
        )
        try await client
            .from("profiles")
            .update(patch)
            .eq("id", value: userId.uuidString)
            .execute()
    }
}
