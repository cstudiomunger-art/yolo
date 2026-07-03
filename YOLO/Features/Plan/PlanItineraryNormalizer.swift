import Foundation

/// Post-processes assembled itineraries for geographic sanity (mirrors Edge normalize).
enum PlanItineraryNormalizer {
    /// Dedup + geo split + slot trim only — preserves scheduler travel/hop days.
    static func hopSafeNormalize(
        _ trip: SampleItinerary,
        selectedCityIds: [String],
        catalogById: [String: Attraction] = [:],
        pace: TripPace = .standard,
        arrivalTime: String? = nil,
        departureTime: String? = nil
    ) -> SampleItinerary {
        if trip.userEdited { return trip }
        guard !trip.days.isEmpty else { return trip }

        var days = trip.days
        var pool: [ItineraryActivity] = []
        var seenAttractionIds = Set<String>()

        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            var deduped: [ItineraryActivity] = []
            for act in days[index].activities {
                guard let aid = act.attractionId else {
                    deduped.append(act)
                    continue
                }
                if seenAttractionIds.contains(aid) {
                    pool.append(act)
                    continue
                }
                seenAttractionIds.insert(aid)
                deduped.append(act)
            }
            days[index] = days[index].withActivities(deduped)
            if days[index].intercityHop == nil {
                let split = splitIncompatibleSameDay(days[index].activities)
                days[index] = days[index].withActivities(split.keep)
                pool.append(contentsOf: split.overflow)
            }
        }

        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            let dayCapacity = PlanItinerarySlotBudget.daytimeCapacity(
                dayIndex: days[index].dayIndex,
                days: days,
                pace: pace,
                arrivalTime: arrivalTime,
                departureTime: departureTime
            )
            let trimmed = PlanItinerarySlotBudget.trimDaytimeToCapacity(
                activities: days[index].activities,
                capacity: dayCapacity,
                catalogById: catalogById
            )
            days[index] = days[index].withActivities(trimmed.keep)
            pool.append(contentsOf: trimmed.overflow)
        }

        let visitOrder = trip.visitOrder ?? deriveVisitOrder(from: days, fallback: selectedCityIds)
        let route = CityTravelHints.routeLabel(from: visitOrder)

        days = PlanItineraryDayFill.fillEmptyDays(
            days,
            visitOrder: visitOrder,
            pace: pace,
            arrivalTime: arrivalTime,
            departureTime: departureTime
        )

        let dayCount = days.count
        let title = titleMatchesRoute(trip.title, route: route)
            ? trip.title
            : "\(dayCount)-Day \(route) Trip"

        var adjustments = trip.schedulingAdjustments ?? []
        for activity in pool {
            let label = activity.attractionId ?? activity.name
            adjustments.append(String(localized: "Could not place \(label) during normalize"))
        }

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
            visitOrder: visitOrder,
            userEdited: trip.userEdited,
            droppedAttractionIds: trip.droppedAttractionIds,
            schedulingAdjustments: adjustments.isEmpty ? nil : adjustments,
            seasonHints: trip.seasonHints,
            pace: trip.pace
        )
    }

    static func normalize(
        _ trip: SampleItinerary,
        selectedCityIds: [String],
        catalogById: [String: Attraction] = [:],
        pace: TripPace = .standard,
        arrivalTime: String? = nil,
        departureTime: String? = nil
    ) -> SampleItinerary {
        if trip.userEdited { return trip }
        guard !trip.days.isEmpty else { return trip }

        var days = trip.days
        var pool: [ItineraryActivity] = []
        var seenAttractionIds = Set<String>()
        let hasScheduledExperienceDays = days.contains { $0.isExperienceSuggestions }

        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            var deduped: [ItineraryActivity] = []
            for act in days[index].activities {
                guard let aid = act.attractionId else {
                    deduped.append(act)
                    continue
                }
                if seenAttractionIds.contains(aid) {
                    pool.append(act)
                    continue
                }
                seenAttractionIds.insert(aid)
                deduped.append(act)
            }
            days[index] = days[index].withActivities(deduped)
            if days[index].intercityHop == nil {
                let split = splitIncompatibleSameDay(days[index].activities)
                days[index] = days[index].withActivities(split.keep)
                pool.append(contentsOf: split.overflow)
            }
        }

        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            let dayCapacity = PlanItinerarySlotBudget.daytimeCapacity(
                dayIndex: days[index].dayIndex,
                days: days,
                pace: pace,
                arrivalTime: arrivalTime,
                departureTime: departureTime
            )
            let trimmed = PlanItinerarySlotBudget.trimDaytimeToCapacity(
                activities: days[index].activities,
                capacity: dayCapacity,
                catalogById: catalogById
            )
            days[index] = days[index].withActivities(trimmed.keep)
            pool.append(contentsOf: trimmed.overflow)
        }

        for activity in pool {
            placeActivity(
                activity,
                into: &days,
                catalogById: catalogById,
                pace: pace,
                arrivalTime: arrivalTime,
                departureTime: departureTime
            )
        }

        // Scheduler already inserts dedicated travel days — do not overwrite them.
        if !hasScheduledExperienceDays {
            insertTravelDays(into: &days)
        }

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
                experienceCityId: day.experienceCityId,
                intercityHop: day.intercityHop
            )
        }

        let visitOrder = trip.visitOrder ?? deriveVisitOrder(from: days, fallback: selectedCityIds)
        let route = CityTravelHints.routeLabel(from: visitOrder)

        days = PlanItineraryDayFill.fillEmptyDays(
            days,
            visitOrder: visitOrder,
            pace: pace,
            arrivalTime: arrivalTime,
            departureTime: departureTime
        )

        let dayCount = days.count
        let title = titleMatchesRoute(trip.title, route: route)
            ? trip.title
            : "\(dayCount)-Day \(route) Trip"

        var adjustments = trip.schedulingAdjustments ?? []
        for activity in pool {
            let label = activity.attractionId ?? activity.name
            adjustments.append(String(localized: "Could not place \(label) during normalize"))
        }

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
            visitOrder: visitOrder,
            userEdited: trip.userEdited,
            droppedAttractionIds: trip.droppedAttractionIds,
            schedulingAdjustments: adjustments.isEmpty ? nil : adjustments,
            seasonHints: trip.seasonHints,
            pace: trip.pace
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

    private static func placeActivity(
        _ activity: ItineraryActivity,
        into days: inout [ItineraryDay],
        catalogById: [String: Attraction],
        pace: TripPace,
        arrivalTime: String?,
        departureTime: String?
    ) {
        guard let city = activity.cityId else { return }
        let targetCity = city.lowercased()
        for index in days.indices {
            guard !days[index].isExperienceSuggestions else { continue }
            if let hop = days[index].intercityHop {
                let allowed = [hop.fromCityId.lowercased(), hop.toCityId.lowercased()]
                guard allowed.contains(targetCity) else { continue }
            } else if let scheduled = days[index].experienceCityId?.lowercased(), !scheduled.isEmpty,
                      scheduled != targetCity {
                continue
            }
            let dayCapacity = PlanItinerarySlotBudget.daytimeCapacity(
                dayIndex: days[index].dayIndex,
                days: days,
                pace: pace,
                arrivalTime: arrivalTime,
                departureTime: departureTime
            )
            let used = PlanItinerarySlotBudget.usedDaytimeSlots(
                activities: days[index].activities,
                catalogById: catalogById
            )
            guard PlanItinerarySlotBudget.fitsDaytime(
                activity: activity,
                into: used,
                capacity: dayCapacity,
                catalogById: catalogById
            ) else { continue }
            let cities = Set(days[index].activities.compactMap(\.cityId))
            let compatible: Bool
            if let hop = days[index].intercityHop {
                let allowed = Set([hop.fromCityId.lowercased(), hop.toCityId.lowercased()])
                compatible = allowed.contains(targetCity)
                    && (cities.isEmpty || cities.allSatisfy { allowed.contains($0.lowercased()) })
            } else {
                compatible = cities.isEmpty || cities.allSatisfy({ CityTravelHints.canVisitSameDay($0, city) })
            }
            if compatible {
                days[index] = days[index].withActivities(days[index].activities + [activity])
                return
            }
        }
        // No compatible day found: silently drop instead of forcing a mixed-city day.
    }

    private static func insertTravelDays(into days: inout [ItineraryDay]) {
        var previousCity: String?
        for index in days.indices {
            if days[index].isExperienceSuggestions {
                previousCity = days[index].experienceCityId ?? previousCity
                continue
            }
            if days[index].intercityHop != nil {
                previousCity = days[index].intercityHop?.toCityId ?? days[index].experienceCityId
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
        if let hop = day.intercityHop {
            return CityTravelHints.hopDayRouteLabel(fromCityId: hop.fromCityId, toCityId: hop.toCityId)
        }
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
