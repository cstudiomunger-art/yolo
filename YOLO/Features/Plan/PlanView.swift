import SwiftUI

struct PlanView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var path = NavigationPath()
    @State private var tripToDelete: SampleItinerary?
    @State private var prepItems: [ChecklistItem] = []

    private var savedTrips: [SampleItinerary] {
        let all = appEnv.preferences.savedItineraries
        guard let activeId = appEnv.preferences.activeItineraryId,
              let active = all.first(where: { $0.id == activeId }) else {
            return all
        }
        return [active] + all.filter { $0.id != activeId }
    }

    var body: some View {
        navigationStack
            .onAppear { consumePlanGeneratorDeepLink() }
            .task { await appEnv.profileSync.syncItineraries() }
            .onChange(of: appEnv.navigation.planShowGenerator) { _, shouldOpen in
                if shouldOpen { consumePlanGeneratorDeepLink() }
            }
            .onChange(of: path.count) { _, count in
                appEnv.navigation.planPathCount = count
            }
            .onChange(of: appEnv.preferences.showPrepareGuideAfterSave) { _, show in
                if show { Task { await reloadPrepProgress() } }
            }
            .task { await reloadPrepProgress() }
    }

    private var showPrepGuideBanner: Bool {
        appEnv.preferences.showPrepareGuideAfterSave && path.isEmpty
    }

    private var prepGuideBanner: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Trip saved")
                    .font(Theme.FontToken.inter(12, weight: .medium))
                Text("Start your prep checklist before you go")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
            Button("Open →") {
                appEnv.preferences.showPrepareGuideAfterSave = false
                appEnv.navigation.presentPrepare()
            }
            .font(Theme.FontToken.inter(11, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .leading) {
            Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.vertical, 8)
    }

    private var navigationStack: some View {
        NavigationStack(path: $path) {
            planRootContent
        }
        .alert(
            String(localized: "Delete this trip?"),
            isPresented: showDeleteAlert,
            presenting: tripToDelete
        ) { trip in
            deleteAlertActions(for: trip)
        } message: { _ in
            deleteAlertMessage
        }
    }

    private var planRootContent: some View {
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
            planDestination(for: route)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                newTripButton
            }
        }
    }

    private var showDeleteAlert: Binding<Bool> {
        Binding(
            get: { tripToDelete != nil },
            set: { if !$0 { tripToDelete = nil } }
        )
    }

    private var deleteAlertMessage: Text {
        Text(String(localized: "This cannot be undone."))
    }

    @ViewBuilder
    private func planDestination(for route: PlanRoute) -> some View {
        switch route {
        case .create:
            PlanCreateFlowView { _ in
                path = NavigationPath()
            }
        case .detail(let trip):
            ItineraryDetailView(itinerary: trip)
        }
    }

    @ViewBuilder
    private func deleteAlertActions(for trip: SampleItinerary) -> some View {
        Button(String(localized: "Delete"), role: .destructive) {
            deleteTrip(trip)
        }
        Button(String(localized: "Cancel"), role: .cancel) {
            tripToDelete = nil
        }
    }

    private func deleteTrip(_ trip: SampleItinerary) {
        appEnv.preferences.deleteItinerary(id: trip.id)
        tripToDelete = nil
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
            if showPrepGuideBanner {
                Section {
                    prepGuideBanner
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
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
            if !prepItems.isEmpty {
                let done = PrepProgressMetrics.processedCount(items: prepItems) { item in
                    appEnv.preferences.checklistStatus(for: item.id, type: item.type)
                }
                Text("\(done)/\(prepItems.count) prep complete")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(done == prepItems.count ? Theme.ColorToken.success : Theme.ColorToken.textMuted)
            }
        }
        .padding(.vertical, 6)
    }

    private func reloadPrepProgress() async {
        let ctx = PrepChecklistContext(
            countryCode: appEnv.preferences.countryCode,
            activeItinerary: appEnv.preferences.activeItinerary
        )
        let cityIds = ctx.hasSavedItinerary ? ctx.itineraryCityIds : []
        let all = (try? await appEnv.content.fetchChecklistItems(
            cityIds: cityIds,
            countryCode: appEnv.preferences.countryCode
        )) ?? []
        let cities = (try? await appEnv.content.fetchCities()) ?? []
        prepItems = PrepChecklistAssembler.assemble(allItems: all, context: ctx, cities: cities).allItems
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
