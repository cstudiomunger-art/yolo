import Foundation

struct MembershipPlan: Identifiable, Codable, Sendable {
    let id: String
    let rcPackageId: String?
    let appleProductId: String
    let nameEn: String
    let nameZh: String?
    let priceLabel: String
    let durationDays: Int?
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
        case planType = "plan_type"
        case accessFlags = "access_flags"
        case featureLines = "feature_lines"
        case isBestValue = "is_best_value"
        case displayOrder = "display_order"
        case isActive = "is_active"
    }
}

extension MembershipPlan {
    /// Display name preferring the app language.
    func localizedName(preferChinese: Bool) -> String {
        if preferChinese, let zh = nameZh, !zh.isEmpty { return zh }
        return nameEn
    }
}
