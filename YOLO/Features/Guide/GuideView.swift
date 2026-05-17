import SwiftUI

struct GuideView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var segment: GuideSegment = .attractions
    @State private var cities: [City] = []
    @State private var attractions: [Attraction] = []
    @State private var cultureTips: [CultureTip] = []
    @State private var selectedCity: City?
    @State private var selectedAttraction: Attraction?
    @State private var selectedCulture: CultureTip?

    enum GuideSegment {
        case culture
        case attractions
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            guideSegment

            if segment == .culture {
                cultureList
            } else if let city = selectedCity {
                attractionList(city: city)
            } else {
                cityGrid
            }
        }
        .background(Theme.ColorToken.background)
        .sheet(item: $selectedAttraction) { attraction in
            AttractionDetailView(attraction: attraction)
        }
        .sheet(item: $selectedCulture) { tip in
            CultureDetailView(tip: tip)
        }
        .task { await load() }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await load() }
        }
    }

    private func applyGuideDeepLink(_ link: (cityId: String?, attractionId: String)) async {
        segment = .attractions
        let cityId = link.cityId ?? "beijing"
        guard let city = cities.first(where: { $0.id == cityId }) ?? cities.first else { return }
        selectedCity = city
        await loadAttractions(cityId: city.id)
        if let attraction = attractions.first(where: { $0.id == link.attractionId }) {
            selectedAttraction = attraction
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Guide")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text("Cultural tips & audio attraction tours")
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    private var guideSegment: some View {
        HStack(spacing: 0) {
            guideSegButton("Cultural Tips", segment == .culture) {
                segment = .culture
                selectedCity = nil
            }
            guideSegButton("Attractions", segment == .attractions) {
                segment = .attractions
            }
        }
        .padding(.horizontal, Theme.screenPadding)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private func guideSegButton(_ title: String, _ active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(active ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(alignment: .bottom) {
                    if active {
                        Rectangle().fill(Theme.ColorToken.textPrimary).frame(height: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private var cultureList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(cultureTips) { tip in
                    Button {
                        selectedCulture = tip
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(tip.emoji)
                                Text(tip.title)
                                    .font(Theme.FontToken.inter(14))
                                    .foregroundStyle(Theme.ColorToken.textPrimary)
                                Spacer()
                                Text("›")
                                    .foregroundStyle(Theme.ColorToken.textGhost)
                            }
                            Text(tip.preview)
                                .font(Theme.FontToken.inter(12))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.plain)
                    Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
        }
    }

    private var cityGrid: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !tripCities.isEmpty {
                    Text("🗺 Your Trip Cities")
                        .sectionTitleStyle()
                    ForEach(tripCities) { city in
                        tripCityCard(city)
                    }
                }

                Text("All Cities")
                    .sectionTitleStyle()
                    .padding(.top, 8)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(cities) { city in
                        Button {
                            selectedCity = city
                            Task { await loadAttractions(cityId: city.id) }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(city.emoji ?? "📍")
                                Text(city.name)
                                    .font(Theme.FontToken.playfair(13, weight: .semibold))
                                    .foregroundStyle(Theme.ColorToken.textPrimary)
                                Text(city.chineseName)
                                    .font(Theme.FontToken.inter(10))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                                Text("\(city.attractionCount) attractions →")
                                    .font(Theme.FontToken.inter(10))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 16)
        }
    }

    private var tripCities: [City] {
        cities.filter { appEnv.preferences.selectedCityIds.contains($0.id) }
    }

    private func tripCityCard(_ city: City) -> some View {
        Button {
            selectedCity = city
            Task { await loadAttractions(cityId: city.id) }
        } label: {
            HStack(spacing: 12) {
                Text(city.emoji ?? "🏯")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(city.name)  \(city.chineseName)")
                        .font(Theme.FontToken.inter(13))
                    Text("\(city.attractionCount) attractions · in your plan")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Text("Your Trip ★")
                    .font(Theme.FontToken.inter(9, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            .padding(12)
            .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func attractionList(city: City) -> some View {
        VStack(spacing: 0) {
            Button {
                selectedCity = nil
                attractions = []
            } label: {
                Text("← Guide · Attractions")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Theme.screenPadding)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            Text("\(city.name)  \(city.chineseName)")
                .font(Theme.FontToken.playfair(20, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Theme.screenPadding)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(attractions) { attraction in
                        Button {
                            selectedAttraction = attraction
                        } label: {
                            AttractionRowView(attraction: attraction)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
            }
        }
    }

    private func load() async {
        cities = (try? await appEnv.content.fetchCities()) ?? []
        cultureTips = (try? await appEnv.content.fetchCultureTips()) ?? []
        if let link = appEnv.navigation.consumeGuideDeepLink() {
            await applyGuideDeepLink(link)
        }
    }

    private func loadAttractions(cityId: String) async {
        attractions = (try? await appEnv.content.fetchAttractions(cityId: cityId)) ?? []
    }
}

struct AttractionRowView: View {
    let attraction: Attraction

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(attraction.name)
                        .font(Theme.FontToken.inter(14))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text(attraction.chineseName)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                if attraction.audioGuideCount > 0 {
                    Text("🎧 12min")
                        .font(Theme.FontToken.inter(10))
                }
            }
            HStack(spacing: 6) {
                if let duration = attraction.recommendedDuration {
                    pill("⏱ \(duration)")
                }
                if let price = attraction.ticketPrice {
                    pill("💰 \(price)")
                }
                if attraction.requiresAdvanceBooking {
                    pill("🎫 Book ahead", urgent: true)
                }
            }
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private func pill(_ text: String, urgent: Bool = false) -> some View {
        Text(text)
            .font(Theme.FontToken.inter(10))
            .foregroundStyle(urgent ? Theme.ColorToken.urgent : Theme.ColorToken.textMuted)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Theme.ColorToken.backgroundSubtle)
    }
}

struct CultureDetailView: View {
    let tip: CultureTip
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(tip.body)
                    .font(Theme.FontToken.inter(14))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .lineSpacing(6)
                    .padding(Theme.screenPadding)
            }
            .navigationTitle("\(tip.emoji) \(tip.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AttractionDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let attraction: Attraction
    @State private var audioGuides: [AudioGuide] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let guide = audioGuides.first {
                        audioCard(guide)
                    }

                    Text("Introduction")
                        .sectionTitleStyle()
                    Text(attraction.introduction ?? attraction.summary ?? "")
                        .font(Theme.FontToken.inter(14))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                        .lineSpacing(5)

                    if !attraction.westernVisitorTips.isEmpty {
                        Text("Tips for Western Visitors")
                            .sectionTitleStyle()
                        ForEach(attraction.westernVisitorTips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 8) {
                                Text("→")
                                    .foregroundStyle(Theme.ColorToken.accent)
                                Text(tip)
                                    .font(Theme.FontToken.inter(12))
                                    .foregroundStyle(Theme.ColorToken.textSecondary)
                            }
                        }
                    }
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle(attraction.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                audioGuides = (try? await appEnv.content.fetchAudioGuides(attractionId: attraction.id)) ?? []
            }
        }
    }

    @ViewBuilder
    private func audioCard(_ guide: AudioGuide) -> some View {
        AudioPlayerView(attraction: attraction, guide: guide)
    }
}
