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
