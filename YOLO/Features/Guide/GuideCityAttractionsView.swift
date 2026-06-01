import SwiftUI

struct GuideCityAttractionsView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let city: City
    let onSelectCityGuide: (CityGuide) -> Void
    let onSelectAttraction: (Attraction) -> Void

    @State private var attractions: [Attraction] = []
    @State private var cityGuides: [CityGuide] = []
    @State private var loadError: String?
    @State private var isLoading = true

    private var hasContent: Bool {
        !attractions.isEmpty || !cityGuides.isEmpty || city.coverImagePath != nil
            || !(city.description?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let loadError, !hasContent {
                errorState(message: loadError)
            } else if !hasContent {
                emptyState
            } else {
                cityContentList
            }
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await load() }
        .task(id: city.id) { await load() }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await load() }
        }
    }

    private var cityContentList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let cover = city.coverImagePath {
                    CoverImageView(path: cover, height: 160, cornerRadius: 0)
                }
                if let desc = city.description, !desc.isEmpty {
                    HTMLContentView(content: desc, fontSize: 13, lineSpacing: 4, allowsInteraction: false)
                        .padding(.top, 12)
                        .padding(.bottom, cityGuides.isEmpty ? 0 : 4)
                }

                if !cityGuides.isEmpty {
                    cityGuidesSection
                }

                if !attractions.isEmpty {
                    attractionsSection
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 16)
        }
    }

    private var cityGuidesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("City Guides")
                    .sectionTitleStyle()
                Spacer()
            }
            .padding(.top, 14)

            ForEach(cityGuides) { guide in
                Button {
                    onSelectCityGuide(guide)
                } label: {
                    CityGuideRowView(guide: guide)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, attractions.isEmpty ? 0 : 8)
    }

    private var attractionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Attractions")
                    .sectionTitleStyle()
                Spacer()
                Text("\(attractions.count) available")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(.top, cityGuides.isEmpty ? 14 : 10)

            ForEach(attractions) { attraction in
                Button {
                    onSelectAttraction(attraction)
                } label: {
                    AttractionRowView(attraction: attraction)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("Coming soon — we're adding content for \(city.name)")
                .font(Theme.FontToken.inter(13, weight: .medium))
                .multilineTextAlignment(.center)
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 12) {
            Text("Unable to load city content. Check your connection.")
                .font(Theme.FontToken.inter(13, weight: .medium))
                .multilineTextAlignment(.center)
            Text(message)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
            Button("Retry") {
                Task { await load() }
            }
            .font(Theme.FontToken.inter(12, weight: .medium))
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func load() async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        do {
            async let guidesTask = appEnv.content.fetchCityGuides(cityId: city.id)
            async let attractionsTask = appEnv.content.fetchAttractions(cityId: city.id)
            cityGuides = try await guidesTask
            attractions = try await attractionsTask
        } catch {
            cityGuides = (try? await appEnv.content.fetchCityGuides(cityId: city.id)) ?? []
            attractions = (try? await appEnv.content.fetchAttractions(cityId: city.id)) ?? []
            if cityGuides.isEmpty, attractions.isEmpty {
                loadError = JSONCoding.describe(error)
            }
        }
    }
}

struct AttractionRowView: View {
    private static let thumbnailSize: CGFloat = 92

    let attraction: Attraction

    private var coverPath: String? {
        attraction.coverImages.first ?? attraction.coverImagePath
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            coverThumbnail

            VStack(alignment: .leading, spacing: 4) {
                Text(attraction.name)
                    .font(Theme.FontToken.inter(14, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .lineLimit(2)
                if let short = attraction.shortDescription, !short.isEmpty {
                    Text(HTMLContentView.plainText(from: short))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineLimit(2)
                } else if let summary = attraction.summary, !summary.isEmpty {
                    Text(HTMLContentView.plainText(from: summary))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineLimit(2)
                }
                if attraction.audioGuideCount > 0 {
                    Text("🎧 Audio Guide available")
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    @ViewBuilder
    private var coverThumbnail: some View {
        if coverPath != nil {
            CoverImageView(
                path: coverPath,
                height: Self.thumbnailSize,
                width: Self.thumbnailSize
            )
        } else {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Theme.ColorToken.backgroundSubtle)
                .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                .overlay {
                    Image(systemName: "photo")
                        .foregroundStyle(Theme.ColorToken.textGhost)
                }
        }
    }
}
