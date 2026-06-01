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

struct Attraction: Identifiable, Hashable, Codable {
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
    let practicalInfo: [PracticalInfoItem]
    let westernVisitorTips: [String]
    let nearbyPlaces: [NearbyPlace]
    let audioGuideCount: Int
    let iapProductId: String?
    let displayOrder: Int
    let shortDescription: String?
    let coverImages: [String]
    let addressEn: String?
    let addressZh: String?
    let paywallSubtitleOverride: String?

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        cityId = try c.decode(String.self, forKey: .cityId)
        name = try c.decode(String.self, forKey: .name)
        if let decodedChinese = try c.decodeIfPresent(String.self, forKey: .chineseName)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !decodedChinese.isEmpty {
            chineseName = decodedChinese
        } else {
            chineseName = name
        }
        category = try c.decodeIfPresent(String.self, forKey: .category) ?? "sight"
        coverImagePath = try c.decodeIfPresent(String.self, forKey: .coverImagePath)
        summary = try c.decodeIfPresent(String.self, forKey: .summary)
        introduction = try c.decodeIfPresent(String.self, forKey: .introduction)
        priority = try c.decodeIfPresent(String.self, forKey: .priority) ?? "P1"
        ticketPrice = try c.decodeIfPresent(String.self, forKey: .ticketPrice)
        recommendedDuration = try c.decodeIfPresent(String.self, forKey: .recommendedDuration)
        openingHours = try c.decodeIfPresent(String.self, forKey: .openingHours)
        closedDays = try c.decodeIfPresent(String.self, forKey: .closedDays)
        requiresAdvanceBooking = try c.decodeIfPresent(Bool.self, forKey: .requiresAdvanceBooking) ?? false
        metroAccess = try c.decodeIfPresent(String.self, forKey: .metroAccess)
        westernVisitorTips = Self.decodeStringArray(from: c, forKey: .westernVisitorTips)
        nearbyPlaces = (try? c.decode([NearbyPlace].self, forKey: .nearbyPlaces)) ?? []
        audioGuideCount = try c.decodeIfPresent(Int.self, forKey: .audioGuideCount) ?? 0
        iapProductId = try c.decodeIfPresent(String.self, forKey: .iapProductId)
        displayOrder = try c.decodeIfPresent(Int.self, forKey: .displayOrder) ?? 0
        shortDescription = try c.decodeIfPresent(String.self, forKey: .shortDescription)
        var images = Self.decodeStringArray(from: c, forKey: .coverImages)
        if images.isEmpty, let path = coverImagePath, !path.isEmpty {
            images = [path]
        }
        coverImages = images
        addressEn = try c.decodeIfPresent(String.self, forKey: .addressEn)
        addressZh = try c.decodeIfPresent(String.self, forKey: .addressZh)
        paywallSubtitleOverride = try c.decodeIfPresent(String.self, forKey: .paywallSubtitleOverride)

        let decodedPractical = (try? c.decode([PracticalInfoItem].self, forKey: .practicalInfo)) ?? []
        if !decodedPractical.isEmpty {
            practicalInfo = decodedPractical.filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        } else {
            practicalInfo = Self.legacyPracticalInfo(
                ticketPrice: ticketPrice,
                recommendedDuration: recommendedDuration,
                openingHours: openingHours,
                closedDays: closedDays,
                metroAccess: metroAccess
            )
        }
    }

    /// Prefer CMS `practical_info`; fall back to legacy scalar columns.
    var recommendedDurationText: String? {
        practicalInfoValue(matching: ["Duration", "建议时长"]) ?? recommendedDuration
    }

    var ticketPriceText: String? {
        practicalInfoValue(matching: ["Ticket", "门票"]) ?? ticketPrice
    }

    func practicalInfoValue(matching labels: [String]) -> String? {
        practicalInfo.first { item in
            labels.contains { label in
                item.label.localizedCaseInsensitiveContains(label)
                    || label.localizedCaseInsensitiveContains(item.label)
            }
        }?.value
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(cityId, forKey: .cityId)
        try c.encode(name, forKey: .name)
        try c.encode(chineseName, forKey: .chineseName)
        try c.encode(category, forKey: .category)
        try c.encodeIfPresent(coverImagePath, forKey: .coverImagePath)
        try c.encodeIfPresent(summary, forKey: .summary)
        try c.encodeIfPresent(introduction, forKey: .introduction)
        try c.encode(priority, forKey: .priority)
        try c.encodeIfPresent(ticketPrice, forKey: .ticketPrice)
        try c.encodeIfPresent(recommendedDuration, forKey: .recommendedDuration)
        try c.encodeIfPresent(openingHours, forKey: .openingHours)
        try c.encodeIfPresent(closedDays, forKey: .closedDays)
        try c.encode(requiresAdvanceBooking, forKey: .requiresAdvanceBooking)
        try c.encodeIfPresent(metroAccess, forKey: .metroAccess)
        try c.encode(practicalInfo, forKey: .practicalInfo)
        try c.encode(westernVisitorTips, forKey: .westernVisitorTips)
        try c.encode(nearbyPlaces, forKey: .nearbyPlaces)
        try c.encode(audioGuideCount, forKey: .audioGuideCount)
        try c.encodeIfPresent(iapProductId, forKey: .iapProductId)
        try c.encode(displayOrder, forKey: .displayOrder)
        try c.encodeIfPresent(shortDescription, forKey: .shortDescription)
        try c.encode(coverImages, forKey: .coverImages)
        try c.encodeIfPresent(addressEn, forKey: .addressEn)
        try c.encodeIfPresent(addressZh, forKey: .addressZh)
        try c.encodeIfPresent(paywallSubtitleOverride, forKey: .paywallSubtitleOverride)
    }

    private enum CodingKeys: String, CodingKey {
        case id, cityId, name, chineseName, category, coverImagePath, summary, introduction
        case priority, ticketPrice, recommendedDuration, openingHours, closedDays
        case requiresAdvanceBooking, metroAccess, practicalInfo, westernVisitorTips, nearbyPlaces
        case audioGuideCount, iapProductId, displayOrder
        case shortDescription, coverImages, addressEn, addressZh, paywallSubtitleOverride
    }

    private static func decodeStringArray(
        from container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) -> [String] {
        if let strings = try? container.decode([String].self, forKey: key) {
            return strings
        }
        if let single = try? container.decode(String.self, forKey: key), !single.isEmpty {
            return [single]
        }
        return []
    }

    private static func legacyPracticalInfo(
        ticketPrice: String?,
        recommendedDuration: String?,
        openingHours: String?,
        closedDays: String?,
        metroAccess: String?
    ) -> [PracticalInfoItem] {
        var items: [PracticalInfoItem] = []
        if let v = ticketPrice, !v.isEmpty {
            items.append(PracticalInfoItem(icon: "🎫", label: "Ticket", value: v))
        }
        if let v = recommendedDuration, !v.isEmpty {
            items.append(PracticalInfoItem(icon: "🕐", label: "Duration", value: v))
        }
        if let v = openingHours, !v.isEmpty {
            items.append(PracticalInfoItem(icon: "🕘", label: "Opening Hours", value: v))
        }
        if let v = closedDays, !v.isEmpty {
            items.append(PracticalInfoItem(icon: "❌", label: "Closed", value: v))
        }
        if let v = metroAccess, !v.isEmpty {
            items.append(PracticalInfoItem(icon: "🚇", label: "Metro", value: v))
        }
        return items
    }
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

    init(
        id: String,
        attractionId: String,
        titleEn: String,
        description: String? = nil,
        durationSeconds: Int = 0,
        audioUrl: String,
        quote: String? = nil,
        segments: [AudioSegment] = [],
        isMainGuide: Bool = false
    ) {
        self.id = id
        self.attractionId = attractionId
        self.titleEn = titleEn
        self.description = description
        self.durationSeconds = durationSeconds
        self.audioUrl = audioUrl
        self.quote = quote
        self.segments = segments
        self.isMainGuide = isMainGuide
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        attractionId = try c.decode(String.self, forKey: .attractionId)
        titleEn = try c.decode(String.self, forKey: .titleEn)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        durationSeconds = try c.decodeIfPresent(Int.self, forKey: .durationSeconds) ?? 0
        audioUrl = try c.decodeIfPresent(String.self, forKey: .audioUrl) ?? ""
        quote = try c.decodeIfPresent(String.self, forKey: .quote)
        segments = (try? c.decode([AudioSegment].self, forKey: .segments)) ?? []
        isMainGuide = try c.decodeIfPresent(Bool.self, forKey: .isMainGuide) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(attractionId, forKey: .attractionId)
        try c.encode(titleEn, forKey: .titleEn)
        try c.encodeIfPresent(description, forKey: .description)
        try c.encode(durationSeconds, forKey: .durationSeconds)
        try c.encode(audioUrl, forKey: .audioUrl)
        try c.encodeIfPresent(quote, forKey: .quote)
        try c.encode(segments, forKey: .segments)
        try c.encode(isMainGuide, forKey: .isMainGuide)
    }

    private enum CodingKeys: String, CodingKey {
        case id, attractionId, titleEn, description, durationSeconds, audioUrl, quote, segments, isMainGuide
    }
}

struct AudioSegment: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let startSeconds: Int

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        startSeconds = try c.decodeIfPresent(Int.self, forKey: .startSeconds) ?? 0
        id = try c.decodeIfPresent(String.self, forKey: .id) ?? "\(title)-\(startSeconds)"
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(startSeconds, forKey: .startSeconds)
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, startSeconds
    }
}

enum ChecklistItemType: String, Codable, Hashable {
    case entry
    case universal
    case city
}

struct ChecklistExternalLink: Codable, Hashable {
    let label: String
    let url: String
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
    let type: ChecklistItemType
    let whyImportant: String?
    let howToComplete: String?
    let externalLinks: [ChecklistExternalLink]
    let targetNationalities: [String]
    let targetCities: [String]
    let priority: String

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        cityId = try c.decodeIfPresent(String.self, forKey: .cityId)
        phase = try c.decodeIfPresent(String.self, forKey: .phase) ?? "before_departure"
        groupTitle = try c.decode(String.self, forKey: .groupTitle)
        titleEn = try c.decode(String.self, forKey: .titleEn)
        estimatedMinutes = try c.decodeIfPresent(Int.self, forKey: .estimatedMinutes)
        displayTags = (try? c.decode([String].self, forKey: .displayTags)) ?? []
        culturalTip = try c.decodeIfPresent(String.self, forKey: .culturalTip)
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        whyImportant = try c.decodeIfPresent(String.self, forKey: .whyImportant)
        howToComplete = try c.decodeIfPresent(String.self, forKey: .howToComplete)
        externalLinks = (try? c.decode([ChecklistExternalLink].self, forKey: .externalLinks)) ?? []
        targetNationalities = (try? c.decode([String].self, forKey: .targetNationalities)) ?? []
        targetCities = (try? c.decode([String].self, forKey: .targetCities)) ?? []
        priority = try c.decodeIfPresent(String.self, forKey: .priority) ?? "recommended"
        if let decodedType = try c.decodeIfPresent(ChecklistItemType.self, forKey: .type) {
            type = decodedType
        } else {
            type = Self.inferredType(cityId: cityId, groupTitle: groupTitle)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, cityId, phase, groupTitle, titleEn, estimatedMinutes, displayTags, culturalTip
        case sortOrder, type, whyImportant, howToComplete, externalLinks
        case targetNationalities, targetCities, priority
    }

    private static func inferredType(cityId: String?, groupTitle: String) -> ChecklistItemType {
        if cityId != nil { return .city }
        let lower = groupTitle.lowercased()
        if lower.contains("entry") || lower.contains("visa") { return .entry }
        return .universal
    }

    var sectionTitle: String {
        switch type {
        case .entry: "Entry Requirements"
        case .universal: "Essential Prep"
        case .city: groupTitle
        }
    }
}

struct SubAreaContentBlock: Codable, Hashable {
    let type: String?
    let title: String?
    let body: String?
    let imagePath: String?

    var blockType: String {
        let raw = type?.lowercased() ?? ""
        if raw == "heading" || raw == "image" || raw == "paragraph" { return raw }
        if imagePath != nil || (raw.isEmpty && title == nil && body?.hasPrefix("http") == true) {
            return "image"
        }
        if title != nil, body == nil || body?.isEmpty == true { return "heading" }
        return "paragraph"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        type = try c.decodeIfPresent(String.self, forKey: .type)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        body = try c.decodeIfPresent(String.self, forKey: .body)
        imagePath = try c.decodeIfPresent(String.self, forKey: .imagePath)
            ?? c.decodeIfPresent(String.self, forKey: .image_path)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(type, forKey: .type)
        try c.encodeIfPresent(title, forKey: .title)
        try c.encodeIfPresent(body, forKey: .body)
        try c.encodeIfPresent(imagePath, forKey: .imagePath)
    }

    private enum CodingKeys: String, CodingKey {
        case type, title, body, imagePath, image_path
    }
}

struct SubArea: Identifiable, Hashable, Codable {
    let id: String
    let attractionId: String
    let nameEn: String
    let nameZh: String?
    let coverImagePath: String?
    let body: String?
    let contentBlocks: [SubAreaContentBlock]
    let audioUrl: String?
    let audioGuideId: String?
    let sortOrder: Int

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        attractionId = try c.decode(String.self, forKey: .attractionId)
        nameEn = try c.decode(String.self, forKey: .nameEn)
        nameZh = try c.decodeIfPresent(String.self, forKey: .nameZh)
        coverImagePath = try c.decodeIfPresent(String.self, forKey: .coverImagePath)
        body = try c.decodeIfPresent(String.self, forKey: .body)
        contentBlocks = try c.decodeIfPresent([SubAreaContentBlock].self, forKey: .contentBlocks) ?? []
        audioUrl = try c.decodeIfPresent(String.self, forKey: .audioUrl)
        audioGuideId = try c.decodeIfPresent(String.self, forKey: .audioGuideId)
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(attractionId, forKey: .attractionId)
        try c.encode(nameEn, forKey: .nameEn)
        try c.encodeIfPresent(nameZh, forKey: .nameZh)
        try c.encodeIfPresent(coverImagePath, forKey: .coverImagePath)
        try c.encodeIfPresent(body, forKey: .body)
        try c.encode(contentBlocks, forKey: .contentBlocks)
        try c.encodeIfPresent(audioUrl, forKey: .audioUrl)
        try c.encodeIfPresent(audioGuideId, forKey: .audioGuideId)
        try c.encode(sortOrder, forKey: .sortOrder)
    }

    private enum CodingKeys: String, CodingKey {
        case id, attractionId, nameEn, nameZh, coverImagePath, body, contentBlocks, audioUrl, audioGuideId, sortOrder
    }

    func playbackGuide(attractionId: String) -> AudioGuide? {
        let direct = audioUrl?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !direct.isEmpty {
            return AudioGuide(
                id: "subarea_\(id)",
                attractionId: attractionId,
                titleEn: nameEn,
                audioUrl: direct
            )
        }
        return nil
    }
}

struct FlightPlatform: Codable, Hashable, Identifiable {
    let id: String
    let label: String
    let urlTemplate: String
}

struct PaywallCopy: Codable, Equatable, Hashable {
    let titleTemplate: String
    let previewLineTemplate: String
    let proTitle: String
    let proSubtitle: String
    let proPriceHint: String
    let proCta: String
    let singleTitle: String
    let singleSubtitle: String
    let singleCta: String
    let maybeLater: String
    let restore: String
    let footnote: String

    static let fallback = PaywallCopy(
        titleTemplate: "Unlock {attraction_name} Audio Guide",
        previewLineTemplate: "{duration} min · Literary narrative",
        proTitle: "YOLO HAPPY Pro",
        proSubtitle: "Unlock ALL audio guides",
        proPriceHint: "Billed annually · Cancel anytime",
        proCta: "Start Pro",
        singleTitle: "This Attraction Only",
        singleSubtitle: "One-time purchase · Yours forever",
        singleCta: "Buy This Guide",
        maybeLater: "Maybe Later",
        restore: "Restore Purchase",
        footnote: "Prices shown in your local currency. Subscriptions renew automatically unless cancelled."
    )

    func title(for attractionName: String) -> String {
        titleTemplate.replacingOccurrences(of: "{attraction_name}", with: attractionName)
    }

    func previewLine(duration: String) -> String {
        previewLineTemplate.replacingOccurrences(of: "{duration}", with: duration)
    }
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

    init(
        id: String,
        emoji: String,
        title: String,
        preview: String,
        body: String,
        category: CultureTipCategory = .social,
        doText: String? = nil,
        dontText: String? = nil
    ) {
        self.id = id
        self.emoji = emoji
        self.title = title
        self.preview = preview
        self.body = body
        self.category = category
        self.doText = doText
        self.dontText = dontText
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
    }

    private enum CodingKeys: String, CodingKey {
        case id, emoji, title, preview, body, category
        case doText = "do_text"
        case dontText = "dont_text"
    }
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
    var shareSlug: String?
    var isShared: Bool

    init(
        id: String,
        title: String,
        meta: String,
        routeSummary: String,
        estimatedBudget: String,
        days: [ItineraryDay],
        shareSlug: String? = nil,
        isShared: Bool = false
    ) {
        self.id = id
        self.title = title
        self.meta = meta
        self.routeSummary = routeSummary
        self.estimatedBudget = estimatedBudget
        self.days = days
        self.shareSlug = shareSlug
        self.isShared = isShared
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        meta = try c.decode(String.self, forKey: .meta)
        routeSummary = try c.decode(String.self, forKey: .routeSummary)
        estimatedBudget = try c.decode(String.self, forKey: .estimatedBudget)
        days = try c.decode([ItineraryDay].self, forKey: .days)
        shareSlug = try c.decodeIfPresent(String.self, forKey: .shareSlug)
        isShared = try c.decodeIfPresent(Bool.self, forKey: .isShared) ?? false
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, meta, routeSummary, estimatedBudget, days, shareSlug, isShared
    }
}

enum ItineraryDayKind: String, Codable, Hashable {
    case standard
    case experienceSuggestions = "experience_suggestions"
}

struct ItineraryDay: Identifiable, Codable, Hashable {
    let id: String
    let dayIndex: Int
    let dateLabel: String
    let cityName: String
    let costEstimate: String?
    let dayKind: ItineraryDayKind
    let experienceItems: [String]
    let experienceCityId: String?
    let activities: [ItineraryActivity]

    var isExperienceSuggestions: Bool {
        dayKind == .experienceSuggestions
    }

    init(
        id: String,
        dayIndex: Int,
        dateLabel: String,
        cityName: String,
        costEstimate: String?,
        activities: [ItineraryActivity],
        dayKind: ItineraryDayKind = .standard,
        experienceItems: [String] = [],
        experienceCityId: String? = nil
    ) {
        self.id = id
        self.dayIndex = dayIndex
        self.dateLabel = dateLabel
        self.cityName = cityName
        self.costEstimate = costEstimate
        self.dayKind = dayKind
        self.experienceItems = experienceItems
        self.experienceCityId = experienceCityId
        self.activities = activities
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        dayIndex = try c.decode(Int.self, forKey: .dayIndex)
        dateLabel = try c.decode(String.self, forKey: .dateLabel)
        cityName = try c.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        costEstimate = try c.decodeIfPresent(String.self, forKey: .costEstimate)
        dayKind = try c.decodeIfPresent(ItineraryDayKind.self, forKey: .dayKind) ?? .standard
        experienceItems = try c.decodeIfPresent([String].self, forKey: .experienceItems) ?? []
        experienceCityId = try c.decodeIfPresent(String.self, forKey: .experienceCityId)
        activities = try c.decodeIfPresent([ItineraryActivity].self, forKey: .activities) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(dayIndex, forKey: .dayIndex)
        try c.encode(dateLabel, forKey: .dateLabel)
        try c.encode(cityName, forKey: .cityName)
        try c.encodeIfPresent(costEstimate, forKey: .costEstimate)
        if dayKind != .standard {
            try c.encode(dayKind, forKey: .dayKind)
        }
        if !experienceItems.isEmpty {
            try c.encode(experienceItems, forKey: .experienceItems)
        }
        try c.encodeIfPresent(experienceCityId, forKey: .experienceCityId)
        try c.encode(activities, forKey: .activities)
    }

    private enum CodingKeys: String, CodingKey {
        case id, dayIndex, dateLabel, cityName, costEstimate, dayKind, experienceItems, experienceCityId, activities
    }

    func withActivities(_ activities: [ItineraryActivity]) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: costEstimate,
            activities: activities,
            dayKind: dayKind,
            experienceItems: experienceItems,
            experienceCityId: experienceCityId
        )
    }

    func withDayIndex(_ dayIndex: Int) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: costEstimate,
            activities: activities,
            dayKind: dayKind,
            experienceItems: experienceItems,
            experienceCityId: experienceCityId
        )
    }
}

struct ItineraryActivity: Identifiable, Codable, Hashable {
    let id: String
    let timeSlot: String
    let name: String
    let detail: String
    let attractionId: String?
    let cityId: String?
    let hasAudio: Bool

    init(
        id: String,
        timeSlot: String = "",
        name: String,
        detail: String,
        attractionId: String?,
        cityId: String? = nil,
        hasAudio: Bool
    ) {
        self.id = id
        self.timeSlot = timeSlot
        self.name = name
        self.detail = detail
        self.attractionId = attractionId
        self.cityId = cityId
        self.hasAudio = hasAudio
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        timeSlot = try c.decodeIfPresent(String.self, forKey: .timeSlot) ?? ""
        name = try c.decode(String.self, forKey: .name)
        detail = try c.decodeIfPresent(String.self, forKey: .detail) ?? ""
        attractionId = try c.decodeIfPresent(String.self, forKey: .attractionId)
        cityId = try c.decodeIfPresent(String.self, forKey: .cityId)
        hasAudio = try c.decodeIfPresent(Bool.self, forKey: .hasAudio) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        if !timeSlot.isEmpty { try c.encode(timeSlot, forKey: .timeSlot) }
        try c.encode(name, forKey: .name)
        try c.encode(detail, forKey: .detail)
        try c.encodeIfPresent(attractionId, forKey: .attractionId)
        try c.encodeIfPresent(cityId, forKey: .cityId)
        try c.encode(hasAudio, forKey: .hasAudio)
    }

    private enum CodingKeys: String, CodingKey {
        case id, timeSlot, name, detail, attractionId, cityId, hasAudio
    }
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
    let helpPhrases: [EmergencyHelpPhrase]

    init(contacts: [EmergencyContact], embassyNote: String, helpPhrases: [EmergencyHelpPhrase] = []) {
        self.contacts = contacts
        self.embassyNote = embassyNote
        self.helpPhrases = helpPhrases
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        contacts = (try? c.decode([EmergencyContact].self, forKey: .contacts)) ?? []
        embassyNote = try c.decodeIfPresent(String.self, forKey: .embassyNote) ?? ""
        helpPhrases = (try? c.decode([EmergencyHelpPhrase].self, forKey: .helpPhrases)) ?? []
    }

    private enum CodingKeys: String, CodingKey {
        case contacts, embassyNote, helpPhrases
    }
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
        supportEmail: "support@yolohappy.app",
        aboutTitle: "YOLO HAPPY",
        aboutVersion: "1.0.0",
        aboutBody: "Your companion for planning and experiencing travel in China.",
        iapProTitle: "YOLO HAPPY Pro",
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
        shareWebBaseURL: "https://yolo.cstudiomunger.workers.dev"
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
    let paywall: PaywallCopy
    let flightPlatforms: [FlightPlatform]
    let privacyPolicyBody: String
    let termsOfServiceBody: String
    let shareWebBaseURL: String

    init(
        supportEmail: String,
        aboutTitle: String,
        aboutVersion: String,
        aboutBody: String,
        iapProTitle: String,
        iapProPrice: String,
        iapProTrialText: String,
        iapProFeatures: String,
        iapSinglePriceLabel: String,
        assistantGreetingGeneral: String,
        assistantGreetingPlanning: String,
        planAlertMessage: String,
        planAlertLinkAttractionId: String?,
        planAlertLinkCityId: String?,
        planAlertLinkLabel: String,
        freeAudioPreviewSeconds: Int,
        paywall: PaywallCopy = .fallback,
        flightPlatforms: [FlightPlatform] = AppBranding.fallback.flightPlatforms,
        privacyPolicyBody: String = "",
        termsOfServiceBody: String = "",
        shareWebBaseURL: String = "https://yolo.cstudiomunger.workers.dev"
    ) {
        self.supportEmail = supportEmail
        self.aboutTitle = aboutTitle
        self.aboutVersion = aboutVersion
        self.aboutBody = aboutBody
        self.iapProTitle = iapProTitle
        self.iapProPrice = iapProPrice
        self.iapProTrialText = iapProTrialText
        self.iapProFeatures = iapProFeatures
        self.iapSinglePriceLabel = iapSinglePriceLabel
        self.assistantGreetingGeneral = assistantGreetingGeneral
        self.assistantGreetingPlanning = assistantGreetingPlanning
        self.planAlertMessage = planAlertMessage
        self.planAlertLinkAttractionId = planAlertLinkAttractionId
        self.planAlertLinkCityId = planAlertLinkCityId
        self.planAlertLinkLabel = planAlertLinkLabel
        self.freeAudioPreviewSeconds = freeAudioPreviewSeconds
        self.paywall = paywall
        self.flightPlatforms = flightPlatforms
        self.privacyPolicyBody = privacyPolicyBody
        self.termsOfServiceBody = termsOfServiceBody
        self.shareWebBaseURL = shareWebBaseURL
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        supportEmail = try c.decode(String.self, forKey: .supportEmail)
        aboutTitle = try c.decode(String.self, forKey: .aboutTitle)
        aboutVersion = try c.decode(String.self, forKey: .aboutVersion)
        aboutBody = try c.decode(String.self, forKey: .aboutBody)
        iapProTitle = try c.decode(String.self, forKey: .iapProTitle)
        iapProPrice = try c.decode(String.self, forKey: .iapProPrice)
        iapProTrialText = try c.decode(String.self, forKey: .iapProTrialText)
        iapProFeatures = try c.decode(String.self, forKey: .iapProFeatures)
        iapSinglePriceLabel = try c.decode(String.self, forKey: .iapSinglePriceLabel)
        assistantGreetingGeneral = try c.decode(String.self, forKey: .assistantGreetingGeneral)
        assistantGreetingPlanning = try c.decode(String.self, forKey: .assistantGreetingPlanning)
        planAlertMessage = try c.decodeIfPresent(String.self, forKey: .planAlertMessage) ?? ""
        planAlertLinkAttractionId = try c.decodeIfPresent(String.self, forKey: .planAlertLinkAttractionId)
        planAlertLinkCityId = try c.decodeIfPresent(String.self, forKey: .planAlertLinkCityId)
        planAlertLinkLabel = try c.decodeIfPresent(String.self, forKey: .planAlertLinkLabel) ?? "How to Book →"
        freeAudioPreviewSeconds = try c.decodeIfPresent(Int.self, forKey: .freeAudioPreviewSeconds) ?? 180
        paywall = (try? c.decode(PaywallCopy.self, forKey: .paywall)) ?? .fallback
        flightPlatforms = (try? c.decode([FlightPlatform].self, forKey: .flightPlatforms)) ?? Self.fallback.flightPlatforms
        privacyPolicyBody = try c.decodeIfPresent(String.self, forKey: .privacyPolicyBody) ?? ""
        termsOfServiceBody = try c.decodeIfPresent(String.self, forKey: .termsOfServiceBody) ?? ""
        shareWebBaseURL = try c.decodeIfPresent(String.self, forKey: .shareWebBaseURL) ?? Self.fallback.shareWebBaseURL
    }

    private enum CodingKeys: String, CodingKey {
        case supportEmail, aboutTitle, aboutVersion, aboutBody
        case iapProTitle, iapProPrice, iapProTrialText, iapProFeatures, iapSinglePriceLabel
        case assistantGreetingGeneral, assistantGreetingPlanning
        case planAlertMessage, planAlertLinkAttractionId, planAlertLinkCityId, planAlertLinkLabel
        case freeAudioPreviewSeconds, paywall, flightPlatforms
        case privacyPolicyBody, termsOfServiceBody, shareWebBaseURL
    }

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
    let aiModelId: String?
    let aiChatApiUrl: String?
    let aiChatMaxTokens: Int?
    let aiItineraryMaxTokens: Int?
    let aiTemperature: Double?
    let aiTimeoutMs: Int?
    let aiSystemPromptAssistant: String?
    let aiSystemPromptItinerary: String?
    let paywallTitleTemplate: String?
    let paywallPreviewLineTemplate: String?
    let paywallProTitle: String?
    let paywallProSubtitle: String?
    let paywallProPriceHint: String?
    let paywallProCta: String?
    let paywallSingleTitle: String?
    let paywallSingleSubtitle: String?
    let paywallSingleCta: String?
    let paywallMaybeLater: String?
    let paywallRestore: String?
    let paywallFootnote: String?
    let flightPlatforms: [FlightPlatform]?
    let privacyPolicyBody: String?
    let termsOfServiceBody: String?
    let shareWebBaseURL: String?

    // Keys are camelCase; JSONDecoder.convertFromSnakeCase maps use_remote_ai → useRemoteAI.
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
        case aiModelId
        case aiChatApiUrl
        case aiChatMaxTokens
        case aiItineraryMaxTokens
        case aiTemperature
        case aiTimeoutMs
        case aiSystemPromptAssistant
        case aiSystemPromptItinerary
        case paywallTitleTemplate
        case paywallPreviewLineTemplate
        case paywallProTitle
        case paywallProSubtitle
        case paywallProPriceHint
        case paywallProCta
        case paywallSingleTitle
        case paywallSingleSubtitle
        case paywallSingleCta
        case paywallMaybeLater
        case paywallRestore
        case paywallFootnote
        case flightPlatforms
        case privacyPolicyBody
        case termsOfServiceBody
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
        aiModelId = try container.decodeIfPresent(String.self, forKey: .aiModelId)
        aiChatApiUrl = try container.decodeIfPresent(String.self, forKey: .aiChatApiUrl)
        aiChatMaxTokens = try container.decodeIfPresent(Int.self, forKey: .aiChatMaxTokens)
        aiItineraryMaxTokens = try container.decodeIfPresent(Int.self, forKey: .aiItineraryMaxTokens)
        aiTemperature = try container.decodeIfPresent(Double.self, forKey: .aiTemperature)
        aiTimeoutMs = try container.decodeIfPresent(Int.self, forKey: .aiTimeoutMs)
        aiSystemPromptAssistant = try container.decodeIfPresent(String.self, forKey: .aiSystemPromptAssistant)
        aiSystemPromptItinerary = try container.decodeIfPresent(String.self, forKey: .aiSystemPromptItinerary)
        paywallTitleTemplate = try container.decodeIfPresent(String.self, forKey: .paywallTitleTemplate)
        paywallPreviewLineTemplate = try container.decodeIfPresent(String.self, forKey: .paywallPreviewLineTemplate)
        paywallProTitle = try container.decodeIfPresent(String.self, forKey: .paywallProTitle)
        paywallProSubtitle = try container.decodeIfPresent(String.self, forKey: .paywallProSubtitle)
        paywallProPriceHint = try container.decodeIfPresent(String.self, forKey: .paywallProPriceHint)
        paywallProCta = try container.decodeIfPresent(String.self, forKey: .paywallProCta)
        paywallSingleTitle = try container.decodeIfPresent(String.self, forKey: .paywallSingleTitle)
        paywallSingleSubtitle = try container.decodeIfPresent(String.self, forKey: .paywallSingleSubtitle)
        paywallSingleCta = try container.decodeIfPresent(String.self, forKey: .paywallSingleCta)
        paywallMaybeLater = try container.decodeIfPresent(String.self, forKey: .paywallMaybeLater)
        paywallRestore = try container.decodeIfPresent(String.self, forKey: .paywallRestore)
        paywallFootnote = try container.decodeIfPresent(String.self, forKey: .paywallFootnote)
        flightPlatforms = try container.decodeIfPresent([FlightPlatform].self, forKey: .flightPlatforms)
        privacyPolicyBody = try container.decodeIfPresent(String.self, forKey: .privacyPolicyBody)
        termsOfServiceBody = try container.decodeIfPresent(String.self, forKey: .termsOfServiceBody)
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

    /// `convertFromSnakeCase` maps `use_remote_ai` → `useRemoteAi`, not `useRemoteAI`.
    private static func boolKeyCandidates(for key: CodingKeys) -> [CodingKeys] {
        switch key {
        case .useRemoteAI:
            return [.useRemoteAI, CodingKeys(stringValue: "useRemoteAi")].compactMap { $0 }
        case .useRemoteIAP:
            return [.useRemoteIAP, CodingKeys(stringValue: "useRemoteIap")].compactMap { $0 }
        default:
            return [key]
        }
    }

    var asSettings: AppSettingsRemote {
        let defaults = AppBranding.fallback
        let paywallDefaults = PaywallCopy.fallback
        let paywall = PaywallCopy(
            titleTemplate: paywallTitleTemplate ?? paywallDefaults.titleTemplate,
            previewLineTemplate: paywallPreviewLineTemplate ?? paywallDefaults.previewLineTemplate,
            proTitle: paywallProTitle ?? paywallDefaults.proTitle,
            proSubtitle: paywallProSubtitle ?? paywallDefaults.proSubtitle,
            proPriceHint: paywallProPriceHint ?? paywallDefaults.proPriceHint,
            proCta: paywallProCta ?? paywallDefaults.proCta,
            singleTitle: paywallSingleTitle ?? paywallDefaults.singleTitle,
            singleSubtitle: paywallSingleSubtitle ?? paywallDefaults.singleSubtitle,
            singleCta: paywallSingleCta ?? paywallDefaults.singleCta,
            maybeLater: paywallMaybeLater ?? paywallDefaults.maybeLater,
            restore: paywallRestore ?? paywallDefaults.restore,
            footnote: paywallFootnote ?? paywallDefaults.footnote
        )
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
            freeAudioPreviewSeconds: freeAudioPreviewSeconds ?? defaults.freeAudioPreviewSeconds,
            paywall: paywall,
            flightPlatforms: flightPlatforms ?? defaults.flightPlatforms,
            privacyPolicyBody: privacyPolicyBody ?? defaults.privacyPolicyBody,
            termsOfServiceBody: termsOfServiceBody ?? defaults.termsOfServiceBody,
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
