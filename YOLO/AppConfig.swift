import Foundation

enum AppConfig {
    static var isSupabaseConfigured: Bool {
        guard let raw = plistString(forKey: "SUPABASE_URL"),
              !raw.isEmpty,
              URL(string: raw) != nil,
              let key = plistString(forKey: "SUPABASE_ANON_KEY"),
              !key.isEmpty
        else {
            return false
        }
        return true
    }

    static var supabaseURL: URL {
        guard let raw = plistString(forKey: "SUPABASE_URL"),
              let url = URL(string: raw)
        else {
            fatalError("在 Secrets.xcconfig 中配置 SUPABASE_URL")
        }
        return url
    }

    static var supabaseAnonKey: String {
        guard let key = plistString(forKey: "SUPABASE_ANON_KEY"), !key.isEmpty else {
            fatalError("在 Secrets.xcconfig 中配置 SUPABASE_ANON_KEY")
        }
        return key
    }

    /// 遗留开关：未配置 Supabase 时等同强制静态模式。
    static var useMock: Bool {
        if plistBool(forKey: "USE_MOCK") == true { return true }
        if plistBool(forKey: "USE_MOCK") == false { return false }
        return !isSupabaseConfigured
    }

    /// 为 true 时忽略 Supabase `app_settings`，始终使用内置 JSON。
    static var forceBundled: Bool {
        if forceBundledPlist { return true }
        if plistBool(forKey: "USE_MOCK") == true { return true }
        return false
    }

    private static func plistString(forKey key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else { return nil }
        if let string = value as? String { return string }
        if let number = value as? NSNumber { return number.stringValue }
        return nil
    }

    static var forceBundledPlist: Bool {
        plistBool(forKey: "FORCE_BUNDLED") == true
    }

    private static func plistBool(forKey key: String) -> Bool? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else { return nil }
        if let bool = value as? Bool { return bool }
        if let string = value as? String {
            switch string.lowercased() {
            case "true", "yes", "1": return true
            case "false", "no", "0": return false
            default: return nil
            }
        }
        return nil
    }
}
