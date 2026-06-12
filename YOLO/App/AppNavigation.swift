import Foundation
import Observation

enum AppModal: Identifiable, Equatable, Hashable {
    case prepare
    case emergency

    var id: String {
        switch self {
        case .prepare: "prepare"
        case .emergency: "emergency"
        }
    }
}

struct GuideDeepLink: Equatable {
    let cityId: String?
    let attractionId: String
    let presentation: GuidePresentationContext?
}

@Observable
final class AppNavigation {
    var selectedTab: AppTab = .home
    var guideCityId: String?
    var guideAttractionId: String?
    var guidePresentationContext: GuidePresentationContext?
    var guideDeepLinkRevision = 0
    /// Increment to reset Guide `NavigationStack` to home.
    var guideStackResetRevision = 0
    var planShowGenerator = false
    /// Guide `NavigationStack` depth (0 = home).
    var guidePathCount = 0
    /// Plan `NavigationStack` depth (0 = list).
    var planPathCount = 0
    var presentedModal: AppModal?

    /// Universal link / custom URL share slug pending presentation.
    var pendingShareSlug: String?

    /// Set when opening attraction from Plan itinerary editor preview.
    var guideAddToItineraryHandler: ((Attraction) -> Void)?

    func openTab(_ tab: AppTab) {
        selectedTab = tab
    }

    func openGuide(
        attractionId: String,
        cityId: String? = nil,
        presentation: GuidePresentationContext? = nil,
        onAddToItinerary: ((Attraction) -> Void)? = nil
    ) {
        guideAttractionId = attractionId
        guideCityId = cityId
        guidePresentationContext = presentation
        guideAddToItineraryHandler = onAddToItinerary
        guideDeepLinkRevision += 1
        selectedTab = .guide
    }

    func openPlanGenerator() {
        planShowGenerator = true
        selectedTab = .plan
    }

    func returnToPlanFromGuide() {
        guideStackResetRevision += 1
        guidePathCount = 0
        selectedTab = .plan
    }

    func openSharedItinerary(slug: String) {
        pendingShareSlug = slug
        selectedTab = .plan
    }

    func consumePendingShareSlug() -> String? {
        let slug = pendingShareSlug
        pendingShareSlug = nil
        return slug
    }

    func presentPrepare() {
        presentedModal = .prepare
    }

    func presentEmergency() {
        presentedModal = .emergency
    }

    func dismissModal() {
        presentedModal = nil
    }

    func consumeGuideDeepLink() -> GuideDeepLink? {
        guard let attractionId = guideAttractionId else { return nil }
        let link = GuideDeepLink(
            cityId: guideCityId,
            attractionId: attractionId,
            presentation: guidePresentationContext
        )
        guideAttractionId = nil
        guideCityId = nil
        guidePresentationContext = nil
        return link
    }

    func reset() {
        selectedTab = .home
        guideCityId = nil
        guideAttractionId = nil
        guidePresentationContext = nil
        guideDeepLinkRevision = 0
        guideStackResetRevision = 0
        guideAddToItineraryHandler = nil
        planShowGenerator = false
        guidePathCount = 0
        planPathCount = 0
        presentedModal = nil
        pendingShareSlug = nil
    }
}
