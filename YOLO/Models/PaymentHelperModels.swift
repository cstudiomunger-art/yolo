import Foundation

// MARK: - Merchant phrases

struct MerchantPhrase: Codable, Identifiable, Hashable {
    let id: String
    let cn: String
    let en: String?
    let sortOrder: Int?
    let speakable: Bool?
    let audioUrl: String?
}

// MARK: - Checklist

struct PaymentChecklistItem: Codable, Identifiable, Hashable {
    let id: String
    let itemOrder: Int?
    let labelZh: String
    let labelEn: String?
    let weight: Int?
    let condition: String?
}

// MARK: - Flow steps

struct PaymentFailReasonRow: Codable, Hashable {
    let reason: String
    let fix: String
}

struct PaymentFlowStep: Codable, Identifiable, Hashable {
    let id: String
    let nodeKey: String
    let tool: String?
    let stepOrder: Int?
    let titleZh: String?
    let titleEn: String?
    let instructionMdZh: String?
    let instructionMdEn: String?
    let screenshotUrl: String?
    let failReasons: [PaymentFailReasonRow]?
    let stabilityTier: String?
}

// MARK: - Cash rules

struct PaymentCashRule: Codable, Identifiable, Hashable {
    let tripType: String
    let labelZh: String?
    let labelEn: String?
    let amountMdZh: String?
    let amountMdEn: String?
    let noteZh: String?
    let noteEn: String?
    let optOrder: Int?

    var id: String { tripType }
}

// MARK: - Rescue rungs

struct PaymentRescueRung: Codable, Identifiable, Hashable {
    let id: String
    let rungOrder: Int?
    let titleZh: String?
    let titleEn: String?
    let subtitleZh: String?
    let subtitleEn: String?
    let detailMdZh: String?
    let detailMdEn: String?
    let applies: String?
}

// MARK: - Articles

struct PaymentArticle: Codable, Identifiable, Hashable {
    let id: String
    let nodeKey: String
    let titleZh: String?
    let titleEn: String?
    let bodyMdZh: String?
    let bodyMdEn: String?
    let displayOrder: Int?
    let isPublished: Bool?
}

// MARK: - Node screen copy

struct PaymentNodeText: Codable, Identifiable, Hashable {
    let id: String
    let nodeKey: String
    let slot: String
    let textZh: String?
    let textEn: String?
    let tone: String?
    let ord: Int?
}

// MARK: - Countries (q1)

struct PaymentCountry: Codable, Identifiable, Hashable {
    let countryCode: String
    let flagEmoji: String?
    let nameZh: String?
    let nameEn: String?
    let smsTone: String?
    let regMethod: String?
    let smsAdviceZh: String?
    let smsAdviceEn: String?
    let enabled: Bool?
    let optOrder: Int?

    var id: String { countryCode }
}

// MARK: - Card networks (q2)

struct PaymentCardNetwork: Codable, Identifiable, Hashable {
    let id: String
    let nameZh: String?
    let nameEn: String?
    let alipayOk: Bool?
    let wechatOk: Bool?
    let noteZh: String?
    let noteEn: String?
    let sortOrder: Int?
}

// MARK: - Helper links

struct PaymentHelperLink: Codable, Identifiable, Hashable {
    let id: String
    let labelZh: String?
    let labelEn: String?
    let url: String
    let lane: String
    let sortOrder: Int?
}

// MARK: - Bundle

struct PaymentHelperContent: Codable, Equatable {
    var merchantPhrases: [MerchantPhrase]
    var flowSteps: [PaymentFlowStep]
    var cashRules: [PaymentCashRule]
    var rescueRungs: [PaymentRescueRung]
    var articles: [PaymentArticle]
    var nodeTexts: [PaymentNodeText]
    var checklistItems: [PaymentChecklistItem]
    var countries: [PaymentCountry]
    var cardNetworks: [PaymentCardNetwork]
    var helperLinks: [PaymentHelperLink]

    static let empty = PaymentHelperContent(
        merchantPhrases: [],
        flowSteps: [],
        cashRules: [],
        rescueRungs: [],
        articles: [],
        nodeTexts: [],
        checklistItems: [],
        countries: [],
        cardNetworks: [],
        helperLinks: []
    )
}
