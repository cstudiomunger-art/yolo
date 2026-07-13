import SwiftUI

struct GuideView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var path = NavigationPath()
    @State private var cities: [City] = []
    @State private var cultureTips: [CultureTip] = []
    @State private var publishedAttractionCounts: [String: Int] = [:]

    var body: some View {
        NavigationStack(path: $path) {
            GuideHomeView(
                cities: cities,
                publishedAttractionCounts: publishedAttractionCounts,
                onSelectCity: { city in
                    path.append(GuideRoute.city(city.id))
                },
                onOpenFavorites: {
                    path.append(GuideRoute.favorites)
                }
            )
            .navigationBarHidden(true)
            .navigationDestination(for: GuideRoute.self) { route in
                destination(for: route)
            }
        }
        .background(Theme.ColorToken.background)
        .task { await load() }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await load() }
        }
        .onChange(of: appEnv.navigation.guideDeepLinkRevision) { _, _ in
            Task { await applyDeepLink() }
        }
        .onChange(of: appEnv.navigation.guideStackResetRevision) { _, _ in
            path = NavigationPath()
        }
        .onChange(of: path.count) { _, count in
            appEnv.navigation.guidePathCount = count
        }
    }

    @ViewBuilder
    private func destination(for route: GuideRoute) -> some View {
        switch route {
        case .city(let cityId):
            if let city = cities.first(where: { $0.id == cityId }) {
                GuideCityAttractionsView(
                    city: city,
                    onSelectCityGuide: { guide in
                        path.append(GuideRoute.cityGuide(GuideCityGuideRoute(
                            guideId: guide.id,
                            cityId: city.id,
                            cityName: city.name
                        )))
                    },
                    onSelectAttraction: { attraction in
                        path.append(GuideRoute.attraction(GuideAttractionRoute(
                            attractionId: attraction.id,
                            cityId: city.id,
                            presentation: .browse(cityName: city.name)
                        )))
                    }
                )
            } else {
                Text("City not found")
                    .padding()
            }
        case .cityGuide(let route):
            CityGuideDetailLoaderView(route: route)
        case .cultureTips:
            GuideCultureTipsView(tips: cultureTips) { tip in
                path.append(GuideRoute.cultureTip(tip.id))
            }
        case .cultureTip(let tipId):
            if let tip = cultureTips.first(where: { $0.id == tipId }) {
                CultureTipDetailView(tip: tip)
            }
        case .favorites:
            FavoriteAttractionsView(cities: cities) { route in
                path.append(GuideRoute.attraction(route))
            }
        case .attraction(let route):
            AttractionDetailLoaderView(route: route)
        case .subArea(let route):
            SubAreaDetailView(route: route)
        }
    }

    private func load() async {
        do {
            cities = try await appEnv.content.fetchCities()
            cultureTips = try await appEnv.content.fetchCultureTips(cityIds: [])
        } catch {
            cities = (try? await BundledContentRepository().fetchCities()) ?? []
            cultureTips = (try? await BundledContentRepository().fetchCultureTips(cityIds: [])) ?? []
        }
        publishedAttractionCounts = await GuideContentHelpers.publishedAttractionCounts(
            for: cities,
            content: appEnv.content
        )
        await applyDeepLink()
    }

    private func applyDeepLink() async {
        guard let link = appEnv.navigation.consumeGuideDeepLink() else { return }
        if cities.isEmpty { await load() }

        let cityId = link.cityId ?? "beijing"
        let city = cities.first(where: { $0.id == cityId }) ?? cities.first
        let presentation = link.presentation ?? .browse(cityName: city?.name ?? cityId)
        let isPlanContext: Bool = {
            switch presentation {
            case .planDay, .planAddToDay: return true
            case .browse: return false
            }
        }()

        path = NavigationPath()
        if !isPlanContext, let city {
            path.append(GuideRoute.city(city.id))
        }

        path.append(GuideRoute.attraction(GuideAttractionRoute(
            attractionId: link.attractionId,
            cityId: city?.id ?? cityId,
            presentation: presentation
        )))
    }
}

private struct CityGuideDetailLoaderView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let route: GuideCityGuideRoute
    @State private var preview: CityGuide?
    @State private var failed = false

    var body: some View {
        Group {
            if let preview {
                CityGuideDetailView(listPreview: preview, route: route)
            } else if failed {
                Text("Content coming soon")
                    .font(Theme.FontToken.inter(13))
                    .padding(Theme.screenPadding)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task(id: route.guideId) { await resolvePreview() }
    }

    private func resolvePreview() async {
        failed = false
        preview = nil
        if let full = try? await appEnv.content.fetchCityGuide(id: route.guideId) {
            preview = full
            return
        }
        if let list = try? await appEnv.content.fetchCityGuides(cityId: route.cityId),
           let match = list.first(where: { $0.id == route.guideId }) {
            preview = match
            return
        }
        failed = true
    }
}

