import Foundation

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
    let closedWeekdays: [String]
    let openTime: String?
    let closeTime: String?
    let lastEntryTime: String?
    let requiresAdvanceBooking: Bool
    let metroAccess: String?
    let practicalInfo: [PracticalInfoItem]
    let westernVisitorTips: [String]
    let nearbyPlaces: [NearbyPlace]
    let audioGuideCount: Int
    let iapProductId: String?
    let textPaywallFree: Bool
    let requiresPurchase: Bool
    let priceTierId: String?
    let displayOrder: Int
    let shortDescription: String?
    let coverImages: [String]
    let addressEn: String?
    let addressZh: String?
    let paywallSubtitleOverride: String?
    let planningZone: String?
    let recommendedVisitPeriod: String?
    let attractionKind: String?
    let latitude: Double?
    let longitude: Double?
    let isDayTrip: Bool
    let distanceFromCenterKm: Double?
    let durationSlotsMin: Double?
    let durationSlotsMax: Double?

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
        let structuredWeekdays = Self.decodeStringArray(from: c, forKey: .closedWeekdays).map { $0.lowercased() }
        closedWeekdays = structuredWeekdays.isEmpty
            ? Self.parseWeekdays(fromClosedDays: closedDays)
            : structuredWeekdays
        openTime = try c.decodeIfPresent(String.self, forKey: .openTime)
        closeTime = try c.decodeIfPresent(String.self, forKey: .closeTime)
        lastEntryTime = try c.decodeIfPresent(String.self, forKey: .lastEntryTime)
        requiresAdvanceBooking = try c.decodeIfPresent(Bool.self, forKey: .requiresAdvanceBooking) ?? false
        metroAccess = try c.decodeIfPresent(String.self, forKey: .metroAccess)
        westernVisitorTips = Self.decodeStringArray(from: c, forKey: .westernVisitorTips)
        nearbyPlaces = (try? c.decode([NearbyPlace].self, forKey: .nearbyPlaces)) ?? []
        audioGuideCount = try c.decodeIfPresent(Int.self, forKey: .audioGuideCount) ?? 0
        iapProductId = try c.decodeIfPresent(String.self, forKey: .iapProductId)
        textPaywallFree = try c.decodeIfPresent(Bool.self, forKey: .textPaywallFree) ?? false
        requiresPurchase = try c.decodeIfPresent(Bool.self, forKey: .requiresPurchase) ?? false
        priceTierId = try c.decodeIfPresent(String.self, forKey: .priceTierId)
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
        planningZone = try c.decodeIfPresent(String.self, forKey: .planningZone)
        recommendedVisitPeriod = try c.decodeIfPresent(String.self, forKey: .recommendedVisitPeriod) ?? "flexible"
        attractionKind = try c.decodeIfPresent(String.self, forKey: .attractionKind)
        latitude = try c.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try c.decodeIfPresent(Double.self, forKey: .longitude)
        isDayTrip = try c.decodeIfPresent(Bool.self, forKey: .isDayTrip) ?? false
        distanceFromCenterKm = try c.decodeIfPresent(Double.self, forKey: .distanceFromCenterKm)
        durationSlotsMin = try c.decodeIfPresent(Double.self, forKey: .durationSlotsMin)
        durationSlotsMax = try c.decodeIfPresent(Double.self, forKey: .durationSlotsMax)

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
        try c.encode(closedWeekdays, forKey: .closedWeekdays)
        try c.encodeIfPresent(openTime, forKey: .openTime)
        try c.encodeIfPresent(closeTime, forKey: .closeTime)
        try c.encodeIfPresent(lastEntryTime, forKey: .lastEntryTime)
        try c.encode(requiresAdvanceBooking, forKey: .requiresAdvanceBooking)
        try c.encodeIfPresent(metroAccess, forKey: .metroAccess)
        try c.encode(practicalInfo, forKey: .practicalInfo)
        try c.encode(westernVisitorTips, forKey: .westernVisitorTips)
        try c.encode(nearbyPlaces, forKey: .nearbyPlaces)
        try c.encode(audioGuideCount, forKey: .audioGuideCount)
        try c.encodeIfPresent(iapProductId, forKey: .iapProductId)
        try c.encode(textPaywallFree, forKey: .textPaywallFree)
        try c.encode(requiresPurchase, forKey: .requiresPurchase)
        try c.encodeIfPresent(priceTierId, forKey: .priceTierId)
        try c.encode(displayOrder, forKey: .displayOrder)
        try c.encodeIfPresent(shortDescription, forKey: .shortDescription)
        try c.encode(coverImages, forKey: .coverImages)
        try c.encodeIfPresent(addressEn, forKey: .addressEn)
        try c.encodeIfPresent(addressZh, forKey: .addressZh)
        try c.encodeIfPresent(paywallSubtitleOverride, forKey: .paywallSubtitleOverride)
        try c.encodeIfPresent(planningZone, forKey: .planningZone)
        if recommendedVisitPeriod != "flexible" {
            try c.encodeIfPresent(recommendedVisitPeriod, forKey: .recommendedVisitPeriod)
        }
        try c.encodeIfPresent(attractionKind, forKey: .attractionKind)
        try c.encodeIfPresent(latitude, forKey: .latitude)
        try c.encodeIfPresent(longitude, forKey: .longitude)
        if isDayTrip { try c.encode(isDayTrip, forKey: .isDayTrip) }
        try c.encodeIfPresent(distanceFromCenterKm, forKey: .distanceFromCenterKm)
        try c.encodeIfPresent(durationSlotsMin, forKey: .durationSlotsMin)
        try c.encodeIfPresent(durationSlotsMax, forKey: .durationSlotsMax)
    }

    private enum CodingKeys: String, CodingKey {
        case id, cityId, name, chineseName, category, coverImagePath, summary, introduction
        case priority, ticketPrice, recommendedDuration, openingHours, closedDays
        case closedWeekdays, openTime, closeTime, lastEntryTime
        case requiresAdvanceBooking, metroAccess, practicalInfo, westernVisitorTips, nearbyPlaces
        case audioGuideCount, iapProductId, textPaywallFree, requiresPurchase, priceTierId, displayOrder
        case shortDescription, coverImages, addressEn, addressZh, paywallSubtitleOverride, planningZone
        case recommendedVisitPeriod = "recommended_visit_period"
        case attractionKind = "attraction_kind"
        case latitude, longitude
        case isDayTrip = "is_day_trip"
        case distanceFromCenterKm = "distance_from_center_km"
        case durationSlotsMin = "duration_slots_min"
        case durationSlotsMax = "duration_slots_max"
    }

    var isEveningOnly: Bool {
        PlanItineraryVisitHours.isEveningOnly(self)
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

    private static func parseWeekdays(fromClosedDays text: String?) -> [String] {
        let raw = (text ?? "").lowercased()
        guard !raw.isEmpty else { return [] }
        var days: [String] = []
        let map: [(String, String)] = [
            ("mon", "mon"), ("monday", "mon"),
            ("tue", "tue"), ("tuesday", "tue"),
            ("wed", "wed"), ("wednesday", "wed"),
            ("thu", "thu"), ("thursday", "thu"),
            ("fri", "fri"), ("friday", "fri"),
            ("sat", "sat"), ("saturday", "sat"),
            ("sun", "sun"), ("sunday", "sun"),
        ]
        for (token, key) in map where raw.contains(token) {
            if !days.contains(key) { days.append(key) }
        }
        return days
    }

    var displayAddressLine: String? { mapDestination.displayAddressLine }

    var canOpenInMaps: Bool { mapDestination.canOpenInMaps }

    var mapDestination: MapDestination {
        MapDestination(
            name: name,
            addressZh: addressZh,
            addressEn: addressEn,
            latitude: latitude,
            longitude: longitude
        )
    }
}

struct NearbyPlace: Codable, Hashable {
    let name: String
    let distance: String
}

struct FavoriteAttractionRecord: Codable, Equatable, Identifiable {
    var id: String { attractionId }
    let attractionId: String
    let cityId: String
    let createdAt: Date?

    init(attractionId: String, cityId: String, createdAt: Date? = nil) {
        self.attractionId = attractionId
        self.cityId = cityId
        self.createdAt = createdAt
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
    let audioTranscript: String?
    let sortOrder: Int
    let requiresPurchase: Bool
    let priceTierId: String?

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
        audioTranscript = try c.decodeIfPresent(String.self, forKey: .audioTranscript)
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        requiresPurchase = try c.decodeIfPresent(Bool.self, forKey: .requiresPurchase) ?? false
        priceTierId = try c.decodeIfPresent(String.self, forKey: .priceTierId)
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
        try c.encodeIfPresent(audioTranscript, forKey: .audioTranscript)
        try c.encode(sortOrder, forKey: .sortOrder)
        try c.encode(requiresPurchase, forKey: .requiresPurchase)
        try c.encodeIfPresent(priceTierId, forKey: .priceTierId)
    }

    private enum CodingKeys: String, CodingKey {
        case id, attractionId, nameEn, nameZh, coverImagePath, body, contentBlocks, audioUrl, audioGuideId, audioTranscript, sortOrder
        case requiresPurchase, priceTierId
    }

    func playbackGuide(attractionId: String) -> AudioGuide? {
        let direct = audioUrl?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !direct.isEmpty {
            return AudioGuide(
                id: "subarea_\(id)",
                attractionId: attractionId,
                titleEn: nameEn,
                audioUrl: direct,
                transcript: audioTranscript
            )
        }
        return nil
    }
}
