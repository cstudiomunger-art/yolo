import Foundation

struct TransportTip: Codable, Identifiable, Hashable {
    let id: String
    let category: String         // "rail" | "taxi" | "metro"
    let titleEn: String?
    let titleZh: String?
    let bodyEn: String?
    let bodyZh: String?
    let cityId: String?
    let sortOrder: Int?
}

struct CommonPhrase: Codable, Identifiable, Hashable {
    let id: String
    let cn: String
    let pinyin: String?
    let en: String?
    let audioUrl: String?
    let sortOrder: Int?
}

struct DialectPhrase: Codable, Identifiable, Hashable {
    let id: String
    let dialect: String
    let emoji: String?
    let cn: String
    let pinyin: String?
    let en: String?
    let audioUrl: String?
    let sortOrder: Int?
}

struct InfoHubContent: Codable, Equatable {
    var transport: [TransportTip]
    var common: [CommonPhrase]
    var dialect: [DialectPhrase]

    static let empty = InfoHubContent(transport: [], common: [], dialect: [])
}
