import Foundation

// Standalone regression harness for itinerary assembly + normalization.
// Compile:
//   swiftc -parse-as-library \
//     YOLO/Models/CityModels.swift \
//     YOLO/Models/AudioModels.swift \
//     YOLO/Models/ItineraryModels.swift \
//     YOLO/Models/AttractionModels.swift \
//     YOLO/Features/Plan/CityTravelHints.swift \
//     YOLO/Features/Plan/PlanItineraryNormalizer.swift \
//     YOLO/Features/Plan/PlanItineraryAssembler.swift \
//     scripts/html_plain_stub.swift \
//     scripts/plan_itinerary_golden_test.swift \
//     -o /tmp/plan_itinerary_golden_test
//
// Run: /tmp/plan_itinerary_golden_test

@main
enum PlanItineraryGoldenTest {
    static func main() {
        var fails = 0

        fails += testDeterministicFourCitiesSixDays()
        fails += testExperienceDayOccupiesSlot()
        fails += testNormalizeSplitsIncompatibleSameDay()
        fails += testRouteConsistency()

        if fails == 0 {
            print("\n✅ Itinerary golden tests passed")
            exit(0)
        } else {
            print("\n❌ \(fails) itinerary golden test(s) failed")
            exit(1)
        }
    }

    private static func testDeterministicFourCitiesSixDays() -> Int {
        let cities = ["beijing", "shanghai", "chengdu", "chongqing"]
        let attractions = mockCatalog(cities: cities, perCity: 4)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions
        )

        var fail = 0
        if trip.days.count != 6 {
            print("✗ 4-city 6-day: expected 6 days, got \(trip.days.count)")
            fail += 1
        }

        for day in trip.days where !day.isExperienceSuggestions {
            let cityIds = Set(day.activities.compactMap(\.cityId))
            if cityIds.contains("beijing"), cityIds.contains("shanghai"), cityIds.contains("chengdu") {
                print("✗ 4-city 6-day: day \(day.dayIndex) mixes beijing+shanghai+chengdu")
                fail += 1
            }
            for a in cityIds {
                for b in cityIds where a != b {
                    if !CityTravelHints.canVisitSameDay(a, b) {
                        print("✗ 4-city 6-day: day \(day.dayIndex) incompatible pair \(a)+\(b)")
                        fail += 1
                    }
                }
            }
        }

        let hasTravel = trip.days.contains { $0.isExperienceSuggestions && !$0.experienceItems.isEmpty }
        if !hasTravel {
            print("✗ 4-city 6-day: expected at least one travel/rest experience day")
            fail += 1
        }

        print(fail == 0 ? "✓ 4-city 6-day deterministic assembly" : "")
        return fail
    }

    private static func testExperienceDayOccupiesSlot() -> Int {
        let badDay = ItineraryDay(
            id: "day_3",
            dayIndex: 3,
            dateLabel: "Day 3",
            cityName: "Shanghai",
            costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: CityTravelHints.travelExperienceItems(toCityId: "shanghai"),
            experienceCityId: "shanghai"
        )
        let trip = SampleItinerary(
            id: "t1",
            title: "Test",
            meta: "Test",
            routeSummary: "Beijing → Shanghai",
            estimatedBudget: "$0",
            days: [
                mockAttractionDay(dayIndex: 1, cityId: "beijing", count: 2),
                mockAttractionDay(dayIndex: 2, cityId: "beijing", count: 2),
                badDay,
                mockAttractionDay(dayIndex: 4, cityId: "shanghai", count: 2),
            ]
        )
        let normalized = PlanItineraryNormalizer.normalize(trip, selectedCityIds: ["beijing", "shanghai"])
        guard let day3 = normalized.days.first(where: { $0.dayIndex == 3 }) else {
            print("✗ experience slot: missing day 3")
            return 1
        }
        let ok = day3.isExperienceSuggestions && day3.activities.isEmpty
        print(ok ? "✓ experience day occupies slot (no attractions on day 3)" : "✗ experience day should have no attractions")
        return ok ? 0 : 1
    }

    private static func testNormalizeSplitsIncompatibleSameDay() -> Int {
        let mixed = ItineraryDay(
            id: "day_1",
            dayIndex: 1,
            dateLabel: "Day 1",
            cityName: "",
            costEstimate: nil,
            activities: [
                mockActivity(id: "a1", cityId: "beijing", name: "Forbidden City"),
                mockActivity(id: "a2", cityId: "chengdu", name: "Panda Base"),
            ]
        )
        let trip = SampleItinerary(
            id: "t2",
            title: "Bad",
            meta: "",
            routeSummary: "",
            estimatedBudget: "$0",
            days: [mixed, mockAttractionDay(dayIndex: 2, cityId: "beijing", count: 1)]
        )
        let normalized = PlanItineraryNormalizer.normalize(
            trip,
            selectedCityIds: ["beijing", "chengdu"]
        )
        var fail = 0
        for day in normalized.days where !day.isExperienceSuggestions {
            let cities = Set(day.activities.compactMap(\.cityId))
            if cities.contains("beijing"), cities.contains("chengdu") {
                print("✗ normalize: still has beijing+chengdu same day")
                fail += 1
            }
        }
        print(fail == 0 ? "✓ normalize splits incompatible same-day cities" : "")
        return fail
    }

    private static func testRouteConsistency() -> Int {
        let cities = ["beijing", "shanghai", "hangzhou"]
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: mockCatalog(cities: cities, perCity: 3)
        )
        let routeCities = trip.routeSummary.components(separatedBy: " → ")
            .map { $0.lowercased().replacingOccurrences(of: " ", with: "") }
        let visit = trip.visitOrder ?? []
        var fail = 0
        if routeCities.count != visit.count {
            print("✗ route consistency: route segments \(routeCities.count) != visitOrder \(visit.count)")
            fail += 1
        }
        if !trip.title.localizedCaseInsensitiveContains(routeCities.first ?? "") {
            print("✗ route consistency: title '\(trip.title)' missing first city")
            fail += 1
        }
        print(fail == 0 ? "✓ route/title/visitOrder consistency" : "")
        return fail
    }

    // MARK: - Fixtures

    private static func mockCatalog(cities: [String], perCity: Int) -> [Attraction] {
        var rows: [Attraction] = []
        for city in cities {
            for i in 0..<perCity {
                rows.append(mockAttraction(id: "\(city)_\(i)", cityId: city, name: "\(city.capitalized) Spot \(i)", displayOrder: i))
            }
        }
        return rows
    }

    private static func mockAttraction(id: String, cityId: String, name: String, displayOrder: Int) -> Attraction {
        let json = """
        {"id":"\(id)","cityId":"\(cityId)","name":"\(name)","displayOrder":\(displayOrder)}
        """
        return try! JSONDecoder().decode(Attraction.self, from: Data(json.utf8))
    }

    private static func mockAttractionDay(dayIndex: Int, cityId: String, count: Int) -> ItineraryDay {
        let acts = (0..<count).map { i in
            mockActivity(id: "d\(dayIndex)_\(i)", cityId: cityId, name: "\(cityId) \(i)")
        }
        return ItineraryDay(
            id: "day_\(dayIndex)",
            dayIndex: dayIndex,
            dateLabel: "Day \(dayIndex)",
            cityName: CityTravelHints.displayName(for: cityId),
            costEstimate: nil,
            activities: acts
        )
    }

    private static func mockActivity(id: String, cityId: String, name: String) -> ItineraryActivity {
        ItineraryActivity(
            id: id,
            name: name,
            detail: "Explore",
            attractionId: id,
            cityId: cityId,
            hasAudio: false
        )
    }
}
