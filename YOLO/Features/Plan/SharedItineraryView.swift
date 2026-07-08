import SwiftUI

struct SharedItineraryView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let slug: String
    @State private var itinerary: SampleItinerary?
    @State private var loadError: String?
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView(String(localized: "Loading trip…"))
                } else if let itinerary {
                    SharedItineraryContent(itinerary: itinerary)
                } else {
                    ContentUnavailableView(
                        String(localized: "Trip not found"),
                        systemImage: "link.badge.plus",
                        description: Text(loadError ?? String(localized: "This link may have expired or sharing was turned off."))
                    )
                }
            }
            .navigationTitle(itinerary?.title ?? String(localized: "Shared trip"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
            .task(id: slug) {
                await load()
            }
        }
        .sheetDragToDismiss()
    }

    private func load() async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        guard AppConfig.isSupabaseConfigured else {
            loadError = String(localized: "Connect to the internet to open shared trips.")
            return
        }
        do {
            if let row = try await ItineraryRepository().fetchByShareSlug(slug) {
                itinerary = row.asSampleItinerary
                TelemetryService.shared.logEvent("shared_itinerary_open", parameters: ["slug": slug])
            } else {
                loadError = String(localized: "No shared itinerary matches this link.")
            }
        } catch {
            loadError = error.localizedDescription
        }
    }
}

private struct SharedItineraryContent: View {
    let itinerary: SampleItinerary

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Read-only · shared with YOLO HAPPY"))
                    .font(Theme.FontToken.inter(10, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                Text(itinerary.meta)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textSecondary)

                ForEach(itinerary.days) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(day.dateLabel)
                            .font(Theme.FontToken.inter(12, weight: .semibold))
                        ForEach(day.activities) { act in
                            Text("• \(act.name)")
                                .font(Theme.FontToken.inter(12))
                                .foregroundStyle(Theme.ColorToken.textSecondary)
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.ColorToken.backgroundSubtle)
                }
            }
            .padding(Theme.screenPadding)
        }
        .background(Theme.ColorToken.background)
    }
}
