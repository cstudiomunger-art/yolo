import Foundation
import Observation
import Supabase

enum ContentBackend: Equatable {
    case bundled
    case remote
}

@Observable
final class ContentModeService {
    private typealias Keys = UserDefaultsKeys

    private(set) var backend: ContentBackend = .bundled
    private(set) var useRemoteContent = false
    /// CMS flag; use `effectiveUseRemoteAI` for invocation decisions.
    private(set) var useRemoteAI = false

    /// Default-on: call VolcEngine whenever Supabase is configured (unless FORCE_BUNDLED / Mock).
    var effectiveUseRemoteAI: Bool {
        AppConfig.isSupabaseConfigured && !AppConfig.forceBundled
    }
    private(set) var useRemoteIAP = false
    private(set) var branding: AppBranding = .fallback
    private(set) var aiSettings: AISettings = .fallback
    private(set) var isRefreshing = false
    private(set) var lastRefreshError: String?

    var contentModeLabel: String {
        if !effectiveUseRemoteAI {
            return String(localized: "Static Demo")
        }
        switch backend {
        case .bundled:
            return String(localized: "Static · AI")
        case .remote:
            return String(localized: "Live · AI")
        }
    }

    func refreshFromRemote() async {
        if AppConfig.forceBundled {
            applyBundledDefaults()
            return
        }

        isRefreshing = true
        lastRefreshError = nil
        defer { isRefreshing = false }

        guard AppConfig.isSupabaseConfigured else {
            lastRefreshError = "未配置 Supabase URL / Anon Key（检查 Secrets.xcconfig）"
            restoreCachedOrBundled()
            return
        }

        do {
            let rows: [AppSettingsRow] = try await SupabaseManager.shared
                .from("app_settings")
                .select()
                .eq("id", value: "global")
                .limit(1)
                .execute()
                .value

            guard let row = rows.first else {
                lastRefreshError =
                    "Supabase 中缺少 app_settings（id=global）。请在 SQL Editor 执行 001 与 003 迁移。"
                restoreCachedOrBundled()
                return
            }

            apply(remote: row.asSettings)
            cacheSettings(row.asSettings)
            lastRefreshError = nil
        } catch {
            lastRefreshError = Self.describeFetchError(error)
            if await applyFlagsFallback() {
                lastRefreshError = (lastRefreshError ?? "") + "（已用精简字段恢复开关）"
            } else {
                restoreCachedOrBundled()
            }
        }
    }

    func refreshBranding(from content: any ContentRepositoryProtocol) async {
        branding = (try? await content.fetchAppBranding()) ?? .fallback
    }

    private func apply(remote settings: AppSettingsRemote) {
        useRemoteContent = settings.useRemoteContent
        useRemoteIAP = settings.useRemoteIAP
        branding = settings.resolvedBranding
        aiSettings = settings.resolvedAI
        backend = settings.useRemoteContent ? .remote : .bundled
        useRemoteAI = Self.defaultRemoteAIEnabled
    }

    private func applyBundledDefaults() {
        useRemoteContent = false
        useRemoteIAP = false
        backend = .bundled
        useRemoteAI = false
        branding = (try? BundledJSONLoader.load(AppBranding.self, resource: "app_branding")) ?? .fallback
        aiSettings = .fallback
        if AppConfig.forceBundled {
            lastRefreshError = "当前为静态演示模式（FORCE_BUNDLED / Mock）。请在 Secrets.xcconfig 关闭 USE_MOCK 与 FORCE_BUNDLED。"
        }
    }

    func clearCachedSettings() {
        for key in [
            Keys.cachedAppSettings,
            "yolohappy.cachedAppSettings.v5",
            "chinago.cachedAppSettings.v5",
            "chinago.cachedAppSettings.v4",
            "chinago.cachedAppSettings.v2",
            "chinago.cachedAppSettings",
        ] {
            UserDefaults.standard.removeObject(forKey: key)
        }
        OfflineCacheLocations.clearAppSettingsFile()
    }

    private func restoreCachedOrBundled() {
        if let cached = loadSettingsFromDisk() {
            apply(remote: cached)
            return
        }
        if let data = UserDefaults.standard.data(forKey: Keys.cachedAppSettings),
           let cached = try? JSONCoding.makeDecoder().decode(AppSettingsRemote.self, from: data) {
            apply(remote: cached)
            saveSettingsToDisk(cached)
        } else {
            clearCachedSettings()
            applyBundledDefaults()
        }
    }

    private func cacheSettings(_ settings: AppSettingsRemote) {
        if let data = try? JSONCoding.makeEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: Keys.cachedAppSettings)
        }
        saveSettingsToDisk(settings)
    }

    private func loadSettingsFromDisk() -> AppSettingsRemote? {
        let url = OfflineCacheLocations.appSettingsFile
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONCoding.makeDecoder().decode(AppSettingsRemote.self, from: data)
    }

    private func saveSettingsToDisk(_ settings: AppSettingsRemote) {
        let url = OfflineCacheLocations.appSettingsFile
        let parent = url.deletingLastPathComponent()
        OfflineCacheLocations.ensureDirectory(parent)
        guard let data = try? JSONCoding.makeEncoder().encode(settings) else { return }
        try? data.write(to: url, options: .atomic)
    }

    /// Minimal fetch when full row decode fails (e.g. schema drift).
    private func applyFlagsFallback() async -> Bool {
        struct FlagsRow: Decodable {
            let useRemoteContent: Bool
            let useRemoteAi: Bool
            let useRemoteIap: Bool
        }
        do {
            let rows: [FlagsRow] = try await SupabaseManager.shared
                .from("app_settings")
                .select("use_remote_content, use_remote_ai, use_remote_iap")
                .eq("id", value: "global")
                .limit(1)
                .execute()
                .value
            guard let row = rows.first else { return false }
            useRemoteContent = row.useRemoteContent
            useRemoteIAP = row.useRemoteIap
            backend = row.useRemoteContent ? .remote : .bundled
            useRemoteAI = Self.defaultRemoteAIEnabled
            return true
        } catch {
            return false
        }
    }

    private static var defaultRemoteAIEnabled: Bool {
        AppConfig.isSupabaseConfigured && !AppConfig.forceBundled
    }

    private static func describeFetchError(_ error: Error) -> String {
        if error is DecodingError {
            return "CMS 配置解析失败：\(JSONCoding.describe(error))。请在 Supabase 执行 011、016 迁移后重试。"
        }
        let message = error.localizedDescription
        if message.contains("数据缺失") || message.localizedCaseInsensitiveContains("missing") {
            return "CMS 配置解析失败（\(message)）。请确认已执行迁移 001、003、011，且 app_settings 存在 global 行。"
        }
        return message
    }
}
