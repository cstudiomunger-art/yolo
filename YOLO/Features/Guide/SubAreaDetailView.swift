import SwiftUI

struct SubAreaDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let route: GuideSubAreaRoute

    @State private var subArea: SubArea?
    @State private var attraction: Attraction?
    @State private var audioGuide: AudioGuide?
    @State private var isLoading = true
    @State private var fullScreenImagePath: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let subArea {
                detailContent(subArea)
            } else {
                Text("Content coming soon for this area")
                    .font(Theme.FontToken.inter(13))
                    .padding(Theme.screenPadding)
            }
        }
        .navigationTitle(subArea?.nameEn ?? route.attractionName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("← \(route.attractionName)")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineLimit(1)
                }
            }
        }
        .task(id: route.subAreaId) { await load() }
        .fullScreenCover(isPresented: Binding(
            get: { fullScreenImagePath != nil },
            set: { if !$0 { fullScreenImagePath = nil } }
        )) {
            if let path = fullScreenImagePath {
                GuideFullScreenImage(path: path)
            }
        }
    }

    @ViewBuilder
    private func detailContent(_ area: SubArea) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let cover = area.coverImagePath {
                    Button { fullScreenImagePath = cover } label: {
                        CoverImageView(path: cover, height: 200, cornerRadius: 0)
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(area.nameEn)
                        .font(Theme.FontToken.playfair(20, weight: .semibold))
                    if let zh = area.nameZh, !zh.isEmpty {
                        Text(zh)
                            .font(Theme.FontToken.inter(13))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }

                if let guide = audioGuide, let attraction {
                    Text("🎧 Area Audio")
                        .sectionTitleStyle()
                    AudioGuideSection(
                        attraction: attraction,
                        guide: guide,
                        includedWithLabel: String(
                            format: String(localized: "Included with %@ audio guide"),
                            route.attractionName
                        ),
                        allowsPreview: true,
                        subArea: area
                    )
                }

                if let body = area.body?.trimmingCharacters(in: .whitespacesAndNewlines), !body.isEmpty {
                    ContentPaywallOverlay(
                        htmlContent: body,
                        freeChars: appEnv.contentMode.branding.freeTextPreviewChars,
                        hasAccess: subAreaTextAccess(area),
                        attraction: attraction,
                        priceTierId: area.priceTierId,
                        purchaseTargetId: area.id,
                        displayTitle: area.nameEn
                    )
                    .guideContentCardStyle()
                } else if !area.contentBlocks.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(area.contentBlocks, id: \.self) { block in
                            SubAreaContentBlockView(block: block) { path in
                                fullScreenImagePath = path
                            }
                        }
                    }
                    .guideContentCardStyle()
                }
            }
            .padding(Theme.screenPadding)
        }
    }

    /// Text access for a sub-area: free items always open; otherwise member / single / parent purchase.
    private func subAreaTextAccess(_ area: SubArea) -> Bool {
        if !appEnv.contentMode.effectiveUseRemoteIAP { return true }
        return appEnv.purchase.hasContentAccess(
            \.textContent,
            requiresPurchase: area.requiresPurchase,
            // Use the sub-area's own parent id so a parent purchase still unlocks it
            // even if the parent Attraction object failed to load.
            contentId: area.id,
            parentId: area.attractionId
        )
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        attraction = try? await appEnv.content.fetchAttraction(id: route.attractionId)
        let areas = (try? await appEnv.content.fetchSubAreas(attractionId: route.attractionId)) ?? []
        subArea = areas.first { $0.id == route.subAreaId }
        if let area = subArea, let direct = area.playbackGuide(attractionId: route.attractionId) {
            audioGuide = direct
        } else if let gid = subArea?.audioGuideId {
            audioGuide = try? await appEnv.content.fetchAudioGuide(id: gid)
        }
    }
}
