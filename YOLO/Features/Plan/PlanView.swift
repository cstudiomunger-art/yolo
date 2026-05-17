import SwiftUI

struct PlanView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var itinerary: SampleItinerary?
    @State private var cities: [City] = []
    @State private var path = NavigationPath()
    @State private var showShare = false
    @State private var showEdit = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    generateCTA
                    if let itinerary {
                        savedSection(itinerary)
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .background(Theme.ColorToken.background)
            .navigationDestination(for: PlanRoute.self) { route in
                switch route {
                case .cityOverview(let city):
                    CityOverviewView(city: city, onOpenGenerator: {
                        path.append(PlanRoute.generator)
                    })
                case .generator:
                    ItineraryGeneratorView(onGenerated: { trip in
                        path.append(PlanRoute.itineraryDetail(trip))
                    })
                case .itineraryDetail(let trip):
                    ItineraryDetailView(itinerary: trip)
                }
            }
        }
        .sheet(isPresented: $showShare) {
            if let itinerary {
                ShareItinerarySheet(itinerary: itinerary)
            }
        }
        .sheet(isPresented: $showEdit) {
            if let itinerary {
                ItineraryEditSheet(itinerary: itinerary)
            }
        }
        .onAppear {
            reload()
            consumePlanGeneratorDeepLink()
        }
        .onChange(of: appEnv.navigation.planShowGenerator) { _, shouldOpen in
            if shouldOpen {
                consumePlanGeneratorDeepLink()
            }
        }
        .onChange(of: appEnv.preferences.activeItineraryId) { _, _ in reload() }
    }

    private func consumePlanGeneratorDeepLink() {
        guard appEnv.navigation.planShowGenerator else { return }
        appEnv.navigation.planShowGenerator = false
        path.append(PlanRoute.generator)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Plan My Trip")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text("AI-powered · China booking rules built in")
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .padding(.bottom, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private var generateCTA: some View {
        Button {
            if let city = cities.first(where: { appEnv.preferences.selectedCityIds.contains($0.id) }) ?? cities.first {
                path.append(PlanRoute.cityOverview(city))
            } else {
                path.append(PlanRoute.generator)
            }
        } label: {
            HStack(spacing: 14) {
                Text("✦").font(.title2)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Generate New Itinerary")
                        .font(Theme.FontToken.inter(14, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text("Tell us your dates, cities & style")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Text("→").foregroundStyle(Theme.ColorToken.accent)
            }
            .padding(18)
            .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func savedSection(_ trip: SampleItinerary) -> some View {
        Group {
            Text("My Saved Trip")
                .sectionTitleStyle()
                .padding(.top, 20)
                .padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 14) {
                Text(trip.title)
                    .font(Theme.FontToken.playfair(16, weight: .semibold))
                Text(trip.meta)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Text(trip.routeSummary)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: 0xF8F5F0))

                HStack(spacing: 12) {
                    Button("View →") { path.append(PlanRoute.itineraryDetail(trip)) }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .textCase(.uppercase)
                    Button("Edit") { showEdit = true }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .textCase(.uppercase)
                    Button("Share") { showShare = true }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .textCase(.uppercase)
                }
            }
            .padding(18)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))

            warningBar

            if let day = trip.days.first {
                Text("Day 1 Preview — \(day.cityName)")
                    .sectionTitleStyle()
                    .padding(.top, 20)
                    .padding(.bottom, 12)
                dayPreview(day, trip: trip)
            }
        }
    }

    @ViewBuilder
    private var warningBar: some View {
        let branding = appEnv.contentMode.branding
        if !branding.planAlertMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            HStack(alignment: .top, spacing: 10) {
                Text("⚠")
                VStack(alignment: .leading, spacing: 4) {
                    Text(branding.planAlertMessage)
                        .font(Theme.FontToken.inter(12))
                    if let attractionId = branding.planAlertLinkAttractionId {
                        Button {
                            appEnv.navigation.openGuide(
                                attractionId: attractionId,
                                cityId: branding.planAlertLinkCityId
                            )
                        } label: {
                            Text(branding.planAlertLinkLabel)
                                .font(Theme.FontToken.inter(11, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.warning)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.ColorToken.warningBackground)
            .padding(.top, 16)
        }
    }

    private func dayPreview(_ day: ItineraryDay, trip: SampleItinerary) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(day.dateLabel)
                    .font(Theme.FontToken.playfair(14, weight: .semibold))
                Spacer()
                if let cost = day.costEstimate {
                    Text(cost).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            ForEach(day.activities) { activity in
                HStack(alignment: .top, spacing: 10) {
                    Text(activity.timeSlot)
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textDisabled)
                        .frame(width: 28, alignment: .leading)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(activity.name).font(Theme.FontToken.inter(13))
                        Text(activity.detail).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    if activity.hasAudio, let aid = activity.attractionId {
                        Button("🎧 Audio") {
                            appEnv.navigation.openGuide(attractionId: aid)
                        }
                        .font(Theme.FontToken.inter(10))
                    }
                }
            }
        }
        .padding(16)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
    }

    private func reload() {
        itinerary = appEnv.preferences.activeItinerary
        Task {
            cities = (try? await appEnv.content.fetchCities()) ?? []
        }
    }
}
