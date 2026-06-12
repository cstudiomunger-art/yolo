import SwiftUI

struct GuideHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let cities: [City]
    let onSelectCity: (City) -> Void
    let onOpenFavorites: () -> Void

    @State private var activeTripCardIndex = 0

    private var activeItinerary: SampleItinerary? {
        GuideTripHelpers.activeItinerary(from: appEnv.preferences)
    }

    private var tripCityIds: [String] {
        GuideTripHelpers.tripCityIds(from: appEnv.preferences)
    }

    private var tripCities: [City] {
        tripCityIds.compactMap { id in cities.first { $0.id == id } }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                if !tripCities.isEmpty {
                    tripSection
                }

                Text("Explore All Cities")
                    .sectionTitleStyle()

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(cities) { city in
                        cityGridCard(city)
                    }
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 16)
        }
    }

    // MARK: - Header & sections

    private var favoritesCount: Int {
        appEnv.preferences.favoriteAttractions.count
    }

    private var favoritesButton: some View {
        Button(action: onOpenFavorites) {
            VStack(spacing: 2) {
                Image(systemName: favoritesCount > 0 ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .medium))
                Text(String(localized: "Saved"))
                    .font(Theme.FontToken.inter(10, weight: .medium))
            }
            .foregroundStyle(favoritesCount > 0 ? Theme.ColorToken.accent : Theme.ColorToken.textMuted)
            .frame(minWidth: 32)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(localized: "My Favorites"))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 8) {
                Text("Guide")
                    .font(Theme.FontToken.playfair(30, weight: .bold))
                Spacer(minLength: 8)
                favoritesButton
            }
            Text("Audio attraction tours")
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.ColorToken.border)
                .frame(height: 1)
        }
    }

    @ViewBuilder
    private var tripSection: some View {
        if tripCities.count == 1, let city = tripCities.first {
            Text("Your Trip")
                .sectionTitleStyle()
            tripSingleCityCard(city)
        } else {
            Text("Your Trip Destinations")
                .sectionTitleStyle()
            tripMultiCityScroll
        }
    }

    // MARK: - Trip cards

    private var tripMultiCityScroll: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(tripCities.enumerated()), id: \.element.id) { index, city in
                        tripMultiCityCard(city)
                            .id(index)
                    }
                }
                .scrollTargetLayout()
                .padding(.trailing, 12)
            }
            .scrollTargetBehavior(.viewAligned)
            .onScrollTargetVisibilityChange(idType: Int.self) { visible in
                if let first = visible.sorted().first {
                    activeTripCardIndex = first
                }
            }

            if tripCities.count > 1 {
                HStack(spacing: 5) {
                    ForEach(0..<tripCities.count, id: \.self) { index in
                        Circle()
                            .fill(index == activeTripCardIndex ? Theme.ColorToken.accent : Theme.ColorToken.border)
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func tripSingleCityCard(_ city: City) -> some View {
        Button {
            onSelectCity(city)
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    cityCover(city, height: 180)
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.55)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    VStack(alignment: .leading, spacing: 3) {
                        Text(city.name)
                            .font(Theme.FontToken.playfair(22, weight: .bold))
                            .foregroundStyle(.white)
                        Text(city.chineseName)
                            .font(Theme.FontToken.inter(12))
                            .foregroundStyle(.white.opacity(0.75))
                    }
                    .padding(16)
                }
                .frame(height: 180)
                .clipped()

                HStack {
                    tripDateLine(for: city)
                    Spacer(minLength: 8)
                    Text("\(city.attractionCount) attractions →")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func tripMultiCityCard(_ city: City) -> some View {
        Button {
            onSelectCity(city)
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    cityCover(city, height: 140)
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.4)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    if let dates = tripDates(for: city) {
                        Text(dates.tagText)
                            .font(Theme.FontToken.inter(9, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .textCase(.uppercase)
                            .kerning(0.6)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(.black.opacity(0.35))
                            .overlay(Rectangle().stroke(.white.opacity(0.25), lineWidth: 1))
                            .padding(10)
                    }
                }
                .frame(height: 140)
                .clipped()

                VStack(alignment: .leading, spacing: 5) {
                    Text(city.name)
                        .font(Theme.FontToken.playfair(16, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    tripDateSubtitle(for: city)
                    HStack(spacing: 0) {
                        Text("\(city.attractionCount) attractions ")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                        Text("→")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .frame(width: 232, alignment: .leading)
            .background(Theme.ColorToken.background)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func cityGridCard(_ city: City) -> some View {
        Button {
            onSelectCity(city)
        } label: {
            VStack(spacing: 0) {
                cityCover(city, height: 100)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 0) {
                    Text(city.name)
                        .font(Theme.FontToken.playfair(14, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                        .padding(.bottom, 1)

                    Text(city.chineseName)
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .padding(.bottom, 4)

                    HStack(spacing: 0) {
                        Text("\(city.attractionCount) attractions ")
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                        Text("→")
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Theme.ColorToken.borderLight)
                        .frame(height: 1)
                }
            }
            .background(Theme.ColorToken.background)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Shared helpers

    @ViewBuilder
    private func cityCover(_ city: City, height: CGFloat) -> some View {
        if let cover = city.coverImagePath {
            CoverImageView(path: cover, height: height, cornerRadius: 0)
        } else {
            ZStack {
                Theme.ColorToken.backgroundSubtle
                Text(city.emoji ?? "📍")
                    .font(.system(size: height * 0.35))
            }
            .frame(height: height)
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func tripDateLine(for city: City) -> some View {
        if let dates = tripDates(for: city) {
            HStack(spacing: 0) {
                Text(dates.rangeText)
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text(" · \(dates.dayCount) days")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
        } else {
            Text("\(city.attractionCount) attractions")
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textSecondary)
        }
    }

    @ViewBuilder
    private func tripDateSubtitle(for city: City) -> some View {
        if let dates = tripDates(for: city) {
            Text("\(dates.rangeText) · \(dates.dayCount) days")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
    }

    private func tripDates(for city: City) -> CityTripDates? {
        guard let itinerary = activeItinerary else { return nil }
        return GuideTripHelpers.tripDates(for: city.id, itinerary: itinerary)
    }
}
