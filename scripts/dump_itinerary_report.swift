import Foundation

/// Full itinerary dump for manual review (screenshot regression scenario).
@main
enum DumpItineraryReport {
    static func main() {
        print("========== SCENARIO A: 6-city screenshot-like (13 activity days, relaxed) ==========\n")
        dumpScenario(
            cities: ["beijing", "shanghai", "nanjing", "chongqing", "chengdu", "hangzhou"],
            tripDays: 13,
            entry: "beijing",
            exit: "hangzhou",
            pace: .relaxed,
            arrivalTime: nil,
            perCity: 6,
            calendarStart: "2026-07-03"
        )

        print("\n========== SCENARIO B: 6-city 15-day Beijing→Guangzhou (parity vector) ==========\n")
        dumpScenario(
            cities: ["beijing", "nanjing", "suzhou", "hangzhou", "shanghai", "guangzhou"],
            tripDays: 15,
            entry: "beijing",
            exit: "guangzhou",
            pace: .standard,
            arrivalTime: nil,
            perCity: 5,
            calendarStart: "2026-07-03"
        )

        print("\n========== SCENARIO C: Chongqing→Chengdu short hop (5 days) ==========\n")
        dumpScenario(
            cities: ["chongqing", "chengdu"],
            tripDays: 5,
            entry: "chongqing",
            exit: "chengdu",
            pace: .standard,
            arrivalTime: nil,
            perCity: 8,
            calendarStart: "2026-07-03",
            namedSpots: [
                "chongqing": ["Liziba", "Hongyadong", "Ciqikou", "Three Gorges Museum", "Jiefangbei", "Dazu", "Wulong", "Hotpot Street"],
                "chengdu": ["Panda Base", "Jinli", "Wuhou Shrine", "Du Fu Cottage", "Kuanzhai Alley", "Leshan", "Mount Qingcheng", "Tianfu Square"],
            ]
        )

        print("\n========== SCENARIO D: User-like 6 cities × 15 days (relaxed auto-pace) ==========\n")
        let userCities = ["beijing", "shanghai", "chengdu", "chongqing", "hangzhou", "guangzhou"]
        dumpScenario(
            cities: userCities,
            tripDays: 15,
            entry: "beijing",
            exit: "guangzhou",
            pace: TripPace.defaultPace(tripDays: 15, cityCount: userCities.count),
            arrivalTime: "14:00",
            perCity: 8,
            calendarStart: "2026-07-03",
            namedSpots: [
                "beijing": ["Forbidden City", "Temple of Heaven", "Summer Palace", "Great Wall", "Hutong", "798 Art", "Lama Temple", "Tiananmen"],
                "shanghai": ["The Bund", "Yu Garden", "French Concession", "Pudong", "Nanjing Road", "Xujiahui", "Disney", "Zhujiajiao"],
                "chengdu": ["Panda Base", "Jinli", "Wuhou Shrine", "Du Fu Cottage", "Kuanzhai Alley", "Leshan", "Qingcheng", "Tianfu"],
                "chongqing": ["Liziba", "Hongyadong", "Ciqikou", "Three Gorges Museum", "Jiefangbei", "Dazu", "Wulong", "Hotpot"],
                "hangzhou": ["West Lake", "Lingyin Temple", "Longjing Tea", "Xixi Wetland", "Hefang Street", "Six Harmonies", "Qiantang", "Song City"],
                "guangzhou": ["Canton Tower", "Chen Clan", "Shamian", "Baiyun Mountain", "Yuexiu Park", "Beijing Road", "Chimelong", "Pearl River"],
            ]
        )
    }

    private static func dumpScenario(
        cities: [String],
        tripDays: Int,
        entry: String,
        exit: String,
        pace: TripPace,
        arrivalTime: String?,
        perCity: Int,
        calendarStart: String,
        namedSpots: [String: [String]]? = nil
    ) {
        let attractions = buildCatalog(cities: cities, perCity: perCity, namedSpots: namedSpots)
        let trip = PlanItineraryAssembler.build(
            cities: cities,
            tripDays: tripDays,
            attractions: attractions,
            pace: pace,
            arrivalTime: arrivalTime,
            entryCityId: entry,
            exitCityId: exit
        )

        let cityNames = Dictionary(uniqueKeysWithValues: cities.map {
            ($0, CityTravelHints.displayName(for: $0))
        })
        let catalogById = Dictionary(uniqueKeysWithValues: attractions.map { ($0.id, $0) })
        let dateLabels = activityDateLabels(start: calendarStart, count: tripDays)

        print("Title: \(trip.title)")
        print("Route: \(trip.routeSummary)")
        print("Visit order: \((trip.visitOrder ?? []).joined(separator: " → "))")
        print("Pace: \(pace.rawValue) · Activity days: \(tripDays)")
        if let adj = trip.schedulingAdjustments, !adj.isEmpty {
            print("Scheduling adjustments:")
            for a in adj { print("  · \(a)") }
        }
        if let dropped = trip.droppedAttractionIds, !dropped.isEmpty {
            print("Dropped attractions: \(dropped.count) — \(dropped.joined(separator: ", "))")
        }
        print("")

        for (index, day) in trip.days.enumerated() {
            let cal = index < dateLabels.count ? dateLabels[index] : "Day \(day.dayIndex)"
            let header = CityTravelHints.daySectionCityLabel(
                day: day,
                cityNameById: cityNames,
                attractionCache: catalogById
            )
            var tags: [String] = []
            if day.isExperienceSuggestions { tags.append("Flexible") }
            if day.intercityHop != nil { tags.append("Intercity") }
            if day.activities.isEmpty && !day.isExperienceSuggestions && day.intercityHop == nil {
                tags.append("Empty")
            }
            let tagStr = tags.isEmpty ? "" : " [\(tags.joined(separator: ", "))]"

            print("── \(cal) (day \(day.dayIndex)) ── \(header)\(tagStr)")
            if let hop = day.intercityHop {
                let from = cityNames[hop.fromCityId] ?? hop.fromCityId
                let to = cityNames[hop.toCityId] ?? hop.toCityId
                print("   🚄 \(from) → \(to) (~\(hop.travelHours)h)")
                for item in hop.items.prefix(3) {
                    print("      · \(item)")
                }
            }
            if day.activities.isEmpty {
                print("   (no activities)")
            } else {
                for act in day.activities {
                    let city = act.cityId.flatMap { cityNames[$0] } ?? act.cityId ?? "?"
                    let slot = act.timeSlot.isEmpty ? "" : " · \(act.timeSlot)"
                    print("   · \(act.name) (\(city))\(slot)")
                }
            }
            print("")
        }
    }

    private static func buildCatalog(
        cities: [String],
        perCity: Int,
        namedSpots: [String: [String]]?
    ) -> [Attraction] {
        var rows: [Attraction] = []
        for city in cities {
            let names = namedSpots?[city] ?? (0..<perCity).map { "\(city.capitalized) Spot \($0)" }
            for (i, name) in names.prefix(perCity).enumerated() {
                let json = """
                {"id":"\(city)_\(i)","cityId":"\(city)","name":"\(name)","displayOrder":\(i),"recommendedDuration":"2-3 hours"}
                """
                rows.append(try! JSONDecoder().decode(Attraction.self, from: Data(json.utf8)))
            }
        }
        return rows
    }

    private static func activityDateLabels(start: String, count: Int) -> [String] {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.timeZone = TimeZone(identifier: "Asia/Shanghai")
        guard let arrival = fmt.date(from: start) else {
            return (1...count).map { "Day \($0)" }
        }
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = fmt.timeZone!
        let outFmt = DateFormatter()
        outFmt.dateFormat = "M/d"
        outFmt.timeZone = fmt.timeZone
        return (0..<count).compactMap { offset in
            guard let d = cal.date(byAdding: .day, value: offset + 1, to: arrival) else { return nil }
            return outFmt.string(from: d)
        }
    }
}
