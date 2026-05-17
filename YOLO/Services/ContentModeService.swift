import Foundation
import Observation
import Supabase

enum ContentBackend: Equatable {
    case bundled
    case remote
}

@Observable
final class ContentModeService {
    private enum Keys {
        static let cachedSettings = "chinago.cachedAppSettings"
    }

    private(set) var backend: ContentBackend = .bundled
    private(set) var useRemoteContent = false
    private(set) var useRemoteAI = false
    private(set) var useRemoteIAP = false
    private(set) var branding: AppBranding = .fallback
    private(set) var isRefreshing = false
    private(set) var lastRefreshError: String?

    var contentModeLabel: String {
        switch backend {
        case .bundled: String(localized: "Static Demo")
        case .remote: String(localized: "Live Services")
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
            restoreCachedOrBundled()
        }
    }

    func refreshBranding(from content: any ContentRepositoryProtocol) async {
        branding = (try? await content.fetchAppBranding()) ?? .fallback
    }

    private func apply(remote settings: AppSettingsRemote) {
        useRemoteContent = settings.useRemoteContent
        useRemoteAI = settings.useRemoteAI
        useRemoteIAP = settings.useRemoteIAP
        branding = settings.resolvedBranding
        backend = settings.useRemoteContent ? .remote : .bundled
    }

    private func applyBundledDefaults() {
        useRemoteContent = false
        useRemoteAI = false
        useRemoteIAP = false
        backend = .bundled
        branding = (try? BundledJSONLoader.load(AppBranding.self, resource: "app_branding")) ?? .fallback
        if AppConfig.forceBundled {
            lastRefreshError = "当前为静态演示模式（FORCE_BUNDLED / Mock）。请在 Secrets.xcconfig 关闭 USE_MOCK 与 FORCE_BUNDLED。"
        }
    }

    func clearCachedSettings() {
        UserDefaults.standard.removeObject(forKey: Keys.cachedSettings)
    }

    private func restoreCachedOrBundled() {
        if let data = UserDefaults.standard.data(forKey: Keys.cachedSettings),
           let cached = try? JSONCoding.makeDecoder().decode(AppSettingsRemote.self, from: data) {
            apply(remote: cached)
        } else {
            clearCachedSettings()
            applyBundledDefaults()
        }
    }

    private func cacheSettings(_ settings: AppSettingsRemote) {
        if let data = try? JSONCoding.makeEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: Keys.cachedSettings)
        }
    }

    private static func describeFetchError(_ error: Error) -> String {
        if error is DecodingError {
            return "CMS 配置解析失败：\(JSONCoding.describe(error))。请在 Supabase 执行 011_app_branding_and_assistant_chips.sql 后重试。"
        }
        let message = error.localizedDescription
        if message.contains("数据缺失") || message.localizedCaseInsensitiveContains("missing") {
            return "CMS 配置解析失败（\(message)）。请确认已执行迁移 001、003、011，且 app_settings 存在 global 行。"
        }
        return message
    }
}
