import Foundation

struct City: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let chineseName: String
    let emoji: String?
    let coverImagePath: String?
    let description: String?
    let bestFor: [String]
    let seasonNote: String?
    let bestTimeToVisit: String?
    let avgDaysRecommended: Int?
    let attractionCount: Int
}

struct CityRoute: Identifiable, Codable {
    let id: String
    let cityId: String
    let title: String
    let days: Int
    let summary: String
    let sortOrder: Int
}

struct Attraction: Identifiable, Codable, Hashable {
    let id: String
    let cityId: String
    let name: String
    let chineseName: String
    let category: String
    let coverImagePath: String?
    let summary: String?
    let introduction: String?
    let priority: String
    let ticketPrice: String?
    let recommendedDuration: String?
    let openingHours: String?
    let closedDays: String?
    let requiresAdvanceBooking: Bool
    let metroAccess: String?
    let westernVisitorTips: [String]
    let nearbyPlaces: [NearbyPlace]
    let audioGuideCount: Int
    let iapProductId: String?
}

struct NearbyPlace: Codable, Hashable {
    let name: String
    let distance: String
}

struct AudioGuide: Identifiable, Codable {
    let id: String
    let attractionId: String
    let titleEn: String
    let description: String?
    let durationSeconds: Int
    let audioUrl: String
    let quote: String?
    let segments: [AudioSegment]
    let isMainGuide: Bool
}

struct AudioSegment: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let startSeconds: Int
}

struct ChecklistItem: Identifiable, Codable, Hashable {
    let id: String
    let cityId: String?
    let phase: String
    let groupTitle: String
    let titleEn: String
    let estimatedMinutes: Int?
    let displayTags: [String]
    let culturalTip: String?
    let sortOrder: Int
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    let id: String
    let cityId: String?
    let titleEn: String
    let noteEn: String?
    let sortOrder: Int
}

struct ReadingItem: Identifiable, Codable, Hashable {
    let id: String
    let cityIds: [String]
    let title: String
    let author: String
    let genre: String
    let synopsisEn: String
    let sortOrder: Int
}

struct Hotel: Identifiable, Codable {
    let id: String
    let cityId: String
    let name: String
    let chineseName: String
    let stars: Int
    let priceMinUsd: Int
    let hasEnglishStaff: Bool
    let englishStaffNote: String?
    let languageTip: String?
    let locationNote: String?
    let bookingPlatforms: [String]
}

struct HomeTip: Identifiable, Codable {
    let id: String
    let cityId: String?
    let kicker: String
    let headline: String
    let body: String
    let linkLabel: String?
    let linkAttractionId: String?
}

struct CultureTip: Identifiable, Codable {
    let id: String
    let emoji: String
    let title: String
    let preview: String
    let body: String
}

struct VisaRule: Codable {
    let countryCode: String
    let countryName: String
    let flag: String
    let visaFree: Bool
    let stayDays: Int?
    let headline: String
    let details: [VisaDetail]
}

struct VisaDetail: Codable {
    let label: String
    let value: String
}

struct VisaRulesBundle: Codable {
    let rules: [VisaRule]
}

struct SampleItinerary: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let meta: String
    let routeSummary: String
    let estimatedBudget: String
    let days: [ItineraryDay]
}

struct ItineraryDay: Identifiable, Codable, Hashable {
    let id: String
    let dayIndex: Int
    let dateLabel: String
    let cityName: String
    let costEstimate: String?
    let activities: [ItineraryActivity]
}

struct ItineraryActivity: Identifiable, Codable, Hashable {
    let id: String
    let timeSlot: String
    let name: String
    let detail: String
    let attractionId: String?
    let hasAudio: Bool
}

struct AssistantReply: Codable {
    let scenarioId: String
    let userMessage: String?
    let assistantMessage: String
}

struct EmergencyContact: Codable, Identifiable, Hashable {
    var id: String { label }
    let label: String
    let number: String
    let note: String?
}

struct EmergencyData: Codable {
    let contacts: [EmergencyContact]
    let embassyNote: String
}

struct ContentItineraryRow: Codable {
    let id: String
    let kind: String
    let title: String
    let meta: String
    let routeSummary: String
    let estimatedBudget: String
    let days: [ItineraryDay]

    func asSampleItinerary() -> SampleItinerary {
        SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days
        )
    }
}

struct AppBranding: Codable, Equatable {
    static let fallback = AppBranding(
        supportEmail: "support@chinago.app",
        aboutTitle: "ChinaGo",
        aboutVersion: "1.0.0",
        aboutBody: "Your companion for planning and experiencing travel in China.",
        iapProTitle: "ChinaGo Pro",
        iapProPrice: "$19.99/year",
        iapProTrialText: "3-day free trial",
        iapProFeatures: "All attraction guides\nUnlimited AI planning\nOffline download",
        iapSinglePriceLabel: "Buy This Guide · $1.99",
        assistantGreetingGeneral: "Good morning. How can I assist with your China trip today?",
        assistantGreetingPlanning: "Hi! I'm building your itinerary. Tell me: how many days, interests, and budget?",
        planAlertMessage: "",
        planAlertLinkAttractionId: nil,
        planAlertLinkCityId: nil,
        planAlertLinkLabel: "How to Book →",
        freeAudioPreviewSeconds: 180
    )

    let supportEmail: String
    let aboutTitle: String
    let aboutVersion: String
    let aboutBody: String
    let iapProTitle: String
    let iapProPrice: String
    let iapProTrialText: String
    let iapProFeatures: String
    let iapSinglePriceLabel: String
    let assistantGreetingGeneral: String
    let assistantGreetingPlanning: String
    let planAlertMessage: String
    let planAlertLinkAttractionId: String?
    let planAlertLinkCityId: String?
    let planAlertLinkLabel: String
    let freeAudioPreviewSeconds: Int

    var iapProFeatureLines: [String] {
        iapProFeatures
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.hasPrefix("•") {
                    return String(trimmed.dropFirst()).trimmingCharacters(in: .whitespaces)
                }
                return trimmed
            }
            .filter { !$0.isEmpty }
    }

}

struct AssistantChip: Identifiable, Codable, Hashable {
    let id: String
    let scenarioId: String
    let label: String
    let sortOrder: Int
}

struct AppSettingsRemote: Codable {
    let useRemoteContent: Bool
    let useRemoteAI: Bool
    let useRemoteIAP: Bool
    let branding: AppBranding?

    var resolvedBranding: AppBranding { branding ?? .fallback }
}

struct AppSettingsRow: Decodable {
    let id: String
    let useRemoteContent: Bool
    let useRemoteAI: Bool
    let useRemoteIAP: Bool
    let supportEmail: String?
    let aboutTitle: String?
    let aboutVersion: String?
    let aboutBody: String?
    let iapProTitle: String?
    let iapProPrice: String?
    let iapProTrialText: String?
    let iapProFeatures: String?
    let iapSinglePriceLabel: String?
    let assistantGreetingGeneral: String?
    let assistantGreetingPlanning: String?
    let planAlertMessage: String?
    let planAlertLinkAttractionId: String?
    let planAlertLinkCityId: String?
    let planAlertLinkLabel: String?
    let freeAudioPreviewSeconds: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case useRemoteContent
        case useRemoteAI
        case useRemoteIAP
        case supportEmail
        case aboutTitle
        case aboutVersion
        case aboutBody
        case iapProTitle
        case iapProPrice
        case iapProTrialText
        case iapProFeatures
        case iapSinglePriceLabel
        case assistantGreetingGeneral
        case assistantGreetingPlanning
        case planAlertMessage
        case planAlertLinkAttractionId
        case planAlertLinkCityId
        case planAlertLinkLabel
        case freeAudioPreviewSeconds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "global"
        useRemoteContent = Self.decodeBool(from: container, forKey: .useRemoteContent)
        useRemoteAI = Self.decodeBool(from: container, forKey: .useRemoteAI)
        useRemoteIAP = Self.decodeBool(from: container, forKey: .useRemoteIAP)
        supportEmail = try container.decodeIfPresent(String.self, forKey: .supportEmail)
        aboutTitle = try container.decodeIfPresent(String.self, forKey: .aboutTitle)
        aboutVersion = try container.decodeIfPresent(String.self, forKey: .aboutVersion)
        aboutBody = try container.decodeIfPresent(String.self, forKey: .aboutBody)
        iapProTitle = try container.decodeIfPresent(String.self, forKey: .iapProTitle)
        iapProPrice = try container.decodeIfPresent(String.self, forKey: .iapProPrice)
        iapProTrialText = try container.decodeIfPresent(String.self, forKey: .iapProTrialText)
        iapProFeatures = try container.decodeIfPresent(String.self, forKey: .iapProFeatures)
        iapSinglePriceLabel = try container.decodeIfPresent(String.self, forKey: .iapSinglePriceLabel)
        assistantGreetingGeneral = try container.decodeIfPresent(String.self, forKey: .assistantGreetingGeneral)
        assistantGreetingPlanning = try container.decodeIfPresent(String.self, forKey: .assistantGreetingPlanning)
        planAlertMessage = try container.decodeIfPresent(String.self, forKey: .planAlertMessage)
        planAlertLinkAttractionId = try container.decodeIfPresent(String.self, forKey: .planAlertLinkAttractionId)
        planAlertLinkCityId = try container.decodeIfPresent(String.self, forKey: .planAlertLinkCityId)
        planAlertLinkLabel = try container.decodeIfPresent(String.self, forKey: .planAlertLinkLabel)
        freeAudioPreviewSeconds = try container.decodeIfPresent(Int.self, forKey: .freeAudioPreviewSeconds)
    }

    private static func decodeBool(
        from container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) -> Bool {
        if let value = try? container.decode(Bool.self, forKey: key) { return value }
        if let value = try? container.decode(Int.self, forKey: key) { return value != 0 }
        if let value = try? container.decode(String.self, forKey: key) {
            switch value.lowercased() {
            case "true", "t", "1", "yes": return true
            default: return false
            }
        }
        return false
    }

    var asSettings: AppSettingsRemote {
        let defaults = AppBranding.fallback
        let branding = AppBranding(
            supportEmail: supportEmail ?? defaults.supportEmail,
            aboutTitle: aboutTitle ?? defaults.aboutTitle,
            aboutVersion: aboutVersion ?? defaults.aboutVersion,
            aboutBody: aboutBody ?? defaults.aboutBody,
            iapProTitle: iapProTitle ?? defaults.iapProTitle,
            iapProPrice: iapProPrice ?? defaults.iapProPrice,
            iapProTrialText: iapProTrialText ?? defaults.iapProTrialText,
            iapProFeatures: iapProFeatures ?? defaults.iapProFeatures,
            iapSinglePriceLabel: iapSinglePriceLabel ?? defaults.iapSinglePriceLabel,
            assistantGreetingGeneral: assistantGreetingGeneral ?? defaults.assistantGreetingGeneral,
            assistantGreetingPlanning: assistantGreetingPlanning ?? defaults.assistantGreetingPlanning,
            planAlertMessage: planAlertMessage ?? defaults.planAlertMessage,
            planAlertLinkAttractionId: planAlertLinkAttractionId ?? defaults.planAlertLinkAttractionId,
            planAlertLinkCityId: planAlertLinkCityId ?? defaults.planAlertLinkCityId,
            planAlertLinkLabel: planAlertLinkLabel ?? defaults.planAlertLinkLabel,
            freeAudioPreviewSeconds: freeAudioPreviewSeconds ?? defaults.freeAudioPreviewSeconds
        )
        return AppSettingsRemote(
            useRemoteContent: useRemoteContent,
            useRemoteAI: useRemoteAI,
            useRemoteIAP: useRemoteIAP,
            branding: branding
        )
    }
}
