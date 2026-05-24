import Foundation

enum DeepLinkHandler {
    enum Action: Equatable {
        case openSharedItinerary(slug: String)
        case passwordRecovery
    }

    static func action(for url: URL) -> Action? {
        if url.scheme?.lowercased() == "yoloapp" {
            if url.host == "auth", url.path.contains("reset") || url.fragment?.contains("type=recovery") == true {
                return .passwordRecovery
            }
            if let slug = ItineraryShareService.parseShareSlug(from: url) {
                return .openSharedItinerary(slug: slug)
            }
        }
        if let slug = ItineraryShareService.parseShareSlug(from: url) {
            return .openSharedItinerary(slug: slug)
        }
        if url.absoluteString.contains("type=recovery") {
            return .passwordRecovery
        }
        return nil
    }
}
