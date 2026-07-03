import Foundation

/// Four-step itinerary scheduling (mirrors Edge `itinerary-scheduler.ts`).
enum PlanItineraryScheduler {
    struct DayPlanDraft {
        let dayIndex: Int
        let cityId: String
        var attractionIds: [String]
    }

    struct PipelineResult {
        let days: [ItineraryDay]
        let visitOrder: [String]
        let droppedAttractionIds: [String]
        let schedulingAdjustments: [String]
    }

    private struct TimelineSlot {
        let dayIndex: Int
        let kind: String
        let cityId: String
        let dayCapacity: Double
        let eveningCapacity: Int
        let fromCityId: String?
    }

    static func run(
        cities: [String],
        tripDays: Int,
        attractions: [Attraction],
        userNotes: String? = nil,
        pace: TripPace = .standard,
        arrivalTime: String? = nil,
        departureTime: String? = nil,
        startDate: Date? = nil,
        entryCityId: String? = nil,
        exitCityId: String? = nil
    ) -> PipelineResult {
        let cityIds = Array(Set(cities.map { $0.lowercased() }.filter { !$0.isEmpty }))
        let resolved = cityIds.isEmpty ? ["beijing"] : cityIds
        let days = max(1, min(tripDays, 21))

        var catalogByCity: [String: [Attraction]] = [:]
        for row in attractions {
            catalogByCity[row.cityId, default: []].append(row)
        }
        let catalogCounts = Dictionary(uniqueKeysWithValues: catalogByCity.map { ($0.key, $0.value.count) })

        let visitOrder = CityTravelHints.inferVisitOrder(
            cityIds: resolved,
            catalogCountByCity: catalogCounts,
            entryCityId: entryCityId,
            exitCityId: exitCityId
        )
        let cityDays = PlanItineraryCityDays.calibrateCityDays(
            visitOrder: visitOrder,
            aiWeights: nil,
            catalogByCity: catalogByCity,
            tripDays: days
        )

        let resolvedPace = pace

        let pick = PlanItineraryPickAttractions.pick(
            catalogByCity: catalogByCity,
            cityDays: cityDays,
            pace: resolvedPace
        )

        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })
        var timeline = buildTimeline(tripDays: days, visitOrder: visitOrder, cityDays: cityDays)
        timeline = applyFlightAndPaceProfiles(
            timeline,
            tripDays: days,
            pace: resolvedPace,
            arrivalTime: arrivalTime,
            departureTime: departureTime
        )
        var dayPlans = buildRuleDayPlans(
            timeline: timeline,
            candidatesByCity: pick.candidatesByCity,
            catalogById: catalogById
        )

        var adjustments: [String] = []
        var repaired = validateAndRepair(
            tripDays: days,
            dayPlans: &dayPlans,
            timeline: timeline,
            catalogById: catalogById,
            startDate: startDate,
            adjustments: &adjustments
        )

        let geo = PlanItineraryGeoRepair.apply(
            assignments: repaired.assignments,
            catalogById: catalogById,
            adjustments: &adjustments
        )
        repaired = (assignments: geo.assignments, dropped: repaired.dropped + geo.dropped)

        var itineraryDays: [ItineraryDay] = []
        let travelSlots = timeline.filter { $0.kind == "travel" }
        let expByDay = Dictionary(uniqueKeysWithValues: travelSlots.map { ($0.dayIndex, $0) })

        for dayIndex in 1...days {
            if let travelSlot = expByDay[dayIndex] {
                let fromCity = travelSlot.fromCityId ?? ""
                let hours = fromCity.isEmpty
                    ? 6.0
                    : CityTravelHints.travelHours(fromCity, travelSlot.cityId)
                let items = fromCity.isEmpty
                    ? CityTravelHints.travelExperienceItems(toCityId: travelSlot.cityId)
                    : CityTravelHints.buildTravelDayContent(
                        fromCityId: fromCity,
                        toCityId: travelSlot.cityId,
                        hours: hours
                    )
                var day = experienceDay(
                    dayIndex: dayIndex,
                    cityId: travelSlot.cityId,
                    travel: true,
                    items: items
                )
                let ids = repaired.assignments[dayIndex] ?? []
                var activities: [ItineraryActivity] = []
                for (actIndex, id) in ids.enumerated() {
                    guard let row = catalogById[id], row.isEveningOnly else { continue }
                    activities.append(activity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: .evening))
                }
                day = day.withActivities(activities)
                itineraryDays.append(day)
                continue
            }
            let ids = repaired.assignments[dayIndex] ?? []
            var activities: [ItineraryActivity] = []
            for (actIndex, id) in ids.enumerated() {
                guard let row = catalogById[id] else { continue }
                let preferred: VisitTimeSlot? = row.isEveningOnly
                    ? .evening
                    : (actIndex % 2 == 0 ? .morning : .afternoon)
                activities.append(activity(from: row, dayIndex: dayIndex, actIndex: actIndex, preferred: preferred))
            }
            let cityId = timeline.first { $0.dayIndex == dayIndex && $0.kind == "sightseeing" }?.cityId
                ?? visitOrder[(dayIndex - 1) % visitOrder.count]
            itineraryDays.append(
                ItineraryDay(
                    id: "day_\(dayIndex)",
                    dayIndex: dayIndex,
                    dateLabel: "Day \(dayIndex)",
                    cityName: CityTravelHints.displayName(for: cityId),
                    costEstimate: nil,
                    activities: activities
                )
            )
        }

        let route = CityTravelHints.routeLabel(from: visitOrder)
        _ = route
        _ = userNotes

        return PipelineResult(
            days: itineraryDays,
            visitOrder: visitOrder,
            droppedAttractionIds: pick.preDropped + repaired.dropped,
            schedulingAdjustments: adjustments
        )
    }

    private static func buildTimeline(
        tripDays: Int,
        visitOrder: [String],
        cityDays: [String: Int]
    ) -> [TimelineSlot] {
        var slots: [TimelineSlot] = []
        var dayPtr = 1

        for (i, city) in visitOrder.enumerated() {
            let cityId = city.lowercased()
            if i > 0 {
                let prev = visitOrder[i - 1]
                if CityTravelHints.needsTravelDay(prev, cityId),
                   CityTravelHints.commuteSlots(CityTravelHints.travelHours(prev, cityId)) >= 2,
                   dayPtr <= tripDays {
                    slots.append(TimelineSlot(
                        dayIndex: dayPtr,
                        kind: "travel",
                        cityId: cityId,
                        dayCapacity: 0,
                        eveningCapacity: 1,
                        fromCityId: prev
                    ))
                    dayPtr += 1
                }
            }

            let budget = cityDays[cityId] ?? 1
            for b in 0..<budget where dayPtr <= tripDays {
                var capacity = PlanItineraryDuration.daySlotCapacity(.fullDay)
                if i > 0 {
                    let h = CityTravelHints.travelHours(visitOrder[i - 1], cityId)
                    if CityTravelHints.commuteSlots(h) == 1, b == 0 {
                        capacity = 1
                    }
                }
                slots.append(TimelineSlot(
                    dayIndex: dayPtr,
                    kind: "sightseeing",
                    cityId: cityId,
                    dayCapacity: capacity,
                    eveningCapacity: 1,
                    fromCityId: nil
                ))
                dayPtr += 1
            }
        }

        while dayPtr <= tripDays {
            let cityId = visitOrder[(dayPtr - 1) % visitOrder.count]
            slots.append(TimelineSlot(
                dayIndex: dayPtr,
                kind: "sightseeing",
                cityId: cityId,
                dayCapacity: PlanItineraryDuration.daySlotCapacity(.fullDay),
                eveningCapacity: 1,
                fromCityId: nil
            ))
            dayPtr += 1
        }

        return Array(slots.prefix(tripDays))
    }

    private static func applyFlightAndPaceProfiles(
        _ slots: [TimelineSlot],
        tripDays: Int,
        pace: TripPace,
        arrivalTime: String?,
        departureTime: String?
    ) -> [TimelineSlot] {
        let sightseeing = slots.filter { $0.kind == "sightseeing" }
        let firstSight = sightseeing.first?.dayIndex
        let lastSight = sightseeing.last?.dayIndex

        return slots.map { slot in
            guard slot.kind == "sightseeing" else { return slot }

            var profile: DayScheduleProfile = .fullDay
            if slot.dayIndex == firstSight { profile = .arrivalDay }
            if slot.dayIndex == lastSight, tripDays > 1 { profile = .departureDay }

            var dayCapacity = min(slot.dayCapacity, PlanItineraryPace.daySlotCapacity(profile: profile, pace: pace))
            var eveningCapacity = slot.eveningCapacity

            if slot.dayIndex == firstSight, PlanItineraryFlightTimes.isAfternoonArrival(arrivalTime) {
                dayCapacity = 0
                eveningCapacity = max(eveningCapacity, 1)
            }
            if slot.dayIndex == lastSight, PlanItineraryFlightTimes.isMorningDeparture(departureTime) {
                dayCapacity = min(dayCapacity, PlanItineraryPace.daySlotCapacity(profile: .departureDay, pace: pace))
            }

            return TimelineSlot(
                dayIndex: slot.dayIndex,
                kind: slot.kind,
                cityId: slot.cityId,
                dayCapacity: dayCapacity,
                eveningCapacity: eveningCapacity,
                fromCityId: slot.fromCityId
            )
        }
    }

    private static func buildRuleDayPlans(
        timeline: [TimelineSlot],
        candidatesByCity: [String: [String]],
        catalogById: [String: Attraction]
    ) -> [DayPlanDraft] {
        var pools = candidatesByCity
        var plans: [DayPlanDraft] = []

        for slot in timeline {
            let city = slot.cityId
            var pool = pools[city] ?? []
            var daytimeIds: [String] = []
            var eveningIds: [String] = []

            if slot.dayCapacity > 0 {
                var used = 0.0
                var i = 0
                while i < pool.count, used < slot.dayCapacity {
                    let id = pool[i]
                    guard let row = catalogById[id], !row.isEveningOnly else {
                        i += 1
                        continue
                    }
                    let dur = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                    if used + dur <= slot.dayCapacity || daytimeIds.isEmpty {
                        daytimeIds.append(id)
                        used += dur
                        pool.remove(at: i)
                    } else {
                        i += 1
                    }
                }
            }

            if slot.eveningCapacity > 0,
               let eveIdx = pool.firstIndex(where: { catalogById[$0]?.isEveningOnly == true }) {
                eveningIds.append(pool[eveIdx])
                pool.remove(at: eveIdx)
            }

            pools[city] = pool
            plans.append(DayPlanDraft(
                dayIndex: slot.dayIndex,
                cityId: city,
                attractionIds: daytimeIds + eveningIds
            ))
        }
        return plans
    }

    private static func partitionAttractionIds(
        _ ids: [String],
        catalogById: [String: Attraction]
    ) -> (daytime: [String], evening: [String]) {
        var daytime: [String] = []
        var evening: [String] = []
        for id in ids {
            guard let row = catalogById[id] else { continue }
            if row.isEveningOnly { evening.append(id) }
            else { daytime.append(id) }
        }
        return (daytime, evening)
    }

    private static func validateAndRepair(
        tripDays: Int,
        dayPlans: inout [DayPlanDraft],
        timeline: [TimelineSlot],
        catalogById: [String: Attraction],
        startDate: Date?,
        adjustments: inout [String]
    ) -> (assignments: [Int: [String]], dropped: [String]) {
        var assignments: [Int: [String]] = [:]
        var dropped: [String] = []
        var overflow: [(id: String, priority: Int)] = []

        let capacityByDay = Dictionary(uniqueKeysWithValues: timeline.map { ($0.dayIndex, $0.dayCapacity) })
        let eveningCapByDay = Dictionary(uniqueKeysWithValues: timeline.map { ($0.dayIndex, $0.eveningCapacity) })
        let planByDay = Dictionary(uniqueKeysWithValues: dayPlans.map { ($0.dayIndex, $0) })

        for day in 1...tripDays {
            let capacity = capacityByDay[day] ?? PlanItineraryDuration.daySlotCapacity(.fullDay)
            let eveningCap = eveningCapByDay[day] ?? 0
            let ids = planByDay[day]?.attractionIds ?? []
            let parts = partitionAttractionIds(ids, catalogById: catalogById)

            var used = 0.0
            var keptDaytime: [String] = []
            var keptEvening: [String] = []

            for id in parts.daytime {
                guard let row = catalogById[id] else { continue }
                let dur = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                let pr = priorityRank(row.priority)
                if let date = dateForDay(day, startDate: startDate),
                   PlanItineraryVisitHours.isClosedOnDate(row, date: date) {
                    overflow.append((id, pr))
                    adjustments.append("Moved \(id) (closed on day \(day))")
                    continue
                }
                if used + dur > capacity {
                    overflow.append((id, pr))
                    adjustments.append("Moved \(id) (exceeds day \(day) slot budget)")
                    continue
                }
                keptDaytime.append(id)
                used += dur
            }

            for id in parts.evening {
                guard let row = catalogById[id] else { continue }
                let pr = priorityRank(row.priority)
                if !row.isEveningOnly {
                    overflow.append((id, pr))
                    adjustments.append("Moved \(id) (not an evening-only sight)")
                    continue
                }
                if keptEvening.count >= eveningCap {
                    overflow.append((id, pr))
                    adjustments.append("Moved \(id) (evening slot full on day \(day))")
                    continue
                }
                keptEvening.append(id)
            }

            assignments[day] = keptDaytime + keptEvening
        }

        overflow.sort { $0.priority < $1.priority }

        for item in overflow {
            guard let row = catalogById[item.id] else { continue }
            var placed = false

            if row.isEveningOnly {
                for day in 1...tripDays {
                    let eveCap = eveningCapByDay[day] ?? 0
                    guard eveCap > 0 else { continue }
                    let eveningCount = (assignments[day] ?? []).filter { catalogById[$0]?.isEveningOnly == true }.count
                    guard eveningCount < eveCap else { continue }
                    assignments[day, default: []].append(item.id)
                    placed = true
                    adjustments.append("Placed \(item.id) on day \(day) (evening)")
                    break
                }
            } else {
                for day in 1...tripDays {
                    if let date = dateForDay(day, startDate: startDate),
                       PlanItineraryVisitHours.isClosedOnDate(row, date: date) {
                        continue
                    }
                    let cap = capacityByDay[day] ?? PlanItineraryDuration.daySlotCapacity(.fullDay)
                    let dur = PlanItineraryDuration.parseDurationSlots(row.recommendedDurationText)
                    var used = 0.0
                    for id in assignments[day] ?? [] {
                        guard let r = catalogById[id], !r.isEveningOnly else { continue }
                        used += PlanItineraryDuration.parseDurationSlots(r.recommendedDurationText)
                    }
                    if used + dur <= cap {
                        assignments[day, default: []].append(item.id)
                        placed = true
                        adjustments.append("Placed \(item.id) on day \(day)")
                        break
                    }
                }
            }
            if !placed { dropped.append(item.id) }
        }

        return (assignments, dropped)
    }

    private static func dateForDay(_ day: Int, startDate: Date?, calendar: Calendar = .current) -> Date? {
        guard let startDate, day >= 1 else { return nil }
        let start = calendar.startOfDay(for: startDate)
        return calendar.date(byAdding: .day, value: day - 1, to: start)
    }

    private static func priorityRank(_ p: String) -> Int {
        switch p.uppercased() {
        case "P0": return 0
        case "P2": return 2
        default: return 1
        }
    }

    private static func experienceDay(
        dayIndex: Int,
        cityId: String,
        travel: Bool,
        items: [String]? = nil
    ) -> ItineraryDay {
        let resolvedItems = items ?? (travel
            ? CityTravelHints.travelExperienceItems(toCityId: cityId)
            : ["Local experiences"])
        return ItineraryDay(
            id: "day_\(dayIndex)",
            dayIndex: dayIndex,
            dateLabel: "Day \(dayIndex)",
            cityName: CityTravelHints.displayName(for: cityId),
            costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: resolvedItems,
            experienceCityId: cityId
        )
    }

    private static func activity(
        from row: Attraction,
        dayIndex: Int,
        actIndex: Int,
        preferred: VisitTimeSlot? = nil
    ) -> ItineraryActivity {
        var detailParts: [String] = []
        if let duration = row.recommendedDurationText, !duration.isEmpty {
            detailParts.append(duration)
        }
        if let summary = row.summary, !summary.isEmpty {
            detailParts.append(HTMLContentView.plainText(from: summary))
        }
        let detail = detailParts.isEmpty ? "Explore at your own pace" : detailParts.joined(separator: " · ")

        let resolvedPreferred = preferred ?? (actIndex % 2 == 0 ? VisitTimeSlot.morning : .afternoon)
        let timeSlot = PlanItineraryVisitHours.visitTimeSlotLabel(
            PlanItineraryVisitHours.pickVisitTimeSlot(row, preferred: resolvedPreferred)
        )

        return ItineraryActivity(
            id: "a_\(dayIndex)_\(actIndex)_\(row.id)",
            timeSlot: timeSlot,
            name: row.name,
            detail: detail,
            attractionId: row.id,
            cityId: row.cityId,
            hasAudio: row.audioGuideCount > 0
        )
    }
}
