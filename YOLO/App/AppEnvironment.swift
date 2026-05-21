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
        preferences.onSyncableChange = { [weak self] in
            guard let self else { return }
            Task { await self.profileSync.schedulePush() }
        }
        preferences.onChecklistToggled = { [weak self] itemId, isDone in
            guard let self else { return }
            Task { await self.profileSync.syncChecklistToggle(itemId: itemId, isDone: isDone) }
        }
        preferences.onItineraryDeleted = { [weak self] tripId in
            guard let self else { return }
            Task { await self.profileSync.syncItineraryDeleted(id: tripId) }
        }
        preferences.onItinerarySaved = { [weak self] in
            guard let self else { return }
            Task { await self.profileSync.pushItinerariesNow() }
        }
    }

    func signOutAndReset() async {
        await profileSync.pushToRemote()
        try? await auth.signOut()
        preferences.resetAll()
        contentMode.clearCachedSettings()
        await invalidateOfflineCaches()
        navigation.reset()
        await refreshContentMode(clearSettingsCache: false)
    }

    func reloadRepositories() {
        switch contentMode.backend {
        case .bundled:
            content = BundledContentRepository()
        case .remote:
            content = CachingContentRepository()
        }
    }

    func refreshContentMode(clearSettingsCache: Bool = false) async {
        if clearSettingsCache {
            contentMode.clearCachedSettings()
            await invalidateOfflineCaches()
        }
        let previousBackend = contentMode.backend
        await contentMode.refreshFromRemote()
        reloadRepositories()
        await contentMode.refreshBranding(from: content)
        // Only remount tab roots when bundled ↔ remote switches (avoids breaking TextField focus).
        if contentMode.backend != previousBackend {
            await invalidateOfflineCaches()
            contentRevision += 1
        }
        await refreshVisaRule()
        await seedDefaultItineraryIfNeeded()
    }

    func invalidateOfflineCaches() async {
        await ContentCacheStore.shared.removeAll()
        await ImageCacheService.shared.removeAll()
        OfflineCacheLocations.clearPersistentURLCache()
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
        guard auth.isAuthenticated || AppConfig.useMock else { return }
        guard preferences.savedItineraries.isEmpty else { return }
        if let sample = try? await content.fetchSampleItinerary() {
            preferences.saveItinerary(sample)
        }
    }
}
