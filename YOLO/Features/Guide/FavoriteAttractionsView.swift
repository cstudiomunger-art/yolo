import SwiftUI

struct FavoriteAttractionsView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let cities: [City]
    let onSelectAttraction: (GuideAttractionRoute) -> Void

    @State private var loadedAttractions: [String: Attraction] = [:]
    @State private var isLoading = true

    private var records: [FavoriteAttractionRecord] {
        appEnv.preferences.favoriteAttractions
    }

    var body: some View {
        Group {
            if isLoading && records.isEmpty == false {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if records.isEmpty {
                emptyState
            } else {
                favoritesList
            }
        }
        .navigationTitle(String(localized: "My Favorites"))
        .navigationBarTitleDisplayMode(.inline)
        .task(id: records.map(\.attractionId)) {
            await loadAttractions()
        }
        .onChange(of: appEnv.preferences.favoriteAttractions) { _, _ in
            Task { await loadAttractions() }
        }
    }

    private var favoritesList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(records) { record in
                    favoriteRow(for: record)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private func favoriteRow(for record: FavoriteAttractionRecord) -> some View {
        let attraction = loadedAttractions[record.attractionId]
            ?? Attraction.stub(id: record.attractionId, cityId: record.cityId)

        AttractionRowView(attraction: attraction) {
            let cityName = cities.first(where: { $0.id == record.cityId })?.name ?? record.cityId
            onSelectAttraction(GuideAttractionRoute(
                attractionId: record.attractionId,
                cityId: record.cityId,
                presentation: .browse(cityName: cityName)
            ))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 36))
                .foregroundStyle(Theme.ColorToken.textGhost)
            Text(String(localized: "No favorites yet"))
                .font(Theme.FontToken.inter(14, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func loadAttractions() async {
        isLoading = true
        defer { isLoading = false }

        let currentRecords = records
        guard !currentRecords.isEmpty else {
            loadedAttractions = [:]
            return
        }

        var resolved: [String: Attraction] = [:]
        await withTaskGroup(of: (String, Attraction?).self) { group in
            for record in currentRecords {
                group.addTask {
                    let attraction = try? await appEnv.content.fetchAttraction(id: record.attractionId)
                    return (record.attractionId, attraction)
                }
            }
            for await (id, attraction) in group {
                if let attraction {
                    resolved[id] = attraction
                }
            }
        }
        loadedAttractions = resolved
    }
}
