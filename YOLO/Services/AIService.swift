import Foundation

enum AIService {
    static func generateItinerary(
        content: any ContentRepositoryProtocol,
        cities: [String],
        days: Int,
        style: String
    ) async throws -> SampleItinerary {
        if AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            // 远程 AI：后续接 Edge Function
        }
        let base = try await content.fetchSampleItinerary()
        let cityLabel = cities.map { $0.capitalized }.joined(separator: " → ")
        return SampleItinerary(
            id: UUID().uuidString,
            title: "\(days)-Day \(cityLabel) Trip",
            meta: "Generated · \(style)",
            routeSummary: cityLabel,
            estimatedBudget: base.estimatedBudget,
            days: base.days
        )
    }

    static func planningItineraryCard(content: any ContentRepositoryProtocol) async throws -> SampleItinerary {
        try await content.fetchPlanningItinerary()
    }
}
