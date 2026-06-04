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
    @State private var loadError: String?
    @State private var isLoading = true
    @State private var introExpanded = false
    @State private var carouselIndex = 0
    @State private var fullScreenImagePath: String?
    @State private var showAddToast = false
    @State private var showPaywall = false

    private let subAreasAnchor = "exploreByArea"

    private var display: Attraction { attraction ?? listPreview }
    private var cityName: String { route.presentation.browseCityName ?? "Guide" }

    private var hasFullAccess: Bool {
        if !appEnv.contentMode.effectiveUseRemoteIAP { return true }
        return appEnv.purchase.hasAccess(to: \.audioGuides, for: display.id)
            || appEnv.preferences.hasAccessToAttraction(display.id, iapProductId: display.iapProductId)
    }

    private func hasContentAccess(_ flag: KeyPath<MembershipPlan.AccessFlags, Bool>) -> Bool {
        if !appEnv.contentMode.effectiveUseRemoteIAP { return true }
        if display.textPaywallFree { return true }
        return appEnv.purchase.hasAccess(to: flag, for: display.id)
    }

    private var mainGuide: AudioGuide? {
        audioGuides.first(where: \.isMainGuide) ?? audioGuides.first
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
            if let guide = mainGuide {
                MembershipPlansView(attraction: display, guide: guide)
                    .environment(appEnv)
            } else {
                MembershipPlansView(attraction: display)
                    .environment(appEnv)
            }
        }
        .refreshable { await loadDetail(attractionId: listPreview.id) }
        .task(id: listPreview.id) {
            await loadDetail(attractionId: listPreview.id)
        }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await loadDetail(attractionId: listPreview.id) }
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
            if let loadError, !isLoading {
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
            Text(display.name)
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text(display.chineseName)
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
            if let en = display.addressEn, !en.isEmpty {
                Text("📍 \(en)")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            if let zh = display.addressZh, !zh.isEmpty {
                Text(zh)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
    }

    @ViewBuilder
    private var audioSection: some View {
        if let guide = mainGuide {
            Text("🎧 Audio Guide")
                .sectionTitleStyle()
            AudioGuideSection(attraction: display, guide: guide, allowsPreview: true)
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
                        attraction: display
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
                attraction: display
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
            for area in areas {
                if let direct = area.playbackGuide(attractionId: attractionId) {
                    audioMap[area.id] = direct
                } else if let gid = area.audioGuideId,
                          let guide = try? await appEnv.content.fetchAudioGuide(id: gid) {
                    audioMap[area.id] = guide
                    audioMap[gid] = guide
                }
            }
            subAreaAudio = audioMap
        } catch {
            attraction = listPreview
            audioGuides = []
            subAreas = []
            subAreaAudio = [:]
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
