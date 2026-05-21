import SwiftUI

struct GuideHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let cities: [City]
    let onSelectCity: (City) -> Void
    let onCultureTips: () -> Void

    @AppStorage("guide.planTripBannerDismissed") private var planBannerDismissed = false

    private var tripCityIds: [String] {
        GuideTripHelpers.tripCityIds(from: appEnv.preferences)
    }

    private var tripCities: [City] {
        tripCityIds.compactMap { id in cities.first { $0.id == id } }
    }

    private var hasSavedTrip: Bool {
        GuideTripHelpers.activeItinerary(from: appEnv.preferences) != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                if !hasSavedTrip || tripCities.isEmpty {
                    if !planBannerDismissed {
                        planTripBanner
                    }
                } else {
                    Text("Your Trip Destinations")
                        .sectionTitleStyle()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(tripCities) { city in
                                tripCityCard(city)
                            }
                        }
                    }
                }

                cultureTipsEntry

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

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Guide")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text("Cultural tips & audio attraction tours")
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var planTripBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("Plan a trip to see your destination highlighted here →")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textSecondary)
            Button {
                planBannerDismissed = true
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
    }

    private var cultureTipsEntry: some View {
        Button(action: onCultureTips) {
            HStack(spacing: 12) {
                Text("💡")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Cultural Tips")
                        .font(Theme.FontToken.inter(14, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text("Food, transport, temples & more")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Text("›")
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
            .padding(14)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func tripCityCard(_ city: City) -> some View {
        Button {
            onSelectCity(city)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                if let cover = city.coverImagePath {
                    CoverImageView(path: cover, height: 88, cornerRadius: 0)
                } else {
                    Text(city.emoji ?? "📍")
                        .font(.largeTitle)
                        .frame(height: 88)
                        .frame(maxWidth: .infinity)
                        .background(Theme.ColorToken.backgroundSubtle)
                }
                Text(city.name)
                    .font(Theme.FontToken.playfair(13, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text("\(city.attractionCount) attractions")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .frame(width: 140, alignment: .leading)
            .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func cityGridCard(_ city: City) -> some View {
        Button {
            onSelectCity(city)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                if let cover = city.coverImagePath {
                    CoverImageView(path: cover, height: 72)
                } else {
                    Text(city.emoji ?? "📍")
                }
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
