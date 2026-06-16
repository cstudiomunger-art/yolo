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

    static let empty = PaymentHelperContent(adviceRules: [], merchantPhrases: [], links: [])
}

/// The three situations the helper branches on.
enum PaymentLane: String, CaseIterable, Identifiable {
    case prep, china, rescue
    var id: String { rawValue }
}

/// Card organizations the user can hold (drives the WeChat-binding pruning).
enum CardOrg: String, CaseIterable, Identifiable {
    case visa, mc, jcb, unionpay, amex
    var id: String { rawValue }
    var label: String {
        switch self {
        case .visa: return "Visa"
        case .mc: return "Mastercard"
        case .jcb: return "JCB"
        case .unionpay: return "银联 UnionPay"
        case .amex: return "Amex"
        }
    }
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
