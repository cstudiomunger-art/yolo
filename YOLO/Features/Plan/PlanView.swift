import SwiftUI

struct PlanView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var path = NavigationPath()
    @State private var tripToDelete: SampleItinerary?
    @State private var prepItems: [ChecklistItem] = []
    @State private var showLogin = false
    @State private var pendingCreateAfterLogin = false

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
            .loginSheet(isPresented: $showLogin, appEnv: appEnv)
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                guard isAuthenticated else { return }
                showLogin = false
                if pendingCreateAfterLogin {
                    pendingCreateAfterLogin = false
                    openCreateFlowIfAllowed()
                }
            }
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
        VStack(spacing: 0) {
            planHeader
            if savedTrips.isEmpty {
                emptyState
            } else {
                tripList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Theme.ColorToken.background)
        .navigationBarHidden(true)
        .navigationDestination(for: PlanRoute.self) { route in
            planDestination(for: route)
        }
    }

    private var planHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Text(String(localized: "Plan"))
                    .font(Theme.FontToken.playfair(30, weight: .bold))
                Spacer(minLength: 8)
                newTripHeaderButton
            }
            Text(String(localized: "Plan your China trip"))
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 24)
        .padding(.bottom, 4)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.ColorToken.border)
                .frame(height: 1)
        }
    }

    private var newTripHeaderButton: some View {
        Button {
            requestCreateTrip()
        } label: {
            VStack(spacing: 2) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                Text(String(localized: "Plan Trip"))
                    .font(Theme.FontToken.inter(10, weight: .medium))
            }
            .foregroundStyle(
                appEnv.preferences.canSaveMoreItineraries
                    ? Theme.ColorToken.accent
                    : Theme.ColorToken.textMuted
            )
            .frame(minWidth: 32)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!appEnv.preferences.canSaveMoreItineraries)
        .accessibilityLabel(String(localized: "Plan Trip"))
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
                if appEnv.auth.isAuthenticated || AppConfig.useMock {
                    Text(String(localized: "Choose cities and dates — AI builds a day-by-day itinerary you can edit."))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                } else {
                    Text(String(localized: "Sign in to create an AI-powered day-by-day itinerary."))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    Button {
                        requestCreateTrip()
                    } label: {
                        Text(String(localized: "Sign in to plan →"))
                            .font(Theme.FontToken.inter(12, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
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
        .contentMargins(.bottom, Theme.tabBarHeight + 12, for: .scrollContent)
    }

    private func tripRow(_ trip: SampleItinerary) -> some View {
        let isActive = appEnv.preferences.activeItineraryId == trip.id
            || (appEnv.preferences.activeItineraryId == nil && savedTrips.first?.id == trip.id)

        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if isActive {
                    Text(String(localized: "ACTIVE"))
                        .font(Theme.FontToken.inter(9, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
                if let status = trip.tripStatus() {
                    tripStatusPill(status)
                }
                Spacer(minLength: 0)
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

    @ViewBuilder
    private func tripStatusPill(_ status: TripStatus) -> some View {
        Text(tripStatusLabel(status))
            .font(Theme.FontToken.inter(9, weight: .semibold))
            .foregroundStyle(tripStatusColor(status))
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(Capsule().fill(tripStatusColor(status).opacity(0.12)))
    }

    private func tripStatusLabel(_ status: TripStatus) -> String {
        switch status {
        case .upcoming(let days):
            return String(format: String(localized: "Starts in %lld days"), days)
        case .ongoing(let day, let total):
            return String(format: String(localized: "Day %lld of %lld"), day, total)
        case .ended:
            return String(localized: "Ended")
        }
    }

    private func tripStatusColor(_ status: TripStatus) -> Color {
        switch status {
        case .upcoming: return Theme.ColorToken.accent
        case .ongoing: return Theme.ColorToken.success
        case .ended: return Theme.ColorToken.textMuted
        }
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

    private func consumePlanGeneratorDeepLink() {
        guard appEnv.navigation.planShowGenerator else { return }
        appEnv.navigation.planShowGenerator = false
        requestCreateTrip()
    }

    private func requestCreateTrip() {
        guard appEnv.preferences.canSaveMoreItineraries else { return }
        if !appEnv.auth.isAuthenticated, !AppConfig.useMock {
            pendingCreateAfterLogin = true
            showLogin = true
            return
        }
        openCreateFlowIfAllowed()
    }

    private func openCreateFlowIfAllowed() {
        guard appEnv.preferences.canSaveMoreItineraries else { return }
        path.append(PlanRoute.create)
    }
}
