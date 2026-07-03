import Foundation

struct PlanItineraryGenerateOptions {
    var pace: TripPace = .standard
    var arrivalTime: String?
    var departureTime: String?
    var startDate: Date?
    /// First city the traveler lands in (international entry).
    var entryCityId: String?
    /// Last city before flying home (international exit).
    var exitCityId: String?

    static let `default` = PlanItineraryGenerateOptions()
}
