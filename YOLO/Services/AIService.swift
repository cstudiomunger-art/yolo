import Foundation
import Supabase

enum AIService {
    private static let functionName = "ai-complete"

    // MARK: - Public API

    static func generateItinerary(
        content: any ContentRepositoryProtocol,
        cities: [String],
        days: Int,
        useRemoteAI: Bool,
        userNotes: String? = nil
    ) async throws -> SampleItinerary {
        if useRemoteAI, isAuthenticated, AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            let payload = ItineraryRequest(
                type: "itinerary",
                cities: cities,
                days: days,
                userNotes: userNotes
            )
            let result: Result<ItineraryResponse, AIInvokeError> = await invokeResult(payload)
            if case .success(let response) = result,
               response.code == 200,
               let itinerary = response.itinerary {
                let cityIds = cities.map { $0.lowercased() }
                return PlanItineraryNormalizer.normalize(itinerary, selectedCityIds: cityIds)
            }
        }
        return try await localItineraryFallback(
            content: content,
            cities: cities,
            days: days,
            userNotes: userNotes
        )
    }

    static func planningItineraryCard(
        content: any ContentRepositoryProtocol,
        useRemoteAI: Bool,
        cities: [String],
        userNotes: String? = nil
    ) async throws -> SampleItinerary {
        if useRemoteAI, isAuthenticated, AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            return try await generateItinerary(
                content: content,
                cities: cities.isEmpty ? ["beijing"] : cities,
                days: 7,
                useRemoteAI: true,
                userNotes: userNotes
            )
        }
        return try await content.fetchPlanningItinerary()
    }

    // MARK: - Edge Function

    private struct AIInvokeError: Error {
        let message: String
    }

    private static func invokeResult<T: Decodable>(
        _ body: some Encodable
    ) async -> Result<T, AIInvokeError> {
        do {
            let value: T = try await SupabaseManager.shared.functions.invoke(
                functionName,
                options: FunctionInvokeOptions(body: body, encoder: JSONCoding.makeEncoder()),
                decoder: JSONCoding.makeDecoder()
            )
            return .success(value)
        } catch let error as FunctionsError {
            return .failure(AIInvokeError(message: describeFunctionsError(error)))
        } catch {
            return .failure(AIInvokeError(message: error.localizedDescription))
        }
    }

    private static func describeFunctionsError(_ error: FunctionsError) -> String {
        switch error {
        case .httpError(let code, let data):
            let body = String(data: data, encoding: .utf8) ?? ""
            return "HTTP \(code)\(body.isEmpty ? "" : " — \(body.prefix(120))")"
        case .relayError:
            return "Edge Function relay error"
        }
    }

    private static func localItineraryFallback(
        content: any ContentRepositoryProtocol,
        cities: [String],
        days: Int,
        userNotes: String? = nil
    ) async throws -> SampleItinerary {
        let cityIds = cities.isEmpty ? ["beijing"] : cities
        var catalog: [Attraction] = []
        for cityId in cityIds {
            let list = (try? await content.fetchAttractions(cityId: cityId)) ?? []
            catalog.append(contentsOf: list)
        }
        return PlanItineraryAssembler.build(
            cities: cityIds,
            tripDays: days,
            attractions: catalog,
            userNotes: userNotes
        )
    }

    /// ai-complete 要求登录用户 JWT（verify_jwt=true）；游客一律走本地兜底，不调用远程。
    private static var isAuthenticated: Bool {
        SupabaseManager.shared.auth.currentSession != nil
    }
}

// MARK: - Request / Response types

private struct ItineraryRequest: Encodable {
    let type: String
    let cities: [String]
    let days: Int
    let userNotes: String?

    enum CodingKeys: String, CodingKey {
        case type, cities, days
        case userNotes = "user_notes"
    }
}

private struct ItineraryResponse: Decodable {
    let code: Int
    let itinerary: SampleItinerary?
}
