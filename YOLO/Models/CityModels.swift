import Foundation

struct City: Identifiable, Hashable, Codable {
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

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        chineseName = try c.decode(String.self, forKey: .chineseName)
        emoji = try c.decodeIfPresent(String.self, forKey: .emoji)
        coverImagePath = try c.decodeIfPresent(String.self, forKey: .coverImagePath)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        bestFor = (try? c.decode([String].self, forKey: .bestFor)) ?? []
        seasonNote = try c.decodeIfPresent(String.self, forKey: .seasonNote)
        bestTimeToVisit = try c.decodeIfPresent(String.self, forKey: .bestTimeToVisit)
        avgDaysRecommended = try c.decodeIfPresent(Int.self, forKey: .avgDaysRecommended)
        attractionCount = try c.decodeIfPresent(Int.self, forKey: .attractionCount) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(chineseName, forKey: .chineseName)
        try c.encodeIfPresent(emoji, forKey: .emoji)
        try c.encodeIfPresent(coverImagePath, forKey: .coverImagePath)
        try c.encodeIfPresent(description, forKey: .description)
        try c.encode(bestFor, forKey: .bestFor)
        try c.encodeIfPresent(seasonNote, forKey: .seasonNote)
        try c.encodeIfPresent(bestTimeToVisit, forKey: .bestTimeToVisit)
        try c.encodeIfPresent(avgDaysRecommended, forKey: .avgDaysRecommended)
        try c.encode(attractionCount, forKey: .attractionCount)
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, chineseName, emoji, coverImagePath, description, bestFor
        case seasonNote, bestTimeToVisit, avgDaysRecommended, attractionCount
    }
}

struct CityRoute: Identifiable, Codable {
    let id: String
    let cityId: String
    let title: String
    let days: Int
    let summary: String
    let sortOrder: Int
}

struct CityGuide: Identifiable, Hashable, Codable {
    let id: String
    let cityId: String
    let titleEn: String
    let titleZh: String?
    let subtitle: String?
    let icon: String?
    let badge: String?
    let coverImages: [String]
    let body: String?
    let audioUrl: String?
    let audioTitle: String?
    let audioDurationSeconds: Int
    let audioQuote: String?
    let audioTranscript: String?
    let metaItems: [PracticalInfoItem]
    let displayOrder: Int

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        cityId = try c.decode(String.self, forKey: .cityId)
        titleEn = try c.decode(String.self, forKey: .titleEn)
        titleZh = try c.decodeIfPresent(String.self, forKey: .titleZh)
        subtitle = try c.decodeIfPresent(String.self, forKey: .subtitle)
        icon = try c.decodeIfPresent(String.self, forKey: .icon)
        badge = try c.decodeIfPresent(String.self, forKey: .badge)
        coverImages = try c.decodeIfPresent([String].self, forKey: .coverImages) ?? []
        body = try c.decodeIfPresent(String.self, forKey: .body)
        audioUrl = try c.decodeIfPresent(String.self, forKey: .audioUrl)
        audioTitle = try c.decodeIfPresent(String.self, forKey: .audioTitle)
        audioDurationSeconds = try c.decodeIfPresent(Int.self, forKey: .audioDurationSeconds) ?? 0
        audioQuote = try c.decodeIfPresent(String.self, forKey: .audioQuote)
        audioTranscript = try c.decodeIfPresent(String.self, forKey: .audioTranscript)
        if let items = try c.decodeIfPresent([PracticalInfoItem].self, forKey: .metaItems), !items.isEmpty {
            metaItems = items
        } else {
            metaItems = Self.legacyMetaItems(from: c)
        }
        displayOrder = try c.decodeIfPresent(Int.self, forKey: .displayOrder) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(cityId, forKey: .cityId)
        try c.encode(titleEn, forKey: .titleEn)
        try c.encodeIfPresent(titleZh, forKey: .titleZh)
        try c.encodeIfPresent(subtitle, forKey: .subtitle)
        try c.encodeIfPresent(icon, forKey: .icon)
        try c.encodeIfPresent(badge, forKey: .badge)
        try c.encode(coverImages, forKey: .coverImages)
        try c.encodeIfPresent(body, forKey: .body)
        try c.encodeIfPresent(audioUrl, forKey: .audioUrl)
        try c.encodeIfPresent(audioTitle, forKey: .audioTitle)
        try c.encode(audioDurationSeconds, forKey: .audioDurationSeconds)
        try c.encodeIfPresent(audioQuote, forKey: .audioQuote)
        try c.encodeIfPresent(audioTranscript, forKey: .audioTranscript)
        try c.encode(metaItems, forKey: .metaItems)
        try c.encode(displayOrder, forKey: .displayOrder)
    }

    private static func legacyMetaItems(from c: KeyedDecodingContainer<CodingKeys>) -> [PracticalInfoItem] {
        var items: [PracticalInfoItem] = []
        if let duration = try? c.decodeIfPresent(String.self, forKey: .metaDuration)?
            .trimmingCharacters(in: .whitespacesAndNewlines), !duration.isEmpty {
            items.append(PracticalInfoItem(icon: "⏱", label: "Duration", value: duration))
        }
        if let distance = try? c.decodeIfPresent(String.self, forKey: .metaDistance)?
            .trimmingCharacters(in: .whitespacesAndNewlines), !distance.isEmpty {
            items.append(PracticalInfoItem(icon: "📏", label: "Distance", value: distance))
        }
        if let stops = try? c.decodeIfPresent(Int.self, forKey: .metaStops) {
            items.append(PracticalInfoItem(icon: "📍", label: "Stops", value: String(stops)))
        }
        return items
    }

    var listTitle: String { titleEn }

    var listSubtitle: String? {
        subtitle?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
    }

    func playbackGuide() -> AudioGuide? {
        let direct = audioUrl?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !direct.isEmpty else { return nil }
        let title = audioTitle?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty ?? titleEn
        return AudioGuide(
            id: "cityguide_\(id)",
            attractionId: cityId,
            titleEn: title,
            durationSeconds: audioDurationSeconds,
            audioUrl: direct,
            quote: audioQuote
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id, cityId, titleEn, titleZh, subtitle, icon, badge, coverImages, body
        case audioUrl, audioTitle, audioDurationSeconds, audioQuote, audioTranscript
        case metaItems, metaDuration, metaDistance, metaStops, displayOrder
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

struct PracticalInfoItem: Codable, Hashable {
    let icon: String?
    let label: String
    let value: String
}
