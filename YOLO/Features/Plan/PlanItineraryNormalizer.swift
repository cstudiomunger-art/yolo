import Foundation

/// Post-processes assembled itineraries for geographic sanity (mirrors Edge normalize).
enum PlanItineraryNormalizer {
    private static let maxPerDay = 3

    static func normalize(_ trip: SampleItinerary, selectedCityIds: [String]) -> SampleItinerary {
        guard !trip.days.isEmpty else { return trip }

        var days = trip.days
        var pool: [ItineraryActivity] = []

        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            let split = splitIncompatibleSameDay(days[index].activities)
            days[index] = days[index].withActivities(split.keep)
            pool.append(contentsOf: split.overflow)
        }

        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            var acts = days[index].activities
            while acts.count > maxPerDay {
                pool.append(acts.removeLast())
            }
            days[index] = days[index].withActivities(acts)
        }

        for activity in pool {
            placeActivity(activity, into: &days)
        }

        insertTravelDays(into: &days)
        days = days.map { day in
            guard !day.isExperienceSuggestions else { return day }
            let label = dayCityLabel(day)
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: label,
                costEstimate: day.costEstimate,
                activities: day.activities,
                dayKind: day.dayKind,
                experienceItems: day.experienceItems,
                experienceCityId: day.experienceCityId
            )
        }

        let visitOrder = deriveVisitOrder(from: days, fallback: selectedCityIds)
        let route = CityTravelHints.routeLabel(from: visitOrder)
        let dayCount = days.count
        let title = titleMatchesRoute(trip.title, route: route)
            ? trip.title
            : "\(dayCount)-Day \(route) Trip"

        return SampleItinerary(
            id: trip.id,
            title: title,
            meta: trip.meta,
            routeSummary: route,
            estimatedBudget: trip.estimatedBudget,
            days: days,
            shareSlug: trip.shareSlug,
            isShared: trip.isShared,
            startDate: trip.startDate,
            endDate: trip.endDate,
            visitOrder: visitOrder
        )
    }

    private static func splitIncompatibleSameDay(_ activities: [ItineraryActivity]) -> (keep: [ItineraryActivity], overflow: [ItineraryActivity]) {
        guard activities.count > 1 else { return (activities, []) }
        var keep: [ItineraryActivity] = []
        var overflow: [ItineraryActivity] = []
        var anchor: String?

        for act in activities {
            guard let city = act.cityId, !city.isEmpty else {
                keep.append(act)
                continue
            }
            if anchor == nil {
                anchor = city
                keep.append(act)
                continue
            }
            if city == anchor || CityTravelHints.canVisitSameDay(anchor!, city) {
                keep.append(act)
            } else {
                overflow.append(act)
            }
        }
        return (keep, overflow)
    }

    private static func placeActivity(_ activity: ItineraryActivity, into days: inout [ItineraryDay]) {
        guard let city = activity.cityId else { return }
        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            guard days[index].activities.count < maxPerDay else { continue }
            let cities = Set(days[index].activities.compactMap(\.cityId))
            if cities.isEmpty || cities.allSatisfy({ CityTravelHints.canVisitSameDay($0, city) }) {
                days[index] = days[index].withActivities(days[index].activities + [activity])
                return
            }
        }
        if let index = days.indices.last(where: { !days[$0].isExperienceSuggestions && days[$0].activities.count < maxPerDay }) {
            days[index] = days[index].withActivities(days[index].activities + [activity])
        }
    }

    private static func insertTravelDays(into days: inout [ItineraryDay]) {
        var previousCity: String?
        for index in days.indices {
            if days[index].isExperienceSuggestions {
                previousCity = days[index].experienceCityId ?? previousCity
                continue
            }
            let city = primaryCity(for: days[index].activities)
            guard let city else { continue }
            if let prev = previousCity,
               CityTravelHints.needsTravelDay(prev, city),
               !days[index].isExperienceSuggestions {
                let items = CityTravelHints.travelExperienceItems(toCityId: city)
                days[index] = ItineraryDay(
                    id: days[index].id,
                    dayIndex: days[index].dayIndex,
                    dateLabel: days[index].dateLabel,
                    cityName: CityTravelHints.displayName(for: city),
                    costEstimate: nil,
                    activities: [],
                    dayKind: .experienceSuggestions,
                    experienceItems: items,
                    experienceCityId: city
                )
            }
            if !days[index].isExperienceSuggestions {
                previousCity = city
            } else {
                previousCity = days[index].experienceCityId ?? previousCity
            }
        }
    }

    private static func primaryCity(for activities: [ItineraryActivity]) -> String? {
        var counts: [String: Int] = [:]
        for act in activities {
            guard let cid = act.cityId else { continue }
            counts[cid, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })?.key
    }

    private static func dayCityLabel(_ day: ItineraryDay) -> String {
        if day.isExperienceSuggestions {
            return day.experienceCityId.map { CityTravelHints.displayName(for: $0) } ?? day.cityName
        }
        var seen: [String] = []
        for act in day.activities {
            guard let cid = act.cityId else { continue }
            let name = CityTravelHints.displayName(for: cid)
            if !seen.contains(name) { seen.append(name) }
        }
        return seen.joined(separator: " · ")
    }

    private static func deriveVisitOrder(from days: [ItineraryDay], fallback: [String]) -> [String] {
        var order: [String] = []
        var seen = Set<String>()
        for day in days {
            if day.isExperienceSuggestions, let cid = day.experienceCityId?.lowercased(), !seen.contains(cid) {
                seen.insert(cid)
                order.append(cid)
                continue
            }
            for act in day.activities {
                guard let cid = act.cityId?.lowercased(), !seen.contains(cid) else { continue }
                seen.insert(cid)
                order.append(cid)
            }
        }
        if order.isEmpty {
            return fallback.map { $0.lowercased() }
        }
        return order
    }

    private static func titleMatchesRoute(_ title: String, route: String) -> Bool {
        guard !route.isEmpty else { return true }
        return title.localizedCaseInsensitiveContains(route.components(separatedBy: " → ").first ?? "")
    }
}
