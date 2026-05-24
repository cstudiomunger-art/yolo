import SwiftUI

struct GuideView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var path = NavigationPath()
    @State private var cities: [City] = []
    @State private var cultureTips: [CultureTip] = []

    var body: some View {
        NavigationStack(path: $path) {
            GuideHomeView(
                cities: cities,
                onSelectCity: { city in
                    path.append(GuideRoute.city(city.id))
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
        .onChange(of: path.count) { _, count in
            appEnv.navigation.guidePathCount = count
        }
    }

    @ViewBuilder
    private func destination(for route: GuideRoute) -> some View {
        switch route {
        case .city(let cityId):
            if let city = cities.first(where: { $0.id == cityId }) {
                GuideCityAttractionsView(city: city) { attraction in
                    path.append(GuideRoute.attraction(GuideAttractionRoute(
                        attractionId: attraction.id,
                        cityId: city.id,
                        presentation: .browse(cityName: city.name)
                    )))
                }
            } else {
                Text("City not found")
                    .padding()
            }
        case .cultureTips:
            GuideCultureTipsView(tips: cultureTips) { tip in
                path.append(GuideRoute.cultureTip(tip.id))
            }
        case .cultureTip(let tipId):
            if let tip = cultureTips.first(where: { $0.id == tipId }) {
                CultureTipDetailView(tip: tip)
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
            cultureTips = try await appEnv.content.fetchCultureTips()
        } catch {
            cities = (try? await BundledContentRepository().fetchCities()) ?? []
            cultureTips = (try? await BundledContentRepository().fetchCultureTips()) ?? []
        }
        await applyDeepLink()
    }

    private func applyDeepLink() async {
        guard let link = appEnv.navigation.consumeGuideDeepLink() else { return }
        if cities.isEmpty { await load() }

        let cityId = link.cityId ?? "beijing"
        let city = cities.first(where: { $0.id == cityId }) ?? cities.first
        let presentation = link.presentation ?? .browse(cityName: city?.name ?? cityId)

        path = NavigationPath()
        if let city {
            path.append(GuideRoute.city(city.id))
        }

        path.append(GuideRoute.attraction(GuideAttractionRoute(
            attractionId: link.attractionId,
            cityId: city?.id ?? cityId,
            presentation: presentation
        )))
    }
}

private struct AttractionDetailLoaderView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let route: GuideAttractionRoute
    @State private var preview: Attraction?
    @State private var failed = false

    var body: some View {
        Group {
            if let preview {
                AttractionDetailView(listPreview: preview, route: route)
            } else if failed {
                AttractionDetailView(
                    listPreview: Attraction.stub(id: route.attractionId, cityId: route.cityId ?? "beijing"),
                    route: route
                )
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task(id: route.attractionId) { await resolvePreview() }
    }

    private func resolvePreview() async {
        failed = false
        preview = nil
        if let full = try? await appEnv.content.fetchAttraction(id: route.attractionId) {
            preview = full
            return
        }
        if let cityId = route.cityId,
           let list = try? await appEnv.content.fetchAttractions(cityId: cityId),
           let match = list.first(where: { $0.id == route.attractionId }) {
            preview = match
            return
        }
        failed = true
    }
}

private extension Attraction {
    static func stub(id: String, cityId: String) -> Attraction {
        let json = """
        {"id":"\(id)","city_id":"\(cityId)","name":"Loading…","chinese_name":""}
        """
        return (try? JSONCoding.makeDecoder().decode(Attraction.self, from: Data(json.utf8)))
            ?? Attraction.fallbackStub(id: id, cityId: cityId)
    }

    static func fallbackStub(id: String, cityId: String) -> Attraction {
        let json = """
        {"id":"\(id)","city_id":"\(cityId)","name":"","chinese_name":""}
        """
        return (try? JSONCoding.makeDecoder().decode(Attraction.self, from: Data(json.utf8)))
            ?? stub(id: id, cityId: cityId)
    }
}
