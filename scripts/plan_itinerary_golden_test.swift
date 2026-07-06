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
//     YOLO/Features/Plan/PlanItineraryAttractionLedger.swift \
//     YOLO/Features/Plan/PlanItineraryEventDayPlanner.swift \
//     YOLO/Features/Plan/PlanItineraryIntercityReplanner.swift \
//     YOLO/Features/Plan/PlanItineraryEndpointReplanner.swift \
//     YOLO/Features/Plan/PlanItineraryCityDays.swift \
//     YOLO/Features/Plan/PlanItineraryPickAttractions.swift \
//     YOLO/Features/Plan/PlanItineraryGeoRepair.swift \
//     YOLO/Features/Plan/PlanItineraryDayFill.swift \
//     YOLO/Features/Plan/PlanItineraryIntercityAnnotator.swift \
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
        fails += testNormalizePreservesTravelDayIntercityHop()
        fails += testInferTripPaceDistinguishesTravelLite()
        fails += testNormalizePreservesSchedulerMetadata()
        fails += testDurationBasedPacking()
        fails += testFullDaySightBlocksSecond()
        fails += testChineseDurationParsing()
        fails += testGeoRepairSplitsIncompatibleSameDay()
        fails += testAfternoonArrivalFillsFirstDay()
        fails += testOnlyFirstTripDayGetsArrivalCard()
        fails += testGeoRepairStripsWrongCityDay()
        fails += testLateDaysOnlyUseTimelineCity()
        fails += testCustomEntryExitVisitOrder()
        fails += testCustomEntryExitFiveCityShanghaiBeijing()
        fails += testIntenseHopDayForNearbyCities()
        fails += testStandardTravelLiteHasIntercityHop()
        fails += testSixCitySeventeenDayLinearRoute()
        fails += testSixCityFifteenDayBeijingEntry()
        fails += testHopSafeNormalizePreservesTravelHop()
        fails += testIntenseLongLegUsesTravelDayNotHop()
        fails += testHopDayGeoRepairKeepsBothCities()
        fails += testTravelDayHasIntercityHopMetadata()
        fails += testHopDayAfternoonArrivalStripsMorning()
        fails += testHopDayEveningArrivalKeepsEveningOnly()
        fails += testArrivalReplanOverflowRelocates()
        fails += testClearArrivalTimeRestoresSnapshot()
        fails += testNormalizePreservesIntenseHopDayDualCities()
        fails += testTravelDayEveningArrivalReplans()
        fails += testTravelDayArrivalReplanNoDuplicateAcrossDays()
        fails += testNilInternationalArrivalFullDayEntry()
        fails += testInternationalArrival1400TrimsEntryDay()
        fails += testInternationalDeparture1000TrimsLastDay()
        fails += testEndpointReplannerNoDuplicateAcrossDays()
        fails += testEndpointClearArrivalRestoresFromBaseline()
        fails += testDepartureThenArrivalChainsReplans()
        fails += testSameDayEntryExitCombinedReplan()
        fails += testEntryReplanPullsSightsFromLaterSameCityDay()
        fails += testExitReplanKeepsMorningSightsForAfternoonDeparture()
        fails += testCalendarBookendArrivalPreservesFirstActivityDay()
        fails += testCalendarBookendDeparturePreservesLastActivityDay()
        fails += testCalendarBookendManualActivitiesStayInMetadata()
        fails += testAttractionLedgerEnforceUnique()
        fails += testIntercityHopBackfillDoesNotBorrowLaterDay()
        fails += testAfternoonInternationalArrivalEventDayIndependent()
        fails += testEntryCityMinDaysOnLongTrip()
        fails += testSuggestEntryExitTwoAndSixCities()
        fails += testChongqingChengduShortHop()
        fails += testRelaxedShortHopAfternoonSight()
        fails += testBlankDayExitCity()
        fails += testShortHopNoStealPrevDay()
        fails += testHopDayHeaderRouteLabel()
        fails += testFullTravelDayRouteLabel()
        fails += testRuleBasedEnrichAnnotatesHopAfterNormalize()
        fails += testSixCityFourteenDayCityDayBalance()
        fails += testChengduShortHopHasPureSightseeingDay()

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
        let ok = first.activities.contains { $0.attractionId == "night_street" && $0.timeSlot == "Evening" }
        print(ok ? "✓ afternoon arrival: evening-only sight still schedules on first activity day" : "✗ evening-only sight missing on first activity day")
        return ok ? 0 : 1
    }

    private static func testNormalizePreservesTravelDayIntercityHop() -> Int {
        let hop = ItineraryIntercityHop(
            fromCityId: "beijing",
            toCityId: "shanghai",
            travelHours: 5.5,
            items: CityTravelHints.buildTravelDayContent(fromCityId: "beijing", toCityId: "shanghai", hours: 5.5)
        )
        let travelDay = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Shanghai",
            costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: hop.items,
            experienceCityId: "shanghai",
            intercityHop: hop
        )
        let trip = SampleItinerary(
            id: "t_hop_meta",
            title: "Test",
            meta: "Test",
            routeSummary: "Beijing → Shanghai",
            estimatedBudget: "$0",
            days: [mockAttractionDay(dayIndex: 1, cityId: "beijing", count: 1), travelDay],
            visitOrder: ["beijing", "shanghai"]
        )
        let normalized = PlanItineraryNormalizer.normalize(
            trip,
            selectedCityIds: ["beijing", "shanghai"],
            catalogById: [:],
            pace: .standard
        )
        let day = normalized.days.first { $0.dayIndex == 2 }
        let ok = day?.intercityHop?.fromCityId == "beijing"
            && day?.intercityHop?.toCityId == "shanghai"
            && day?.isExperienceSuggestions == true
        print(ok ? "✓ normalize preserves travel day intercity_hop" : "✗ normalize dropped travel day intercity_hop")
        return ok ? 0 : 1
    }

    private static func testInferTripPaceDistinguishesTravelLite() -> Int {
        let hop = ItineraryIntercityHop(
            fromCityId: "beijing",
            toCityId: "nanjing",
            travelHours: 4,
            items: []
        )
        let travelLiteDay = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing → Nanjing",
            costEstimate: nil,
            activities: [
                ItineraryActivity(
                    id: "nj1",
                    timeSlot: "Afternoon",
                    name: "Wall",
                    detail: "",
                    attractionId: "nj1",
                    cityId: "nanjing",
                    hasAudio: false
                )
            ],
            experienceCityId: "nanjing",
            intercityHop: hop
        )
        let pace = PlanItinerarySlotBudget.inferTripPace(from: [travelLiteDay])
        let ok = pace == .standard
        print(ok ? "✓ travel-lite day infers standard pace" : "✗ travel-lite should not infer intense pace")
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
            experienceItems: CityTravelHints.buildTravelDayContent(
                fromCityId: "beijing",
                toCityId: "shanghai",
                hours: 5.5
            ),
            experienceCityId: "shanghai",
            intercityHop: ItineraryIntercityHop(
                fromCityId: "beijing",
                toCityId: "shanghai",
                travelHours: 5.5,
                items: CityTravelHints.buildTravelDayContent(
                    fromCityId: "beijing",
                    toCityId: "shanghai",
                    hours: 5.5
                )
            )
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
        if travel.intercityHop?.fromCityId != "beijing" || travel.intercityHop?.toCityId != "shanghai" {
            print("✗ normalize metadata: travel day intercity_hop not preserved")
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
        duration: String? = nil,
        visitPeriod: String? = nil
    ) -> Attraction {
        let durationField = duration.map { ",\"recommendedDuration\":\"\($0)\"" } ?? ""
        let periodField = visitPeriod.map { ",\"recommended_visit_period\":\"\($0)\"" } ?? ""
        let json = """
        {"id":"\(id)","cityId":"\(cityId)","name":"\(name)","displayOrder":\(displayOrder)\(durationField)\(periodField)}
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
        guard !trip.days.isEmpty else {
            print("✗ afternoon arrival: missing first day")
            return 1
        }
        // Phase 4: 15:00 arrival → first day has no daytime budget; museum schedules on day 2.
        let museumLater = trip.days.contains { day in
            day.dayIndex > 1 && day.activities.contains { $0.attractionId == "museum" }
        }
        let ok = museumLater
        print(ok ? "✓ afternoon arrival: museum schedules after first day" : "✗ museum should move to day 2 after afternoon arrival")
        return ok ? 0 : 1
    }

    private static func testOnlyFirstTripDayGetsArrivalCard() -> Int {
        let beijing = mockAttraction(id: "bj1", cityId: "beijing", name: "Palace", displayOrder: 0)
        let hangzhou = mockAttraction(id: "hz1", cityId: "hangzhou", name: "Lake", displayOrder: 0)
        let trip = PlanItineraryAssembler.build(
            cities: ["beijing", "hangzhou"],
            tripDays: 3,
            attractions: [beijing, hangzhou],
            arrivalTime: "15:00",
            applyNormalizer: false
        )
        var filled = PlanItineraryDayFill.fillEmptyDays(
            trip.days,
            visitOrder: trip.visitOrder ?? ["beijing", "hangzhou"],
            arrivalTime: "15:00",
            activityDaysExcludeCalendarEndpoints: false
        )
        // Simulate day 1 already an arrival experience card (day 2 still blank).
        if let idx = filled.firstIndex(where: { $0.dayIndex == 1 }) {
            filled[idx] = ItineraryDay(
                id: filled[idx].id,
                dayIndex: 1,
                dateLabel: filled[idx].dateLabel,
                cityName: "Beijing",
                costEstimate: nil,
                activities: [],
                dayKind: .experienceSuggestions,
                experienceItems: CityTravelHints.arrivalAfternoonExperienceItems(cityId: "beijing"),
                experienceCityId: "beijing"
            )
        }
        guard let day2 = filled.first(where: { $0.dayIndex == 2 }) else {
            print("✗ arrival card scope: missing day 2")
            return 1
        }
        let arrivalLine = day2.experienceItems.first ?? ""
        let ok = !arrivalLine.contains("Afternoon arrival")
        print(ok ? "✓ only trip day 1 may use arrival card template" : "✗ day 2 wrongly shows afternoon arrival card")
        return ok ? 0 : 1
    }

    private static func testGeoRepairStripsWrongCityDay() -> Int {
        let beijing = mockAttraction(id: "bj1", cityId: "beijing", name: "Palace", displayOrder: 0)
        let shanghai = mockAttraction(id: "sh1", cityId: "shanghai", name: "Garden", displayOrder: 0)
        let catalogById = [beijing.id: beijing, shanghai.id: shanghai]
        var adjustments: [String] = []
        let geo = PlanItineraryGeoRepair.apply(
            assignments: [2: ["bj1"]],
            catalogById: catalogById,
            allowedCitiesByDay: [2: ["shanghai"]],
            adjustments: &adjustments
        )
        let ok = !(geo.assignments[2] ?? []).contains("bj1")
        print(ok ? "✓ geo repair strips wrong-city sights from a day" : "✗ beijing sight should not remain on shanghai day")
        return ok ? 0 : 1
    }

    private static func testLateDaysOnlyUseTimelineCity() -> Int {
        let cities = ["beijing", "shanghai"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions
        )
        guard let shanghaiStart = trip.days.firstIndex(where: { day in
            day.experienceCityId == "shanghai" || day.activities.contains { $0.cityId == "shanghai" }
        }) else {
            print("✗ timeline city: no shanghai segment found")
            return 1
        }
        var fail = 0
        for day in trip.days.dropFirst(shanghaiStart) where !day.isExperienceSuggestions {
            let expected = day.experienceCityId ?? "shanghai"
            for act in day.activities {
                guard let cid = act.cityId else { continue }
                if cid != expected {
                    print("✗ day \(day.dayIndex): found \(cid) during \(expected) segment")
                    fail += 1
                }
            }
        }
        print(fail == 0 ? "✓ post-arrival days only keep that city's sights" : "")
        return fail
    }

    private static func testCustomEntryExitVisitOrder() -> Int {
        let cities = ["beijing", "shanghai"]
        let attractions = mockCatalog(cities: cities, perCity: 5)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions,
            entryCityId: "shanghai",
            exitCityId: "beijing"
        )
        let order = trip.visitOrder ?? []
        let ok = order.first == "shanghai" && order.last == "beijing"
        print(ok ? "✓ custom landing/return cities anchor visit order" : "✗ visit order should start shanghai and end beijing, got \(order)")
        return ok ? 0 : 1
    }

    private static func testCustomEntryExitFiveCityShanghaiBeijing() -> Int {
        let cities = ["chongqing", "chengdu", "shanghai", "hangzhou", "beijing"]
        let attractions = mockCatalog(cities: cities, perCity: 5)
        let customOrder = CityTravelHints.visitOrder(
            cityIds: cities,
            cities: [],
            entryCityId: "shanghai",
            exitCityId: "beijing"
        )
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 14,
            attractions: attractions,
            entryCityId: "shanghai",
            exitCityId: "beijing"
        )
        let order = trip.visitOrder ?? []
        let ok = order.first == "shanghai"
            && order.last == "beijing"
            && customOrder.first == "shanghai"
            && customOrder.last == "beijing"
        print(ok ? "✓ 5-city custom shanghai/beijing endpoints anchor visit order" : "✗ 5-city custom endpoints wrong: \(order)")
        return ok ? 0 : 1
    }

    private static func testIntenseHopDayForNearbyCities() -> Int {
        let cities = ["shanghai", "nanjing"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            pace: .intense,
            entryCityId: "shanghai",
            exitCityId: "nanjing"
        )
        guard let hopDay = trip.days.first(where: { $0.intercityHop != nil }) else {
            print("✗ intense shanghai→nanjing should produce an intercity hop day")
            return 1
        }
        let citiesOnDay = Set(hopDay.activities.compactMap(\.cityId))
        let ok = citiesOnDay.contains("shanghai") && citiesOnDay.contains("nanjing")
            && hopDay.intercityHop?.fromCityId == "shanghai"
            && hopDay.intercityHop?.toCityId == "nanjing"
        print(ok ? "✓ intense pace creates hop day for ≤4h city pair" : "✗ hop day should include both shanghai and nanjing sights")
        return ok ? 0 : 1
    }

    private static func testStandardTravelLiteHasIntercityHop() -> Int {
        let cities = ["beijing", "nanjing"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            pace: .standard,
            entryCityId: "beijing",
            exitCityId: "nanjing"
        )
        let travelLite = trip.days.first {
            !$0.isExperienceSuggestions && $0.intercityHop != nil
        }
        let ok = travelLite != nil
            && travelLite?.intercityHop?.fromCityId == "beijing"
            && travelLite?.intercityHop?.toCityId == "nanjing"
        print(ok ? "✓ standard 2-4h leg uses travel-lite intercity card" : "✗ standard should show travel-lite hop card")
        return ok ? 0 : 1
    }

    private static func testSixCitySeventeenDayLinearRoute() -> Int {
        let cities = ["beijing", "nanjing", "suzhou", "hangzhou", "shanghai", "guangzhou"]
        let avgDays: [String: Int] = [
            "beijing": 3, "nanjing": 2, "suzhou": 2,
            "hangzhou": 2, "shanghai": 3, "guangzhou": 2,
        ]
        let attractions = mockCatalog(cities: cities, perCity: 5)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 17,
            attractions: attractions,
            pace: .standard,
            entryCityId: "beijing",
            exitCityId: "guangzhou",
            avgDaysByCity: avgDays
        )
        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })
        var fail = 0
        if trip.days.count != 17 {
            print("✗ 6-city 17-day: expected 17 days, got \(trip.days.count)")
            fail += 1
        }

        let order = trip.visitOrder ?? []
        if order.first != "beijing" {
            print("✗ 6-city 17-day: visit order should start at beijing, got \(order.first ?? "nil")")
            fail += 1
        }
        if order.last != "guangzhou" {
            print("✗ 6-city 17-day: visit order should end at guangzhou, got \(order.last ?? "nil")")
            fail += 1
        }
        if Set(order).count != order.count {
            print("✗ 6-city 17-day: visit order repeats cities (yo-yo)")
            fail += 1
        }

        let calibration = PlanItineraryCityDays.calibrateCityDays(
            visitOrder: order.isEmpty ? cities : order,
            aiWeights: nil,
            catalogByCity: Dictionary(grouping: attractions, by: { $0.cityId.lowercased() }),
            tripDays: 17,
            pace: .standard,
            avgDaysByCity: avgDays
        )
        let cityDaySum = calibration.cityDays.values.reduce(0, +)
        if cityDaySum + calibration.reservedTravelDays > 17 {
            print("✗ 6-city 17-day: city days \(cityDaySum) + travel \(calibration.reservedTravelDays) exceeds 17")
            fail += 1
        }

        for day in trip.days where !day.isExperienceSuggestions {
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
                print("✗ 6-city 17-day: day \(day.dayIndex) exceeds slot budget")
                fail += 1
            }
        }

        let intercityDays = trip.days.filter { $0.intercityHop != nil }
        if intercityDays.isEmpty {
            print("✗ 6-city 17-day: should include intercity hop/travel cards")
            fail += 1
        }

        if fail == 0 {
            print("✓ 6-city 17-day linear route with intercity cards")
        }
        return fail
    }

    private static func testSixCityFifteenDayBeijingEntry() -> Int {
        let cities = ["beijing", "nanjing", "suzhou", "hangzhou", "shanghai", "guangzhou"]
        let attractions = mockCatalog(cities: cities, perCity: 5)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 15,
            attractions: attractions,
            pace: .standard,
            entryCityId: "beijing",
            exitCityId: "guangzhou"
        )
        var fail = 0
        if trip.days.count != 15 {
            print("✗ 6-city 15-day: expected 15 days, got \(trip.days.count)")
            fail += 1
        }
        let order = trip.visitOrder ?? []
        if order.first != "beijing" {
            print("✗ 6-city 15-day: visit order should start at beijing")
            fail += 1
        }
        if order.last != "guangzhou" {
            print("✗ 6-city 15-day: visit order should end at guangzhou")
            fail += 1
        }
        if trip.days.filter({ $0.intercityHop != nil }).isEmpty {
            print("✗ 6-city 15-day: should include intercity hop/travel cards")
            fail += 1
        }
        if fail == 0 {
            print("✓ 6-city 15-day beijing entry linear route")
        }
        return fail
    }

    private static func testHopSafeNormalizePreservesTravelHop() -> Int {
        let hop = ItineraryIntercityHop(
            fromCityId: "beijing",
            toCityId: "nanjing",
            travelHours: 3.5,
            items: ["Train to Nanjing"]
        )
        let day = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing → Nanjing",
            costEstimate: nil,
            activities: [
                mockActivity(id: "bj_1", cityId: "beijing", name: "Morning"),
                mockActivity(id: "nj_1", cityId: "nanjing", name: "Afternoon"),
            ],
            intercityHop: hop
        )
        let trip = SampleItinerary(
            id: "t_hop_safe",
            title: "Test",
            meta: "",
            routeSummary: "Beijing → Nanjing",
            estimatedBudget: "",
            days: [day],
            visitOrder: ["beijing", "nanjing"]
        )
        let normalized = PlanItineraryNormalizer.hopSafeNormalize(
            trip,
            selectedCityIds: ["beijing", "nanjing"],
            pace: .intense
        )
        let ok = normalized.days.first?.intercityHop?.fromCityId == "beijing"
            && Set(normalized.days.first?.activities.compactMap(\.cityId) ?? []).count >= 1
        print(ok ? "✓ hopSafeNormalize preserves intercity hop" : "✗ hopSafeNormalize dropped hop metadata")
        return ok ? 0 : 1
    }

    private static func testIntenseLongLegUsesTravelDayNotHop() -> Int {
        let cities = ["beijing", "shanghai"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions,
            pace: .intense,
            entryCityId: "beijing",
            exitCityId: "shanghai"
        )
        let hasHop = trip.days.contains { !$0.isExperienceSuggestions && $0.intercityHop != nil }
        let hasTravel = trip.days.contains {
            $0.isExperienceSuggestions &&
            $0.intercityHop != nil
        }
        let ok = hasTravel && !hasHop
        print(ok ? "✓ intense >4h leg still uses dedicated travel day" : "✗ beijing→shanghai should not hop same day")
        return ok ? 0 : 1
    }

    private static func testHopDayGeoRepairKeepsBothCities() -> Int {
        let sh = mockAttraction(id: "sh1", cityId: "shanghai", name: "Bund", displayOrder: 0)
        let nj = mockAttraction(id: "nj1", cityId: "nanjing", name: "Wall", displayOrder: 0)
        let catalogById = [sh.id: sh, nj.id: nj]
        var adjustments: [String] = []
        let geo = PlanItineraryGeoRepair.apply(
            assignments: [2: ["sh1", "nj1"]],
            catalogById: catalogById,
            allowedCitiesByDay: [2: ["shanghai", "nanjing"]],
            adjustments: &adjustments
        )
        let onDay = Set((geo.assignments[2] ?? []).compactMap { catalogById[$0]?.cityId })
        let ok = onDay.contains("shanghai") && onDay.contains("nanjing")
        print(ok ? "✓ geo repair keeps both cities on hop day" : "✗ hop day geo repair stripped a valid city")
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
            allowedCitiesByDay: [1: ["beijing"]],
            adjustments: &adjustments
        )
        let day1Cities = Set((geo.assignments[1] ?? []).compactMap { catalogById[$0]?.cityId })
        let ok = !day1Cities.contains("beijing") || !day1Cities.contains("chengdu")
        print(ok ? "✓ geo repair splits incompatible same-day cities" : "✗ geo repair should split beijing+chengdu")
        return ok ? 0 : 1
    }

    private static func testTravelDayHasIntercityHopMetadata() -> Int {
        let cities = ["beijing", "shanghai"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions,
            pace: .intense,
            entryCityId: "beijing",
            exitCityId: "shanghai"
        )
        let travelDay = trip.days.first {
            $0.isExperienceSuggestions && $0.intercityHop != nil
        }
        let ok = travelDay != nil
            && travelDay?.intercityHop?.fromCityId == "beijing"
            && travelDay?.intercityHop?.toCityId == "shanghai"
        print(ok ? "✓ travel day carries intercity_hop metadata" : "✗ travel day missing intercity_hop")
        return ok ? 0 : 1
    }

    private static func testHopDayAfternoonArrivalStripsMorning() -> Int {
        let sh = mockAttraction(id: "sh1", cityId: "shanghai", name: "Bund", displayOrder: 0)
        let nj = mockAttraction(id: "nj1", cityId: "nanjing", name: "Wall", displayOrder: 1)
        let hop = ItineraryIntercityHop(
            fromCityId: "shanghai",
            toCityId: "nanjing",
            travelHours: 1.5,
            items: ["Travel"]
        )
        let day = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Shanghai → Nanjing",
            costEstimate: nil,
            activities: [
                mockActivity(id: "sh1", cityId: "shanghai", name: "Bund AM"),
                mockActivity(id: "nj1", cityId: "nanjing", name: "Wall PM"),
            ],
            intercityHop: hop
        )
        let (newDays, _) = PlanItineraryIntercityReplanner.replan(
            days: [day],
            dayIndex: 2,
            arrivalTime: "15:00",
            options: .init(pace: .intense, catalogById: [sh.id: sh, nj.id: nj])
        )
        let updated = newDays[0]
        let hasShanghai = updated.activities.contains { $0.cityId == "shanghai" }
        let ok = !hasShanghai && updated.activities.contains { $0.cityId == "nanjing" }
        print(ok ? "✓ 15:00 arrival strips morning origin sights" : "✗ afternoon arrival should drop shanghai morning")
        return ok ? 0 : 1
    }

    private static func testHopDayEveningArrivalKeepsEveningOnly() -> Int {
        let sh = mockAttraction(id: "sh1", cityId: "shanghai", name: "Bund", displayOrder: 0, visitPeriod: "evening")
        let nj = mockAttraction(id: "nj1", cityId: "nanjing", name: "Wall", displayOrder: 1)
        let eve = mockAttraction(id: "nj2", cityId: "nanjing", name: "Night market", displayOrder: 2, visitPeriod: "evening")
        let hop = ItineraryIntercityHop(
            fromCityId: "shanghai",
            toCityId: "nanjing",
            travelHours: 1.5,
            items: ["Travel"]
        )
        let day = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Shanghai → Nanjing",
            costEstimate: nil,
            activities: [
                mockActivity(id: "sh1", cityId: "shanghai", name: "Bund Eve"),
                mockActivity(id: "nj1", cityId: "nanjing", name: "Wall PM"),
                mockActivity(id: "nj2", cityId: "nanjing", name: "Night market"),
            ],
            intercityHop: hop
        )
        let (newDays, _) = PlanItineraryIntercityReplanner.replan(
            days: [day],
            dayIndex: 2,
            arrivalTime: "18:00",
            options: .init(pace: .intense, catalogById: [sh.id: sh, nj.id: nj, eve.id: eve])
        )
        let updated = newDays[0]
        let ok = !updated.activities.contains { $0.cityId == "shanghai" }
            && updated.activities.contains { $0.name == "Night market" }
        print(ok ? "✓ 18:00 arrival keeps evening-only sights" : "✗ evening arrival replan wrong")
        return ok ? 0 : 1
    }

    private static func testArrivalReplanOverflowRelocates() -> Int {
        let nj1 = mockAttraction(id: "nj1", cityId: "nanjing", name: "Wall", displayOrder: 0)
        let nj2 = mockAttraction(id: "nj2", cityId: "nanjing", name: "Museum", displayOrder: 1)
        let nj3 = mockAttraction(id: "nj3", cityId: "nanjing", name: "Temple", displayOrder: 2)
        let hop = ItineraryIntercityHop(
            fromCityId: "shanghai",
            toCityId: "nanjing",
            travelHours: 1.5,
            items: ["Travel"]
        )
        let hopDay = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Hop",
            costEstimate: nil,
            activities: [
                mockActivity(id: "nj1", cityId: "nanjing", name: "Wall"),
                mockActivity(id: "nj2", cityId: "nanjing", name: "Museum"),
                mockActivity(id: "nj3", cityId: "nanjing", name: "Temple"),
            ],
            intercityHop: hop
        )
        let nextDay = ItineraryDay(
            id: "day_3",
            dayIndex: 3,
            dateLabel: "Day 3",
            cityName: "Nanjing",
            costEstimate: nil,
            activities: []
        )
        let (newDays, adj) = PlanItineraryIntercityReplanner.replan(
            days: [hopDay, nextDay],
            dayIndex: 2,
            arrivalTime: "16:00",
            options: .init(pace: .standard, catalogById: [nj1.id: nj1, nj2.id: nj2, nj3.id: nj3])
        )
        let day3Acts = newDays[1].activities.count
        let ok = day3Acts > 0 && adj.contains { $0.localizedCaseInsensitiveContains("Moved") }
        print(ok ? "✓ overflow sights relocate to next day" : "✗ late arrival should overflow to day 3")
        return ok ? 0 : 1
    }

    private static func testClearArrivalTimeRestoresSnapshot() -> Int {
        // UI layer restores snapshot; replanner with nil is no-op on hop without prior replan
        let hop = ItineraryIntercityHop(
            fromCityId: "shanghai",
            toCityId: "nanjing",
            travelHours: 1.5,
            items: ["Travel"],
            arrivalTimeAtDestination: "15:00"
        )
        let day = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Hop",
            costEstimate: nil,
            activities: [mockActivity(id: "a1", cityId: "nanjing", name: "Wall")],
            intercityHop: hop
        )
        let (newDays, _) = PlanItineraryIntercityReplanner.replan(
            days: [day],
            dayIndex: 2,
            arrivalTime: nil,
            options: .init(pace: .standard, catalogById: [:])
        )
        let ok = newDays[0].intercityHop?.arrivalTimeAtDestination == nil
        print(ok ? "✓ clearing arrival time removes stored arrival" : "✗ nil arrival should clear hop arrival time")
        return ok ? 0 : 1
    }

    private static func testNormalizePreservesIntenseHopDayDualCities() -> Int {
        let cities = ["shanghai", "nanjing"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            pace: .intense,
            entryCityId: "shanghai",
            exitCityId: "nanjing"
        )
        let normalized = PlanItineraryNormalizer.hopSafeNormalize(
            trip,
            selectedCityIds: cities,
            catalogById: catalogById,
            pace: .intense
        )
        guard let hopDay = normalized.days.first(where: { $0.intercityHop != nil && !$0.isExperienceSuggestions }) else {
            print("✗ intense shanghai→nanjing should have a hop day before normalize")
            return 1
        }
        let onDay = Set(hopDay.activities.compactMap(\.cityId))
        let ok = onDay.contains("shanghai") && onDay.contains("nanjing")
        print(ok ? "✓ hopSafeNormalize keeps both cities on 4h hop day" : "✗ hopSafeNormalize stripped valid hop-day cities")
        return ok ? 0 : 1
    }

    private static func testTravelDayEveningArrivalReplans() -> Int {
        let eve = mockAttraction(id: "sh1", cityId: "shanghai", name: "Bund night", displayOrder: 0, visitPeriod: "evening")
        let museum = mockAttraction(id: "sh2", cityId: "shanghai", name: "Museum", displayOrder: 1)
        let hop = ItineraryIntercityHop(
            fromCityId: "beijing",
            toCityId: "shanghai",
            travelHours: 5.5,
            items: ["Travel"]
        )
        let travelDay = ItineraryDay(
            id: "day_3",
            dayIndex: 3,
            dateLabel: "Day 3",
            cityName: "Shanghai",
            costEstimate: nil,
            activities: [
                mockActivity(id: "sh2", cityId: "shanghai", name: "Museum"),
                mockActivity(id: "sh1", cityId: "shanghai", name: "Bund night"),
            ],
            dayKind: .experienceSuggestions,
            experienceItems: ["Travel from Beijing to Shanghai"],
            experienceCityId: "shanghai",
            intercityHop: hop
        )
        let (newDays, _) = PlanItineraryIntercityReplanner.replan(
            days: [travelDay],
            dayIndex: 3,
            arrivalTime: "19:00",
            options: .init(pace: .standard, catalogById: [eve.id: eve, museum.id: museum])
        )
        let updated = newDays[0]
        let ok = updated.activities.count == 1
            && updated.activities.first?.attractionId == "sh1"
        print(ok ? "✓ travel day 19:00 keeps evening-only activity" : "✗ travel evening replan wrong")
        return ok ? 0 : 1
    }

    private static func testTravelDayArrivalReplanNoDuplicateAcrossDays() -> Int {
        let temple = mockAttraction(id: "bj_temple", cityId: "beijing", name: "Temple of Heaven", displayOrder: 0)
        let summer = mockAttraction(id: "bj_summer", cityId: "beijing", name: "Summer Palace", displayOrder: 1)
        let forbidden = mockAttraction(id: "bj_forbidden", cityId: "beijing", name: "Forbidden City", displayOrder: 2)
        let catalog = [temple.id: temple, summer.id: summer, forbidden.id: forbidden]
        let hop = ItineraryIntercityHop(
            fromCityId: "hangzhou",
            toCityId: "beijing",
            travelHours: 5,
            items: ["Travel from Hangzhou to Beijing"]
        )
        let travelDay = ItineraryDay(
            id: "day_1",
            dayIndex: 1,
            dateLabel: "Day 1",
            cityName: "Hangzhou → Beijing",
            costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: ["Travel from Hangzhou to Beijing"],
            experienceCityId: "beijing",
            intercityHop: hop
        )
        let nextDay = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [mockActivity(id: "bj_temple", cityId: "beijing", name: "Temple of Heaven")]
        )
        let (newDays, _) = PlanItineraryIntercityReplanner.replan(
            days: [travelDay, nextDay],
            dayIndex: 1,
            arrivalTime: "12:01",
            options: .init(pace: .standard, catalogById: catalog)
        )
        let allIds = newDays.flatMap { $0.activities.compactMap(\.attractionId) }
        let uniqueIds = Set(allIds)
        let travelActs = newDays[0].activities.compactMap(\.attractionId)
        let nextActs = newDays[1].activities.compactMap(\.attractionId)
        let noDup = allIds.count == uniqueIds.count
        let travelSkipsTemple = !travelActs.contains("bj_temple")
        let nextKeepsTemple = nextActs.contains("bj_temple")
        let travelBackfilled = !travelActs.isEmpty
        let ok = noDup && travelSkipsTemple && nextKeepsTemple && travelBackfilled
        print(ok ? "✓ travel day replan skips sights already on later days" : "✗ travel day replan duplicated sights across days")
        return ok ? 0 : 1
    }

    private static func testNilInternationalArrivalFullDayEntry() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let trip = PlanItineraryAssembler.build(
            cities: ["beijing"],
            tripDays: 2,
            attractions: [museum, temple],
            arrivalTime: nil
        )
        guard let firstDay = trip.days.first else {
            print("✗ nil international arrival: missing first day")
            return 1
        }
        let capacity = PlanItinerarySlotBudget.daytimeCapacity(
            dayIndex: firstDay.dayIndex,
            days: trip.days,
            pace: .standard,
            arrivalTime: nil,
            departureTime: nil
        )
        let catalog = [museum.id: museum, temple.id: temple]
        let used = PlanItinerarySlotBudget.usedDaytimeSlots(activities: firstDay.activities, catalogById: catalog)
        let ok = capacity >= 2 && used >= 1
        print(ok ? "✓ nil international arrival keeps full entry-day capacity" : "✗ entry day should schedule sights without landing time")
        return ok ? 0 : 1
    }

    private static func testInternationalArrival1400TrimsEntryDay() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let summer = mockAttraction(id: "summer", cityId: "beijing", name: "Summer Palace", displayOrder: 2)
        let catalog = [museum.id: museum, temple.id: temple, summer.id: summer]
        let day1 = ItineraryDay(
            id: "day_1",
            dayIndex: 1,
            dateLabel: "Day 1",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [
                mockActivity(id: "museum", cityId: "beijing", name: "Museum"),
                mockActivity(id: "temple", cityId: "beijing", name: "Temple"),
            ]
        )
        let day2 = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [mockActivity(id: "summer", cityId: "beijing", name: "Summer Palace")]
        )
        let (newDays, _) = PlanItineraryEndpointReplanner.replanArrival(
            days: [day1, day2],
            entryCityId: "beijing",
            arrivalTime: "14:00",
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false)
        )
        let entryDay = newDays[0]
        let daytimeActs = entryDay.activities.filter { $0.timeSlot != "Evening" }
        let ok = daytimeActs.isEmpty
        print(ok ? "✓ 14:00 international arrival trims entry-day daytime sights" : "✗ entry day should lose daytime sights after 14:00 landing (kept \(daytimeActs.count))")
        return ok ? 0 : 1
    }

    private static func testInternationalDeparture1000TrimsLastDay() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let summer = mockAttraction(id: "summer", cityId: "beijing", name: "Summer Palace", displayOrder: 2)
        let catalog = [museum.id: museum, temple.id: temple, summer.id: summer]
        let day1 = ItineraryDay(
            id: "day_1",
            dayIndex: 1,
            dateLabel: "Day 1",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [mockActivity(id: "museum", cityId: "beijing", name: "Museum")]
        )
        let day2 = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [
                mockActivity(id: "temple", cityId: "beijing", name: "Temple"),
                mockActivity(id: "summer", cityId: "beijing", name: "Summer Palace"),
            ]
        )
        let (newDays, _) = PlanItineraryEndpointReplanner.replanDeparture(
            days: [day1, day2],
            exitCityId: "beijing",
            departureTime: "10:00",
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false)
        )
        let exitDay = newDays[1]
        let fullCap = PlanItineraryPace.daySlotCapacity(profile: .fullDay, pace: .standard)
        let depCap = PlanItineraryPace.daySlotCapacity(profile: .departureDay, pace: .standard)
        let used = PlanItinerarySlotBudget.usedDaytimeSlots(activities: exitDay.activities, catalogById: catalog)
        let ok = depCap < fullCap && used <= depCap
        print(ok ? "✓ 10:00 international departure trims exit-day capacity" : "✗ exit day should fit departure-day budget after 10:00 flight")
        return ok ? 0 : 1
    }

    private static func testEndpointReplannerNoDuplicateAcrossDays() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let summer = mockAttraction(id: "summer", cityId: "beijing", name: "Summer Palace", displayOrder: 2)
        let catalog = [museum.id: museum, temple.id: temple, summer.id: summer]
        let day1 = ItineraryDay(
            id: "day_1",
            dayIndex: 1,
            dateLabel: "Day 1",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [
                mockActivity(id: "museum", cityId: "beijing", name: "Museum"),
                mockActivity(id: "temple", cityId: "beijing", name: "Temple"),
            ]
        )
        let day2 = ItineraryDay(
            id: "day_2",
            dayIndex: 2,
            dateLabel: "Day 2",
            cityName: "Beijing",
            costEstimate: nil,
            activities: [mockActivity(id: "summer", cityId: "beijing", name: "Summer Palace")]
        )
        let (newDays, _) = PlanItineraryEndpointReplanner.replanArrival(
            days: [day1, day2],
            entryCityId: "beijing",
            arrivalTime: "14:00",
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false)
        )
        let allIds = newDays.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = allIds.count == Set(allIds).count
        print(ok ? "✓ endpoint replan avoids duplicate sights across days" : "✗ endpoint replan duplicated attraction ids")
        return ok ? 0 : 1
    }

    private static func testEndpointClearArrivalRestoresFromBaseline() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let summer = mockAttraction(id: "summer", cityId: "beijing", name: "Summer Palace", displayOrder: 2)
        let catalog = [museum.id: museum, temple.id: temple, summer.id: summer]
        let baseline = [
            ItineraryDay(
                id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Beijing", costEstimate: nil,
                activities: [
                    mockActivity(id: "museum", cityId: "beijing", name: "Museum"),
                    mockActivity(id: "temple", cityId: "beijing", name: "Temple"),
                ]
            ),
            ItineraryDay(
                id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Beijing", costEstimate: nil,
                activities: [mockActivity(id: "summer", cityId: "beijing", name: "Summer Palace")]
            ),
        ]
        let options = PlanItineraryEndpointReplanner.Options(
            pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false
        )
        let trimmed = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "beijing",
            exitCityId: "beijing",
            arrivalTime: "14:00",
            departureTime: nil,
            options: options
        )
        let trimmedDaytime = trimmed.days[0].activities.filter { $0.timeSlot != "Evening" }
        let restored = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "beijing",
            exitCityId: "beijing",
            arrivalTime: nil,
            departureTime: nil,
            options: options
        )
        let baselineEntryIds = baseline[0].activities.compactMap(\.attractionId)
        let restoredEntryIds = restored.days[0].activities.compactMap(\.attractionId)
        let ok = trimmedDaytime.isEmpty
            && restoredEntryIds == baselineEntryIds
        print(ok ? "✓ clearing international arrival restores baseline schedule" : "✗ baseline restore after clearing arrival failed (trimmed=\(trimmedDaytime.count) restored=\(restoredEntryIds))")
        return ok ? 0 : 1
    }

    private static func testDepartureThenArrivalChainsReplans() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let summer = mockAttraction(id: "summer", cityId: "beijing", name: "Summer Palace", displayOrder: 2)
        let catalog = [museum.id: museum, temple.id: temple, summer.id: summer]
        let baseline = [
            ItineraryDay(
                id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Beijing", costEstimate: nil,
                activities: [],
                dayKind: .experienceSuggestions,
                experienceItems: CityTravelHints.internationalArrivalPlaceholder(cityId: "beijing"),
                experienceCityId: "beijing"
            ),
            ItineraryDay(
                id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Beijing", costEstimate: nil,
                activities: [
                    mockActivity(id: "museum", cityId: "beijing", name: "Museum"),
                    mockActivity(id: "temple", cityId: "beijing", name: "Temple"),
                    mockActivity(id: "summer", cityId: "beijing", name: "Summer Palace"),
                ],
                experienceCityId: "beijing"
            ),
        ]
        let options = PlanItineraryEndpointReplanner.Options(
            pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false
        )
        let exitTrimmed = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "beijing",
            exitCityId: "beijing",
            arrivalTime: nil,
            departureTime: "10:00",
            options: options
        )
        let chained = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "beijing",
            exitCityId: "beijing",
            arrivalTime: "14:00",
            departureTime: "10:00",
            options: options
        )
        let exitIds = { (days: [ItineraryDay]) in days[1].activities.compactMap(\.attractionId) }
        let eventDaytime = chained.days[0].activities.filter { $0.timeSlot != "Evening" }
        let allIds = chained.days.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = eventDaytime.isEmpty
            && allIds.count == Set(allIds).count
            && exitIds(chained.days) == exitIds(exitTrimmed.days)
        print(ok ? "✓ departure-then-arrival chain trims event day and preserves exit departure trim" : "✗ chained replan should keep event day daytime empty and exit trim stable (event=\(chained.days[0].activities.map(\.name)) exit=\(exitIds(chained.days)))")
        return ok ? 0 : 1
    }

    private static func testSameDayEntryExitCombinedReplan() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let summer = mockAttraction(id: "summer", cityId: "beijing", name: "Summer Palace", displayOrder: 2)
        let catalog = [museum.id: museum, temple.id: temple, summer.id: summer]
        let baseline = [
            ItineraryDay(
                id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Beijing", costEstimate: nil,
                activities: [
                    mockActivity(id: "museum", cityId: "beijing", name: "Museum"),
                    mockActivity(id: "temple", cityId: "beijing", name: "Temple"),
                    mockActivity(id: "summer", cityId: "beijing", name: "Summer Palace", timeSlot: "Evening"),
                ]
            ),
        ]
        let options = PlanItineraryEndpointReplanner.Options(
            pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false
        )
        let result = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "beijing",
            exitCityId: "beijing",
            arrivalTime: "14:00",
            departureTime: "10:00",
            options: options
        )
        let daytimeActs = result.days[0].activities.filter { $0.timeSlot != "Evening" }
        let ok = daytimeActs.isEmpty
        print(ok ? "✓ same-day entry/exit uses combined capacity (no daytime sights)" : "✗ same-day endpoint should trim all daytime sights")
        return ok ? 0 : 1
    }

    private static func testEntryReplanPullsSightsFromLaterSameCityDay() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "chongqing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "chongqing", name: "Temple", displayOrder: 1)
        let catalog = [museum.id: museum, temple.id: temple]
        let day1 = ItineraryDay(
            id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Chongqing", costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: CityTravelHints.flexibleRestDayItems(cityId: "chongqing"),
            experienceCityId: "chongqing"
        )
        let day2 = ItineraryDay(
            id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Chongqing", costEstimate: nil,
            activities: [
                mockActivity(id: "museum", cityId: "chongqing", name: "Museum"),
                mockActivity(id: "temple", cityId: "chongqing", name: "Temple"),
            ]
        )
        let result = PlanItineraryEndpointReplanner.replan(
            days: [day1, day2],
            entryCityId: "chongqing",
            exitCityId: "chongqing",
            arrivalTime: "08:00",
            departureTime: nil,
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["chongqing"], activityDaysExcludeCalendarEndpoints: false)
        )
        let entryActs = Set(result.days[0].activities.compactMap(\.attractionId))
        let day2Acts = Set(result.days[1].activities.compactMap(\.attractionId))
        let allIds = result.days.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = allIds.count == Set(allIds).count
            && day2Acts == Set(["museum", "temple"])
            && entryActs.isDisjoint(with: day2Acts)
        print(ok ? "✓ arrival event day plans independently without stealing from sightseeing day" : "✗ arrival event day should not duplicate or steal day-2 sights (entry=\(entryActs) day2=\(day2Acts))")
        return ok ? 0 : 1
    }

    private static func testExitReplanKeepsMorningSightsForAfternoonDeparture() -> Int {
        let museum = mockAttraction(id: "museum", cityId: "beijing", name: "Museum", displayOrder: 0)
        let temple = mockAttraction(id: "temple", cityId: "beijing", name: "Temple", displayOrder: 1)
        let catalog = [museum.id: museum, temple.id: temple]
        let day1 = ItineraryDay(
            id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Beijing", costEstimate: nil,
            activities: [mockActivity(id: "museum", cityId: "beijing", name: "Museum")]
        )
        let day2 = ItineraryDay(
            id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Beijing", costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: CityTravelHints.flexibleRestDayItems(cityId: "beijing"),
            experienceCityId: "beijing"
        )
        let result = PlanItineraryEndpointReplanner.replan(
            days: [day1, day2],
            entryCityId: "beijing",
            exitCityId: "beijing",
            arrivalTime: nil,
            departureTime: "19:00",
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["beijing"], activityDaysExcludeCalendarEndpoints: false)
        )
        let exitDaytime = result.days[1].activities.filter { $0.timeSlot != "Evening" }
        let day1Ids = result.days[0].activities.compactMap(\.attractionId)
        let allIds = result.days.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = exitDaytime.isEmpty
            && day1Ids == ["museum"]
            && allIds.count == Set(allIds).count
        print(ok ? "✓ exit day replan does not steal sights from earlier days" : "✗ exit day should not pull museum from day 1 (exit=\(exitDaytime.map(\.name)))")
        return ok ? 0 : 1
    }

    private static func testFullTripSnapshotRestoreAfterOverflow() -> Int {
        let nj1 = mockAttraction(id: "nj1", cityId: "nanjing", name: "Wall", displayOrder: 0)
        let nj2 = mockAttraction(id: "nj2", cityId: "nanjing", name: "Museum", displayOrder: 1)
        let nj3 = mockAttraction(id: "nj3", cityId: "nanjing", name: "Temple", displayOrder: 2)
        let hop = ItineraryIntercityHop(fromCityId: "shanghai", toCityId: "nanjing", travelHours: 1.5, items: ["Travel"])
        let hopDay = ItineraryDay(
            id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Hop", costEstimate: nil,
            activities: [
                mockActivity(id: "nj1", cityId: "nanjing", name: "Wall"),
                mockActivity(id: "nj2", cityId: "nanjing", name: "Museum"),
                mockActivity(id: "nj3", cityId: "nanjing", name: "Temple"),
            ],
            intercityHop: hop
        )
        let nextDay = ItineraryDay(
            id: "day_3", dayIndex: 3, dateLabel: "Day 3", cityName: "Nanjing", costEstimate: nil, activities: []
        )
        let snapshot = [hopDay, nextDay]
        let (replanned, _) = PlanItineraryIntercityReplanner.replan(
            days: snapshot,
            dayIndex: 2,
            arrivalTime: "16:00",
            options: .init(pace: .standard, catalogById: [nj1.id: nj1, nj2.id: nj2, nj3.id: nj3])
        )
        let overflowed = replanned[1].activities.count > 0
        let restored = snapshot
        let ok = overflowed && restored[1].activities.isEmpty && restored[0].activities.count == 3
        print(ok ? "✓ full-trip snapshot can undo overflow replan" : "✗ snapshot restore should revert overflow")
        return ok ? 0 : 1
    }

    private static func testCalendarBookendArrivalPreservesFirstActivityDay() -> Int {
        let hongya = mockAttraction(id: "hongya", cityId: "chongqing", name: "Hongya Cave", displayOrder: 0)
        let jiefang = mockAttraction(id: "jiefang", cityId: "chongqing", name: "Jiefangbei", displayOrder: 1)
        let catalog = [hongya.id: hongya, jiefang.id: jiefang]
        let baseline = [
            ItineraryDay(
                id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Chongqing", costEstimate: nil,
                activities: [
                    mockActivity(id: "hongya", cityId: "chongqing", name: "Hongya Cave"),
                    mockActivity(id: "jiefang", cityId: "chongqing", name: "Jiefangbei"),
                ]
            ),
        ]
        let baselineIds = baseline[0].activities.compactMap(\.attractionId)
        let result = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "chongqing",
            exitCityId: "beijing",
            arrivalTime: "16:17",
            departureTime: nil,
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["chongqing", "beijing"])
        )
        let afterIds = result.days[0].activities.compactMap(\.attractionId)
        let ok = afterIds == baselineIds
        print(ok ? "✓ calendar bookend arrival time leaves first activity day unchanged" : "✗ arrival switch should not trim day 1 sights (baseline=\(baselineIds) after=\(afterIds))")
        return ok ? 0 : 1
    }

    private static func testCalendarBookendDeparturePreservesLastActivityDay() -> Int {
        let palace = mockAttraction(id: "gugong", cityId: "beijing", name: "Forbidden City", displayOrder: 0)
        let temple = mockAttraction(id: "tiantan", cityId: "beijing", name: "Temple of Heaven", displayOrder: 1)
        let catalog = [palace.id: palace, temple.id: temple]
        let baseline = [
            ItineraryDay(
                id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Beijing", costEstimate: nil,
                activities: [mockActivity(id: "tiantan", cityId: "beijing", name: "Temple of Heaven")]
            ),
            ItineraryDay(
                id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Beijing", costEstimate: nil,
                activities: [mockActivity(id: "gugong", cityId: "beijing", name: "Forbidden City")]
            ),
        ]
        let baselineIds = baseline[1].activities.compactMap(\.attractionId)
        let result = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: "chongqing",
            exitCityId: "beijing",
            arrivalTime: nil,
            departureTime: "06:19",
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["chongqing", "beijing"])
        )
        let afterIds = result.days[1].activities.compactMap(\.attractionId)
        let ok = afterIds == baselineIds
        print(ok ? "✓ calendar bookend departure time leaves last activity day unchanged" : "✗ departure switch should not trim exit day sights (baseline=\(baselineIds) after=\(afterIds))")
        return ok ? 0 : 1
    }

    private static func testCalendarBookendManualActivitiesStayInMetadata() -> Int {
        let baseline = [
            ItineraryDay(
                id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Chongqing", costEstimate: nil,
                activities: [mockActivity(id: "hongya", cityId: "chongqing", name: "Hongya Cave")]
            ),
        ]
        let manual = [mockActivity(id: "guanyin", cityId: "chongqing", name: "Guanyinqiao")]
        let trip = SampleItinerary(
            id: "t1", title: "Test", meta: "", routeSummary: "cq", estimatedBudget: "", days: baseline,
            internationalArrivalTime: "16:17",
            internationalArrivalActivities: manual
        )
        let dayIds = trip.days[0].activities.compactMap(\.attractionId)
        let bookendIds = trip.internationalArrivalActivities?.compactMap(\.attractionId) ?? []
        let ok = dayIds == ["hongya"] && bookendIds == ["guanyin"]
        print(ok ? "✓ bookend manual sights live in metadata without touching activity days" : "✗ manual bookend add should not change days (days=\(dayIds) bookend=\(bookendIds))")
        return ok ? 0 : 1
    }

    private static func testAttractionLedgerEnforceUnique() -> Int {
        let act1 = ItineraryActivity(
            id: "a1", timeSlot: "Morning", name: "A", detail: "", attractionId: "s1", cityId: "beijing", hasAudio: false
        )
        let act2 = ItineraryActivity(
            id: "a2", timeSlot: "Afternoon", name: "B", detail: "", attractionId: "s1", cityId: "beijing", hasAudio: false
        )
        let days = [
            ItineraryDay(id: "d1", dayIndex: 1, dateLabel: "Day 1", cityName: "", costEstimate: nil, activities: [act1]),
            ItineraryDay(id: "d2", dayIndex: 2, dateLabel: "Day 2", cityName: "", costEstimate: nil, activities: [act2]),
        ]
        let (deduped, _) = PlanItineraryAttractionLedger.enforceUnique(days)
        let allIds = deduped.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = allIds == ["s1"]
        print(ok ? "✓ attraction ledger keeps one sight per id trip-wide" : "✗ enforceUnique should drop duplicate attraction ids")
        return ok ? 0 : 1
    }

    private static func testIntercityHopBackfillDoesNotBorrowLaterDay() -> Int {
        let wenshu = mockAttraction(id: "wenshu", cityId: "chengdu", name: "Wenshu", displayOrder: 0)
        let wuhou = mockAttraction(id: "wuhou", cityId: "chengdu", name: "Wuhou", displayOrder: 1)
        let jiefang = mockAttraction(id: "jiefang", cityId: "chongqing", name: "Jiefangbei", displayOrder: 0)
        let catalog = [wenshu.id: wenshu, wuhou.id: wuhou, jiefang.id: jiefang]
        let hop = ItineraryIntercityHop(
            fromCityId: "chongqing",
            toCityId: "chengdu",
            travelHours: 1.5,
            items: ["Travel"]
        )
        let hopDay = ItineraryDay(
            id: "day_10", dayIndex: 10, dateLabel: "Day 10", cityName: "Chongqing → Chengdu", costEstimate: nil,
            activities: [],
            intercityHop: hop
        )
        let sightDay = ItineraryDay(
            id: "day_11", dayIndex: 11, dateLabel: "Day 11", cityName: "Chengdu", costEstimate: nil,
            activities: [
                mockActivity(id: "wuhou", cityId: "chengdu", name: "Wuhou"),
                mockActivity(id: "wenshu", cityId: "chengdu", name: "Wenshu"),
            ],
            experienceCityId: "chengdu"
        )
        let (replanned, _) = PlanItineraryIntercityReplanner.replan(
            days: [hopDay, sightDay],
            dayIndex: 10,
            arrivalTime: "03:46",
            options: .init(pace: .standard, catalogById: catalog)
        )
        let hopIds = replanned[0].activities.compactMap(\.attractionId)
        let day11Ids = replanned[1].activities.compactMap(\.attractionId)
        let allIds = replanned.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = allIds.count == Set(allIds).count
            && day11Ids == ["wuhou", "wenshu"]
            && !hopIds.contains("wenshu")
        print(ok ? "✓ early hop arrival backfills from catalog without borrowing day 11" : "✗ hop day duplicated or stole wenshu (hop=\(hopIds) day11=\(day11Ids))")
        return ok ? 0 : 1
    }

    private static func testAfternoonInternationalArrivalEventDayIndependent() -> Int {
        let hongya = mockAttraction(id: "hongya", cityId: "chongqing", name: "Hongya Cave", displayOrder: 0, visitPeriod: "evening")
        let jiefang = mockAttraction(id: "jiefang", cityId: "chongqing", name: "Jiefangbei", displayOrder: 1)
        let guanyin = mockAttraction(id: "guanyin", cityId: "chongqing", name: "Guanyinqiao", displayOrder: 2)
        let catalog = [hongya.id: hongya, jiefang.id: jiefang, guanyin.id: guanyin]
        let day1 = ItineraryDay(
            id: "day_1", dayIndex: 1, dateLabel: "Day 1", cityName: "Chongqing", costEstimate: nil,
            activities: [],
            dayKind: .experienceSuggestions,
            experienceItems: CityTravelHints.internationalArrivalPlaceholder(cityId: "chongqing"),
            experienceCityId: "chongqing"
        )
        let day2 = ItineraryDay(
            id: "day_2", dayIndex: 2, dateLabel: "Day 2", cityName: "Chongqing", costEstimate: nil,
            activities: [
                mockActivity(id: "hongya", cityId: "chongqing", name: "Hongya Cave", timeSlot: "Evening"),
                mockActivity(id: "jiefang", cityId: "chongqing", name: "Jiefangbei"),
                mockActivity(id: "guanyin", cityId: "chongqing", name: "Guanyinqiao"),
            ],
            experienceCityId: "chongqing"
        )
        let result = PlanItineraryEndpointReplanner.replan(
            days: [day1, day2],
            entryCityId: "chongqing",
            exitCityId: "chongqing",
            arrivalTime: "15:45",
            departureTime: nil,
            options: .init(pace: .standard, catalogById: catalog, visitOrder: ["chongqing"])
        )
        let eventDaytime = result.days[0].activities.filter { $0.timeSlot != "Evening" }
        let eventIds = Set(result.days[0].activities.compactMap(\.attractionId))
        let sightIds = Set(result.days[1].activities.compactMap(\.attractionId))
        let allIds = result.days.flatMap { $0.activities.compactMap(\.attractionId) }
        let ok = eventDaytime.isEmpty
            && eventIds.count <= 1
            && sightIds == Set(["hongya", "jiefang", "guanyin"])
            && allIds.count == Set(allIds).count
            && eventIds.isDisjoint(with: sightIds)
        print(ok ? "✓ 15:45 arrival event day stays evening-only and independent from day-2 sights" : "✗ afternoon arrival should not mirror sightseeing day (event=\(eventIds) day2=\(sightIds))")
        return ok ? 0 : 1
    }

    private static func testEntryCityMinDaysOnLongTrip() -> Int {
        let cities = ["beijing", "nanjing", "suzhou", "hangzhou", "shanghai", "guangzhou"]
        let attractions = mockCatalog(cities: cities, perCity: 5)
        let catalogByCity = Dictionary(grouping: attractions, by: { $0.cityId.lowercased() })
        let calibration = PlanItineraryCityDays.calibrateCityDays(
            visitOrder: cities,
            aiWeights: nil,
            catalogByCity: catalogByCity,
            tripDays: 15,
            pace: .standard
        )
        let beijingDays = calibration.cityDays["beijing"] ?? 0
        let ok = beijingDays >= 2
        print(ok ? "✓ entry city gets min 2 days on 15-day 6-city trip" : "✗ beijing should have ≥2 city days, got \(beijingDays)")
        return ok ? 0 : 1
    }

    private static func testMergeExperienceRespectsHopDays() -> Int {
        let cities = ["beijing", "nanjing"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            pace: .standard,
            entryCityId: "beijing",
            exitCityId: "nanjing",
            applyNormalizer: false
        )
        let travelLite = trip.days.first {
            !$0.isExperienceSuggestions && $0.intercityHop != nil
        }
        let ok = travelLite != nil
            && !travelLite!.isExperienceSuggestions
            && travelLite!.intercityHop?.fromCityId == "beijing"
        print(ok ? "✓ travel-lite day is hop card not experience card" : "✗ beijing→nanjing should be travel-lite with intercity_hop")
        return ok ? 0 : 1
    }

    private static func testSuggestEntryExitTwoAndSixCities() -> Int {
        var fail = 0
        let two = CityTravelHints.suggestEntryExit(
            cityIds: ["shanghai", "nanjing"],
            cities: []
        )
        if two.entryCityId != two.visitOrder.first || two.exitCityId != two.visitOrder.last {
            print("✗ suggestEntryExit 2-city: entry/exit should match visit order ends")
            fail += 1
        }

        let sixIds = ["beijing", "nanjing", "suzhou", "hangzhou", "shanghai", "guangzhou"]
        let six = CityTravelHints.suggestEntryExit(cityIds: sixIds, cities: [])
        if Set(six.visitOrder).count != sixIds.count {
            print("✗ suggestEntryExit 6-city: visit order should be linear without repeats")
            fail += 1
        }
        if fail == 0 {
            print("✓ suggestEntryExit returns linear route endpoints")
        }
        return fail
    }

    private static func testChongqingChengduShortHop() -> Int {
        let cities = ["chongqing", "chengdu"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            entryCityId: "chongqing",
            exitCityId: "chengdu",
            applyNormalizer: false
        )
        let hop = trip.days.first {
            $0.intercityHop?.fromCityId == "chongqing" && $0.intercityHop?.toCityId == "chengdu"
        }
        let routeLabel = hop.map {
            CityTravelHints.daySectionCityLabel(
                day: $0,
                cityNameById: ["chongqing": "Chongqing", "chengdu": "Chengdu"]
            )
        } ?? ""
        let ok = hop != nil && !hop!.isExperienceSuggestions
            && routeLabel.contains("Chongqing") && routeLabel.contains("Chengdu")
        print(ok ? "✓ chongqing→chengdu short hop has intercity_hop card" : "✗ ≤2h hop missing intercity card or route label")
        return ok ? 0 : 1
    }

    private static func testRelaxedShortHopAfternoonSight() -> Int {
        let cities = ["chongqing", "chengdu"]
        let attractions = mockCatalog(cities: cities, perCity: 8)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions,
            pace: .relaxed,
            entryCityId: "chongqing",
            exitCityId: "chengdu",
            applyNormalizer: false
        )
        guard let hopDay = trip.days.first(where: {
            $0.intercityHop?.fromCityId == "chongqing" && $0.intercityHop?.toCityId == "chengdu"
        }) else {
            print("✗ relaxed short-hop: missing hop day")
            return 1
        }
        let pmChengdu = hopDay.activities.filter {
            $0.cityId == "chengdu" && $0.timeSlot != "Evening" && $0.timeSlot != "Morning"
        }
        let ok = !pmChengdu.isEmpty
        print(ok ? "✓ relaxed short_hop schedules ≥1 chengdu afternoon sight" : "✗ relaxed short_hop hop day has 0 chengdu daytime sights")
        return ok ? 0 : 1
    }

    private static func testShortHopNoStealPrevDay() -> Int {
        let cities = ["chongqing", "chengdu"]
        let attractions = mockCatalog(cities: cities, perCity: 8)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 6,
            attractions: attractions,
            entryCityId: "chongqing",
            exitCityId: "chengdu",
            applyNormalizer: false
        )
        guard let hopDay = trip.days.first(where: {
            $0.intercityHop?.fromCityId == "chongqing" && $0.intercityHop?.toCityId == "chengdu"
        }) else {
            print("✗ short-hop no-steal: missing hop day")
            return 1
        }
        let prevDays = trip.days.filter { $0.dayIndex < hopDay.dayIndex }
        let lastChongqing = prevDays.last {
            $0.activities.contains { $0.cityId == "chongqing" } || $0.experienceCityId == "chongqing"
        }
        let prevHasSight = lastChongqing?.activities.contains { $0.cityId == "chongqing" } ?? false
        let ok = prevHasSight || (lastChongqing?.activities.isEmpty == false)
        print(ok ? "✓ short_hop does not leave prior chongqing day empty" : "✗ prior chongqing day was emptied for hop AM steal")
        return ok ? 0 : 1
    }

    private static func testHopDayHeaderRouteLabel() -> Int {
        let cities = ["chongqing", "chengdu"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            entryCityId: "chongqing",
            exitCityId: "chengdu",
            applyNormalizer: false
        )
        guard let hop = trip.days.first(where: { $0.intercityHop != nil }) else {
            print("✗ hop header: no hop day")
            return 1
        }
        let label = CityTravelHints.daySectionCityLabel(
            day: hop,
            cityNameById: ["chongqing": "Chongqing", "chengdu": "Chengdu"]
        )
        let ok = label.contains("→") || (label.contains("Chongqing") && label.contains("Chengdu"))
        print(ok ? "✓ hop day section header uses route label" : "✗ hop header should be route label, got \(label)")
        return ok ? 0 : 1
    }

    private static func testFullTravelDayRouteLabel() -> Int {
        let cities = ["chengdu", "hangzhou"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            entryCityId: "chengdu",
            exitCityId: "hangzhou",
            applyNormalizer: false
        )
        guard let travelDay = trip.days.first(where: {
            $0.isExperienceSuggestions && $0.intercityHop != nil
        }) else {
            print("✗ full travel day route: no travel experience day with hop")
            return 1
        }
        let label = CityTravelHints.daySectionCityLabel(
            day: travelDay,
            cityNameById: ["chengdu": "Chengdu", "hangzhou": "Hangzhou"]
        )
        let ok = label.contains("→")
            && label.lowercased().contains("chengdu")
            && label.lowercased().contains("hangzhou")
        print(ok ? "✓ full travel day header uses route label" : "✗ full travel day header should be Chengdu → Hangzhou, got \(label)")
        return ok ? 0 : 1
    }

    private static func testRuleBasedEnrichAnnotatesHopAfterNormalize() -> Int {
        let cities = ["chongqing", "chengdu"]
        let attractions = mockCatalog(cities: cities, perCity: 6)
        let base = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 5,
            attractions: attractions,
            entryCityId: "chongqing",
            exitCityId: "chengdu",
            applyNormalizer: false
        )
        guard let originalHop = base.days.first(where: {
            $0.intercityHop?.fromCityId == "chongqing" && $0.intercityHop?.toCityId == "chengdu"
        }) else {
            print("✗ rule-based annotate: baseline missing chongqing→chengdu hop day")
            return 1
        }

        let wrongAct = mockActivity(id: "chongqing_ciqikou", cityId: "chongqing", name: "Ciqikou")
        let corruptedDays = base.days.map { day -> ItineraryDay in
            guard day.dayIndex == originalHop.dayIndex else {
                return day.withIntercityHop(nil)
            }
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: "Chengdu",
                costEstimate: day.costEstimate,
                activities: [wrongAct],
                dayKind: day.dayKind,
                experienceItems: day.experienceItems,
                experienceCityId: "chengdu",
                intercityHop: nil
            )
        }

        let corrupted = SampleItinerary(
            id: base.id,
            title: base.title,
            meta: base.meta,
            routeSummary: base.routeSummary,
            estimatedBudget: base.estimatedBudget,
            days: corruptedDays,
            visitOrder: base.visitOrder
        )
        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })
        let normalized = PlanItineraryNormalizer.hopSafeNormalize(
            corrupted,
            selectedCityIds: cities,
            catalogById: catalogById,
            pace: .standard
        )

        let hop = normalized.days.first {
            $0.intercityHop?.fromCityId == "chongqing" && $0.intercityHop?.toCityId == "chengdu"
        }
        let strayChongqingOnChengduDay = normalized.days.contains { day in
            day.intercityHop == nil
                && !day.isExperienceSuggestions
                && day.experienceCityId == "chengdu"
                && day.activities.contains { $0.cityId == "chongqing" }
        }
        let ok = hop != nil && !strayChongqingOnChengduDay
        print(ok
            ? "✓ hopSafeNormalize + annotate restores chongqing→chengdu hop after overflow"
            : "✗ normalize should re-inject intercity hop and strip wrong-city overflow")
        return ok ? 0 : 1
    }

    private static func testSixCityFourteenDayCityDayBalance() -> Int {
        let cities = ["chongqing", "chengdu", "shanghai", "suzhou", "nanjing", "beijing"]
        let attractions = mockCatalog(cities: cities, perCity: 8)
        let catalogByCity = Dictionary(grouping: attractions, by: { $0.cityId.lowercased() })
        let calibration = PlanItineraryCityDays.calibrateCityDays(
            visitOrder: cities,
            aiWeights: nil,
            catalogByCity: catalogByCity,
            tripDays: 14,
            pace: .standard
        )
        let cq = calibration.cityDays["chongqing"] ?? 0
        let cd = calibration.cityDays["chengdu"] ?? 0
        let allAtLeastTwo = cities.allSatisfy { (calibration.cityDays[$0] ?? 0) >= 2 }
        let ok = cq <= 3 && cd >= 2 && allAtLeastTwo
        print(ok
            ? "✓ 14-day 6-city balances city days (CQ≤3, CD≥2, each≥2)"
            : "✗ city day balance: chongqing=\(cq) chengdu=\(cd) map=\(calibration.cityDays)")
        return ok ? 0 : 1
    }

    private static func testChengduShortHopHasPureSightseeingDay() -> Int {
        let cities = ["chongqing", "chengdu", "shanghai", "suzhou", "nanjing", "beijing"]
        let attractions = mockCatalog(cities: cities, perCity: 8)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: 14,
            attractions: attractions,
            entryCityId: "chongqing",
            exitCityId: "beijing",
            applyNormalizer: false
        )
        let pureChengduDays = trip.days.filter { day in
            !day.isExperienceSuggestions
                && day.intercityHop == nil
                && day.activities.contains { $0.cityId == "chengdu" }
        }
        let ok = !pureChengduDays.isEmpty
        print(ok
            ? "✓ chengdu has a dedicated sightseeing day beyond short-hop transfer"
            : "✗ chengdu only has hop/travel days, no pure sightseeing day")
        return ok ? 0 : 1
    }

    private static func testBlankDayExitCity() -> Int {
        let sixIds = ["beijing", "nanjing", "suzhou", "hangzhou", "shanghai", "guangzhou"]
        let attractions = mockCatalog(cities: sixIds, perCity: 4)
        let trip = PlanItineraryAssembler.build(
            cities: sixIds,
            tripDays: 15,
            attractions: attractions,
            entryCityId: "beijing",
            exitCityId: "guangzhou",
            applyNormalizer: false
        )
        guard let last = trip.days.last else {
            print("✗ blank exit city: no last day")
            return 1
        }
        let cityId = last.experienceCityId ?? last.activities.compactMap(\.cityId).first
        let ok = cityId == "guangzhou"
        print(ok ? "✓ trailing blank day uses exit city guangzhou" : "✗ last day city should be guangzhou, got \(cityId ?? "nil")")
        return ok ? 0 : 1
    }

    private static func mockActivity(id: String, cityId: String, name: String, timeSlot: String = "Morning") -> ItineraryActivity {
        ItineraryActivity(
            id: id,
            timeSlot: timeSlot,
            name: name,
            detail: "Explore",
            attractionId: id,
            cityId: cityId,
            hasAudio: false
        )
    }
}
