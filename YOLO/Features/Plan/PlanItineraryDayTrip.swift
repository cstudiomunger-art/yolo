import Foundation

/// Identifies full-day / far-suburb sights that must not share a calendar day with urban stops.
enum PlanItineraryDayTrip {
    /// Curated until `is_day_trip` column is populated in CMS.
    static let knownDayTripIds: Set<String> = [
        "chongqing_wulong_karst",
        "beijing_mutianyu_great_wall",
        "beijing_jinshanling_great_wall",
        "chongqing_dazu_rock_carvings",
    ]

    static func isDayTrip(attractionId: String, catalogById: [String: Attraction]) -> Bool {
        let id = attractionId.lowercased()
        if knownDayTripIds.contains(id) { return true }
        guard let row = catalogById[id] ?? catalogById[attractionId] else { return false }
        if let zone = row.planningZone?.lowercased(), zone.hasPrefix("daytrip") { return true }
        return PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText) >= 3
    }

    /// Split a same-city day that mixes urban sights with day-trip sights.
    static func splitDayTripFromUrban(
        _ ids: [String],
        catalogById: [String: Attraction]
    ) -> (keep: [String], overflow: [String]) {
        if ids.count <= 1 { return (ids, []) }
        var dayTrips: [String] = []
        var urban: [String] = []
        for id in ids {
            if isDayTrip(attractionId: id, catalogById: catalogById) {
                dayTrips.append(id)
            } else {
                urban.append(id)
            }
        }
        if dayTrips.isEmpty || urban.isEmpty { return (ids, []) }
        if dayTrips.count == ids.count { return (ids, []) }
        return (urban, dayTrips)
    }
}
