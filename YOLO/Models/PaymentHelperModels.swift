import Foundation

// MARK: - Flow node keys (fixed IA in app)

enum PaymentNodeKey: String, CaseIterable, Identifiable, Hashable, Codable {
    case home, q1, q2, q3, plan
    case install, register, bind, verify, use
    case china, trouble, rescue, merchant, card

    var id: String { rawValue }
}

// MARK: - Countries (q1 + sms advice)

struct PaymentCountry: Codable, Identifiable, Hashable {
    let countryCode: String
    let flagEmoji: String?
    let nameZh: String
    let nameEn: String?
    let smsTone: String          // ok | info | warn
    let regMethod: String?       // phone | email
    let smsAdviceZh: String?
    let smsAdviceEn: String?
    let enabled: Bool?
    let optOrder: Int?

    var id: String { countryCode }
}

// MARK: - Cash rules (q3 + cash advice)

struct PaymentCashRule: Codable, Identifiable, Hashable {
    let tripType: String
    let labelZh: String
    let labelEn: String?
    let amountMdZh: String?
    let amountMdEn: String?
    let noteZh: String?
    let noteEn: String?
    let optOrder: Int?

    var id: String { tripType }
}

// MARK: - Flow steps (steps_by_node)

struct PaymentFailReason: Codable, Hashable {
    let reason: String
    let fix: String
}

struct PaymentFlowStep: Codable, Identifiable, Hashable {
    let id: String
    let tool: String?            // alipay | wechat | ""
    let nodeKey: String
    let stepOrder: Int?
    let titleZh: String
    let titleEn: String?
    let instructionMdZh: String?
    let instructionMdEn: String?
    let screenshotUrl: String?
    let failReasons: [PaymentFailReason]?
    let stabilityTier: String?   // stable | volatile

    var isVolatile: Bool { stabilityTier == "volatile" }
}

// MARK: - Rescue ladder

struct PaymentRescueRung: Codable, Identifiable, Hashable {
    let id: String
    let rungOrder: Int?
    let titleZh: String
    let titleEn: String?
    let subtitleZh: String?
    let subtitleEn: String?
    let detailMdZh: String?
    let detailMdEn: String?
    let applies: String?         // always | wx_only
}

// MARK: - Node screen copy

struct PaymentNodeText: Codable, Identifiable, Hashable {
    let id: String
    let nodeKey: String
    let slot: String             // h1 | intro | callout
    let textZh: String
    let textEn: String?
    let tone: String?            // default | jade | blue | warm
    let ord: Int?
}

// MARK: - Legacy advice rules (deprecated; kept for bundled fallback decode)

struct PaymentMatch: Codable, Hashable {
    let country: [String]?
    let cardsExclude: [String]?
    let trip: String?
}

struct PaymentAdviceRule: Codable, Identifiable, Hashable {
    let id: String
    let dimension: String
    let matchJson: PaymentMatch?
    let severity: String
    let bodyEn: String?
    let bodyZh: String?
    let sortOrder: Int?
}

// MARK: - Merchant phrases

struct MerchantPhrase: Codable, Identifiable, Hashable {
    let id: String
    let cn: String
    let en: String?
    let sortOrder: Int?
    let speakable: Bool?
    let audioUrl: String?
}

// MARK: - Card networks + checklist

struct CardNetwork: Codable, Identifiable, Hashable {
    let id: String
    let nameZh: String
    let nameEn: String?
    let alipayOk: Bool
    let wechatOk: Bool
    let note: String?
    let noteZh: String?
    let noteEn: String?
    let sortOrder: Int?

    var displayNoteZh: String? {
        if let n = noteZh, !n.isEmpty { return n }
        if let n = note, !n.isEmpty { return n }
        return nil
    }
}

struct PaymentChecklistItem: Codable, Identifiable, Hashable {
    let id: String
    let itemOrder: Int?
    let labelZh: String
    let labelEn: String?
    let weight: Int
    let condition: String?
}

struct PaymentHelperLink: Codable, Identifiable, Hashable {
    let id: String
    let labelEn: String?
    let labelZh: String?
    let url: String
    let lane: String?
    let sortOrder: Int?
}

struct PaymentArticle: Codable, Identifiable, Hashable {
    let id: String
    let nodeKey: String
    let titleZh: String
    let titleEn: String?
    let bodyMdZh: String?
    let bodyMdEn: String?
    let displayOrder: Int?
}

// MARK: - Content bundle

struct PaymentHelperContent: Codable, Equatable {
    var countries: [PaymentCountry]
    var cashRules: [PaymentCashRule]
    var flowSteps: [PaymentFlowStep]
    var rescueRungs: [PaymentRescueRung]
    var nodeTexts: [PaymentNodeText]
    var adviceRules: [PaymentAdviceRule]
    var merchantPhrases: [MerchantPhrase]
    var links: [PaymentHelperLink]
    var cardNetworks: [CardNetwork]
    var checklistItems: [PaymentChecklistItem]
    var articles: [PaymentArticle]

    static let empty = PaymentHelperContent(
        countries: [], cashRules: [], flowSteps: [], rescueRungs: [], nodeTexts: [],
        adviceRules: [], merchantPhrases: [], links: [], cardNetworks: [],
        checklistItems: [], articles: []
    )
}

// MARK: - User inputs

enum PaymentLane: String, CaseIterable, Identifiable {
    case prep, china, rescue
    var id: String { rawValue }
}

enum TripKind: String, CaseIterable, Identifiable {
    case city, both, remote, family
    var id: String { rawValue }
    var label: String {
        switch self {
        case .city: return "Major cities mainly"
        case .both: return "Cities & countryside"
        case .remote: return "Mostly rural / remote areas"
        case .family: return "Family trip / with elders & kids"
        }
    }
}

// MARK: - Advice result (for plan screen)

struct PaymentAdviceResult {
    let tone: String   // ok | warn | info
    let bodyZh: String
    let bodyEn: String?
}
