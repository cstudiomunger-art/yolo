import Foundation

/// Row shape for Supabase `profiles` table.
struct UserProfileRow: Codable, Sendable {
    let id: UUID
    var email: String?
    var displayName: String?
    var avatarUrl: String?
    var avatarStatus: String
    var countryCode: String
    var hasCompletedOnboarding: Bool
    var departureDate: String?
    var selectedCityIds: [String]
    var completedChecklistIds: [String]
    var purchasedAttractionIds: [String]
    var isPro: Bool
    var subscriptionPlanId: String?
    var subscriptionExpiresAt: String?
    var rcCustomerId: String?
    /// Legacy JSON column; new trips use `user_itineraries`. App no longer reads/writes trip payloads here.
    var savedItineraries: [SampleItinerary]
    var activeItineraryId: String?

    // No explicit CodingKeys: the Supabase codec uses .convertFromSnakeCase /
    // .convertToSnakeCase, so synthesized camelCase keys map to/from snake_case
    // columns automatically (e.g. display_name ↔ displayName). Writing snake_case
    // raw values here would break decoding (every field would read as nil/throw).
}
