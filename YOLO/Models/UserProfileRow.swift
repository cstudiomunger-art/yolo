import Foundation

/// Row shape for Supabase `profiles` table.
struct UserProfileRow: Codable, Sendable {
    let id: UUID
    var email: String?
    var displayName: String?
    var countryCode: String
    var hasCompletedOnboarding: Bool
    var departureDate: String?
    var selectedCityIds: [String]
    var completedChecklistIds: [String]
    var purchasedAttractionIds: [String]
    var isPro: Bool
    var savedItineraries: [SampleItinerary]
    var activeItineraryId: String?
}
