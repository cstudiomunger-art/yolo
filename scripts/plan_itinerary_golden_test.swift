import Foundation

// Standalone regression harness for itinerary assembly + normalization.
// Compile:
//   swiftc -parse-as-library \
//     YOLO/Models/CityModels.swift \
//     YOLO/Models/AudioModels.swift \
//     YOLO/Models/ItineraryModels.swift \
//     YOLO/Models/AttractionModels.swift \
//     YOLO/Features/Plan/CityTravelHints.swift \
//     YOLO/Features/Plan/PlanItineraryDuration.swift \
//     YOLO/Features/Plan/PlanItineraryVisitHours.swift \
//     YOLO/Features/Plan/PlanItineraryPace.swift \
//     YOLO/Features/Plan/PlanItineraryFlightTimes.swift \
//     YOLO/Features/Plan/PlanItineraryCityDays.swift \
//     YOLO/Features/Plan/PlanItineraryPickAttractions.swift \
//     YOLO/Features/Plan/PlanItineraryGeoRepair.swift \
//     YOLO/Features/Plan/PlanItineraryDayFill.swift \
//     YOLO/Features/Plan/PlanItineraryScheduler.swift \
//     YOLO/Features/Plan/PlanItinerarySlotBudget.swift \
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
        fails += testClosedWeekdayFallbackParsing()
        fails += testAfternoonOnlySlotRule()
        fails += testEveningOnlyScheduling()
        fails += testRelaxedPaceCapsDaytime()
        fails += testAfternoonArrivalEveningOnly()
        fails += testNormalizePreservesSchedulerMetadata()
        fails += testDurationBasedPacking()
        fails += testFullDaySightBlocksSecond()
        fails += testChineseDurationParsing()
        fails += testGeoRepairSplitsIncompatibleSameDay()
        fails += testAfternoonArrivalFillsFirstDay()

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

        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })

        var fail = 0
        if trip.days.count != 6 {
            print("✗ 4-city 6-day: expected 6 days, got \(trip.days.count)")
            fail += 1
        }

        for day in trip.days where !day.isExperienceSuggestions {
            let cityIds = Set(day.activities.compactMap(\.cityId))
            let capacity = PlanItinerarySlotBudget.daytimeCapacity(
                dayIndex: day.dayIndex,
                days: trip.days,
                pace: .standard
            )
            if !PlanItinerarySlotBudget.daytimeWithinCapacity(
                activities: day.activities,
                capacity: capacity,
                catalogById: catalogById
            ) {
                let used = PlanItinerarySlotBudget.usedDaytimeSlots(activities: day.activities, catalogById: catalogById)
                print("✗ 4-city 6-day: day \(day.dayIndex) uses \(used) slots (max \(capacity))")
                fail += 1
            }
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

    private static func testClosedWeekdayFallbackParsing() -> Int {
        let json = """
        {"id":"museum","cityId":"beijing","name":"National Museum","closedDays":"Most Mondays"}
        """
        let attraction = try! JSONDecoder().decode(Attraction.self, from: Data(json.utf8))
        let ok = attraction.closedWeekdays.contains("mon")
        print(ok ? "✓ closedDays fallback parses weekdays" : "✗ closedDays fallback should parse monday => mon")
        return ok ? 0 : 1
    }

    private static func testAfternoonOnlySlotRule() -> Int {
        let json = """
        {"id":"night_museum","cityId":"shanghai","name":"Night Museum","openTime":"13:00","closeTime":"20:00"}
        """
        let attraction = try! JSONDecoder().decode(Attraction.self, from: Data(json.utf8))
        let allowed = PlanItineraryVisitHours.allowedHalfDaySlots(attraction)
        let ok = allowed == [.afternoon] &&
            PlanItineraryVisitHours.pickVisitTimeSlot(attraction, preferred: .morning) == .afternoon
        print(ok ? "✓ afternoon-only slot rule" : "✗ expected afternoon-only slot behavior")
        return ok ? 0 : 1
    }

    private static func testEveningOnlyScheduling() -> Int {
        let json = """
        {"id":"night_street","cityId":"chongqing","name":"Night Street","recommended_visit_period":"evening","displayOrder":1}
        """
        let evening = try! JSONDecoder().decode(Attraction.self, from: Data(json.utf8))
        let slot = PlanItineraryVisitHours.pickVisitTimeSlot(evening, preferred: .morning)
        if slot != .evening {
            print("✗ evening-only: expected Evening slot, got \(String(describing: slot))")
            return 1
        }

        let trip = PlanItineraryAssembler.build(
            cities: ["chongqing"],
            tripDays: 2,
            attractions: [evening, mockAttraction(id: "museum", cityId: "chongqing", name: "Museum", displayOrder: 0)]
        )
        let eveningActs = trip.days.flatMap(\.activities).filter { $0.timeSlot == "Evening" }
        let morningEvening = trip.days.flatMap(\.activities).filter {
            $0.attractionId == "night_street" && ($0.timeSlot == "Morning" || $0.timeSlot == "Afternoon")
        }
        let ok = !eveningActs.isEmpty && morningEvening.isEmpty
        print(ok ? "✓ evening-only scheduling" : "✗ evening sight should use Evening slot only")
        return ok ? 0 : 1
    }

    private static func testRelaxedPaceCapsDaytime() -> Int {
        let cities = ["beijing"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 3,
            attractions: attractions,
            pace: .relaxed
        )
        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })
        var fail = 0
        for day in trip.days where !day.isExperienceSuggestions {
            let capacity = PlanItinerarySlotBudget.daytimeCapacity(
                dayIndex: day.dayIndex,
                days: trip.days,
                pace: .relaxed
            )
            let used = PlanItinerarySlotBudget.usedDaytimeSlots(activities: day.activities, catalogById: catalogById)
            if used > capacity {
                print("✗ relaxed pace: day \(day.dayIndex) uses \(used) daytime slots (max \(capacity))")
                fail += 1
            }
        }
        print(fail == 0 ? "✓ relaxed pace caps daytime slot budget" : "")
        return fail
    }

    private static func testAfternoonArrivalEveningOnly() -> Int {
        let evening = try! JSONDecoder().decode(
            Attraction.self,
            from: Data("""
            {"id":"night_street","cityId":"beijing","name":"Night","recommended_visit_period":"evening","displayOrder":1}
            """.utf8)
        )
        let day = try! JSONDecoder().decode(
            Attraction.self,
            from: Data("""
            {"id":"museum","cityId":"beijing","name":"Museum","displayOrder":0}
            """.utf8)
        )
        let trip = PlanItineraryAssembler.build(
            cities: ["beijing"],
            tripDays: 2,
            attractions: [day, evening],
            arrivalTime: "15:00"
        )
        guard let first = trip.days.first(where: { !$0.isExperienceSuggestions }) else {
            print("✗ afternoon arrival: missing first sightseeing day")
            return 1
        }
        let daytime = first.activities.filter { $0.timeSlot == "Morning" || $0.timeSlot == "Afternoon" }
        let ok = daytime.isEmpty
        print(ok ? "✓ afternoon arrival → first day no daytime sights" : "✗ expected no morning/afternoon on first day after late arrival")
        return ok ? 0 : 1
    }

    private static func testNormalizePreservesSchedulerMetadata() -> Int {
        let travelDay = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Shanghai",
            costEstimate: nil,
            activities: [
                ItineraryActivity(
                    id: "a_eve",
                    timeSlot: "Evening",
                    name: "The Bund",
                    detail: "Explore",
                    attractionId: "bund",
                    cityId: "shanghai",
                    hasAudio: false
                )
            ],
            dayKind: .experienceSuggestions,
            experienceItems: CityTravelHints.travelExperienceItems(toCityId: "shanghai"),
            experienceCityId: "shanghai"
        )
        let trip = SampleItinerary(
            id: "t_meta",
            title: "Test",
            meta: "Test",
            routeSummary: "Beijing → Shanghai",
            estimatedBudget: "$0",
            days: [
                mockAttractionDay(dayIndex: 1, cityId: "beijing", count: 2),
                travelDay,
                mockAttractionDay(dayIndex: 3, cityId: "shanghai", count: 2),
            ],
            visitOrder: ["beijing", "shanghai"],
            droppedAttractionIds: ["dropped1"],
            schedulingAdjustments: ["Placed bund on day 2 (evening)"],
            seasonHints: ["Pack layers for shoulder season"]
        )
        let normalized = PlanItineraryNormalizer.normalize(trip, selectedCityIds: ["beijing", "shanghai"])

        var fail = 0
        guard let travel = normalized.days.first(where: { $0.isExperienceSuggestions }) else {
            print("✗ normalize metadata: missing experience day")
            return 1
        }
        if travel.activities.isEmpty {
            print("✗ normalize metadata: wiped travel-day evening activity")
            fail += 1
        }
        if normalized.droppedAttractionIds != trip.droppedAttractionIds {
            print("✗ normalize metadata: droppedAttractionIds not preserved")
            fail += 1
        }
        if normalized.schedulingAdjustments != trip.schedulingAdjustments {
            let preserved = trip.schedulingAdjustments?.allSatisfy {
                normalized.schedulingAdjustments?.contains($0) == true
            } ?? true
            if !preserved {
                print("✗ normalize metadata: schedulingAdjustments not preserved")
                fail += 1
            }
        }
        if normalized.seasonHints != trip.seasonHints {
            print("✗ normalize metadata: seasonHints not preserved")
            fail += 1
        }
        print(fail == 0 ? "✓ normalize preserves scheduler travel day + metadata" : "")
        return fail
    }

    private static func testDurationBasedPacking() -> Int {
        let short1 = mockAttraction(id: "s1", cityId: "beijing", name: "Temple", displayOrder: 0, duration: "2h")
        let short2 = mockAttraction(id: "s2", cityId: "beijing", name: "Park", displayOrder: 1, duration: "2h")
        let short3 = mockAttraction(id: "s3", cityId: "beijing", name: "Market", displayOrder: 2, duration: "2h")
        let catalog = [short1, short2, short3]
        let catalogById = Dictionary(uniqueKeysWithValues: catalog.map { ($0.id, $0) })

        let packedDay = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing",
            costEstimate: nil,
            activities: catalog.map { row in
                ItineraryActivity(
                    id: "a_\(row.id)",
                    name: row.name,
                    detail: "Explore",
                    attractionId: row.id,
                    cityId: row.cityId,
                    hasAudio: false
                )
            }
        )
        let trip = SampleItinerary(
            id: "t_pack",
            title: "Pack",
            meta: "",
            routeSummary: "Beijing",
            estimatedBudget: "$0",
            days: [
                mockAttractionDay(dayIndex: 1, cityId: "beijing", count: 1),
                packedDay,
                mockAttractionDay(dayIndex: 3, cityId: "beijing", count: 0),
            ]
        )
        let normalized = PlanItineraryNormalizer.normalize(
            trip,
            selectedCityIds: ["beijing"],
            catalogById: catalogById,
            pace: .standard
        )
        let kept = normalized.days.first(where: { $0.dayIndex == 2 })?.activities.count ?? 0
        let ok = kept == 3
        print(ok ? "✓ duration-based packing keeps three short sights on one day" : "✗ expected 3 short sights on day 2, got \(kept)")
        return ok ? 0 : 1
    }

    private static func testFullDaySightBlocksSecond() -> Int {
        let fullDay = mockAttraction(id: "fc", cityId: "beijing", name: "Forbidden City", displayOrder: 0, duration: "full day")
        let halfDay = mockAttraction(id: "tm", cityId: "beijing", name: "Temple", displayOrder: 1, duration: "half day")
        let catalog = [fullDay, halfDay]
        let catalogById = Dictionary(uniqueKeysWithValues: catalog.map { ($0.id, $0) })

        let trip = SampleItinerary(
            id: "t_full",
            title: "Full",
            meta: "",
            routeSummary: "Beijing",
            estimatedBudget: "$0",
            days: [
                mockAttractionDay(dayIndex: 1, cityId: "beijing", count: 1),
                ItineraryDay(
                    id: "day_2",
                    dayIndex: 2,
                    dateLabel: "Day 2",
                    cityName: "Beijing",
                    costEstimate: nil,
                    activities: catalog.map { row in
                        ItineraryActivity(
                            id: "a_\(row.id)",
                            name: row.name,
                            detail: "Explore",
                            attractionId: row.id,
                            cityId: row.cityId,
                            hasAudio: false
                        )
                    }
                ),
                mockAttractionDay(dayIndex: 3, cityId: "beijing", count: 0),
            ]
        )
        let normalized = PlanItineraryNormalizer.normalize(
            trip,
            selectedCityIds: ["beijing"],
            catalogById: catalogById,
            pace: .standard
        )

        var fail = 0
        for day in normalized.days where !day.isExperienceSuggestions {
            let capacity = PlanItinerarySlotBudget.daytimeCapacity(
                dayIndex: day.dayIndex,
                days: normalized.days,
                pace: .standard
            )
            let used = PlanItinerarySlotBudget.usedDaytimeSlots(activities: day.activities, catalogById: catalogById)
            if used > capacity {
                print("✗ full-day block: day \(day.dayIndex) exceeds slot budget (\(used) > \(capacity))")
                fail += 1
            }
        }
        let day2 = normalized.days.first(where: { $0.dayIndex == 2 })
        let day2Ids = Set(day2?.activities.compactMap(\.attractionId) ?? [])
        if day2Ids.contains("fc"), day2Ids.contains("tm") {
            print("✗ full-day block: both sights should not fit on the same full day")
            fail += 1
        }
        let totalActs = normalized.days.flatMap(\.activities).filter { $0.attractionId == "tm" || $0.attractionId == "fc" }.count
        if totalActs < 2 {
            print("✗ full-day block: expected both sights preserved across days, got \(totalActs)")
            fail += 1
        }
        print(fail == 0 ? "✓ full-day sight blocks second on same day" : "")
        return fail
    }

    private static func testChineseDurationParsing() -> Int {
        let cases: [(String, Double)] = [
            ("建议游玩2小时", 0.5),
            ("3小时", 0.5),
            ("半天", 1),
            ("全天游览", 2),
        ]
        var fail = 0
        for (text, expected) in cases {
            let slots = PlanItineraryDuration.parseDurationSlots(text)
            if slots != expected {
                print("✗ Chinese duration '\(text)': expected \(expected) slots, got \(slots)")
                fail += 1
            }
        }
        print(fail == 0 ? "✓ Chinese duration strings parse to slots" : "")
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

    private static func mockAttraction(
        id: String,
        cityId: String,
        name: String,
        displayOrder: Int,
        duration: String? = nil
    ) -> Attraction {
        let durationField = duration.map { ",\"recommendedDuration\":\"\($0)\"" } ?? ""
        let json = """
        {"id":"\(id)","cityId":"\(cityId)","name":"\(name)","displayOrder":\(displayOrder)\(durationField)}
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

    private static func testAfternoonArrivalFillsFirstDay() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let trip = PlanItineraryAssembler.build(
            cities: ["beijing"],
            tripDays: 2,
            attractions: [museum],
            arrivalTime: "15:00"
        )
        guard let first = trip.days.first else {
            print("✗ afternoon arrival fill: missing first day")
            return 1
        }
        let ok = first.isExperienceSuggestions && !first.experienceItems.isEmpty
        print(ok ? "✓ afternoon arrival fills blank first day" : "✗ first day should show arrival experience card")
        return ok ? 0 : 1
    }

    private static func testGeoRepairSplitsIncompatibleSameDay() -> Int {
        let beijing = mockAttraction(id: "bj1", cityId: "beijing", name: "Forbidden City", displayOrder: 0)
        let chengdu = mockAttraction(id: "cd1", cityId: "chengdu", name: "Panda Base", displayOrder: 0)
        let catalogById = [beijing.id: beijing, chengdu.id: chengdu]
        var adjustments: [String] = []
        let geo = PlanItineraryGeoRepair.apply(
            assignments: [1: ["bj1", "cd1"]],
            catalogById: catalogById,
            adjustments: &adjustments
        )
        let day1Cities = Set((geo.assignments[1] ?? []).compactMap { catalogById[$0]?.cityId })
        let ok = !day1Cities.contains("beijing") || !day1Cities.contains("chengdu")
        print(ok ? "✓ geo repair splits incompatible same-day cities" : "✗ geo repair should split beijing+chengdu")
        return ok ? 0 : 1
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
