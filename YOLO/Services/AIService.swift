import Foundation
import Supabase

struct GeneratedItinerary {
    let trip: SampleItinerary
    /// True when the trip was built by local rules (guest, remote failure, or Edge `is_default`).
    let isRuleBased: Bool
    /// True when remote AI was requested but fell back to local rules.
    let usedLocalFallback: Bool
}

enum AIService {
    private static let functionName = "ai-complete"

    // MARK: - Public API

    static func generateItinerary(
        content: any ContentRepositoryProtocol,
        cities: [String],
        days: Int,
        useRemoteAI: Bool,
        userNotes: String? = nil,
        options: PlanItineraryGenerateOptions = .default
    ) async throws -> GeneratedItinerary {
        if useRemoteAI, isAuthenticated, AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            let startLocal: String? = options.startDate.map { date in
                let f = DateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                f.timeZone = .current
                return f.string(from: date)
            }
            let citySlugs = cities.map { $0.lowercased() }
            let entry = resolvedEndpointCity(options.entryCityId, among: citySlugs)
            let exit = resolvedEndpointCity(options.exitCityId, among: citySlugs) ?? entry
            let payload = ItineraryRequest(
                type: "itinerary",
                cities: cities,
                days: days,
                userNotes: userNotes,
                pace: options.pace.rawValue,
                arrivalTime: options.arrivalTime,
                departureTime: options.departureTime,
                startDate: startLocal,
                entryCityId: entry,
                exitCityId: exit
            )
            let result: Result<ItineraryResponse, AIInvokeError> = await invokeResult(payload)
            if case .success(let response) = result,
               response.code == 200,
               let itinerary = response.itinerary {
                return GeneratedItinerary(
                    trip: itinerary,
                    isRuleBased: response.isDefault ?? false,
                    usedLocalFallback: false
                )
            }
        }
        let attemptedRemote = useRemoteAI && isAuthenticated && AppConfig.isSupabaseConfigured && !AppConfig.forceBundled
        let trip = try await localItineraryFallback(
            content: content,
            cities: cities,
            days: days,
            userNotes: userNotes,
            options: options
        )
        return GeneratedItinerary(
            trip: trip,
            isRuleBased: true,
            usedLocalFallback: attemptedRemote
        )
    }

    static func planningItineraryCard(
        content: any ContentRepositoryProtocol,
        useRemoteAI: Bool,
        cities: [String],
        userNotes: String? = nil
    ) async throws -> SampleItinerary {
        if useRemoteAI, isAuthenticated, AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            let generated = try await generateItinerary(
                content: content,
                cities: cities.isEmpty ? ["beijing"] : cities,
                days: 7,
                useRemoteAI: true,
                userNotes: userNotes
            )
            return generated.trip
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
        userNotes: String? = nil,
        options: PlanItineraryGenerateOptions = .default
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
            userNotes: userNotes,
            pace: options.pace,
            arrivalTime: options.arrivalTime,
            departureTime: options.departureTime,
            startDate: options.startDate,
            entryCityId: options.entryCityId,
            exitCityId: options.exitCityId,
            applyNormalizer: false
        )
    }

    private static func resolvedEndpointCity(_ preferred: String?, among cities: [String]) -> String? {
        let unique = Array(Set(cities.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard !unique.isEmpty else { return nil }
        if let preferred {
            let normalized = preferred.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if unique.contains(normalized) { return normalized }
        }
        return unique.sorted().first
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
    let pace: String?
    let arrivalTime: String?
    let departureTime: String?
    let startDate: String?
    let entryCityId: String?
    let exitCityId: String?

    enum CodingKeys: String, CodingKey {
        case type, cities, days, pace
        case userNotes = "user_notes"
        case arrivalTime = "arrival_time"
        case departureTime = "departure_time"
        case startDate = "start_date"
        case entryCityId = "entry_city_id"
        case exitCityId = "exit_city_id"
    }
}

private struct ItineraryResponse: Decodable {
    let code: Int
    let itinerary: SampleItinerary?
    let isDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case code, itinerary
        case isDefault = "is_default"
    }
}
