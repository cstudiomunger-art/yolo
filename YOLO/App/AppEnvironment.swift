import Foundation
import Observation

@Observable
@MainActor
final class AppEnvironment {
    let auth: AuthSessionStore
    let contentMode: ContentModeService
    let preferences: UserPreferencesStore
    let navigation: AppNavigation
    let profileSync: ProfileSyncService
    private(set) var content: any ContentRepositoryProtocol
    /// 内容源或 CMS 配置变更时递增，用于驱动各 Tab 重新加载远程数据。
    private(set) var contentRevision = 0

    init(
        contentMode: ContentModeService = ContentModeService(),
        preferences: UserPreferencesStore = UserPreferencesStore(),
        navigation: AppNavigation = AppNavigation(),
        profileSync: ProfileSyncService? = nil
    ) {
        self.auth = AuthSessionStore()
        self.contentMode = contentMode
        self.preferences = preferences
        self.navigation = navigation
        self.profileSync = profileSync ?? ProfileSyncService()
        self.content = BundledContentRepository()
        self.profileSync.bind(preferences: preferences, auth: auth)
    }

    func reloadRepositories() {
        switch contentMode.backend {
        case .bundled:
            content = BundledContentRepository()
        case .remote:
            content = RemoteContentRepository()
        }
    }

    func refreshContentMode(clearSettingsCache: Bool = false) async {
        if clearSettingsCache {
            contentMode.clearCachedSettings()
        }
        await contentMode.refreshFromRemote()
        reloadRepositories()
        await contentMode.refreshBranding(from: content)
        contentRevision += 1
        await refreshVisaRule()
        await seedDefaultItineraryIfNeeded()
    }

    func refreshVisaRule() async {
        guard !preferences.countryCode.isEmpty else {
            preferences.cachedVisaRule = nil
            return
        }
        preferences.cachedVisaRule = try? await content.fetchVisaRule(
            countryCode: preferences.countryCode
        )
    }

    private func seedDefaultItineraryIfNeeded() async {
        guard preferences.savedItineraries.isEmpty else { return }
        if let sample = try? await content.fetchSampleItinerary() {
            preferences.saveItinerary(sample)
        }
    }
}
