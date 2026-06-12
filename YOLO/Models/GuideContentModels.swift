import Foundation

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

struct HotelBookingLink: Codable, Hashable, Identifiable {
    var id: String { url }
    let label: String
    let url: String
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
    let coverImagePath: String?
    let addressZh: String?
    let addressEn: String?
    let latitude: Double?
    let longitude: Double?
    let bookingPlatforms: [String]
    let bookingLinks: [HotelBookingLink]
    let acceptsForeigners: Bool

    var displayAddressLine: String? {
        let zh = addressZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let en = addressEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !zh.isEmpty, !en.isEmpty, zh != en { return "\(en) · \(zh)" }
        if !en.isEmpty { return en }
        if !zh.isEmpty { return zh }
        return nil
    }

    var canOpenInMaps: Bool {
        if latitude != nil, longitude != nil { return true }
        let zh = addressZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let en = addressEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return !zh.isEmpty || !en.isEmpty
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        cityId = try c.decode(String.self, forKey: .cityId)
        name = try c.decode(String.self, forKey: .name)
        chineseName = try c.decode(String.self, forKey: .chineseName)
        stars = try c.decodeIfPresent(Int.self, forKey: .stars) ?? 3
        priceMinUsd = try c.decodeIfPresent(Int.self, forKey: .priceMinUsd) ?? 0
        hasEnglishStaff = try c.decodeIfPresent(Bool.self, forKey: .hasEnglishStaff) ?? false
        englishStaffNote = try c.decodeIfPresent(String.self, forKey: .englishStaffNote)
        languageTip = try c.decodeIfPresent(String.self, forKey: .languageTip)
        locationNote = try c.decodeIfPresent(String.self, forKey: .locationNote)
        coverImagePath = try c.decodeIfPresent(String.self, forKey: .coverImagePath)
        addressZh = try c.decodeIfPresent(String.self, forKey: .addressZh)
        addressEn = try c.decodeIfPresent(String.self, forKey: .addressEn)
        latitude = try c.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try c.decodeIfPresent(Double.self, forKey: .longitude)
        bookingPlatforms = (try? c.decode([String].self, forKey: .bookingPlatforms)) ?? []
        acceptsForeigners = try c.decodeIfPresent(Bool.self, forKey: .acceptsForeigners) ?? true
        if let links = try? c.decode([HotelBookingLink].self, forKey: .bookingLinks), !links.isEmpty {
            bookingLinks = links
        } else {
            bookingLinks = bookingPlatforms.map {
                HotelBookingLink(label: $0, url: "https://www.booking.com")
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, cityId, name, chineseName, stars, priceMinUsd, hasEnglishStaff
        case englishStaffNote, languageTip, locationNote, coverImagePath
        case addressZh, addressEn, latitude, longitude
        case bookingPlatforms, bookingLinks, acceptsForeigners
    }
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

enum CultureTipCategory: String, Codable, CaseIterable, Identifiable {
    case food
    case payments
    case temple
    case transport
    case social
    case festivals

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .food: "🍜"
        case .payments: "💰"
        case .temple: "🏯"
        case .transport: "🚇"
        case .social: "🤝"
        case .festivals: "🎆"
        }
    }

    var title: String {
        switch self {
        case .food: "Food & Dining"
        case .payments: "Payments & Money"
        case .temple: "Temple & Sacred Sites"
        case .transport: "Transportation"
        case .social: "Social Etiquette"
        case .festivals: "Festivals & Holidays"
        }
    }
}

struct CultureTip: Identifiable, Codable, Hashable {
    let id: String
    let emoji: String
    let title: String
    let preview: String
    let body: String
    let category: CultureTipCategory
    let doText: String?
    let dontText: String?
    let cityId: String?

    init(
        id: String,
        emoji: String,
        title: String,
        preview: String,
        body: String,
        category: CultureTipCategory = .social,
        doText: String? = nil,
        dontText: String? = nil,
        cityId: String? = nil
    ) {
        self.id = id
        self.emoji = emoji
        self.title = title
        self.preview = preview
        self.body = body
        self.category = category
        self.doText = doText
        self.dontText = dontText
        self.cityId = cityId
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        emoji = try c.decodeIfPresent(String.self, forKey: .emoji) ?? "💡"
        title = try c.decode(String.self, forKey: .title)
        preview = try c.decode(String.self, forKey: .preview)
        body = try c.decode(String.self, forKey: .body)
        if let raw = try c.decodeIfPresent(String.self, forKey: .category),
           let parsed = CultureTipCategory(rawValue: raw) {
            category = parsed
        } else {
            category = .social
        }
        doText = try c.decodeIfPresent(String.self, forKey: .doText)
        dontText = try c.decodeIfPresent(String.self, forKey: .dontText)
        cityId = try c.decodeIfPresent(String.self, forKey: .cityId)
    }

    private enum CodingKeys: String, CodingKey {
        case id, emoji, title, preview, body, category
        case doText, dontText, cityId
    }
}
