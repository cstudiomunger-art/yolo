import Foundation
import Observation

@Observable
@MainActor
final class ProfileSyncService {
    private let repository = ProfileRepository()
    private let itineraryRepository = ItineraryRepository()
    private let checklistRepository = ChecklistCompletionRepository()
    private let favoriteRepository = FavoriteAttractionRepository()
    private weak var preferences: UserPreferencesStore?
    private weak var auth: AuthSessionStore?

    private(set) var lastSyncError: String?
    private(set) var isSyncing = false

    @ObservationIgnored
    private var scheduledPushTask: Task<Void, Never>?

    @ObservationIgnored
    private var itinerarySyncTask: Task<Void, Error>?

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
            preferences.setStorageUserId(userId)

            var profileActiveItineraryId: String?
            if let remote = try await repository.fetch(userId: userId) {
                profileActiveItineraryId = remote.activeItineraryId
                if remote.hasCompletedOnboarding {
                    preferences.applyRemoteProfile(remote)
                } else if preferences.hasCompletedOnboarding {
                    try await repository.upsertClientProfile(preferences.makeClientPushRow(userId: userId, email: auth.userEmail))
                }
            } else if preferences.hasCompletedOnboarding {
                try await repository.upsertClientProfile(preferences.makeClientPushRow(userId: userId, email: auth.userEmail))
            }

            try await runItinerarySync {
                try await self.bidirectionalItinerarySync(userId: userId, preferences: preferences)
            }
            applyActiveItineraryFromProfile(profileActiveItineraryId)
            try await pullChecklistCompletion(userId: userId, preferences: preferences)
            try await bidirectionalFavoriteSync(userId: userId, preferences: preferences)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    /// Pulls admin membership override (and purchased attractions) from Supabase.
    /// Lightweight — call on foreground so ban/grant changes take effect without re-login.
    func refreshRemoteMembershipState() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        do {
            guard let remote = try await repository.fetch(userId: userId) else { return }
            preferences.applyRemoteMembershipOverride(remote)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    /// Push RevenueCat subscription state to Supabase for admin display.
    /// Bypasses nationality-onboarding guard — membership sync must not be blocked by onboarding.
    func pushMembershipMirrorToRemote() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        do {
            try await repository.patchMembershipMirror(
                userId: userId,
                planId: preferences.subscriptionPlanId,
                expiresAt: preferences.subscriptionExpiresAt.map { UserPreferencesStore.formatISO8601ForSync($0) },
                rcCustomerId: userId.uuidString
            )
            lastSyncError = nil
        } catch {
            lastSyncError = error.localizedDescription
            TelemetryService.shared.recordError(error, context: "membership_mirror_push")
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
            try await repository.upsertClientProfile(preferences.makeClientPushRow(userId: userId, email: auth.userEmail))
            try await runItinerarySync {
                try await self.pushItineraries(userId: userId, preferences: preferences)
            }
            try await pushChecklistCompletion(userId: userId, preferences: preferences)
            try await pushFavoriteAttractions(userId: userId, preferences: preferences)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    // MARK: - Itineraries (local + cloud)

    /// Merges cloud trips with the on-device cache, persists locally, then uploads the merged set.
    func syncItineraries() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        isSyncing = true
        lastSyncError = nil
        defer { isSyncing = false }

        do {
            preferences.setStorageUserId(userId)
            try await runItinerarySync {
                try await self.bidirectionalItinerarySync(userId: userId, preferences: preferences)
            }
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    /// Kept for call sites that only refreshed from remote; now performs full bidirectional sync.
    func refreshItinerariesFromRemote() async {
        await syncItineraries()
    }

    func pushItinerariesNow() async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

        do {
            preferences.setStorageUserId(userId)
            try await runItinerarySync {
                try await self.pushItineraries(userId: userId, preferences: preferences)
            }
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    private func bidirectionalItinerarySync(userId: UUID, preferences: UserPreferencesStore) async throws {
        let remoteRows = try await itineraryRepository.fetchAll(userId: userId)
        let remoteTrips = remoteRows.map(\.asSampleItinerary)

        let merged = mergeItineraries(
            local: preferences.savedItineraries,
            remote: remoteTrips
        )
        let activeId = preferences.activeItineraryId ?? merged.first?.id
        preferences.applyRemoteItineraries(merged, activeId: activeId)

        try await pushItineraries(userId: userId, preferences: preferences)
    }

    /// Union of local and remote trips; local wins when the same id exists on both sides.
    private func mergeItineraries(local: [SampleItinerary], remote: [SampleItinerary]) -> [SampleItinerary] {
        var byId: [String: SampleItinerary] = [:]
        for trip in remote {
            byId[trip.id] = trip
        }
        for trip in local {
            byId[trip.id] = trip
        }

        var merged: [SampleItinerary] = []
        var seen = Set<String>()

        for trip in local {
            guard let resolved = byId[trip.id], !seen.contains(trip.id) else { continue }
            merged.append(resolved)
            seen.insert(trip.id)
        }
        for trip in remote where !seen.contains(trip.id) {
            merged.append(trip)
            seen.insert(trip.id)
        }

        if merged.count > UserPreferencesStore.maxSavedItineraries {
            merged = Array(merged.prefix(UserPreferencesStore.maxSavedItineraries))
        }
        return merged
    }

    /// Serializes itinerary sync so concurrent pulls cannot overwrite newer local saves.
    private func runItinerarySync(_ operation: @escaping () async throws -> Void) async throws {
        let previous = itinerarySyncTask
        let task = Task<Void, Error> {
            if let previous {
                _ = await previous.result
            }
            try await operation()
        }
        itinerarySyncTask = task
        try await task.value
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
            try await checklistRepository.deleteForItinerary(userId: userId, itineraryId: id)
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    // MARK: - Checklist completion (020)

    private func pullChecklistCompletion(userId: UUID, preferences: UserPreferencesStore) async throws {
        let rows = try await checklistRepository.fetchAll(userId: userId)
        var map = preferences.checklistStatuses

        for row in rows {
            guard row.status == "done" || row.status == "skipped" else { continue }
            guard let status = ChecklistItemStatus(rawValue: row.status) else { continue }

            if let tripId = row.itineraryId, !tripId.isEmpty {
                let key = UserPreferencesStore.storageKey(
                    itemId: row.checklistItemId,
                    type: .city,
                    itineraryId: tripId
                )
                map[key] = ChecklistStatusEntry(status: status, type: .city)
            } else {
                let key = row.checklistItemId
                let existingType = map[key]?.type ?? .entry
                map[key] = ChecklistStatusEntry(status: status, type: existingType)
            }
        }
        preferences.applyRemoteChecklistStatuses(map)
    }

    private func pushChecklistCompletion(userId: UUID, preferences: UserPreferencesStore) async throws {
        let rows = preferences.checklistStatuses.map { storageKey, entry -> (checklistItemId: String, itineraryId: String?, status: String) in
            let itemId = UserPreferencesStore.itemId(fromStorageKey: storageKey)
            let itineraryId: String? = entry.type == .city
                ? storageKey.split(separator: "#", maxSplits: 1).dropFirst().first.map(String.init)
                : nil
            return (checklistItemId: itemId, itineraryId: itineraryId, status: entry.status.rawValue)
        }
        guard !rows.isEmpty else { return }
        try await checklistRepository.setStatusBatch(userId: userId, rows: rows)
    }

    func syncChecklistStatus(itemId: String, type: ChecklistItemType, status: ChecklistItemStatus) async {
        guard let preferences, let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }
        do {
            try await checklistRepository.setStatus(
                userId: userId,
                checklistItemId: itemId,
                itineraryId: preferences.itineraryIdForCompletion(type: type),
                status: status == .pending ? "pending" : status.rawValue
            )
        } catch {
            lastSyncError = error.localizedDescription
        }
    }

    // MARK: - Favorite attractions

    private func bidirectionalFavoriteSync(userId: UUID, preferences: UserPreferencesStore) async throws {
        let remoteRows = try await favoriteRepository.fetchAll(userId: userId)
        let remote = remoteRows.map { $0.asRecord() }
        let merged = mergeFavorites(local: preferences.favoriteAttractions, remote: remote)
        preferences.applyRemoteFavoriteAttractions(merged)
        try await pushFavoriteAttractions(userId: userId, preferences: preferences)
    }

    private func mergeFavorites(
        local: [FavoriteAttractionRecord],
        remote: [FavoriteAttractionRecord]
    ) -> [FavoriteAttractionRecord] {
        var byId: [String: FavoriteAttractionRecord] = [:]
        for record in remote {
            byId[record.attractionId] = record
        }
        for record in local {
            if let existing = byId[record.attractionId] {
                let localDate = record.createdAt ?? .distantPast
                let remoteDate = existing.createdAt ?? .distantPast
                byId[record.attractionId] = localDate >= remoteDate ? record : existing
            } else {
                byId[record.attractionId] = record
            }
        }
        return byId.values.sorted { lhs, rhs in
            let left = lhs.createdAt ?? .distantPast
            let right = rhs.createdAt ?? .distantPast
            if left != right { return left > right }
            return lhs.attractionId < rhs.attractionId
        }
    }

    private func pushFavoriteAttractions(userId: UUID, preferences: UserPreferencesStore) async throws {
        let local = preferences.favoriteAttractions
        let remoteRows = try await favoriteRepository.fetchAll(userId: userId)
        let localIds = Set(local.map(\.attractionId))

        for record in local {
            try await favoriteRepository.upsert(
                userId: userId,
                attractionId: record.attractionId,
                cityId: record.cityId,
                createdAt: record.createdAt ?? .now
            )
        }

        for row in remoteRows where !localIds.contains(row.attractionId) {
            try await favoriteRepository.delete(userId: userId, attractionId: row.attractionId)
        }
    }

    func syncFavoriteToggle(attractionId: String, cityId: String, isFavorite: Bool) async {
        guard let auth, auth.isAuthenticated, let userId = auth.userId else { return }
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }
        do {
            if isFavorite {
                let createdAt = preferences?.favoriteAttractions
                    .first(where: { $0.attractionId == attractionId })?
                    .createdAt ?? .now
                try await favoriteRepository.upsert(
                    userId: userId,
                    attractionId: attractionId,
                    cityId: cityId,
                    createdAt: createdAt
                )
            } else {
                try await favoriteRepository.delete(userId: userId, attractionId: attractionId)
            }
        } catch {
            lastSyncError = error.localizedDescription
        }
    }
}
