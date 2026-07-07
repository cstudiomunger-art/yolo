import Foundation

// MARK: - Merchant phrases (optional CMS)

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
}

struct PaymentHelperContent: Codable, Equatable {
    var merchantPhrases: [MerchantPhrase]

    static let empty = PaymentHelperContent(merchantPhrases: [])
}
