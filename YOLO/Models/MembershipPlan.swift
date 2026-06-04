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
        var offlineDownload: Bool
        var visitorTips: Bool
        var aiAdvanced: Bool

        static let none = AccessFlags(
            audioGuides: false,
            textContent: false,
            offlineDownload: false,
            visitorTips: false,
            aiAdvanced: false
        )

        enum CodingKeys: String, CodingKey {
            case audioGuides = "audio_guides"
            case textContent = "text_content"
            case offlineDownload = "offline_download"
            case visitorTips = "visitor_tips"
            case aiAdvanced = "ai_advanced"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case rcPackageId = "rc_package_id"
        case appleProductId = "apple_product_id"
        case nameEn = "name_en"
        case nameZh = "name_zh"
        case priceLabel = "price_label"
        case durationDays = "duration_days"
        case freeTrialDays = "free_trial_days"
        case planType = "plan_type"
        case accessFlags = "access_flags"
        case featureLines = "feature_lines"
        case isBestValue = "is_best_value"
        case displayOrder = "display_order"
        case isActive = "is_active"
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
