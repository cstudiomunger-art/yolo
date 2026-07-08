import SwiftUI

struct AttractionDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let listPreview: Attraction
    let route: GuideAttractionRoute

    @State private var attraction: Attraction?
    @State private var audioGuides: [AudioGuide] = []
    @State private var subAreas: [SubArea] = []
    @State private var subAreaAudio: [String: AudioGuide] = [:]
    @State private var resolvedGuides: [String: AudioGuide] = [:]
    @State private var loadError: String?
    @State private var isLoading = true
    @State private var introExpanded = false
    @State private var carouselIndex = 0
    @State private var fullScreenImagePath: String?
    @State private var showAddToast = false
    @State private var showPaywall = false
    @State private var accessRevision = 0
    @State private var copiedField: CopyField?

    private let subAreasAnchor = "exploreByArea"

    private var display: Attraction { attraction ?? listPreview }
    private var cityName: String { route.presentation.browseCityName ?? "Guide" }

    private var hasFullAccess: Bool {
        _ = accessRevision
        return hasContentAccess(\.audioGuides)
    }

    private func hasContentAccess(_ flag: KeyPath<MembershipPlan.AccessFlags, Bool>) -> Bool {
        if !appEnv.contentMode.effectiveUseRemoteIAP { return true }
        return appEnv.purchase.hasContentAccess(
            flag,
            requiresPurchase: display.requiresPurchase,
            contentId: display.id
        )
    }

    private var baseMainGuide: AudioGuide? {
        audioGuides.first(where: \.isMainGuide) ?? audioGuides.first
    }

    private var mainGuide: AudioGuide? {
        guard let base = baseMainGuide else { return nil }
        return resolvedGuides[base.id] ?? base
    }

    private func resolvedGuide(for base: AudioGuide) -> AudioGuide {
        resolvedGuides[base.id] ?? base
    }

    /// Attraction-scoped play queue: the attraction's audio guides followed by each sub-area's
    /// audio, deduplicated by guide id. Powers next/previous and the mini-player's playlist.
    private var attractionAudioQueue: [AudioTrack] {
        var seen = Set<String>()
        var tracks: [AudioTrack] = []
        for g in audioGuides {
            let play = resolvedGuide(for: g)
            guard seen.insert(play.id).inserted else { continue }
            tracks.append(AudioTrack(
                guide: play,
                title: g.titleEn,
                artist: display.name,
                attraction: display,
                subArea: nil,
                allowsPreview: true,
                voiceOwner: AudioVoiceOwner(type: .audioGuide, id: g.id),
                baseGuide: g
            ))
        }
        for area in subAreas {
            guard let base = subAreaAudio[area.id] else { continue }
            let play = resolvedGuide(for: base)
            guard seen.insert(play.id).inserted else { continue }
            let owner = area.playbackGuide(attractionId: display.id) != nil
                ? AudioVoiceOwner(type: .subArea, id: area.id)
                : AudioVoiceOwner(type: .audioGuide, id: base.id)
            tracks.append(AudioTrack(
                guide: play,
                title: base.titleEn,
                artist: display.name,
                attraction: display,
                subArea: area,
                allowsPreview: true,
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
            } else if display.name.isEmpty {
                comingSoonPlaceholder
            } else {
                detailScroll
            }
        }
        .navigationTitle(display.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationSwipeBack { handleBack() }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    handleBack()
                } label: {
                    Text(backTitle)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if case .planAddToDay(let dayIndex) = route.presentation {
                addToDayBar(dayIndex: dayIndex)
            } else if shouldShowUnlockBar {
                unlockStickyBar
            }
        }
        .sheet(isPresented: $showPaywall) {
            MembershipPlansView(
                attraction: display,
                guide: mainGuide,
                priceTierId: display.priceTierId
            )
            .environment(appEnv)
        }
        .refreshable { await loadDetail(attractionId: listPreview.id) }
        .task(id: listPreview.id) {
            await loadDetail(attractionId: listPreview.id)
        }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await loadDetail(attractionId: listPreview.id) }
        }
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
        .overlay(alignment: .top) {
            if loadError != nil, !isLoading {
                Text("Unable to load content. Pull to refresh.")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Theme.ColorToken.urgent.opacity(0.9))
            }
        }
    }

    private var backTitle: String {
        switch route.presentation {
        case .browse: "← \(cityName)"
        case .planDay(let day): "← Back to Day \(day + 1)"
        case .planAddToDay: "← Back to Itinerary"
        }
    }

    private func handleBack() {
        switch route.presentation {
        case .planDay:
            appEnv.navigation.returnToPlanFromGuide()
        case .browse, .planAddToDay:
            dismiss()
        }
    }

    private var detailScroll: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    coverCarousel
                    titleBlock
                    audioSection
                    introductionSection
                    subAreasSection
                        .id(subAreasAnchor)
                    practicalInfoSection
                    visitorTipsSection
                }
                .padding(Theme.screenPadding)
                .padding(.bottom, route.presentation.isPlanAdd ? 72 : 16)
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: "guide.scrollToSubAreas.\(listPreview.id)") {
                    proxy.scrollTo(subAreasAnchor, anchor: .top)
                    UserDefaults.standard.set(false, forKey: "guide.scrollToSubAreas.\(listPreview.id)")
                }
            }
        }
    }

    private var coverCarousel: some View {
        let images = display.coverImages.isEmpty
            ? (display.coverImagePath.map { [$0] } ?? [])
            : display.coverImages
        return Group {
            if images.isEmpty {
                EmptyView()
            } else if images.count == 1, let path = images.first {
                Button { fullScreenImagePath = path } label: {
                    CoverImageView(path: path, height: 220, cornerRadius: 0)
                }
                .buttonStyle(.plain)
            } else {
                TabView(selection: $carouselIndex) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, path in
                        Button { fullScreenImagePath = path } label: {
                            CoverImageView(path: path, height: 220, cornerRadius: 0)
                        }
                        .buttonStyle(.plain)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 220)
            }
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(display.name)
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                Spacer(minLength: 8)
                FavoriteAttractionButton(attraction: display)
            }
            if !display.chineseName.isEmpty {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(display.chineseName)
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    copyButton(text: display.chineseName, field: .name)
                }
            }
            if let en = display.addressEn, !en.isEmpty {
                Text("📍 \(en)")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let zh = display.addressZh, !zh.isEmpty {
                Button {
                    UIPasteboard.general.string = zh
                    withAnimation(.easeInOut(duration: 0.15)) { copiedField = .address }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if copiedField == .address { copiedField = nil }
                        }
                    }
                } label: {
                    addressLabel(zh)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private enum CopyField { case name, address }

    @ViewBuilder
    private func copyButton(text: String, field: CopyField) -> some View {
        Button {
            UIPasteboard.general.string = text
            withAnimation(.easeInOut(duration: 0.15)) { copiedField = field }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if copiedField == field { copiedField = nil }
                }
            }
        } label: {
            Image(systemName: copiedField == field ? "checkmark" : "doc.on.doc")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(copiedField == field ? Color.green : Theme.ColorToken.accent)
        }
        .buttonStyle(.plain)
    }

    /// Address text with the copy icon flowing inline at the end, so a long
    /// address wraps to multiple lines and the icon follows the last character.
    private func addressLabel(_ text: String) -> some View {
        let copied = copiedField == .address
        return HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(text)
                .foregroundColor(Theme.ColorToken.textMuted)
            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(copied ? Color.green : Theme.ColorToken.accent)
        }
        .font(Theme.FontToken.inter(12))
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var audioSection: some View {
        if let base = baseMainGuide {
            Text("🎧 Audio Guide")
                .sectionTitleStyle()
            let queue = attractionAudioQueue
            AudioGuideSection(
                attraction: display,
                guide: base,
                voiceOwner: AudioVoiceOwner(type: .audioGuide, id: base.id),
                allowsPreview: true,
                showsUnlockButton: !shouldShowUnlockBar,
                queue: queue,
                trackIndex: queue.firstIndex(where: { $0.guide.id == (resolvedGuides[base.id] ?? base).id }) ?? 0
            )
        }
    }

    @ViewBuilder
    private var introductionSection: some View {
        if !detailBody.isEmpty {
            let body = detailBody
            let hasAccess = hasContentAccess(\.textContent)
            let freeChars = appEnv.contentMode.branding.freeTextPreviewChars
            Text("Introduction")
                .sectionTitleStyle()
            VStack(alignment: .leading, spacing: 8) {
                if hasAccess {
                    HTMLContentView(content: body, lineSpacing: 5, lineLimit: introExpanded ? nil : 3)
                    if HTMLContentView.plainText(from: body).count > 120 {
                        Button(introExpanded ? "Read less ▲" : "Read more ▼") {
                            introExpanded.toggle()
                        }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                    }
                } else {
                    ContentPaywallOverlay(
                        htmlContent: body,
                        freeChars: freeChars,
                        hasAccess: false,
                        attraction: display,
                        priceTierId: display.priceTierId,
                        showsUnlockButton: !shouldShowUnlockBar
                    )
                }
            }
            .guideContentCardStyle()
        }
    }

    @ViewBuilder
    private var subAreasSection: some View {
        if !subAreas.isEmpty {
            Text("Explore by Area")
                .sectionTitleStyle()
            ForEach(subAreas) { area in
                NavigationLink(value: GuideRoute.subArea(GuideSubAreaRoute(
                    subAreaId: area.id,
                    attractionId: display.id,
                    attractionName: display.name
                ))) {
                    SubAreaRowView(
                        area: area,
                        audioGuide: subAreaAudio[area.id],
                        hasAccess: hasFullAccess
                    )
                }
                .buttonStyle(.plain)
                .simultaneousGesture(TapGesture().onEnded {
                    UserDefaults.standard.set(true, forKey: "guide.scrollToSubAreas.\(display.id)")
                })
            }
        }
    }

    @ViewBuilder
    private var practicalInfoSection: some View {
        let items = display.practicalInfo.filter {
            !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        let hasAddress = display.addressZh?.isEmpty == false
        if !items.isEmpty || hasAddress {
            Text("Practical Info")
                .sectionTitleStyle()
            ForEach(items, id: \.self) { item in
                let icon = (item.icon?.isEmpty == false) ? (item.icon ?? "•") : "•"
                let line = item.label.isEmpty ? item.value : "\(item.label): \(item.value)"
                infoRow(icon, line)
            }
            if let zh = display.addressZh, !zh.isEmpty {
                infoRow("📍", zh)
            }
        }
    }

    @ViewBuilder
    private var visitorTipsSection: some View {
        if !display.westernVisitorTips.isEmpty {
            Text("Visitor Tips")
                .sectionTitleStyle()
            VisitorTipsPaywallOverlay(
                tips: display.westernVisitorTips,
                freeCount: appEnv.contentMode.branding.freeVisitorTipsCount,
                hasAccess: hasContentAccess(\.visitorTips),
                attraction: display,
                priceTierId: display.priceTierId
            )
        }
    }

    private var comingSoonPlaceholder: some View {
        VStack(spacing: 12) {
            Text("Content coming soon for this attraction")
                .font(Theme.FontToken.inter(14, weight: .medium))
                .multilineTextAlignment(.center)
        }
        .padding(Theme.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func infoRow(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
            Text(text)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textSecondary)
        }
    }

    private func addToDayBar(dayIndex: Int) -> some View {
        VStack(spacing: 0) {
            if showAddToast {
                Text("Added to Day \(dayIndex + 1)")
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background(Theme.ColorToken.accent)
            }
            Button {
                appEnv.navigation.guideAddToItineraryHandler?(display)
                showAddToast = true
                Task {
                    try? await Task.sleep(for: .seconds(1.2))
                    dismiss()
                }
            } label: {
                Text("+ Add to Day \(dayIndex + 1)")
                    .font(Theme.FontToken.inter(13, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)
        }
        .background(Theme.ColorToken.background)
    }

    // MARK: - Sticky unlock bar (locked state)

    private var shouldShowUnlockBar: Bool {
        guard case .browse = route.presentation else { return false }
        guard !isLoading, !display.name.isEmpty else { return false }
        return !hasFullAccess
    }

    private var unlockStickyBar: some View {
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

    private var detailBody: String {
        let intro = display.introduction?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !intro.isEmpty { return intro }
        return display.summary?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    private func loadDetail(attractionId: String) async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }

        do {
            if let full = try await appEnv.content.fetchAttraction(id: attractionId) {
                attraction = full
            } else {
                attraction = listPreview
                loadError = "Attraction is not published or was removed."
            }
            async let guidesTask = appEnv.content.fetchAudioGuides(attractionId: attractionId)
            async let areasTask = appEnv.content.fetchSubAreas(attractionId: attractionId)
            audioGuides = try await guidesTask
            let areas = (try? await areasTask) ?? []
            subAreas = areas
            var audioMap: [String: AudioGuide] = [:]
            var resolved: [String: AudioGuide] = [:]
            for area in areas {
                if let direct = area.playbackGuide(attractionId: attractionId) {
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
        } catch {
            attraction = listPreview
            audioGuides = []
            subAreas = []
            subAreaAudio = [:]
            resolvedGuides = [:]
            loadError = JSONCoding.describe(error)
        }
    }
}

extension GuidePresentationContext {
    var browseCityName: String? {
        if case .browse(let name) = self { return name }
        return nil
    }

    var isPlanAdd: Bool {
        if case .planAddToDay = self { return true }
        return false
    }
}
