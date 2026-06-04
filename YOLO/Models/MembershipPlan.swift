import Foundation

struct MembershipPlan: Identifiable, Codable, Sendable {
    let id: String
    let rcPackageId: String?
    let appleProductId: String
    let nameEn: String
    let nameZh: String?
    let priceLabel: String
    let durationDays: Int?
    let freeTrialDays: Int
    let planType: PlanType
    let accessFlags: AccessFlags
    let featureLines: [String]
    let isBestValue: Bool
    let displayOrder: Int
    let isActive: Bool

    enum PlanType: String, Codable, Sendable {
        case subscription
        case oneTimeAttraction = "one_time_attraction"
    }

    struct AccessFlags: Codable, Sendable {
        var audioGuides: Bool
        var textContent: Bool
        var visitorTips: Bool

        static let none = AccessFlags(audioGuides: false, textContent: false, visitorTips: false)

        init(audioGuides: Bool, textContent: Bool, visitorTips: Bool) {
            self.audioGuides = audioGuides
            self.textContent = textContent
            self.visitorTips = visitorTips
        }

        // camelCase keys — Supabase decoder uses .convertFromSnakeCase (audio_guides
        // → audioGuides). decodeIfPresent makes this tolerant of missing/legacy keys
        // (e.g. the removed offline_download / ai_advanced still present in old rows).
        enum CodingKeys: String, CodingKey {
            case audioGuides, textContent, visitorTips
        }

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            audioGuides = try c.decodeIfPresent(Bool.self, forKey: .audioGuides) ?? false
            textContent = try c.decodeIfPresent(Bool.self, forKey: .textContent) ?? false
            visitorTips = try c.decodeIfPresent(Bool.self, forKey: .visitorTips) ?? false
        }
    }

    // camelCase keys — Supabase decoder uses .convertFromSnakeCase (snake→camel).
    // Writing snake_case raw values here would break decoding (fields read as nil).
    enum CodingKeys: String, CodingKey {
        case id
        case rcPackageId
        case appleProductId
        case nameEn
        case nameZh
        case priceLabel
        case durationDays
        case freeTrialDays
        case planType
        case accessFlags
        case featureLines
        case isBestValue
        case displayOrder
        case isActive
    }

    // Memberwise initializer (used by bundled fallback plans)
    init(
        id: String, rcPackageId: String?, appleProductId: String,
        nameEn: String, nameZh: String?, priceLabel: String,
        durationDays: Int?, freeTrialDays: Int, planType: PlanType,
        accessFlags: AccessFlags, featureLines: [String],
        isBestValue: Bool, displayOrder: Int, isActive: Bool
    ) {
        self.id = id
        self.rcPackageId = rcPackageId
        self.appleProductId = appleProductId
        self.nameEn = nameEn
        self.nameZh = nameZh
        self.priceLabel = priceLabel
        self.durationDays = durationDays
        self.freeTrialDays = freeTrialDays
        self.planType = planType
        self.accessFlags = accessFlags
        self.featureLines = featureLines
        self.isBestValue = isBestValue
        self.displayOrder = displayOrder
        self.isActive = isActive
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        rcPackageId = try c.decodeIfPresent(String.self, forKey: .rcPackageId)
        appleProductId = try c.decode(String.self, forKey: .appleProductId)
        nameEn = try c.decode(String.self, forKey: .nameEn)
        nameZh = try c.decodeIfPresent(String.self, forKey: .nameZh)
        priceLabel = try c.decodeIfPresent(String.self, forKey: .priceLabel) ?? ""
        durationDays = try c.decodeIfPresent(Int.self, forKey: .durationDays)
        freeTrialDays = try c.decodeIfPresent(Int.self, forKey: .freeTrialDays) ?? 0
        planType = try c.decodeIfPresent(PlanType.self, forKey: .planType) ?? .subscription
        accessFlags = try c.decodeIfPresent(AccessFlags.self, forKey: .accessFlags) ?? .none
        featureLines = try c.decodeIfPresent([String].self, forKey: .featureLines) ?? []
        isBestValue = try c.decodeIfPresent(Bool.self, forKey: .isBestValue) ?? false
        displayOrder = try c.decodeIfPresent(Int.self, forKey: .displayOrder) ?? 0
        isActive = try c.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
    }
}

extension MembershipPlan {
    /// Display name preferring the app language.
    func localizedName(preferChinese: Bool) -> String {
        if preferChinese, let zh = nameZh, !zh.isEmpty { return zh }
        return nameEn
    }
}
