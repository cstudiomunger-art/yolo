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
    @State private var showPurchase = false

    private var hasFullAccess: Bool {
        guard let attraction else { return false }
        return appEnv.preferences.hasAccessToAttraction(attraction.id, iapProductId: attraction.iapProductId)
            || !appEnv.contentMode.useRemoteIAP
    }

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
        .sheet(isPresented: $showPurchase) {
            if let attraction {
                PurchaseOptionsView(attraction: attraction, guide: audioGuide) {}
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
                    if hasFullAccess {
                        AudioGuideSection(
                            attraction: attraction,
                            guide: guide,
                            includedWithLabel: "Included with \(route.attractionName) audio guide",
                            allowsPreview: false
                        )
                    } else {
                        lockedAudioBlock(attraction: attraction, guide: guide)
                    }
                }

                if let body = area.body?.trimmingCharacters(in: .whitespacesAndNewlines), !body.isEmpty {
                    HTMLContentView(content: body)
                } else if !area.contentBlocks.isEmpty {
                    ForEach(area.contentBlocks, id: \.self) { block in
                        SubAreaContentBlockView(block: block) { path in
                            fullScreenImagePath = path
                        }
                    }
                }
            }
            .padding(Theme.screenPadding)
        }
    }

    private func lockedAudioBlock(attraction: Attraction, guide: AudioGuide) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🎧 \(guide.titleEn)")
                .font(Theme.FontToken.inter(14, weight: .medium))
            Text("Included with \(route.attractionName) audio guide")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
            HStack {
                Text("🔒 Full guide locked")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                Text("🔒")
            }
            Button("Unlock Audio Guide") {
                showPurchase = true
            }
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.ColorToken.accent)
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
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
