import Foundation

/// Match condition for a payment advice rule (decoded from the `match_json` jsonb).
struct PaymentMatch: Codable, Hashable {
    let country: [String]?
    let cardsExclude: [String]?
    let trip: String?
}

/// One piece of tailored advice (注册短信 / 绑卡策略 / 现金) — CMS copy, app-side matching.
struct PaymentAdviceRule: Codable, Identifiable, Hashable {
    let id: String
    let dimension: String          // "sms" | "card" | "cash"
    let matchJson: PaymentMatch?
    let severity: String           // "ok" | "warn" | "info"
    let bodyEn: String?
    let bodyZh: String?
    let sortOrder: Int?
}

struct MerchantPhrase: Codable, Identifiable, Hashable {
    let id: String
    let cn: String
    let en: String?
    let sortOrder: Int?
}

/// One card organization in the receivability matrix (drives WeChat-binding pruning).
/// Data-driven per the folder spec — ops edit the table, no app release needed.
struct CardNetwork: Codable, Identifiable, Hashable {
    let id: String              // 'visa' | 'mc' | 'jcb' | 'amex' | 'unionpay' | 'diners' | 'discover'
    let nameZh: String
    let nameEn: String?
    let alipayOk: Bool
    let wechatOk: Bool
    let note: String?
    let sortOrder: Int?
}

/// One row of the "随身支付卡" readiness checklist.
/// `condition == nil` → always counts as done; `"has_wechat"` → done only when a
/// WeChat-capable card is selected. Readiness % = sum(done weights) / sum(weights).
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

/// Bundle of payment-helper CMS content (fetched + cached, or in-code bundled).
struct PaymentHelperContent: Codable, Equatable {
    var adviceRules: [PaymentAdviceRule]
    var merchantPhrases: [MerchantPhrase]
    var links: [PaymentHelperLink]
    var cardNetworks: [CardNetwork]
    var checklistItems: [PaymentChecklistItem]

    static let empty = PaymentHelperContent(adviceRules: [], merchantPhrases: [], links: [], cardNetworks: [], checklistItems: [])
}

/// The three situations the helper branches on.
enum PaymentLane: String, CaseIterable, Identifiable {
    case prep, china, rescue
    var id: String { rawValue }
}

enum TripKind: String, CaseIterable, Identifiable {
    case city, both, remote
    var id: String { rawValue }
    var label: String {
        switch self {
        case .city: return "大城市为主"
        case .both: return "城市 + 乡村都去"
        case .remote: return "主要去乡村 / 偏远"
        }
    }
}
