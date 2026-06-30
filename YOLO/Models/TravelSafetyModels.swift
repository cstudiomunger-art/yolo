import Foundation

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

struct CityHospital: Identifiable, Codable, Hashable {
    let id: String
    let cityId: String
    let nameEn: String
    let nameZh: String
    let phone: String
    let addressEn: String
    let addressZh: String
    let hasInternationalDept: Bool
    let note: String
    let sortOrder: Int

    var displayName: String {
        let en = nameEn.trimmingCharacters(in: .whitespacesAndNewlines)
        let zh = nameZh.trimmingCharacters(in: .whitespacesAndNewlines)
        if !en.isEmpty, !zh.isEmpty, en != zh { return "\(en) · \(zh)" }
        if !en.isEmpty { return en }
        return zh
    }

    var displayAddress: String? {
        let en = addressEn.trimmingCharacters(in: .whitespacesAndNewlines)
        let zh = addressZh.trimmingCharacters(in: .whitespacesAndNewlines)
        if !en.isEmpty, !zh.isEmpty, en != zh { return "\(en) · \(zh)" }
        if !en.isEmpty { return en }
        if !zh.isEmpty { return zh }
        return nil
    }
}

struct CityEmbassy: Identifiable, Codable, Hashable {
    let id: String
    let cityId: String
    let countryCode: String
    let locationLabel: String
    let embassyPhone: String
    let consularHotline: String
    let sortOrder: Int

    var normalizedCountryCode: String { countryCode.uppercased() }
}

struct EmergencyGuide: Identifiable, Codable, Hashable {
    let id: String
    let kind: String
    let number: String?
    let titleEn: String?
    let titleZh: String?
    let bodyEn: String?
    let bodyZh: String?
    let sortOrder: Int?

    var displayTitle: String {
        let en = titleEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let zh = titleZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !en.isEmpty { return en }
        if !zh.isEmpty { return zh }
        return id
    }

    var displayBodyHTML: String {
        let en = bodyEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let zh = bodyZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !en.isEmpty { return en }
        return zh
    }

    var isConsular: Bool { kind == "consular" }
}
