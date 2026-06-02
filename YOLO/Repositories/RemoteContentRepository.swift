import Foundation
import Supabase

struct RemoteContentRepository: ContentRepositoryProtocol {
    private var client: SupabaseClient { SupabaseManager.shared }
    private let bundledFallback = BundledContentRepository()

    func fetchCities() async throws -> [City] {
        try await client
            .from("cities")
            .select()
            .eq("is_published", value: true)
            .order("display_order", ascending: true)
            .execute()
            .value
    }

    func fetchCityRoutes(cityId: String) async throws -> [CityRoute] {
        []
    }

    func fetchCityGuides(cityId: String) async throws -> [CityGuide] {
        let normalizedCityId = cityId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        do {
            let rows: [CityGuide] = try await client
                .from("city_guides")
                .select()
                .eq("city_id", value: normalizedCityId)
                .eq("is_published", value: true)
                .order("display_order", ascending: true)
                .execute()
                .value
            if !rows.isEmpty { return rows }
        } catch {
            let fallback = try await bundledFallback.fetchCityGuides(cityId: normalizedCityId)
            if !fallback.isEmpty { return fallback }
            throw error
        }
        return try await bundledFallback.fetchCityGuides(cityId: normalizedCityId)
    }

    func fetchCityGuide(id: String) async throws -> CityGuide? {
        let normalizedId = id.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let rows: [CityGuide] = try await client
                .from("city_guides")
                .select()
                .eq("id", value: normalizedId)
                .eq("is_published", value: true)
                .limit(1)
                .execute()
                .value
            if let row = rows.first { return row }
        } catch {
            return try await bundledFallback.fetchCityGuide(id: normalizedId)
        }
        return try await bundledFallback.fetchCityGuide(id: normalizedId)
    }

    func fetchAttractions(cityId: String) async throws -> [Attraction] {
        let normalizedCityId = cityId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        do {
            let rows: [Attraction] = try await client
                .from("attractions")
                .select()
                .eq("city_id", value: normalizedCityId)
                .eq("is_published", value: true)
                .order("display_order", ascending: true)
                .execute()
                .value
            if !rows.isEmpty { return rows }
        } catch {
            let fallback = try await bundledFallback.fetchAttractions(cityId: normalizedCityId)
            if !fallback.isEmpty { return fallback }
            throw error
        }
        return try await bundledFallback.fetchAttractions(cityId: normalizedCityId)
    }

    func fetchAttraction(id: String) async throws -> Attraction? {
        let normalizedId = id.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let rows: [Attraction] = try await client
                .from("attractions")
                .select()
                .eq("id", value: normalizedId)
                .eq("is_published", value: true)
                .limit(1)
                .execute()
                .value
            if let row = rows.first { return row }
        } catch {
            return try await bundledFallback.fetchAttraction(id: normalizedId)
        }
        return try await bundledFallback.fetchAttraction(id: normalizedId)
    }

    func fetchAudioGuides(attractionId: String) async throws -> [AudioGuide] {
        try await client
            .from("audio_guides")
            .select()
            .eq("attraction_id", value: attractionId)
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
    }

    func fetchAudioGuide(id: String) async throws -> AudioGuide? {
        do {
            let rows: [AudioGuide] = try await client
                .from("audio_guides")
                .select()
                .eq("id", value: id)
                .eq("is_active", value: true)
                .limit(1)
                .execute()
                .value
            if let row = rows.first { return row }
        } catch {
            return try await bundledFallback.fetchAudioGuide(id: id)
        }
        return try await bundledFallback.fetchAudioGuide(id: id)
    }

    func fetchChecklistItems(cityIds: [String], countryCode: String) async throws -> [ChecklistItem] {
        let all: [ChecklistItem] = try await client
            .from("checklist_items")
            .select()
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
        return all
            .filter { $0.matchesFilter(cityIds: cityIds, countryCode: countryCode) }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchSubAreas(attractionId: String) async throws -> [SubArea] {
        try await client
            .from("sub_areas")
            .select()
            .eq("attraction_id", value: attractionId)
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
    }

    func fetchShoppingItems(cityIds: [String]) async throws -> [ShoppingItem] {
        let all: [ShoppingItem] = try await client
            .from("shopping_items")
            .select()
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
        return all.filter { item in
            guard let cityId = item.cityId else { return true }
            return cityIds.contains(cityId)
        }
    }

    func fetchReadingItems(cityIds: [String]) async throws -> [ReadingItem] {
        let all: [ReadingItem] = try await client
            .from("reading_list")
            .select()
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
        return all.filter { item in
            item.cityIds.isEmpty || !Set(item.cityIds).isDisjoint(with: cityIds)
        }
    }

    func fetchHotels(cityId: String) async throws -> [Hotel] {
        let normalizedCityId = cityId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        do {
            let rows: [Hotel] = try await client
                .from("hotels")
                .select()
                .eq("city_id", value: normalizedCityId)
                .eq("is_active", value: true)
                .order("sort_order", ascending: true)
                .execute()
                .value
            return rows.filter(\.acceptsForeigners)
        } catch {
            let fallback = try await bundledFallback.fetchHotels(cityId: normalizedCityId)
            if !fallback.isEmpty { return fallback }
            throw error
        }
    }

    func fetchHomeTips(cityIds: [String]) async throws -> [HomeTip] {
        let all: [HomeTip] = try await client
            .from("home_tips")
            .select()
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
        return all.filter { tip in
            guard let cityId = tip.cityId else { return true }
            return cityIds.contains(cityId)
        }
    }

    func fetchCultureTips(cityIds: [String]) async throws -> [CultureTip] {
        do {
            let all: [CultureTip] = try await client
                .from("culture_tips")
                .select()
                .eq("is_active", value: true)
                .order("sort_order", ascending: true)
                .execute()
                .value
            if !all.isEmpty {
                return all.filter { tip in
                    guard let cid = tip.cityId else { return true }
                    return cityIds.contains(cid)
                }
            }
        } catch {
            return try await bundledFallback.fetchCultureTips(cityIds: cityIds)
        }
        return try await bundledFallback.fetchCultureTips(cityIds: cityIds)
    }

    func fetchSampleItinerary() async throws -> SampleItinerary {
        try await fetchItinerary(kind: "sample")
    }

    func fetchPlanningItinerary() async throws -> SampleItinerary {
        do {
            return try await fetchItinerary(kind: "planning")
        } catch {
            return try await fetchItinerary(kind: "sample")
        }
    }

    func fetchAssistantReply(scenarioId: String) async throws -> AssistantReply? {
        let rows: [AssistantReply] = try await client
            .from("assistant_replies")
            .select()
            .eq("scenario_id", value: scenarioId)
            .eq("is_active", value: true)
            .limit(1)
            .execute()
            .value
        return rows.first
    }

    func fetchPassportCountries() async throws -> [PassportCountry] {
        try await client
            .from("passport_countries")
            .select()
            .eq("is_active", value: true)
            .order("display_order", ascending: true)
            .execute()
            .value
    }

    func fetchVisaRule(countryCode: String) async throws -> VisaRule? {
        let rows: [VisaRule] = try await client
            .from("visa_rules")
            .select()
            .eq("country_code", value: countryCode)
            .eq("is_active", value: true)
            .limit(1)
            .execute()
            .value
        return rows.first
    }

    func fetchEmergencyData() async throws -> EmergencyData {
        try await client
            .from("emergency_config")
            .select()
            .eq("id", value: "global")
            .single()
            .execute()
            .value
    }

    func fetchAssistantChips() async throws -> [AssistantChip] {
        try await client
            .from("assistant_chips")
            .select()
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value
    }

    func fetchChecklistSettings() async throws -> ChecklistSettings {
        let rows: [ChecklistSettings] = try await client
            .from("checklist_settings")
            .select()
            .eq("id", value: "global")
            .limit(1)
            .execute()
            .value
        return rows.first ?? .fallback
    }

    func fetchAppBranding() async throws -> AppBranding {
        let rows: [AppSettingsRow] = try await client
            .from("app_settings")
            .select()
            .eq("id", value: "global")
            .limit(1)
            .execute()
            .value
        guard let row = rows.first else { return .fallback }
        return row.asSettings.resolvedBranding
    }

    private func fetchItinerary(kind: String) async throws -> SampleItinerary {
        let row: ContentItineraryRow = try await client
            .from("content_itineraries")
            .select()
            .eq("kind", value: kind)
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .limit(1)
            .single()
            .execute()
            .value
        return row.asSampleItinerary()
    }
}
