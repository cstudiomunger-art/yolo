import SwiftUI

struct AttractionDetailLoaderView: View {
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

extension Attraction {
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
