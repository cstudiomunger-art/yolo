import SwiftUI

struct CityGuideDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let listPreview: CityGuide
    let route: GuideCityGuideRoute

    @State private var guide: CityGuide?
    @State private var loadError: String?
    @State private var isLoading = true
    @State private var carouselIndex = 0
    @State private var fullScreenImagePath: String?

    private var display: CityGuide { guide ?? listPreview }

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                detailScroll
            }
        }
        .navigationTitle(display.titleEn)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Text("← \(route.cityName)")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
        }
        .refreshable { await loadDetail() }
        .task(id: listPreview.id) { await loadDetail() }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await loadDetail() }
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

    private var detailScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                coverCarousel
                titleBlock
                audioSection
                bodySection
            }
            .padding(Theme.screenPadding)
            .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    private var coverCarousel: some View {
        let images = display.coverImages
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

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let badge = display.badge, !badge.isEmpty {
                Text(badge.uppercased())
                    .font(Theme.FontToken.inter(9, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Theme.ColorToken.accent.opacity(0.6), lineWidth: 1)
                    )
            }

            Text(display.titleEn)
                .font(Theme.FontToken.playfair(22, weight: .semibold))

            if let zh = display.titleZh, !zh.isEmpty {
                Text(zh)
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            metaRow
        }
    }

    private var metaItems: [PracticalInfoItem] {
        display.metaItems.filter {
            !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    @ViewBuilder
    private var metaRow: some View {
        if !metaItems.isEmpty {
            HStack(spacing: 14) {
                ForEach(metaItems, id: \.self) { item in
                    Text(metaLine(for: item))
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            .padding(.top, 4)
        }
    }

    private func metaLine(for item: PracticalInfoItem) -> String {
        let icon = item.icon?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let label = item.label.trimmingCharacters(in: .whitespacesAndNewlines)
        let value = item.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefix = icon.isEmpty ? "" : "\(icon) "
        if label.isEmpty {
            return "\(prefix)\(value)"
        }
        return "\(prefix)\(label) · \(value)"
    }

    @ViewBuilder
    private var audioSection: some View {
        if let audioGuide = display.playbackGuide() {
            Text("🎧 Audio Guide")
                .sectionTitleStyle()
            CityGuideAudioSection(guide: display, audioGuide: audioGuide)
        }
    }

    @ViewBuilder
    private var bodySection: some View {
        if let body = display.body?.trimmingCharacters(in: .whitespacesAndNewlines), !body.isEmpty {
            HTMLContentView(content: body, lineSpacing: 5)
                .guideContentCardStyle()
        }
    }

    private func loadDetail() async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        do {
            guide = try await appEnv.content.fetchCityGuide(id: listPreview.id) ?? listPreview
        } catch {
            guide = listPreview
            loadError = JSONCoding.describe(error)
        }
    }
}
