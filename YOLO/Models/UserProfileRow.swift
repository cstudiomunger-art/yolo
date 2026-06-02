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

    enum CodingKeys: String, CodingKey {
        case id, email
        case displayName = "display_name"
        case avatarUrl = "avatar_url"
        case avatarStatus = "avatar_status"
        case countryCode = "country_code"
        case hasCompletedOnboarding = "has_completed_onboarding"
        case departureDate = "departure_date"
        case selectedCityIds = "selected_city_ids"
        case completedChecklistIds = "completed_checklist_ids"
        case purchasedAttractionIds = "purchased_attraction_ids"
        case isPro = "is_pro"
        case subscriptionPlanId = "subscription_plan_id"
        case subscriptionExpiresAt = "subscription_expires_at"
        case rcCustomerId = "rc_customer_id"
        case savedItineraries = "saved_itineraries"
        case activeItineraryId = "active_itinerary_id"
    }
}
