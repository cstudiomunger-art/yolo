import Foundation

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
