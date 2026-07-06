import Foundation

/// Travel feasibility hints for itinerary planning (mirrors Edge `city-travel-hints.ts`).
enum CityTravelHints {
    private static let pairHours: [String: Double] = [
        "beijing|shanghai": 5.5,
        "beijing|nanjing": 4,
        "beijing|hangzhou": 5,
        "beijing|suzhou": 5.5,
        "beijing|chengdu": 7.5,
        "beijing|chongqing": 8,
        "shanghai|nanjing": 1.5,
        "shanghai|hangzhou": 1,
        "shanghai|suzhou": 0.5,
        "shanghai|chengdu": 12,
        "shanghai|chongqing": 11,
        "nanjing|hangzhou": 2.5,
        "nanjing|suzhou": 2,
        "hangzhou|suzhou": 1.5,
        "shanghai|guangzhou": 7,
        "beijing|guangzhou": 8,
        "chengdu|chongqing": 1.5,
    ]

    private static let cityRegionFallback: [String: String] = [
        "beijing": "north_china",
        "shanghai": "yangtze_delta",
        "nanjing": "yangtze_delta",
        "hangzhou": "yangtze_delta",
        "suzhou": "yangtze_delta",
        "guangzhou": "pearl_delta",
        "chengdu": "southwest",
        "chongqing": "southwest",
    ]

    private static let nearRegionPairs: Set<String> = [
        "north_china|yangtze_delta",
        "north_china|central_china",
        "yangtze_delta|central_china",
        "yangtze_delta|southwest",
        "central_china|southwest",
        "central_china|pearl_delta",
        "yangtze_delta|pearl_delta",
    ]

    private static func pairKey(_ a: String, _ b: String) -> String {
        [a.lowercased(), b.lowercased()].sorted().joined(separator: "|")
    }

    private static func regionPairKey(_ a: String, _ b: String) -> String {
        [a, b].sorted().joined(separator: "|")
    }

    static func travelHours(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Double {
        let x = a.lowercased()
        let y = b.lowercased()
        if x == y { return 0 }
        if let known = pairHours[pairKey(x, y)] { return known }
        let rx = (regionByCity[x] ?? nil) ?? cityRegionFallback[x]
        let ry = (regionByCity[y] ?? nil) ?? cityRegionFallback[y]
        if let rx, let ry {
            if rx == ry { return 2 }
            if nearRegionPairs.contains(regionPairKey(rx, ry)) { return 4 }
            return 6
        }
        return 6
    }

    static func commuteSlots(_ travelHours: Double) -> Int {
        if travelHours <= 2 { return 0 }
        if travelHours <= 4 { return 1 }
        return 2
    }

    static func isIntercityHopKind(_ kind: String) -> Bool {
        kind == "hop" || kind == "travel_lite" || kind == "short_hop"
    }

    static func canVisitSameDay(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Bool {
        commuteSlots(travelHours(a, b, regionByCity: regionByCity)) == 0
    }

    static func needsTravelDay(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Bool {
        commuteSlots(travelHours(a, b, regionByCity: regionByCity)) >= 2
    }

    /// Intense pace: same-day hop when commute is at most one slot (≤4h travel).
    static func canIntenseSameDayHop(_ a: String, _ b: String, regionByCity: [String: String?] = [:]) -> Bool {
        commuteSlots(travelHours(a, b, regionByCity: regionByCity)) <= 1
    }

    /// Compact intercity hop card (between morning and afternoon sights).
    static func buildHopCardContent(fromCityId: String, toCityId: String, hours: Double) -> [String] {
        let from = displayName(for: fromCityId)
        let to = displayName(for: toCityId)
        let slots = commuteSlots(hours)
        let journey = hours.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(hours))h"
            : String(format: "~%.1fh", hours)
        var lines = [
            "Travel from \(from) to \(to)",
            "Estimated journey: \(journey) (HSR / flight)",
        ]
        if slots == 0 {
            lines.append("Short hop — afternoon sightseeing in \(to)")
        } else {
            lines.append("Morning commute — afternoon sightseeing window")
        }
        return lines
    }

    static func buildHopCardContentWithArrival(
        fromCityId: String,
        toCityId: String,
        hours: Double,
        arrivalAtDestination: String?
    ) -> [String] {
        let from = displayName(for: fromCityId)
        let to = displayName(for: toCityId)
        let journey = journeyHoursLabel(hours)
        var lines = [
            "Travel from \(from) to \(to)",
            "Estimated journey: \(journey) (HSR / flight)",
        ]
        if let arrival = arrivalAtDestination, !arrival.isEmpty {
            lines.append("Arrive in \(to) at \(arrival)")
            if PlanItineraryFlightTimes.isEveningArrival(arrival) {
                lines.append("Evening arrival — check in and rest")
            } else if PlanItineraryFlightTimes.isAfternoonArrival(arrival) {
                lines.append("Afternoon arrival — light sightseeing window")
            } else if PlanItineraryFlightTimes.isEarlyMorningArrival(arrival) {
                lines.append("Early arrival — full day for sightseeing")
            } else if PlanItineraryFlightTimes.isLateMorningCommuteArrival(arrival) {
                lines.append("Morning commute — afternoon sightseeing window")
            } else {
                lines.append("Morning arrival — afternoon sightseeing window")
            }
        } else {
            let suggested = PlanItineraryFlightTimes.suggestedArrivalAtDestination(travelHours: hours)
            lines.append("Estimated arrival in \(to): \(suggested)")
            lines.append("Set your actual arrival time below")
        }
        return lines
    }

    /// Compact UI summary for intercity hop / travel-day cards (1–2 lines).
    struct IntercityCardSummary {
        let routeTitle: String
        let contextLine: String?
    }

    static func journeyHoursLabel(_ hours: Double) -> String {
        hours.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(hours))h"
            : String(format: "~%.1fh", hours)
    }

    static func intercityCardSummary(
        fromCityId: String,
        toCityId: String,
        travelHours: Double,
        arrivalTime: String?,
        isFullTravelDay: Bool = false
    ) -> IntercityCardSummary {
        let route = routeLabel(from: [fromCityId, toCityId])
        let journey = journeyHoursLabel(travelHours)
        let routeTitle = String(
            format: String(localized: "Intercity route summary format"),
            locale: .current,
            route,
            journey
        )
        let to = displayName(for: toCityId)
        let slots = commuteSlots(travelHours)
        let contextLine: String? = {
            if let arrival = arrivalTime, !arrival.isEmpty {
                if PlanItineraryFlightTimes.isEveningArrival(arrival) {
                    return String(
                        format: String(localized: "Evening arrival in %@ — check in and rest"),
                        locale: .current,
                        to
                    )
                }
                if PlanItineraryFlightTimes.isAfternoonArrival(arrival) {
                    return String(
                        format: String(localized: "Afternoon arrival in %@ — light sightseeing"),
                        locale: .current,
                        to
                    )
                }
                if PlanItineraryFlightTimes.isEarlyMorningArrival(arrival) {
                    return String(
                        format: String(localized: "Early arrival — full day in %@"),
                        locale: .current,
                        to
                    )
                }
                if PlanItineraryFlightTimes.isLateMorningCommuteArrival(arrival) {
                    return String(
                        format: String(localized: "Morning commute — afternoon in %@"),
                        locale: .current,
                        to
                    )
                }
                return String(
                    format: String(localized: "Morning arrival — afternoon in %@"),
                    locale: .current,
                    to
                )
            }
            if isFullTravelDay || slots >= 2 {
                return String(
                    format: String(localized: "Full travel day — check in and rest in %@"),
                    locale: .current,
                    to
                )
            }
            if slots == 0 {
                return String(
                    format: String(localized: "Short hop — afternoon sightseeing in %@"),
                    locale: .current,
                    to
                )
            }
            return String(
                format: String(localized: "Afternoon sightseeing in %@"),
                locale: .current,
                to
            )
        }()
        return IntercityCardSummary(routeTitle: routeTitle, contextLine: contextLine)
    }

    static func hopDayRouteLabel(fromCityId: String, toCityId: String) -> String {
        routeLabel(from: [fromCityId, toCityId])
    }

    static func displayName(for cityId: String) -> String {
        cityId.prefix(1).uppercased() + cityId.dropFirst().replacingOccurrences(of: "_", with: " ")
    }

    static func routeLabel(from cityIds: [String]) -> String {
        cityIds.map { displayName(for: $0) }.joined(separator: " → ")
    }

    /// Section header city line — hop days use route label (e.g. Chongqing → Chengdu).
    static func daySectionCityLabel(
        day: ItineraryDay,
        cityNameById: [String: String],
        attractionCache: [String: Attraction] = [:]
    ) -> String {
        if let hop = day.intercityHop {
            if !day.cityName.isEmpty, day.cityName.contains("→") { return day.cityName }
            return hopDayRouteLabel(fromCityId: hop.fromCityId, toCityId: hop.toCityId)
        }
        if day.isExperienceSuggestions, let cid = day.experienceCityId, !cid.isEmpty {
            return cityNameById[cid] ?? displayName(for: cid)
        }
        if let cid = day.experienceCityId, !cid.isEmpty {
            return cityNameById[cid] ?? displayName(for: cid)
        }
        var seen: [String] = []
        for act in day.activities {
            let cid = act.cityId ?? act.attractionId.flatMap { attractionCache[$0]?.cityId }
            guard let cid, let name = cityNameById[cid], !seen.contains(name) else { continue }
            seen.append(name)
        }
        return seen.joined(separator: " · ")
    }

    static func travelExperienceItems(toCityId: String) -> [String] {
        let name = displayName(for: toCityId)
        return [
            "Intercity travel",
            "Travel to \(name)",
            "Rest and check in",
            "Neighborhood walk near hotel",
        ]
    }

    static func buildTravelDayContent(fromCityId: String, toCityId: String, hours: Double) -> [String] {
        let from = displayName(for: fromCityId)
        let to = displayName(for: toCityId)
        let slots = commuteSlots(hours)
        let journey = hours.truncatingRemainder(dividingBy: 1) == 0
            ? "\(Int(hours))h"
            : String(format: "~%.1fh", hours)
        var lines = [
            "Travel from \(from) to \(to)",
            "Estimated journey: \(journey) (HSR / flight)",
        ]
        if slots >= 2 {
            lines.append("Full travel day — check in and rest")
            lines.append("Optional light evening stroll after arrival")
        } else if slots == 1 {
            lines.append("Morning commute — afternoon sightseeing window")
        }
        lines.append("Explore \(to) near your hotel")
        return lines
    }

    static func arrivalAfternoonExperienceItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "Afternoon arrival in \(name)",
            "Check in and settle at your hotel",
            "Light neighborhood walk if you have energy",
            "Optional evening street food or night market",
            "Major sights start on the next full day",
        ]
    }

    static func departureMorningExperienceItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "Morning departure from \(name)",
            "Pack and hotel checkout",
            "Breakfast near your hotel",
            "Allow extra time for airport or train station transfer",
        ]
    }

    /// Bookend card copy before the user sets an international landing time.
    static func internationalArrivalPlaceholder(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            String(format: String(localized: "International arrival in %@"), name),
            String(localized: "Sightseeing for this day updates after you confirm arrival"),
        ]
    }

    /// Bookend card copy before the user sets an international departure time.
    static func internationalDeparturePlaceholder(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            String(format: String(localized: "International departure from %@"), name),
            String(localized: "Last-day sights adjust after you confirm your flight"),
        ]
    }

    static func internationalArrivalItems(cityId: String, arrivalTime: String) -> [String] {
        let name = displayName(for: cityId)
        var lines = [
            String(format: String(localized: "Land in %@ at %@"), name, arrivalTime),
        ]
        if PlanItineraryFlightTimes.isEveningArrival(arrivalTime) {
            lines.append(String(localized: "Evening arrival — check in and rest"))
            lines.append(String(localized: "Optional light evening stroll if you have energy"))
        } else if PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
            lines.append(String(localized: "Afternoon arrival — light sightseeing window"))
            lines.append(String(localized: "Check in and settle at your hotel"))
        } else {
            lines.append(String(localized: "Morning arrival — full sightseeing day"))
        }
        return lines
    }

    static func internationalDepartureItems(cityId: String, departureTime: String) -> [String] {
        let name = displayName(for: cityId)
        var lines = [
            String(format: String(localized: "Depart from %@ at %@"), name, departureTime),
            String(localized: "Pack and hotel checkout"),
            String(localized: "Allow extra time for airport or train station transfer"),
        ]
        if PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
            lines.append(String(localized: "Morning departure — lighter sightseeing before you leave"))
        } else {
            lines.append(String(localized: "Afternoon departure — morning sights still possible"))
        }
        return lines
    }

    /// First sightseeing day in the entry city (mirrors scheduler `firstEntrySight`).
    static func resolveEntrySightseeingDayIndex(
        days: [ItineraryDay],
        visitOrder: [String],
        entryCityId: String? = nil
    ) -> Int? {
        let entry = (entryCityId ?? visitOrder.first)?.lowercased() ?? ""
        guard !entry.isEmpty else { return nil }
        return days.first { day in
            isSightseeingDay(day) && primaryCityId(for: day) == entry
        }?.dayIndex
    }

    /// Last sightseeing day in the exit city.
    static func resolveExitSightseeingDayIndex(
        days: [ItineraryDay],
        visitOrder: [String],
        exitCityId: String? = nil
    ) -> Int? {
        let exit = (exitCityId ?? visitOrder.last)?.lowercased() ?? ""
        guard !exit.isEmpty else { return nil }
        return days.reversed().first { day in
            isSightseeingDay(day) && primaryCityId(for: day) == exit
        }?.dayIndex
    }

    /// Array index for entry/exit sightseeing day (for bookend ↔ day list binding).
    static func entrySightseeingDayArrayIndex(
        days: [ItineraryDay],
        visitOrder: [String],
        entryCityId: String? = nil
    ) -> Int? {
        guard let dayIndex = resolveEntrySightseeingDayIndex(
            days: days,
            visitOrder: visitOrder,
            entryCityId: entryCityId
        ) else { return nil }
        return days.firstIndex(where: { $0.dayIndex == dayIndex })
    }

    static func exitSightseeingDayArrayIndex(
        days: [ItineraryDay],
        visitOrder: [String],
        exitCityId: String? = nil
    ) -> Int? {
        guard let dayIndex = resolveExitSightseeingDayIndex(
            days: days,
            visitOrder: visitOrder,
            exitCityId: exitCityId
        ) else { return nil }
        return days.firstIndex(where: { $0.dayIndex == dayIndex })
    }

    /// When flight time is set, linked sightseeing activities render on the bookend card instead.
    enum BookendActivityRelocation {
        case none
        case arrivalCard
        case departureCard
    }

    static func bookendActivityRelocation(
        day: ItineraryDay,
        days: [ItineraryDay],
        visitOrder: [String],
        entryCityId: String,
        exitCityId: String,
        arrivalTime: String?,
        departureTime: String?
    ) -> BookendActivityRelocation {
        if PlanItineraryFlightTimes.hasMeaningfulTime(arrivalTime),
           let entryIdx = resolveEntrySightseeingDayIndex(
               days: days,
               visitOrder: visitOrder,
               entryCityId: entryCityId
           ),
           day.dayIndex == entryIdx,
           !day.activities.isEmpty {
            return .arrivalCard
        }
        if PlanItineraryFlightTimes.hasMeaningfulTime(departureTime),
           let exitIdx = resolveExitSightseeingDayIndex(
               days: days,
               visitOrder: visitOrder,
               exitCityId: exitCityId
           ),
           day.dayIndex == exitIdx,
           !day.activities.isEmpty {
            return .departureCard
        }
        return .none
    }

    private static func isSightseeingDay(_ day: ItineraryDay) -> Bool {
        if day.intercityHop != nil, day.isExperienceSuggestions { return false }
        if day.experienceItems.contains(where: {
            $0.localizedCaseInsensitiveContains("travel from")
                || $0.localizedCaseInsensitiveContains("intercity travel")
        }) {
            return false
        }
        return true
    }

    private static func primaryCityId(for day: ItineraryDay) -> String? {
        if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty { return cid }
        if let hop = day.intercityHop, !day.isExperienceSuggestions { return hop.toCityId.lowercased() }
        return day.activities.compactMap { $0.cityId?.lowercased() }.first
    }

    /// Honest copy when scheduling left a sightseeing day empty (not a recommended rest day).
    static func unfilledSchedulingGapItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "行程偏紧，暂无推荐景点",
            "可在 \(name) 自由探索或点 + 添加",
        ]
    }

    static func flexibleRestDayItems(cityId: String) -> [String] {
        let name = displayName(for: cityId)
        return [
            "Flexible day in \(name)",
            "Rest or explore at your own pace",
            "Neighborhood café, park, or local market",
            "Tap + Add attraction to schedule a specific sight",
        ]
    }

    /// Nearest-neighbor visit order using travel hours and catalog weights.
    static func inferVisitOrder(
        cityIds: [String],
        catalogCountByCity: [String: Int],
        avgDaysByCity: [String: Int] = [:],
        regionByCity: [String: String?] = [:],
        entryCityId: String? = nil,
        exitCityId: String? = nil
    ) -> [String] {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard unique.count > 1 else { return unique.isEmpty ? ["beijing"] : unique }

        func weight(_ id: String) -> Int {
            let count = catalogCountByCity[id] ?? 1
            let avg = avgDaysByCity[id] ?? 2
            return count + avg
        }

        let entry = entryCityId?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let exit = exitCityId?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var remaining = Set(unique)
        var order: [String] = []
        var current = (entry != nil && remaining.contains(entry!))
            ? entry!
            : unique.sorted { weight($0) > weight($1) }[0]
        order.append(current)
        remaining.remove(current)

        while !remaining.isEmpty {
            let best = remaining.min {
                travelHours(current, $0, regionByCity: regionByCity) < travelHours(current, $1, regionByCity: regionByCity)
            }!
            order.append(best)
            remaining.remove(best)
            current = best
        }
        if let exit, order.contains(exit), order.last != exit {
            return order.filter { $0 != exit } + [exit]
        }
        return order
    }

    struct EndpointSuggestion {
        let entryCityId: String
        let exitCityId: String
        let visitOrder: [String]
    }

    static func catalogWeights(
        for cityIds: [String],
        cities: [City]
    ) -> (catalogCountByCity: [String: Int], avgDaysByCity: [String: Int]) {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        var catalogCountByCity: [String: Int] = [:]
        var avgDaysByCity: [String: Int] = [:]
        for city in cities {
            let cid = city.id.lowercased()
            guard unique.contains(cid) else { continue }
            catalogCountByCity[cid] = city.attractionCount
            if let avg = city.avgDaysRecommended {
                avgDaysByCity[cid] = avg
            }
        }
        for cid in unique {
            catalogCountByCity[cid, default: 1] = catalogCountByCity[cid, default: 1]
        }
        return (catalogCountByCity, avgDaysByCity)
    }

    /// Visit order for selected cities, optionally anchored by landing/return endpoints.
    static func visitOrder(
        cityIds: [String],
        cities: [City],
        entryCityId: String? = nil,
        exitCityId: String? = nil
    ) -> [String] {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard !unique.isEmpty else { return ["beijing"] }
        if unique.count == 1 { return unique }
        let weights = catalogWeights(for: unique, cities: cities)
        return inferVisitOrder(
            cityIds: unique,
            catalogCountByCity: weights.catalogCountByCity,
            avgDaysByCity: weights.avgDaysByCity,
            entryCityId: entryCityId,
            exitCityId: exitCityId
        )
    }

    /// Suggest international landing/return cities from selected stops using shortest route order.
    static func suggestEntryExit(cityIds: [String], cities: [City]) -> EndpointSuggestion {
        let unique = Array(Set(cityIds.map { $0.lowercased() }.filter { !$0.isEmpty }))
        guard !unique.isEmpty else {
            return EndpointSuggestion(entryCityId: "beijing", exitCityId: "beijing", visitOrder: ["beijing"])
        }
        if unique.count == 1 {
            let only = unique[0]
            return EndpointSuggestion(entryCityId: only, exitCityId: only, visitOrder: [only])
        }

        let order = visitOrder(cityIds: unique, cities: cities)
        return EndpointSuggestion(
            entryCityId: order.first ?? unique[0],
            exitCityId: order.last ?? unique[0],
            visitOrder: order
        )
    }
}
