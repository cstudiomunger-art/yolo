import Foundation
import Observation

@Observable
final class AppNavigation {
    var selectedTab: AppTab = .home
    var guideCityId: String?
    var guideAttractionId: String?
    var assistantStartInPlanning = false
    var planShowGenerator = false

    func openTab(_ tab: AppTab) {
        selectedTab = tab
    }

    func openGuide(attractionId: String, cityId: String? = nil) {
        guideAttractionId = attractionId
        guideCityId = cityId
        selectedTab = .guide
    }

    func openAssistantPlanning() {
        assistantStartInPlanning = true
        selectedTab = .assistant
    }

    func openPlanGenerator() {
        planShowGenerator = true
        selectedTab = .plan
    }

    func consumeGuideDeepLink() -> (cityId: String?, attractionId: String)? {
        guard let attractionId = guideAttractionId else { return nil }
        let cityId = guideCityId
        guideAttractionId = nil
        guideCityId = nil
        return (cityId: cityId, attractionId: attractionId)
    }
}
