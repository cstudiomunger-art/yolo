import Foundation

struct FlightPlatform: Codable, Hashable, Identifiable {
    let id: String
    let label: String
    let urlTemplate: String
}

struct PaywallCopy: Codable, Equatable, Hashable {
    let previewLineTemplate: String
    let restore: String
    let footnote: String

    static let fallback = PaywallCopy(
        previewLineTemplate: "{duration} min · Literary narrative",
        restore: "Restore Purchase",
        footnote: "Prices shown in your local currency. Subscriptions renew automatically unless cancelled."
    )

    func previewLine(duration: String) -> String {
        previewLineTemplate.replacingOccurrences(of: "{duration}", with: duration)
    }
}

struct AppBranding: Codable, Equatable {
    static let fallback = AppBranding(
        supportEmail: "support@yolohappy.app",
        aboutTitle: "YOLO HAPPY",
        aboutVersion: "1.0.0",
        aboutBody: "Your companion for planning and experiencing travel in China.",
        assistantGreetingGeneral: "Good morning. How can I assist with your China trip today?",
        assistantGreetingPlanning: "Hi! I'm building your itinerary. Tell me: how many days, interests, and budget?",
        planAlertMessage: "",
        planAlertLinkAttractionId: nil,
        planAlertLinkCityId: nil,
        planAlertLinkLabel: "How to Book →",
        freeAudioPreviewSeconds: 180,
        paywall: .fallback,
        flightPlatforms: [
            FlightPlatform(id: "skyscanner", label: "Skyscanner", urlTemplate: "https://www.skyscanner.com/"),
            FlightPlatform(id: "google_flights", label: "Google Flights", urlTemplate: "https://www.google.com/travel/flights"),
            FlightPlatform(id: "trip", label: "Trip.com", urlTemplate: "https://www.trip.com/flights/"),
            FlightPlatform(id: "kayak", label: "Kayak", urlTemplate: "https://www.kayak.com/flights/"),
        ],
        privacyPolicyBody: "",
        termsOfServiceBody: "",
        gdprComplianceBody: "",
        aiContentDisclosureBody: "",
        shareWebBaseURL: "https://yolo.cstudiomunger.workers.dev"
    )

    let supportEmail: String
    let aboutTitle: String
    let aboutVersion: String
    let aboutBody: String
    let assistantGreetingGeneral: String
    let assistantGreetingPlanning: String
    let planAlertMessage: String
    let planAlertLinkAttractionId: String?
    let planAlertLinkCityId: String?
    let planAlertLinkLabel: String
    let freeAudioPreviewSeconds: Int
    let freeTextPreviewChars: Int
    let freeVisitorTipsCount: Int
    let paywall: PaywallCopy
    let flightPlatforms: [FlightPlatform]
    let privacyPolicyBody: String
    let termsOfServiceBody: String
    let gdprComplianceBody: String
    let aiContentDisclosureBody: String
    let shareWebBaseURL: String

    init(
        supportEmail: String,
        aboutTitle: String,
        aboutVersion: String,
        aboutBody: String,
        assistantGreetingGeneral: String,
        assistantGreetingPlanning: String,
        planAlertMessage: String,
        planAlertLinkAttractionId: String?,
        planAlertLinkCityId: String?,
        planAlertLinkLabel: String,
        freeAudioPreviewSeconds: Int,
        freeTextPreviewChars: Int = 80,
        freeVisitorTipsCount: Int = 1,
        paywall: PaywallCopy = .fallback,
        flightPlatforms: [FlightPlatform] = AppBranding.fallback.flightPlatforms,
        privacyPolicyBody: String = "",
        termsOfServiceBody: String = "",
        gdprComplianceBody: String = "",
        aiContentDisclosureBody: String = "",
        shareWebBaseURL: String = "https://yolo.cstudiomunger.workers.dev"
    ) {
        self.supportEmail = supportEmail
        self.aboutTitle = aboutTitle
        self.aboutVersion = aboutVersion
        self.aboutBody = aboutBody
        self.assistantGreetingGeneral = assistantGreetingGeneral
        self.assistantGreetingPlanning = assistantGreetingPlanning
        self.planAlertMessage = planAlertMessage
        self.planAlertLinkAttractionId = planAlertLinkAttractionId
        self.planAlertLinkCityId = planAlertLinkCityId
        self.planAlertLinkLabel = planAlertLinkLabel
        self.freeAudioPreviewSeconds = freeAudioPreviewSeconds
        self.freeTextPreviewChars = freeTextPreviewChars
        self.freeVisitorTipsCount = freeVisitorTipsCount
        self.paywall = paywall
        self.flightPlatforms = flightPlatforms
        self.privacyPolicyBody = privacyPolicyBody
        self.termsOfServiceBody = termsOfServiceBody
        self.gdprComplianceBody = gdprComplianceBody
        self.aiContentDisclosureBody = aiContentDisclosureBody
        self.shareWebBaseURL = shareWebBaseURL
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        supportEmail = try c.decode(String.self, forKey: .supportEmail)
        aboutTitle = try c.decode(String.self, forKey: .aboutTitle)
        aboutVersion = try c.decode(String.self, forKey: .aboutVersion)
        aboutBody = try c.decode(String.self, forKey: .aboutBody)
        assistantGreetingGeneral = try c.decode(String.self, forKey: .assistantGreetingGeneral)
        assistantGreetingPlanning = try c.decode(String.self, forKey: .assistantGreetingPlanning)
        planAlertMessage = try c.decodeIfPresent(String.self, forKey: .planAlertMessage) ?? ""
        planAlertLinkAttractionId = try c.decodeIfPresent(String.self, forKey: .planAlertLinkAttractionId)
        planAlertLinkCityId = try c.decodeIfPresent(String.self, forKey: .planAlertLinkCityId)
        planAlertLinkLabel = try c.decodeIfPresent(String.self, forKey: .planAlertLinkLabel) ?? "How to Book →"
        freeAudioPreviewSeconds = try c.decodeIfPresent(Int.self, forKey: .freeAudioPreviewSeconds) ?? 180
        freeTextPreviewChars = try c.decodeIfPresent(Int.self, forKey: .freeTextPreviewChars) ?? 80
        freeVisitorTipsCount = try c.decodeIfPresent(Int.self, forKey: .freeVisitorTipsCount) ?? 1
        paywall = (try? c.decode(PaywallCopy.self, forKey: .paywall)) ?? .fallback
        flightPlatforms = (try? c.decode([FlightPlatform].self, forKey: .flightPlatforms)) ?? Self.fallback.flightPlatforms
        privacyPolicyBody = try c.decodeIfPresent(String.self, forKey: .privacyPolicyBody) ?? ""
        termsOfServiceBody = try c.decodeIfPresent(String.self, forKey: .termsOfServiceBody) ?? ""
        gdprComplianceBody = try c.decodeIfPresent(String.self, forKey: .gdprComplianceBody) ?? ""
        aiContentDisclosureBody = try c.decodeIfPresent(String.self, forKey: .aiContentDisclosureBody) ?? ""
        shareWebBaseURL = try c.decodeIfPresent(String.self, forKey: .shareWebBaseURL) ?? Self.fallback.shareWebBaseURL
    }

    private enum CodingKeys: String, CodingKey {
        case supportEmail, aboutTitle, aboutVersion, aboutBody
        case assistantGreetingGeneral, assistantGreetingPlanning
        case planAlertMessage, planAlertLinkAttractionId, planAlertLinkCityId, planAlertLinkLabel
        case freeAudioPreviewSeconds, freeTextPreviewChars, freeVisitorTipsCount, paywall, flightPlatforms
        case privacyPolicyBody, termsOfServiceBody, gdprComplianceBody, aiContentDisclosureBody, shareWebBaseURL
    }

}

struct AISettings: Codable, Hashable {
    let modelId: String?
    let chatApiUrl: String
    let chatMaxTokens: Int
    let itineraryMaxTokens: Int
    let temperature: Double
    let timeoutMs: Int
    let systemPromptAssistant: String?
    let systemPromptItinerary: String?

    static let fallback = AISettings(
        modelId: nil,
        chatApiUrl: "https://ark.cn-beijing.volces.com/api/v3/chat/completions",
        chatMaxTokens: 450,
        itineraryMaxTokens: 1200,
        temperature: 0.7,
        timeoutMs: 20_000,
        systemPromptAssistant: nil,
        systemPromptItinerary: nil
    )
}

struct AppSettingsRemote: Codable {
    let useRemoteContent: Bool
    /// Matches JSON key `use_remote_ai` under `convertFromSnakeCase` (→ `useRemoteAi`).
    let useRemoteAi: Bool
    let useRemoteIap: Bool
    let branding: AppBranding?
    let ai: AISettings?

    var useRemoteAI: Bool { useRemoteAi }
    var useRemoteIAP: Bool { useRemoteIap }

    var resolvedBranding: AppBranding { branding ?? .fallback }
    var resolvedAI: AISettings { ai ?? .fallback }

    enum CodingKeys: String, CodingKey {
        case useRemoteContent
        case useRemoteAi
        case useRemoteIap
        case branding
        case ai
    }
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
    let assistantGreetingGeneral: String?
    let assistantGreetingPlanning: String?
    let planAlertMessage: String?
    let planAlertLinkAttractionId: String?
    let planAlertLinkCityId: String?
    let planAlertLinkLabel: String?
    let freeAudioPreviewSeconds: Int?
    let freeTextPreviewChars: Int?
    let freeVisitorTipsCount: Int?
    let aiModelId: String?
    let aiChatApiUrl: String?
    let aiChatMaxTokens: Int?
    let aiItineraryMaxTokens: Int?
    let aiTemperature: Double?
    let aiTimeoutMs: Int?
    let aiSystemPromptAssistant: String?
    let aiSystemPromptItinerary: String?
    let paywallPreviewLineTemplate: String?
    let paywallRestore: String?
    let paywallFootnote: String?
    let flightPlatforms: [FlightPlatform]?
    let privacyPolicyBody: String?
    let termsOfServiceBody: String?
    let gdprComplianceBody: String?
    let aiContentDisclosureBody: String?
    let shareWebBaseURL: String?

    // Keys are camelCase; JSONDecoder.convertFromSnakeCase maps use_remote_ai → useRemoteAI.
    enum CodingKeys: String, CodingKey {
        case id
        case useRemoteContent
        // `convertFromSnakeCase` maps use_remote_ai → "useRemoteAi" / use_remote_iap → "useRemoteIap"
        // (only the first letter of each component is capitalised). The raw values must match those
        // forms exactly, otherwise the keys never resolve and the flags silently decode to false.
        case useRemoteAI = "useRemoteAi"
        case useRemoteIAP = "useRemoteIap"
        case supportEmail
        case aboutTitle
        case aboutVersion
        case aboutBody
        case assistantGreetingGeneral
        case assistantGreetingPlanning
        case planAlertMessage
        case planAlertLinkAttractionId
        case planAlertLinkCityId
        case planAlertLinkLabel
        case freeAudioPreviewSeconds
        case freeTextPreviewChars
        case freeVisitorTipsCount
        case aiModelId
        case aiChatApiUrl
        case aiChatMaxTokens
        case aiItineraryMaxTokens
        case aiTemperature
        case aiTimeoutMs
        case aiSystemPromptAssistant
        case aiSystemPromptItinerary
        case paywallPreviewLineTemplate
        case paywallRestore
        case paywallFootnote
        case flightPlatforms
        case privacyPolicyBody
        case termsOfServiceBody
        case gdprComplianceBody
        case aiContentDisclosureBody
        case shareWebBaseURL
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
        assistantGreetingGeneral = try container.decodeIfPresent(String.self, forKey: .assistantGreetingGeneral)
        assistantGreetingPlanning = try container.decodeIfPresent(String.self, forKey: .assistantGreetingPlanning)
        planAlertMessage = try container.decodeIfPresent(String.self, forKey: .planAlertMessage)
        planAlertLinkAttractionId = try container.decodeIfPresent(String.self, forKey: .planAlertLinkAttractionId)
        planAlertLinkCityId = try container.decodeIfPresent(String.self, forKey: .planAlertLinkCityId)
        planAlertLinkLabel = try container.decodeIfPresent(String.self, forKey: .planAlertLinkLabel)
        freeAudioPreviewSeconds = try container.decodeIfPresent(Int.self, forKey: .freeAudioPreviewSeconds)
        freeTextPreviewChars = try container.decodeIfPresent(Int.self, forKey: .freeTextPreviewChars)
        freeVisitorTipsCount = try container.decodeIfPresent(Int.self, forKey: .freeVisitorTipsCount)
        aiModelId = try container.decodeIfPresent(String.self, forKey: .aiModelId)
        aiChatApiUrl = try container.decodeIfPresent(String.self, forKey: .aiChatApiUrl)
        aiChatMaxTokens = try container.decodeIfPresent(Int.self, forKey: .aiChatMaxTokens)
        aiItineraryMaxTokens = try container.decodeIfPresent(Int.self, forKey: .aiItineraryMaxTokens)
        aiTemperature = try container.decodeIfPresent(Double.self, forKey: .aiTemperature)
        aiTimeoutMs = try container.decodeIfPresent(Int.self, forKey: .aiTimeoutMs)
        aiSystemPromptAssistant = try container.decodeIfPresent(String.self, forKey: .aiSystemPromptAssistant)
        aiSystemPromptItinerary = try container.decodeIfPresent(String.self, forKey: .aiSystemPromptItinerary)
        paywallPreviewLineTemplate = try container.decodeIfPresent(String.self, forKey: .paywallPreviewLineTemplate)
        paywallRestore = try container.decodeIfPresent(String.self, forKey: .paywallRestore)
        paywallFootnote = try container.decodeIfPresent(String.self, forKey: .paywallFootnote)
        flightPlatforms = try container.decodeIfPresent([FlightPlatform].self, forKey: .flightPlatforms)
        privacyPolicyBody = try container.decodeIfPresent(String.self, forKey: .privacyPolicyBody)
        termsOfServiceBody = try container.decodeIfPresent(String.self, forKey: .termsOfServiceBody)
        gdprComplianceBody = try container.decodeIfPresent(String.self, forKey: .gdprComplianceBody)
        aiContentDisclosureBody = try container.decodeIfPresent(String.self, forKey: .aiContentDisclosureBody)
        shareWebBaseURL = try container.decodeIfPresent(String.self, forKey: .shareWebBaseURL)
    }

    private static func decodeBool(
        from container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) -> Bool {
        for candidate in boolKeyCandidates(for: key) {
            if let value = try? container.decode(Bool.self, forKey: candidate) { return value }
            if let value = try? container.decode(Int.self, forKey: candidate) { return value != 0 }
            if let value = try? container.decode(String.self, forKey: candidate) {
                switch value.lowercased() {
                case "true", "t", "1", "yes": return true
                default: continue
                }
            }
        }
        return false
    }

    /// Key resolution is handled by the CodingKeys raw values (aligned with `convertFromSnakeCase`);
    /// this just lets `decodeBool` try the one canonical key with bool/int/string tolerance.
    private static func boolKeyCandidates(for key: CodingKeys) -> [CodingKeys] {
        [key]
    }

    var asSettings: AppSettingsRemote {
        let defaults = AppBranding.fallback
        let paywallDefaults = PaywallCopy.fallback
        let paywall = PaywallCopy(
            previewLineTemplate: paywallPreviewLineTemplate ?? paywallDefaults.previewLineTemplate,
            restore: paywallRestore ?? paywallDefaults.restore,
            footnote: paywallFootnote ?? paywallDefaults.footnote
        )
        let branding = AppBranding(
            supportEmail: supportEmail ?? defaults.supportEmail,
            aboutTitle: aboutTitle ?? defaults.aboutTitle,
            aboutVersion: aboutVersion ?? defaults.aboutVersion,
            aboutBody: aboutBody ?? defaults.aboutBody,
            assistantGreetingGeneral: assistantGreetingGeneral ?? defaults.assistantGreetingGeneral,
            assistantGreetingPlanning: assistantGreetingPlanning ?? defaults.assistantGreetingPlanning,
            planAlertMessage: planAlertMessage ?? defaults.planAlertMessage,
            planAlertLinkAttractionId: planAlertLinkAttractionId ?? defaults.planAlertLinkAttractionId,
            planAlertLinkCityId: planAlertLinkCityId ?? defaults.planAlertLinkCityId,
            planAlertLinkLabel: planAlertLinkLabel ?? defaults.planAlertLinkLabel,
            freeAudioPreviewSeconds: freeAudioPreviewSeconds ?? defaults.freeAudioPreviewSeconds,
            freeTextPreviewChars: freeTextPreviewChars ?? defaults.freeTextPreviewChars,
            freeVisitorTipsCount: freeVisitorTipsCount ?? defaults.freeVisitorTipsCount,
            paywall: paywall,
            flightPlatforms: flightPlatforms ?? defaults.flightPlatforms,
            privacyPolicyBody: privacyPolicyBody ?? defaults.privacyPolicyBody,
            termsOfServiceBody: termsOfServiceBody ?? defaults.termsOfServiceBody,
            gdprComplianceBody: gdprComplianceBody ?? defaults.gdprComplianceBody,
            aiContentDisclosureBody: aiContentDisclosureBody ?? defaults.aiContentDisclosureBody,
            shareWebBaseURL: shareWebBaseURL ?? defaults.shareWebBaseURL
        )
        let aiDefaults = AISettings.fallback
        let ai = AISettings(
            modelId: aiModelId,
            chatApiUrl: aiChatApiUrl ?? aiDefaults.chatApiUrl,
            chatMaxTokens: aiChatMaxTokens ?? aiDefaults.chatMaxTokens,
            itineraryMaxTokens: aiItineraryMaxTokens ?? aiDefaults.itineraryMaxTokens,
            temperature: aiTemperature ?? aiDefaults.temperature,
            timeoutMs: aiTimeoutMs ?? aiDefaults.timeoutMs,
            systemPromptAssistant: aiSystemPromptAssistant,
            systemPromptItinerary: aiSystemPromptItinerary
        )
        return AppSettingsRemote(
            useRemoteContent: useRemoteContent,
            useRemoteAi: useRemoteAI,
            useRemoteIap: useRemoteIAP,
            branding: branding,
            ai: ai
        )
    }
}
