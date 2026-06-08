import Foundation
import Observation
import Supabase

@Observable
@MainActor
final class AppEnvironment {
    let auth: AuthSessionStore
    let contentMode: ContentModeService
    let preferences: UserPreferencesStore
    let navigation: AppNavigation
    let profileSync: ProfileSyncService
    let purchase: PurchaseService
    /// Single, app-wide audio player shared by every guide section and the floating mini-player.
    let audioPlayer = AudioQueuePlayer()
    private(set) var content: any ContentRepositoryProtocol
    /// 内容源或 CMS 配置变更时递增，用于驱动各 Tab 重新加载远程数据。
    private(set) var contentRevision = 0

    @ObservationIgnored private var contentRefreshTask: Task<Void, Never>?

    init(
        contentMode: ContentModeService? = nil,
        preferences: UserPreferencesStore? = nil,
        navigation: AppNavigation? = nil,
        profileSync: ProfileSyncService? = nil
    ) {
        let resolvedContentMode = contentMode ?? ContentModeService()
        let resolvedPreferences = preferences ?? UserPreferencesStore()
        let resolvedNavigation = navigation ?? AppNavigation()
        self.auth = AuthSessionStore()
        self.contentMode = resolvedContentMode
        self.preferences = resolvedPreferences
        self.navigation = resolvedNavigation
        let resolvedSync = profileSync ?? ProfileSyncService()
        self.profileSync = resolvedSync
        self.purchase = PurchaseService()
        self.content = BundledContentRepository()
        resolvedSync.bind(preferences: resolvedPreferences, auth: auth)
        purchase.bind(preferences: resolvedPreferences, auth: auth, profileSync: resolvedSync)
        bindAudioPlayer()
        resolvedPreferences.onSyncableChange = { [weak self] in
            guard let self else { return }
            Task { await self.profileSync.schedulePush() }
        }
        resolvedPreferences.onChecklistStatusChanged = { [weak self] itemId, type, status in
            guard let self else { return }
            Task { await self.profileSync.syncChecklistStatus(itemId: itemId, type: type, status: status) }
        }
        resolvedPreferences.onItineraryDeleted = { [weak self] tripId in
            guard let self else { return }
            Task { await self.profileSync.syncItineraryDeleted(id: tripId) }
        }
        resolvedPreferences.onItinerarySaved = { [weak self] in
            guard let self else { return }
            Task {
                await self.profileSync.syncItineraries()
                await self.rescheduleTripReminders()
            }
        }
    }

    /// Wire the shared audio player so it can re-resolve per-track access (member / single /
    /// parent purchase) and read the free-preview length from branding. Mirrors the access
    /// logic in `AudioGuideSection.hasFullAccess`.
    private func bindAudioPlayer() {
        audioPlayer.resolveAccess = { [weak self] track in
            guard let self else { return (hasFullAccess: true, freeTrialSeconds: 0) }
            if track.isFree || !self.contentMode.effectiveUseRemoteIAP {
                return (hasFullAccess: true, freeTrialSeconds: .greatestFiniteMagnitude)
            }
            let hasAccess: Bool
            if let sub = track.subArea {
                hasAccess = self.purchase.hasContentAccess(
                    \.audioGuides,
                    requiresPurchase: sub.requiresPurchase,
                    contentId: sub.id,
                    parentId: sub.attractionId
                )
            } else if let attraction = track.attraction {
                hasAccess = self.purchase.hasContentAccess(
                    \.audioGuides,
                    requiresPurchase: attraction.requiresPurchase,
                    contentId: attraction.id
                )
            } else {
                hasAccess = false
            }
            let trial = track.allowsPreview ? Double(self.contentMode.branding.freeAudioPreviewSeconds) : 0
            return (hasFullAccess: hasAccess, freeTrialSeconds: trial)
        }
    }

    func deleteAccount() async throws {
        try await AccountDeletionService.deleteCurrentAccount()
        TelemetryService.shared.logEvent("account_deleted")
        await signOutAndReset()
    }

    func rescheduleTripReminders() async {
        let active = preferences.activeItinerary
        await TripReminderService.reschedule(
            itinerary: active,
            departureDate: preferences.departureDate,
            remindersEnabled: PrepReminderService.tripRemindersEnabled
        )
    }

    func handleIncomingURL(_ url: URL) async {
        guard let action = DeepLinkHandler.action(for: url) else { return }
        switch action {
        case .openSharedItinerary(let slug):
            navigation.openSharedItinerary(slug: slug)
        case .passwordRecovery:
            do {
                _ = try await SupabaseManager.shared.auth.session(from: url)
                auth.markPasswordRecoveryPending()
            } catch {
                TelemetryService.shared.recordError(error, context: "password_recovery_link")
            }
        case .emailConfirmation:
            do {
                _ = try await SupabaseManager.shared.auth.session(from: url)
                TelemetryService.shared.logEvent("email_confirmed")
                await profileSync.syncAfterSignIn()
            } catch {
                TelemetryService.shared.recordError(error, context: "email_confirmation_link")
            }
        }
    }

    func signOutAndReset() async {
        audioPlayer.close()
        await profileSync.syncItineraries()
        await purchase.logout()
        try? await auth.signOut()
        preferences.resetAll()
        contentMode.clearCachedSettings()
        await invalidateOfflineCaches()
        navigation.reset()
        await refreshContentMode(clearSettingsCache: false)
    }

    func syncAfterSignIn() async {
        if let userId = auth.userId {
            await purchase.login(userId: userId)
        }
        await profileSync.syncAfterSignIn()
        await purchase.loadPlans()
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
        contentRefreshTask?.cancel()
        let task = Task {
            if clearSettingsCache {
                contentMode.clearCachedSettings()
                await invalidateOfflineCaches()
            }
            guard !Task.isCancelled else { return }
            let previousBackend = contentMode.backend
            await contentMode.refreshFromRemote()
            guard !Task.isCancelled else { return }
            reloadRepositories()
            await contentMode.refreshBranding(from: content)
            if contentMode.backend != previousBackend {
                await invalidateOfflineCaches()
                contentRevision += 1
            }
            await refreshVisaRule()
        }
        contentRefreshTask = task
        await task.value
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
}
