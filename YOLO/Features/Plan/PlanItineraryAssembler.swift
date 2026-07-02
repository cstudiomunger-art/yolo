import Foundation

/// Deterministic DB-only itinerary assembly (mirrors Edge `buildItineraryPipeline`).
enum PlanItineraryAssembler {
    private static let experienceTemplates: [String: [String]] = [
        "beijing": [
            "Street food tasting",
            "Traditional tea ceremony",
            "Hutong walking tour",
            "Night market experience",
            "Local craft workshop",
            "Traditional Chinese massage",
        ],
        "shanghai": [
            "Huangpu riverfront walk",
            "Local breakfast crawl",
            "Traditional tea house visit",
            "Night skyline viewing",
            "Calligraphy workshop",
            "French Concession stroll",
        ],
        "chengdu": [
            "Hot pot experience",
            "Tea house culture",
            "Spice market visit",
            "Night food street",
            "Sichuan cooking class",
            "Park tai chi observation",
        ],
    ]

    private static let defaultExperiences = [
        "Street food tasting",
        "Traditional tea ceremony",
        "Local market visit",
        "Night market experience",
        "Cultural workshop",
        "Neighborhood walking time",
    ]

    static func build(
        cities: [String],
        tripDays: Int,
        attractions: [Attraction],
        userNotes: String? = nil
    ) -> SampleItinerary {
        let cityIds = Array(Set(cities.map { $0.lowercased() }.filter { !$0.isEmpty }))
        let resolvedCityIds = cityIds.isEmpty ? ["beijing"] : cityIds
        let days = max(1, min(tripDays, 21))

        let catalog = attractions.sorted {
            if $0.displayOrder != $1.displayOrder { return $0.displayOrder < $1.displayOrder }
            return $0.name < $1.name
        }

        var catalogByCity: [String: [Attraction]] = [:]
        for row in catalog {
            catalogByCity[row.cityId, default: []].append(row)
        }
        let catalogCounts = Dictionary(uniqueKeysWithValues: catalogByCity.map { ($0.key, $0.value.count) })

        let visitOrder = CityTravelHints.inferVisitOrder(
            cityIds: resolvedCityIds,
            catalogCountByCity: catalogCounts
        )

        let durationSlots = catalog.map { PlanItineraryDuration.parseDurationSlots($0.recommendedDurationText) }
        let maxPerDay = PlanItineraryDuration.maxAttractionsPerDay(catalogDurations: durationSlots, tripDays: days, hardMax: 3)

        let dayBudget = distributeDaysAcrossCities(tripDays: days, cities: visitOrder, catalogByCity: catalogByCity)
        var itineraryDays: [ItineraryDay] = []
        var dayPtr = 1

        for (cityIndex, cityId) in visitOrder.enumerated() {
            if dayPtr > days { break }
            if cityIndex > 0 {
                let prevCity = visitOrder[cityIndex - 1]
                if CityTravelHints.needsTravelDay(prevCity, cityId), dayPtr <= days {
                    itineraryDays.append(experienceDay(dayIndex: dayPtr, cityId: cityId, travel: true))
                    dayPtr += 1
                }
            }

            let budget = min(dayBudget[cityId] ?? 1, max(0, days - dayPtr + 1))
            let pool = catalogByCity[cityId] ?? []
            var zoneBuckets: [String: [Attraction]] = [:]
            for row in pool {
                let key = (row.planningZone ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                zoneBuckets[key.isEmpty ? "default" : key, default: []].append(row)
            }
            let zoneOrder = zoneBuckets.keys.sorted()
            var zoneCursor = 0

            for _ in 0..<budget {
                guard dayPtr <= days else { break }
                var activities: [ItineraryActivity] = []
                var actIndex = 0
                while activities.count < maxPerDay, zoneCursor < zoneOrder.count {
                    let zone = zoneOrder[zoneCursor]
                    var list = zoneBuckets[zone] ?? []
                    guard !list.isEmpty else {
                        zoneCursor += 1
                        continue
                    }
                    let row = list.removeFirst()
                    zoneBuckets[zone] = list
                    activities.append(activity(from: row, dayIndex: dayPtr, actIndex: actIndex))
                    actIndex += 1
                    if list.isEmpty { zoneCursor += 1 }
                }
                itineraryDays.append(
                    ItineraryDay(
                        id: "day_\(dayPtr)",
                        dayIndex: dayPtr,
                        dateLabel: "Day \(dayPtr)",
                        cityName: CityTravelHints.displayName(for: cityId),
                        costEstimate: nil,
                        activities: activities
                    )
                )
                dayPtr += 1
            }
        }

        while itineraryDays.count < days {
            let dayIndex = itineraryDays.count + 1
            let cityId = visitOrder[(dayIndex - 1) % visitOrder.count]
            itineraryDays.append(experienceDay(dayIndex: dayIndex, cityId: cityId, travel: false))
        }

        if itineraryDays.count > days {
            itineraryDays = Array(itineraryDays.prefix(days))
        }

        for index in itineraryDays.indices {
            itineraryDays[index] = itineraryDays[index].withDayIndex(index + 1)
        }

        let route = CityTravelHints.routeLabel(from: visitOrder)
        let trip = SampleItinerary(
            id: UUID().uuidString,
            title: "\(days)-Day \(route) Trip",
            meta: userNotes.map { "Generated · \($0.prefix(120))" } ?? "Generated",
            routeSummary: route,
            estimatedBudget: "$800–$1,500",
            days: itineraryDays,
            visitOrder: visitOrder
        )
        return PlanItineraryNormalizer.normalize(trip, selectedCityIds: resolvedCityIds)
    }

    private static func distributeDaysAcrossCities(
        tripDays: Int,
        cities: [String],
        catalogByCity: [String: [Attraction]]
    ) -> [String: Int] {
        guard !cities.isEmpty else { return [:] }
        let weights = cities.map { max(1, catalogByCity[$0]?.count ?? 1) }
        let totalWeight = weights.reduce(0, +)
        var map: [String: Int] = [:]
        var assigned = 0

        for (index, city) in cities.enumerated() {
            let share: Int
            if index == cities.count - 1 {
                share = max(1, tripDays - assigned)
            } else {
                share = max(1, Int((Double(tripDays) * Double(weights[index]) / Double(totalWeight)).rounded()))
            }
            map[city] = share
            assigned += share
        }

        while assigned > tripDays {
            if let richest = map.max(by: { $0.value < $1.value })?.key, map[richest, default: 1] > 1 {
                map[richest, default: 1] -= 1
                assigned -= 1
            } else {
                break
            }
        }
        return map
    }

    private static func experienceDay(dayIndex: Int, cityId: String, travel: Bool) -> ItineraryDay {
        let items = travel
            ? CityTravelHints.travelExperienceItems(toCityId: cityId)
            : templateItems(cityId: cityId)
        return ItineraryDay(
            id: "day_\(dayIndex)",
            dayIndex: dayIndex,
            dateLabel: "Day \(dayIndex)",
            cityName: CityTravelHints.displayName(for: cityId),
            costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: items,
            experienceCityId: cityId
        )
    }

    private static func activity(from row: Attraction, dayIndex: Int, actIndex: Int) -> ItineraryActivity {
        var detailParts: [String] = []
        if let duration = row.recommendedDurationText, !duration.isEmpty {
            detailParts.append(duration)
        }
        if let summary = row.summary, !summary.isEmpty {
            detailParts.append(HTMLContentView.plainText(from: summary))
        } else if let price = row.ticketPriceText, !price.isEmpty {
            detailParts.append(price)
        }
        let detail = detailParts.isEmpty ? "Explore at your own pace" : detailParts.joined(separator: " · ")

        let preferred: HalfDaySlot? = (actIndex % 2 == 0) ? .morning : .afternoon
        let picked = PlanItineraryVisitHours.pickTimeSlot(row, preferred: preferred)
        let timeSlot = picked == .morning ? "Morning" : (picked == .afternoon ? "Afternoon" : "")

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

    private static func templateItems(cityId: String) -> [String] {
        experienceTemplates[cityId.lowercased()] ?? defaultExperiences
    }
}
