import SwiftUI

struct SubAreaDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let route: GuideSubAreaRoute

    @State private var subArea: SubArea?
    @State private var attraction: Attraction?
    @State private var audioGuide: AudioGuide?
    @State private var audioGuides: [AudioGuide] = []
    @State private var subAreas: [SubArea] = []
    @State private var subAreaAudio: [String: AudioGuide] = [:]
    @State private var resolvedGuides: [String: AudioGuide] = [:]
    @State private var isLoading = true
    @State private var fullScreenImagePath: String?
    @State private var showPaywall = false
    @State private var accessRevision = 0

    private func resolvedGuide(for base: AudioGuide) -> AudioGuide {
        resolvedGuides[base.id] ?? base
    }

    /// Attraction-scoped play queue: the attraction's audio guides followed by each sub-area's
    /// audio, deduplicated by guide id — identical to AttractionDetailView so tapping a sub-area
    /// audio plays within the whole attraction's playlist (next/previous across all areas).
    private var attractionAudioQueue: [AudioTrack] {
        guard let attraction else { return [] }
        var seen = Set<String>()
        var tracks: [AudioTrack] = []
        for g in audioGuides {
            let play = resolvedGuide(for: g)
            guard seen.insert(play.id).inserted else { continue }
            tracks.append(AudioTrack(
                guide: play, title: g.titleEn, artist: attraction.name,
                attraction: attraction, subArea: nil, allowsPreview: true,
                voiceOwner: AudioVoiceOwner(type: .audioGuide, id: g.id),
                baseGuide: g
            ))
        }
        for area in subAreas {
            guard let base = subAreaAudio[area.id] else { continue }
            let play = resolvedGuide(for: base)
            guard seen.insert(play.id).inserted else { continue }
            let owner = area.playbackGuide(attractionId: route.attractionId) != nil
                ? AudioVoiceOwner(type: .subArea, id: area.id)
                : AudioVoiceOwner(type: .audioGuide, id: base.id)
            tracks.append(AudioTrack(
                guide: play, title: base.titleEn, artist: attraction.name,
                attraction: attraction, subArea: area, allowsPreview: true,
                voiceOwner: owner,
                baseGuide: base
            ))
        }
        return tracks
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
        .navigationSwipeBackEnabled()
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
        .safeAreaInset(edge: .bottom) {
            if let area = unlockableSubArea {
                unlockStickyBar(for: area)
            }
        }
        .sheet(isPresented: $showPaywall) {
            if let area = subArea, let attraction {
                MembershipPlansView(
                    attraction: attraction,
                    guide: audioGuide,
                    priceTierId: area.priceTierId,
                    purchaseTargetId: area.id,
                    displayTitle: area.nameEn
                )
                .environment(appEnv)
            }
        }
        .task(id: route.subAreaId) { await load() }
        .onChange(of: appEnv.membershipRevision) { _, _ in
            accessRevision += 1
        }
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

                if let base = audioGuide, let attraction, let area = subArea {
                    let play = resolvedGuide(for: base)
                    let queue = attractionAudioQueue
                    Text("🎧 Area Audio")
                        .sectionTitleStyle()
                    AudioGuideSection(
                        attraction: attraction,
                        guide: base,
                        voiceOwner: AudioVoiceOwner(type: .subArea, id: area.id),
                        includedWithLabel: String(
                            format: String(localized: "Included with %@ audio guide"),
                            route.attractionName
                        ),
                        allowsPreview: true,
                        showsUnlockButton: false,
                        subArea: area,
                        queue: queue,
                        trackIndex: queue.firstIndex(where: { $0.guide.id == play.id }) ?? 0
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
                        displayTitle: area.nameEn,
                        showsUnlockButton: false
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

    /// The sub-area to gate behind the sticky bottom unlock bar: only when the parent
    /// attraction is loaded (needed to present the paywall) and the area isn't unlocked yet.
    private var unlockableSubArea: SubArea? {
        guard !isLoading, attraction != nil, let area = subArea else { return nil }
        return subAreaHasFullAccess(area) ? nil : area
    }

    /// Whether both the audio and text of a sub-area are unlocked (a single purchase unlocks both).
    private func subAreaHasFullAccess(_ area: SubArea) -> Bool {
        _ = accessRevision
        if !appEnv.contentMode.effectiveUseRemoteIAP { return true }
        let audioOK = appEnv.purchase.hasContentAccess(
            \.audioGuides, requiresPurchase: area.requiresPurchase,
            contentId: area.id, parentId: area.attractionId
        )
        let textOK = appEnv.purchase.hasContentAccess(
            \.textContent, requiresPurchase: area.requiresPurchase,
            contentId: area.id, parentId: area.attractionId
        )
        return audioOK && textOK
    }

    private func unlockStickyBar(for area: SubArea) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "Unlock this Guide"))
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text(String(localized: "audio + full article"))
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
            Button {
                showPaywall = true
            } label: {
                Text(String(localized: "Unlock"))
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .tracking(0.8)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 11)
                    .background(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.vertical, 11)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    /// Text access for a sub-area: free items always open; otherwise member / single / parent purchase.
    private func subAreaTextAccess(_ area: SubArea) -> Bool {
        _ = accessRevision
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
        async let guidesTask = appEnv.content.fetchAudioGuides(attractionId: route.attractionId)
        let areas = (try? await appEnv.content.fetchSubAreas(attractionId: route.attractionId)) ?? []
        subAreas = areas
        audioGuides = (try? await guidesTask) ?? []
        subArea = areas.first { $0.id == route.subAreaId }

        // Resolve audio for every area so the playlist spans the whole attraction.
        var audioMap: [String: AudioGuide] = [:]
        var resolved: [String: AudioGuide] = [:]
        for area in areas {
            if let direct = area.playbackGuide(attractionId: route.attractionId) {
                audioMap[area.id] = direct
                let owner = AudioVoiceOwner(type: .subArea, id: area.id)
                resolved[direct.id] = await AudioVoicePlaybackSupport.resolveGuide(
                    base: direct,
                    owner: owner,
                    content: appEnv.content,
                    preferences: appEnv.preferences
                )
            } else if let gid = area.audioGuideId,
                      let guide = try? await appEnv.content.fetchAudioGuide(id: gid) {
                audioMap[area.id] = guide
                audioMap[gid] = guide
                let owner = AudioVoiceOwner(type: .audioGuide, id: guide.id)
                resolved[guide.id] = await AudioVoicePlaybackSupport.resolveGuide(
                    base: guide,
                    owner: owner,
                    content: appEnv.content,
                    preferences: appEnv.preferences
                )
            }
        }
        for g in audioGuides {
            let owner = AudioVoiceOwner(type: .audioGuide, id: g.id)
            resolved[g.id] = await AudioVoicePlaybackSupport.resolveGuide(
                base: g,
                owner: owner,
                content: appEnv.content,
                preferences: appEnv.preferences
            )
        }
        subAreaAudio = audioMap
        resolvedGuides = resolved
        if let area = subArea { audioGuide = audioMap[area.id] }
    }
}
