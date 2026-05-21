import SwiftUI

struct GuideCityAttractionsView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let city: City
    let onSelectAttraction: (Attraction) -> Void

    @State private var attractions: [Attraction] = []
    @State private var loadError: String?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let loadError {
                errorState(message: loadError)
            } else if attractions.isEmpty {
                emptyState
            } else {
                attractionList
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

    private var attractionList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let cover = city.coverImagePath {
                    CoverImageView(path: cover, height: 160, cornerRadius: 0)
                }
                if let desc = city.description, !desc.isEmpty {
                    HTMLContentView(content: desc, fontSize: 13, lineSpacing: 4)
                        .padding(.top, 12)
                }

                ForEach(attractions) { attraction in
                    Button {
                        onSelectAttraction(attraction)
                    } label: {
                        AttractionRowView(attraction: attraction)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 16)
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
            Text("Unable to load attractions. Check your connection.")
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
            attractions = try await appEnv.content.fetchAttractions(cityId: city.id)
        } catch {
            attractions = []
            loadError = JSONCoding.describe(error)
        }
    }
}

struct AttractionRowView: View {
    let attraction: Attraction

    private var coverPath: String? {
        attraction.coverImages.first ?? attraction.coverImagePath
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if coverPath != nil {
                CoverImageView(path: coverPath, height: 100)
            }
            Text(attraction.name)
                .font(Theme.FontToken.inter(14, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textPrimary)
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
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}
