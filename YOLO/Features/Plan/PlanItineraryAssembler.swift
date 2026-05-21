import Foundation

/// Deterministic DB-only itinerary assembly (mirrors Edge `itinerary-assembler.ts`).
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
        let cityIds = cities.isEmpty ? ["beijing"] : cities
        let days = max(1, min(tripDays, 21))
        let catalog = attractions.sorted {
            if $0.displayOrder != $1.displayOrder { return $0.displayOrder < $1.displayOrder }
            return $0.name < $1.name
        }

        let attractionDayCount = catalog.isEmpty ? 0 : min(days, catalog.count)
        let attractionDayIndices = (1...attractionDayCount).map { $0 }
        var experienceSpecs: [(dayIndex: Int, cityId: String)] = []
        for dayIndex in (attractionDayCount + 1)...days {
            let cityId = cityIds[(dayIndex - 1) % cityIds.count]
            experienceSpecs.append((dayIndex, cityId))
        }

        let maxPerDay: Int = {
            if catalog.count >= days {
                return min(3, max(1, Int(ceil(Double(catalog.count) / Double(days)))))
            }
            if attractionDayCount > 0 {
                return min(3, max(1, Int(ceil(Double(catalog.count) / Double(attractionDayCount)))))
            }
            return 1
        }()

        var assignments: [(dayIndex: Int, ids: [String])] = attractionDayIndices.map { ($0, []) }
        var cursor = 0
        for i in assignments.indices {
            while cursor < catalog.count, assignments[i].ids.count < maxPerDay {
                assignments[i].ids.append(catalog[cursor].id)
                cursor += 1
            }
        }
        var dayPtr = 0
        while cursor < catalog.count, !assignments.isEmpty {
            if assignments[dayPtr % assignments.count].ids.count < maxPerDay {
                assignments[dayPtr % assignments.count].ids.append(catalog[cursor].id)
                cursor += 1
            }
            dayPtr += 1
            if dayPtr > assignments.count * maxPerDay * 2 { break }
        }

        let catalogById = Dictionary(uniqueKeysWithValues: catalog.map { ($0.id, $0) })
        let cityLabel = cityIds.map { $0.capitalized }.joined(separator: " → ")

        var itineraryDays: [ItineraryDay] = []
        for dayIndex in 1...days {
            if let spec = experienceSpecs.first(where: { $0.dayIndex == dayIndex }) {
                let items = templateItems(cityId: spec.cityId)
                itineraryDays.append(
                    ItineraryDay(
                        id: "day_\(dayIndex)",
                        dayIndex: dayIndex,
                        dateLabel: "Day \(dayIndex)",
                        cityName: "",
                        costEstimate: nil,
                        activities: [],
                        dayKind: .experienceSuggestions,
                        experienceItems: items,
                        experienceCityId: spec.cityId
                    )
                )
                continue
            }

            let ids = assignments.first(where: { $0.dayIndex == dayIndex })?.ids ?? []
            let activities = ids.enumerated().compactMap { actIndex, aid -> ItineraryActivity? in
                guard let row = catalogById[aid] else { return nil }
                return activity(from: row, dayIndex: dayIndex, actIndex: actIndex)
            }

            itineraryDays.append(
                ItineraryDay(
                    id: "day_\(dayIndex)",
                    dayIndex: dayIndex,
                    dateLabel: "Day \(dayIndex)",
                    cityName: "",
                    costEstimate: nil,
                    activities: activities
                )
            )
        }

        return SampleItinerary(
            id: UUID().uuidString,
            title: "\(days)-Day \(cityLabel) Trip",
            meta: userNotes.map { "Generated · \($0.prefix(120))" } ?? "Generated",
            routeSummary: cityLabel,
            estimatedBudget: "$800–$1,500",
            days: itineraryDays
        )
    }

    private static func activity(from row: Attraction, dayIndex: Int, actIndex: Int) -> ItineraryActivity {
        var detailParts: [String] = []
        if let duration = row.recommendedDurationText, !duration.isEmpty {
            detailParts.append(duration)
        }
        if let summary = row.summary, !summary.isEmpty {
            detailParts.append(summary)
        } else if let price = row.ticketPriceText, !price.isEmpty {
            detailParts.append(price)
        }
        let detail = detailParts.isEmpty ? "Explore at your own pace" : detailParts.joined(separator: " · ")

        return ItineraryActivity(
            id: "a_\(dayIndex)_\(actIndex)_\(row.id)",
            name: row.name,
            detail: detail,
            attractionId: row.id,
            cityId: row.cityId,
            hasAudio: row.audioGuideCount > 0
        )
    }

    private static func templateItems(cityId: String) -> [String] {
        let key = cityId.lowercased()
        return experienceTemplates[key] ?? defaultExperiences
    }
}
