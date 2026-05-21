import Foundation

/// Wraps remote fetches with disk cache (stale-while-revalidate, 24h TTL).
struct CachingContentRepository: ContentRepositoryProtocol {
    private let upstream: RemoteContentRepository
    private let store = ContentCacheStore.shared

    init(upstream: RemoteContentRepository = RemoteContentRepository()) {
        self.upstream = upstream
    }

    func fetchCities() async throws -> [City] {
        try await cached(key: ContentCacheKey.cities()) {
            try await upstream.fetchCities()
        }
    }

    func fetchCityRoutes(cityId: String) async throws -> [CityRoute] {
        try await upstream.fetchCityRoutes(cityId: cityId)
    }

    func fetchAttractions(cityId: String) async throws -> [Attraction] {
        let key = ContentCacheKey.attractions(cityId: cityId)
        return try await cached(key: key) {
            try await upstream.fetchAttractions(cityId: cityId)
        }
    }

    func fetchAttraction(id: String) async throws -> Attraction? {
        let key = ContentCacheKey.attraction(id: id)
        return try await cachedOptional(key: key) {
            try await upstream.fetchAttraction(id: id)
        }
    }

    func fetchAudioGuides(attractionId: String) async throws -> [AudioGuide] {
        let key = ContentCacheKey.audioGuides(attractionId: attractionId)
        return try await cached(key: key) {
            try await upstream.fetchAudioGuides(attractionId: attractionId)
        }
    }

    func fetchAudioGuide(id: String) async throws -> AudioGuide? {
        let key = ContentCacheKey.audioGuide(id: id)
        return try await cachedOptional(key: key) {
            try await upstream.fetchAudioGuide(id: id)
        }
    }

    func fetchChecklistItems(cityIds: [String], countryCode: String) async throws -> [ChecklistItem] {
        let key = ContentCacheKey.checklist(cityIds: cityIds, countryCode: countryCode)
        return try await cached(key: key) {
            try await upstream.fetchChecklistItems(cityIds: cityIds, countryCode: countryCode)
        }
    }

    func fetchSubAreas(attractionId: String) async throws -> [SubArea] {
        let key = ContentCacheKey.subAreas(attractionId: attractionId)
        return try await cached(key: key) {
            try await upstream.fetchSubAreas(attractionId: attractionId)
        }
    }

    func fetchShoppingItems(cityIds: [String]) async throws -> [ShoppingItem] {
        let key = ContentCacheKey.shopping(cityIds: cityIds)
        return try await cached(key: key) {
            try await upstream.fetchShoppingItems(cityIds: cityIds)
        }
    }

    func fetchReadingItems(cityIds: [String]) async throws -> [ReadingItem] {
        let key = ContentCacheKey.reading(cityIds: cityIds)
        return try await cached(key: key) {
            try await upstream.fetchReadingItems(cityIds: cityIds)
        }
    }

    func fetchHotels(cityId: String) async throws -> [Hotel] {
        let key = ContentCacheKey.hotels(cityId: cityId)
        return try await cached(key: key) {
            try await upstream.fetchHotels(cityId: cityId)
        }
    }

    func fetchHomeTips(cityIds: [String]) async throws -> [HomeTip] {
        let key = ContentCacheKey.homeTips(cityIds: cityIds)
        return try await cached(key: key) {
            try await upstream.fetchHomeTips(cityIds: cityIds)
        }
    }

    func fetchCultureTips() async throws -> [CultureTip] {
        try await cached(key: ContentCacheKey.cultureTips()) {
            try await upstream.fetchCultureTips()
        }
    }

    func fetchSampleItinerary() async throws -> SampleItinerary {
        try await cached(key: ContentCacheKey.sampleItinerary()) {
            try await upstream.fetchSampleItinerary()
        }
    }

    func fetchPlanningItinerary() async throws -> SampleItinerary {
        try await cached(key: ContentCacheKey.planningItinerary()) {
            try await upstream.fetchPlanningItinerary()
        }
    }

    func fetchAssistantReply(scenarioId: String) async throws -> AssistantReply? {
        let key = ContentCacheKey.assistantReply(scenarioId: scenarioId)
        return try await cachedOptional(key: key) {
            try await upstream.fetchAssistantReply(scenarioId: scenarioId)
        }
    }

    func fetchPassportCountries() async throws -> [PassportCountry] {
        try await cached(key: ContentCacheKey.passportCountries()) {
            try await upstream.fetchPassportCountries()
        }
    }

    func fetchVisaRule(countryCode: String) async throws -> VisaRule? {
        let key = ContentCacheKey.visaRule(countryCode: countryCode)
        return try await cachedOptional(key: key) {
            try await upstream.fetchVisaRule(countryCode: countryCode)
        }
    }

    func fetchEmergencyData() async throws -> EmergencyData {
        try await cached(key: ContentCacheKey.emergencyData()) {
            try await upstream.fetchEmergencyData()
        }
    }

    func fetchAssistantChips() async throws -> [AssistantChip] {
        try await cached(key: ContentCacheKey.assistantChips()) {
            try await upstream.fetchAssistantChips()
        }
    }

    func fetchAppBranding() async throws -> AppBranding {
        try await cached(key: ContentCacheKey.appBranding()) {
            try await upstream.fetchAppBranding()
        }
    }

    // MARK: - Cache helpers

    private func cached<T: Codable>(
        key: String,
        ttl: TimeInterval = ContentCacheStore.defaultTTL,
        fetch: @escaping () async throws -> T
    ) async throws -> T {
        if let entry = await store.load(T.self, key: key, ttl: ttl) {
            if entry.isStale {
                scheduleRefresh(key: key, fetch: fetch)
            }
            return entry.value
        }
        do {
            let fresh = try await fetch()
            await store.save(fresh, key: key)
            return fresh
        } catch {
            if let stale = await store.load(T.self, key: key, ttl: .infinity) {
                return stale.value
            }
            throw error
        }
    }

    private func cachedOptional<T: Codable>(
        key: String,
        ttl: TimeInterval = ContentCacheStore.defaultTTL,
        fetch: @escaping () async throws -> T?
    ) async throws -> T? {
        if let entry = await store.load(T?.self, key: key, ttl: ttl) {
            if entry.isStale {
                scheduleRefresh(key: key, fetch: fetch)
            }
            return entry.value
        }
        do {
            let fresh = try await fetch()
            await store.save(fresh, key: key)
            return fresh
        } catch {
            if let stale = await store.load(T?.self, key: key, ttl: .infinity) {
                return stale.value
            }
            throw error
        }
    }

    private func scheduleRefresh<T: Codable>(
        key: String,
        fetch: @escaping () async throws -> T
    ) {
        Task {
            guard let fresh = try? await fetch() else { return }
            await store.save(fresh, key: key)
        }
    }
}
