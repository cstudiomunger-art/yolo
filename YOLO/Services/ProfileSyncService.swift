import Foundation
import Observation

@Observable
@MainActor
final class ProfileSyncService {
    private let repository = ProfileRepository()
    private weak var preferences: UserPreferencesStore?
    private weak var auth: AuthSessionStore?

    private(set) var lastSyncError: String?
    private(set) var isSyncing = false

    func bind(preferences: UserPreferencesStore, auth: AuthSessionStore) {
        self.preferences = preferences
        self.auth = auth
    }

    func syncAfterSignIn() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        isSyncing = true
        lastSyncError = nil
        defer { isSyncing = false }

        do {
            if let remote = try await repository.fetch(userId: userId) {
                if remote.hasCompletedOnboarding {
                    preferences.applyRemoteProfile(remote)
                } else if preferences.hasCompletedOnboarding {
                    try await repository.upsert(preferences.makeProfileRow(userId: userId, email: auth.userEmail))
                }
            } else if preferences.hasCompletedOnboarding {
                try await repository.upsert(preferences.makeProfileRow(userId: userId, email: auth.userEmail))
            }
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    func pushToRemote() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        isSyncing = true
        lastSyncError = nil
        defer { isSyncing = false }

        do {
            try await repository.upsert(preferences.makeProfileRow(userId: userId, email: auth.userEmail))
        } catch {
            lastSyncError = error.localizedDescription
        }
    }
}
