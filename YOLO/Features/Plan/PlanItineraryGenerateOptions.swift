import Foundation

struct PlanItineraryGenerateOptions {
    var pace: TripPace = .standard
    /// International landing time (HH:mm). Leave nil at generation — user sets on Review bookend card.
    var arrivalTime: String?
    /// International departure time (HH:mm). Leave nil at generation — user sets on Review bookend card.
    var departureTime: String?
    var startDate: Date?
    /// First city the traveler lands in (international entry).
    var entryCityId: String?
    /// Last city before flying home (international exit).
    var exitCityId: String?

    static let `default` = PlanItineraryGenerateOptions()
}
