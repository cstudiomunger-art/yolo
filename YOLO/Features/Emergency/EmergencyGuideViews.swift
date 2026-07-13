import SwiftUI

struct EmergencyContentDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let item: EmergencyContentItem

    @State private var resolved: EmergencyContentItem?
    @State private var isLoading = false
    @State private var loadFailed = false

    private var display: EmergencyContentItem { resolved ?? item }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(display.displayTitle)
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                if isLoading {
                    ProgressView()
                        .padding(.vertical, 8)
                } else if !display.displayBody.isEmpty {
                    MarkdownContentView(content: display.displayBody, fontSize: 14, lineSpacing: 5)
                } else {
                    Text(loadFailed
                        ? "Unable to load this guide. Pull to refresh or try again when online."
                        : "Content is not available offline. Refresh from CMS when online.")
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.screenPadding)
        }
        .navigationTitle(display.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await loadDetail(force: true) }
        .task(id: item.id) { await loadDetail(force: item.displayBody.isEmpty) }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await loadDetail(force: true) }
        }
    }

    @MainActor
    private func loadDetail(force: Bool) async {
        if !force, !(resolved ?? item).displayBody.isEmpty { return }
        isLoading = true
        loadFailed = false
        defer { isLoading = false }

        if let cache = appEnv.content as? CachingContentRepository {
            await cache.invalidateEmergencyContent()
        }

        let help = (try? await appEnv.content.fetchEmergencyHelpItems()) ?? []
        let medical = (try? await appEnv.content.fetchEmergencyMedicalItems()) ?? []
        if let match = (help + medical).first(where: { $0.id == item.id }),
           !match.displayBody.isEmpty {
            resolved = match
            return
        }

        if !(resolved ?? item).displayBody.isEmpty {
            return
        }
        loadFailed = true
    }
}
