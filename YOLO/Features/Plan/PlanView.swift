import SwiftUI

struct PlanView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var path = NavigationPath()
    @State private var tripToDelete: SampleItinerary?
    @State private var showDeleteConfirm = false

    private var savedTrips: [SampleItinerary] {
        let all = appEnv.preferences.savedItineraries
        guard let activeId = appEnv.preferences.activeItineraryId,
              let active = all.first(where: { $0.id == activeId }) else {
            return all
        }
        return [active] + all.filter { $0.id != activeId }
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if savedTrips.isEmpty {
                    emptyState
                } else {
                    tripList
                }
            }
            .background(Theme.ColorToken.background)
            .navigationTitle(String(localized: "Plan"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: PlanRoute.self) { route in
                switch route {
                case .create:
                    PlanCreateFlowView { _ in
                        path = NavigationPath()
                    }
                case .detail(let trip):
                    ItineraryDetailView(itinerary: trip)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    newTripButton
                }
            }
        }
        .confirmationDialog(
            String(localized: "Delete this trip?"),
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible,
            presenting: tripToDelete
        ) { trip in
            Button(String(localized: "Delete"), role: .destructive) {
                appEnv.preferences.deleteItinerary(id: trip.id)
            }
            Button(String(localized: "Cancel"), role: .cancel) {
                tripToDelete = nil
            }
        } message: { _ in
            Text(String(localized: "This cannot be undone."))
        }
        .onAppear {
            consumePlanGeneratorDeepLink()
        }
        .task {
            await appEnv.profileSync.refreshItinerariesFromRemote()
        }
        .onChange(of: appEnv.navigation.planShowGenerator) { _, shouldOpen in
            if shouldOpen { consumePlanGeneratorDeepLink() }
        }
        .onChange(of: path.count) { _, count in
            appEnv.navigation.planPathCount = count
        }
    }

    // MARK: - 4.1 Empty

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 16) {
                Text("✦")
                    .font(.system(size: 36))
                Text(String(localized: "Plan your China trip"))
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                    .multilineTextAlignment(.center)
                Text(String(localized: "Choose cities and dates — AI builds a day-by-day itinerary you can edit."))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            Spacer()
        }
    }

    // MARK: - 4.2 List

    private var tripList: some View {
        List {
            Section {
                ForEach(savedTrips) { trip in
                    tripRow(trip)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            path.append(PlanRoute.detail(trip))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                tripToDelete = trip
                                showDeleteConfirm = true
                            } label: {
                                Label(String(localized: "Delete"), systemImage: "trash")
                            }
                        }
                }
            } header: {
                HStack {
                    Text(String(format: String(localized: "Saved trips · %lld"), savedTrips.count))
                    Spacer()
                    if savedTrips.count >= UserPreferencesStore.maxSavedItineraries {
                        Text(String(localized: "Max 10"))
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func tripRow(_ trip: SampleItinerary) -> some View {
        let isActive = appEnv.preferences.activeItineraryId == trip.id
            || (appEnv.preferences.activeItineraryId == nil && savedTrips.first?.id == trip.id)

        return VStack(alignment: .leading, spacing: 8) {
            if isActive {
                Text(String(localized: "ACTIVE"))
                    .font(Theme.FontToken.inter(9, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            Text(trip.title)
                .font(Theme.FontToken.playfair(16, weight: .semibold))
            Text(trip.meta)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(trip.routeSummary)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .lineLimit(2)
            Text(String(format: String(localized: "%lld days"), trip.days.count))
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textDisabled)
        }
        .padding(.vertical, 6)
    }

    private var newTripButton: some View {
        Button {
            path.append(PlanRoute.create)
        } label: {
            Image(systemName: "plus")
        }
        .disabled(!appEnv.preferences.canSaveMoreItineraries)
    }

    private func consumePlanGeneratorDeepLink() {
        guard appEnv.navigation.planShowGenerator else { return }
        appEnv.navigation.planShowGenerator = false
        if appEnv.preferences.canSaveMoreItineraries {
            path.append(PlanRoute.create)
        }
    }
}
