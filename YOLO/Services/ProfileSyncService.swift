import Foundation
import Observation

@Observable
@MainActor
final class ProfileSyncService {
    private let repository = ProfileRepository()
    private let itineraryRepository = ItineraryRepository()
    private let checklistRepository = ChecklistCompletionRepository()
    private weak var preferences: UserPreferencesStore?
    private weak var auth: AuthSessionStore?

    private(set) var lastSyncError: String?
    private(set) var isSyncing = false

    @ObservationIgnored
    private var scheduledPushTask: Task<Void, Never>?

    func bind(preferences: UserPreferencesStore, auth: AuthSessionStore) {
        self.preferences = preferences
        self.auth = auth
    }

    /// Debounced upload after local profile fields change.
    func schedulePush() {
        scheduledPushTask?.cancel()
        scheduledPushTask = Task {
            try? await Task.sleep(for: .milliseconds(600))
            guard !Task.isCancelled else { return }
            await pushToRemote()
        }
    }

    func syncAfterSignIn() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        isSyncing = true
        lastSyncError = nil
        defer { isSyncing = false }

        do {
            var profileActiveItineraryId: String?
            if let remote = try await repository.fetch(userId: userId) {
                profileActiveItineraryId = remote.activeItineraryId
                if remote.hasCompletedOnboarding {
                    preferences.applyRemoteProfile(remote)
                } else if preferences.hasCompletedOnboarding {
                    try await repository.upsert(preferences.makeProfileRow(userId: userId, email: auth.userEmail))
                }
            } else if preferences.hasCompletedOnboarding {
                try await repository.upsert(preferences.makeProfileRow(userId: userId, email: auth.userEmail))
            }

            try await pullItineraries(userId: userId, preferences: preferences)
            applyActiveItineraryFromProfile(profileActiveItineraryId)
            try await pullChecklistCompletion(userId: userId, preferences: preferences)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    func pushToRemote() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard !preferences.needsNationalityOnboarding else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        isSyncing = true
        lastSyncError = nil
        defer { isSyncing = false }

        do {
            try await repository.upsert(preferences.makeProfileRow(userId: userId, email: auth.userEmail))
            try await pushItineraries(userId: userId, preferences: preferences)
            try await pushChecklistCompletion(userId: userId, preferences: preferences)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    // MARK: - Itineraries (021)

    private func pullItineraries(userId: UUID, preferences: UserPreferencesStore) async throws {
        let remoteRows = try await itineraryRepository.fetchAll(userId: userId)
        let remoteTrips = remoteRows.map(\.asSampleItinerary)

        if remoteTrips.isEmpty, !preferences.savedItineraries.isEmpty {
            for trip in preferences.savedItineraries {
                try await itineraryRepository.upsert(UserItineraryRow.from(trip: trip, userId: userId))
            }
            return
        }

        if !remoteTrips.isEmpty {
            let merged = mergeItineraries(
                local: preferences.savedItineraries,
                remote: remoteTrips
            )
            let activeId = preferences.activeItineraryId ?? merged.first?.id
            preferences.applyRemoteItineraries(merged, activeId: activeId)
        }
    }

    /// Merges remote rows with local-only trips that have not been uploaded yet.
    private func mergeItineraries(local: [SampleItinerary], remote: [SampleItinerary]) -> [SampleItinerary] {
        var byId = Dictionary(uniqueKeysWithValues: remote.map { ($0.id, $0) })
        for trip in local where byId[trip.id] == nil {
            byId[trip.id] = trip
        }
        let remoteIds = remote.map(\.id)
        let localOnly = local.filter { !remoteIds.contains($0.id) }
        return remote + localOnly
    }

    func refreshItinerariesFromRemote() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }
        do {
            try await pullItineraries(userId: userId, preferences: preferences)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    func pushItinerariesNow() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }
        do {
            try await pushItineraries(userId: userId, preferences: preferences)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    /// Applies `active_itinerary_id` from profiles after trips were loaded from `user_itineraries`.
    func applyActiveItineraryFromProfile(_ activeId: String?) {
        guard let preferences, let activeId else { return }
        if preferences.savedItineraries.contains(where: { $0.id == activeId }) {
            preferences.activeItineraryId = activeId
        }
    }

    private func pushItineraries(userId: UUID, preferences: UserPreferencesStore) async throws {
        for trip in preferences.savedItineraries {
            try await itineraryRepository.upsert(UserItineraryRow.from(trip: trip, userId: userId))
        }
    }

    func syncItineraryDeleted(id: String) async {
        guard let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }
        do {
            try await itineraryRepository.markDeleted(id: id, userId: userId)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    // MARK: - Checklist completion (020)

    private func pullChecklistCompletion(userId: UUID, preferences: UserPreferencesStore) async throws {
        let rows = try await checklistRepository.fetchAll(userId: userId)
        let itineraryKey = preferences.activeItineraryId
        let doneIds = rows.filter { row in
            guard row.status == "done" else { return false }
            guard let tripId = row.itineraryId, !tripId.isEmpty else { return true }
            guard let active = itineraryKey else { return true }
            return tripId == active
        }.map(\.checklistItemId)
        if !doneIds.isEmpty {
            preferences.completedChecklistIds.formUnion(doneIds)
        }
    }

    private func pushChecklistCompletion(userId: UUID, preferences: UserPreferencesStore) async throws {
        let itineraryId = preferences.activeItineraryId
        for itemId in preferences.completedChecklistIds {
            try await checklistRepository.setStatus(
                userId: userId,
                checklistItemId: itemId,
                itineraryId: itineraryId,
                status: "done"
            )
        }
    }

    func syncChecklistToggle(itemId: String, isDone: Bool) async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }
        do {
            try await checklistRepository.setStatus(
                userId: userId,
                checklistItemId: itemId,
                itineraryId: preferences.activeItineraryId,
                status: isDone ? "done" : "pending"
            )
        } catch {
            lastSyncError = error.localizedDescription
        }
    }
}
