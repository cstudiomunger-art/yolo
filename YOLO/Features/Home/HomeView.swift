import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var prepItems: [ChecklistItem] = []
    @State private var cities: [City] = []
    @State private var showProfile = false
    @State private var showDatePicker = false
    @State private var showLogin = false
    @State private var pendingPlanAfterLogin = false

    private var trips: [SampleItinerary] { appEnv.orderedVisibleTrips }

    private func prepItemStatus(_ item: ChecklistItem) -> ChecklistItemStatus {
        appEnv.preferences.checklistStatus(for: item.id, type: item.type)
    }

    private var processedPrepCount: Int {
        PrepProgressMetrics.processedCount(items: prepItems, status: prepItemStatus)
    }

    private var prepTotal: Int { max(prepItems.count, 1) }

    private var citiesLine: String {
        let names = cities
            .filter { appEnv.preferences.selectedCityIds.contains($0.id) }
            .map(\.name)
        if names.isEmpty {
            return String(localized: "Plan a trip to see cities")
        }
        return "📍 " + names.joined(separator: " · ")
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return String(localized: "Good morning,")
        case 12..<17:
            return String(localized: "Good afternoon,")
        default:
            return String(localized: "Good evening,")
        }
    }

    private var displayName: String {
        if let name = appEnv.visibleProfileName {
            return name
        }
        if let email = appEnv.auth.userEmail,
           let local = email.split(separator: "@").first {
            return String(local).capitalized
        }
        return String(localized: "Traveler")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                homeGreetingHeader
                HomeTripHeroPanel(
                    trips: trips,
                    citiesLine: citiesLine,
                    prepCompleted: processedPrepCount,
                    prepTotal: prepTotal,
                    daysUntilDeparture: appEnv.preferences.daysUntilDeparture,
                    departureDate: appEnv.preferences.departureDate,
                    visa: appEnv.preferences.visaRule(),
                    onSetDeparture: { showDatePicker = true },
                    onPlanTrip: { requestPlanTrip() },
                    onViewItinerary: { _ in appEnv.navigation.openTab(.plan) },
                    onOpenPrepare: { appEnv.navigation.presentPrepare() }
                )
                HomeQuickAccessGrid(
                    prepCompleted: processedPrepCount,
                    prepTotal: prepTotal,
                    topSpacing: trips.isEmpty ? 48 : 8,
                    onOpenPrepare: { appEnv.navigation.presentPrepare() },
                    onOpenInfoHub: { appEnv.navigation.presentInfoHub() },
                    onOpenGeniusBar: { appEnv.navigation.presentGeniusBar() },
                    onOpenPhrases: { appEnv.navigation.presentPhrases() }
                )
            }
            .padding(.bottom, 24)
        }
        .background(Theme.ColorToken.background)
        .sheet(isPresented: $showProfile) {
            ProfileSheetView()
        }
        .loginSheet(isPresented: $showLogin, appEnv: appEnv)
        .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
            guard isAuthenticated else { return }
            showLogin = false
            if pendingPlanAfterLogin {
                pendingPlanAfterLogin = false
                appEnv.navigation.openPlanGenerator()
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                DatePicker(
                    "Departure date",
                    selection: Bindable(appEnv.preferences).departureDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .navigationTitle("Departure")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { showDatePicker = false }
                    }
                }
            }
            .presentationDetents([.medium])
            .sheetDragToDismiss()
        }
        .onAppear {
            reload()
            if appEnv.preferences.hasSelectedCountry {
                Task { await appEnv.refreshVisaRule() }
            }
        }
        .onChange(of: appEnv.contentRevision) { _, _ in reload() }
        .onChange(of: appEnv.preferences.countryCode) { _, _ in
            Task { await appEnv.refreshVisaRule() }
        }
    }

    private var homeGreetingHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Text(displayName)
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            Spacer()
            ProfileAvatarButton(
                avatarUrl: appEnv.visibleProfileAvatarUrl,
                displayName: appEnv.visibleProfileName
            ) { showProfile = true }
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    private func reload() {
        Task {
            let repo = appEnv.content
            let ctx = PrepChecklistContext(
                countryCode: appEnv.preferences.countryCode,
                activeItinerary: appEnv.visibleActiveItinerary
            )
            let cityIds = ctx.hasSavedItinerary ? ctx.itineraryCityIds : []
            async let checklistTask = repo.fetchChecklistItems(
                cityIds: cityIds,
                countryCode: appEnv.preferences.countryCode
            )
            async let citiesTask = repo.fetchCities()
            var allItems: [ChecklistItem] = []
            do {
                allItems = try await checklistTask
            } catch {
                TelemetryService.shared.recordError(error, context: "home_reload_checklist")
            }
            do {
                cities = try await citiesTask
            } catch {
                cities = []
                TelemetryService.shared.recordError(error, context: "home_reload_cities")
            }
            let result = PrepChecklistAssembler.assemble(
                allItems: allItems,
                context: ctx,
                cities: cities
            )
            prepItems = result.allItems
        }
    }

    private func requestPlanTrip() {
        if appEnv.requiresSignInForTripActions {
            pendingPlanAfterLogin = true
            showLogin = true
            return
        }
        appEnv.navigation.openPlanGenerator()
    }
}
