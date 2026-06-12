import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var prepItems: [ChecklistItem] = []
    @State private var cities: [City] = []
    @State private var showProfile = false
    @State private var showDatePicker = false

    private var trips: [SampleItinerary] { orderedTrips }

    private var orderedTrips: [SampleItinerary] {
        let all = appEnv.preferences.savedItineraries
        guard let activeId = appEnv.preferences.activeItineraryId,
              let active = all.first(where: { $0.id == activeId }) else {
            return all
        }
        return [active] + all.filter { $0.id != activeId }
    }

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
        if let name = appEnv.preferences.displayName, !name.isEmpty {
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
                    onPlanTrip: { appEnv.navigation.openPlanGenerator() },
                    onViewItinerary: { _ in appEnv.navigation.openTab(.plan) },
                    onOpenPrepare: { appEnv.navigation.presentPrepare() }
                )
                HomeQuickAccessGrid(
                    prepCompleted: processedPrepCount,
                    prepTotal: prepTotal,
                    onOpenPrepare: { appEnv.navigation.presentPrepare() },
                    onOpenEmergency: { appEnv.navigation.presentEmergency() }
                )
            }
            .padding(.bottom, 24)
        }
        .background(Theme.ColorToken.background)
        .sheet(isPresented: $showProfile) {
            ProfileSheetView()
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
                avatarUrl: appEnv.preferences.avatarUrl,
                displayName: appEnv.preferences.displayName
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
                activeItinerary: appEnv.preferences.activeItinerary
            )
            let cityIds = ctx.hasSavedItinerary ? ctx.itineraryCityIds : []
            async let checklistTask = repo.fetchChecklistItems(
                cityIds: cityIds,
                countryCode: appEnv.preferences.countryCode
            )
            async let citiesTask = repo.fetchCities()
            let allItems = (try? await checklistTask) ?? []
            cities = (try? await citiesTask) ?? []
            let result = PrepChecklistAssembler.assemble(
                allItems: allItems,
                context: ctx,
                cities: cities
            )
            prepItems = result.allItems
        }
    }
}
