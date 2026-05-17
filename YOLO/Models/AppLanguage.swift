import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case english = "en"
    case chinese = "zh-Hans"

    var id: String { rawValue }

    var locale: Locale { Locale(identifier: rawValue) }

    /// Native name shown in the language picker (not localized).
    var displayName: String {
        switch self {
        case .english: "English"
        case .chinese: "中文"
        }
    }

    static func resolved(fromStoredValue stored: String?) -> AppLanguage {
        if let stored, let language = AppLanguage(rawValue: stored) {
            return language
        }
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return code.hasPrefix("zh") ? .chinese : .english
    }
}
