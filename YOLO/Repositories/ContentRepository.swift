import Foundation

protocol ContentRepositoryProtocol: Sendable {
    func fetchCities() async throws -> [City]
    func fetchCityRoutes(cityId: String) async throws -> [CityRoute]
    func fetchAttractions(cityId: String) async throws -> [Attraction]
    func fetchAttraction(id: String) async throws -> Attraction?
    func fetchAudioGuides(attractionId: String) async throws -> [AudioGuide]
    func fetchAudioGuide(id: String) async throws -> AudioGuide?
    func fetchChecklistItems(cityIds: [String], countryCode: String) async throws -> [ChecklistItem]
    func fetchSubAreas(attractionId: String) async throws -> [SubArea]
    func fetchShoppingItems(cityIds: [String]) async throws -> [ShoppingItem]
    func fetchReadingItems(cityIds: [String]) async throws -> [ReadingItem]
    func fetchHotels(cityId: String) async throws -> [Hotel]
    func fetchHomeTips(cityIds: [String]) async throws -> [HomeTip]
    func fetchCultureTips() async throws -> [CultureTip]
    func fetchSampleItinerary() async throws -> SampleItinerary
    func fetchPlanningItinerary() async throws -> SampleItinerary
    func fetchAssistantReply(scenarioId: String) async throws -> AssistantReply?
    func fetchPassportCountries() async throws -> [PassportCountry]
    func fetchVisaRule(countryCode: String) async throws -> VisaRule?
    func fetchEmergencyData() async throws -> EmergencyData
    func fetchAssistantChips() async throws -> [AssistantChip]
    func fetchAppBranding() async throws -> AppBranding
}

struct BundledContentRepository: ContentRepositoryProtocol {
    private let cities: [City]
    private let routes: [CityRoute]
    private let attractions: [Attraction]
    private let audioGuides: [AudioGuide]
    private let checklist: [ChecklistItem]
    private let shopping: [ShoppingItem]
    private let reading: [ReadingItem]
    private let hotels: [Hotel]
    private let homeTips: [HomeTip]
    private let cultureTips: [CultureTip]
    private let sampleItinerary: SampleItinerary
    private let planningItinerary: SampleItinerary?
    private let assistantReplies: [AssistantReply]
    private let visaRules: [VisaRule]
    private let emergencyData: EmergencyData
    private let assistantChips: [AssistantChip]
    private let appBranding: AppBranding

    init() {
        cities = BundledJSONLoader.load([City].self, resource: "cities")
        routes = BundledJSONLoader.load([CityRoute].self, resource: "city_routes")
        attractions = BundledJSONLoader.load([Attraction].self, resource: "attractions")
        audioGuides = BundledJSONLoader.load([AudioGuide].self, resource: "audio_guides")
        checklist = BundledJSONLoader.load([ChecklistItem].self, resource: "checklist_items")
        shopping = BundledJSONLoader.load([ShoppingItem].self, resource: "shopping_items")
        reading = BundledJSONLoader.load([ReadingItem].self, resource: "reading_list")
        hotels = BundledJSONLoader.load([Hotel].self, resource: "hotels")
        homeTips = BundledJSONLoader.load([HomeTip].self, resource: "home_tips")
        cultureTips = BundledJSONLoader.load([CultureTip].self, resource: "culture_tips")
        sampleItinerary = BundledJSONLoader.load(SampleItinerary.self, resource: "sample_itinerary")
        planningItinerary = BundledJSONLoader.loadOptional(SampleItinerary.self, resource: "planning_itinerary")
        assistantReplies = BundledJSONLoader.load([AssistantReply].self, resource: "assistant_replies")
        let visaBundle = BundledJSONLoader.load(VisaRulesBundle.self, resource: "visa-rules")
        visaRules = visaBundle.rules
        emergencyData = BundledJSONLoader.load(EmergencyData.self, resource: "emergency-data")
        assistantChips = BundledJSONLoader.load([AssistantChip].self, resource: "assistant_chips")
        appBranding = BundledJSONLoader.load(AppBranding.self, resource: "app_branding")
    }

    func fetchCities() async throws -> [City] { cities }

    func fetchCityRoutes(cityId: String) async throws -> [CityRoute] {
        routes.filter { $0.cityId == cityId }.sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchAttractions(cityId: String) async throws -> [Attraction] {
        attractions
            .filter { $0.cityId == cityId }
            .sorted { $0.displayOrder < $1.displayOrder }
    }

    func fetchAttraction(id: String) async throws -> Attraction? {
        attractions.first { $0.id == id }
    }

    func fetchAudioGuides(attractionId: String) async throws -> [AudioGuide] {
        audioGuides.filter { $0.attractionId == attractionId }
    }

    func fetchAudioGuide(id: String) async throws -> AudioGuide? {
        audioGuides.first { $0.id == id }
    }

    func fetchChecklistItems(cityIds: [String], countryCode: String) async throws -> [ChecklistItem] {
        checklist
            .filter { $0.matchesFilter(cityIds: cityIds, countryCode: countryCode) }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchSubAreas(attractionId: String) async throws -> [SubArea] { [] }

    func fetchShoppingItems(cityIds: [String]) async throws -> [ShoppingItem] {
        shopping.filter { item in
            guard let cityId = item.cityId else { return true }
            return cityIds.contains(cityId)
        }
        .sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchReadingItems(cityIds: [String]) async throws -> [ReadingItem] {
        reading.filter { item in
            item.cityIds.isEmpty || !Set(item.cityIds).isDisjoint(with: cityIds)
        }
        .sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchHotels(cityId: String) async throws -> [Hotel] {
        let normalized = cityId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return hotels.filter { $0.cityId.lowercased() == normalized && $0.acceptsForeigners }
    }

    func fetchHomeTips(cityIds: [String]) async throws -> [HomeTip] {
        homeTips.filter { tip in
            guard let cityId = tip.cityId else { return true }
            return cityIds.contains(cityId)
        }
    }

    func fetchCultureTips() async throws -> [CultureTip] { cultureTips }

    func fetchSampleItinerary() async throws -> SampleItinerary { sampleItinerary }

    func fetchPlanningItinerary() async throws -> SampleItinerary {
        planningItinerary ?? sampleItinerary
    }

    func fetchAssistantReply(scenarioId: String) async throws -> AssistantReply? {
        assistantReplies.first { $0.scenarioId == scenarioId }
    }

    func fetchPassportCountries() async throws -> [PassportCountry] {
        visaRules.enumerated().map { index, rule in
            PassportCountry(
                code: rule.countryCode,
                name: rule.countryName,
                flag: rule.flag,
                displayOrder: index
            )
        }
    }

    func fetchVisaRule(countryCode: String) async throws -> VisaRule? {
        visaRules.first { $0.countryCode == countryCode }
    }

    func fetchEmergencyData() async throws -> EmergencyData { emergencyData }

    func fetchAssistantChips() async throws -> [AssistantChip] {
        assistantChips.sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchAppBranding() async throws -> AppBranding { appBranding }
}
