import Foundation

struct PlanItineraryGenerateOptions {
    var pace: TripPace = .standard
    var arrivalTime: String?
    var departureTime: String?
    var startDate: Date?

    static let `default` = PlanItineraryGenerateOptions()
}
