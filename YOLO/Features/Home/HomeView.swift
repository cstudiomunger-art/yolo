import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var cities: [City] = []
    @State private var homeTips: [HomeTip] = []
    @State private var checklist: [ChecklistItem] = []
    @State private var itinerary: SampleItinerary?
    @State private var showProfile = false
    @State private var showDatePicker = false

    private var visa: VisaRule? { appEnv.preferences.visaRule() }

    private var completedCount: Int {
        checklist.filter { appEnv.preferences.completedChecklistIds.contains($0.id) }.count
    }

    private var totalCount: Int { max(checklist.count, 1) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                countdownBlock
                quickActions
                if let tip = homeTips.first {
                    tipBlock(tip)
                }
                if let itinerary {
                    tripSummary(itinerary)
                }
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
        .onAppear { reload() }
        .onChange(of: appEnv.contentRevision) { _, _ in reload() }
        .onChange(of: appEnv.preferences.activeItineraryId) { _, _ in reload() }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            ChinaGoLogo()
            Spacer()
            ProfileAvatarButton { showProfile = true }
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private var countdownBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let visa {
                Text("\(visa.flag)  \(visa.countryName)")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .textCase(.uppercase)
            }

            Button {
                showDatePicker = true
            } label: {
                Text("\(appEnv.preferences.daysUntilDeparture)")
                    .font(Theme.FontToken.playfair(72, weight: .bold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .tracking(-2)
            }
            .buttonStyle(.plain)

            Text("Days until departure")
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .textCase(.uppercase)

            if let visa {
                HStack(spacing: 8) {
                    if visa.visaFree {
                        Text("Visa-free")
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.success)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .overlay(
                                Rectangle().stroke(Theme.ColorToken.success, lineWidth: 1)
                            )
                    }
                    Text(visa.headline)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(.top, 4)
            }

            HStack(spacing: 12) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
                        Rectangle()
                            .fill(Theme.ColorToken.accent)
                            .frame(width: geo.size.width * CGFloat(completedCount) / CGFloat(totalCount), height: 1)
                    }
                }
                .frame(height: 1)

                Text("\(completedCount) of \(checklist.count) prepared")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.bottom, 24)
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .sectionTitleStyle()
                .padding(.horizontal, Theme.screenPadding)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                quickTile(icon: "✅", title: "Prep Checklist", sub: "\(completedCount) of \(checklist.count) tasks done") {
                    appEnv.navigation.openTab(.prepare)
                }
                quickTile(icon: "🗺", title: "Plan Trip", sub: "AI-generated, China-aware") {
                    appEnv.navigation.openTab(.plan)
                }
                quickTile(icon: "💬", title: "Ask Assistant", sub: "Real-time help") {
                    appEnv.navigation.openTab(.assistant)
                }
                quickTile(icon: "📖", title: "Attractions", sub: "Audio tours, 30+ sites") {
                    appEnv.navigation.openTab(.guide)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
        }
        .padding(.bottom, 22)
    }

    private func quickTile(icon: String, title: String, sub: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(icon).font(.system(size: 18))
                Text(title)
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text(sub)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func tipBlock(_ tip: HomeTip) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(tip.kicker)
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .textCase(.uppercase)
            Text(tip.headline)
                .font(Theme.FontToken.playfair(15, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
            Text(tip.body)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .lineSpacing(4)
            if let link = tip.linkLabel {
                Button {
                    let cityId = tip.cityId ?? appEnv.preferences.selectedCityIds.first ?? "beijing"
                    let attractionId = tip.linkAttractionId ?? "beijing_forbidden_city"
                    appEnv.navigation.openGuide(attractionId: attractionId, cityId: cityId)
                } label: {
                    Text(link)
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .textCase(.uppercase)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(Theme.ColorToken.accent)
                .frame(width: 2)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.bottom, 22)
    }

    private func tripSummary(_ trip: SampleItinerary) -> some View {
        VStack(spacing: 0) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(trip.title)
                        .font(Theme.FontToken.playfair(14, weight: .semibold))
                    Text(trip.meta)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Button {
                    appEnv.navigation.openTab(.plan)
                } label: {
                    Text("View →")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .textCase(.uppercase)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 16)
        }
    }

    private func reload() {
        itinerary = appEnv.preferences.activeItinerary
        Task { await load() }
    }

    private func load() async {
        let repo = appEnv.content
        let cityIds = appEnv.preferences.selectedCityIds
        cities = (try? await repo.fetchCities()) ?? []
        homeTips = (try? await repo.fetchHomeTips(cityIds: cityIds)) ?? []
        checklist = (try? await repo.fetchChecklistItems(cityIds: cityIds)) ?? []
        if itinerary == nil {
            itinerary = appEnv.preferences.activeItinerary
        }
    }
}
