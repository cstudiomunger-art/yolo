import Foundation

struct PrepChecklistContext: Equatable {
    let countryCode: String
    let activeItinerary: SampleItinerary?

    var hasSavedItinerary: Bool { activeItinerary != nil }

    var itineraryCityIds: [String] {
        guard let trip = activeItinerary else { return [] }
        return SampleItinerary.orderedCityIds(from: trip)
    }
}

struct PrepChecklistSection: Identifiable {
    let id: String
    let title: String
    let items: [ChecklistItem]
}

struct PrepChecklistResult {
    let entryItems: [ChecklistItem]
    let universalItems: [ChecklistItem]
    let citySections: [PrepChecklistSection]
    let showsCityPlaceholder: Bool

    var allItems: [ChecklistItem] {
        entryItems + universalItems + citySections.flatMap(\.items)
    }

    var displaySections: [PrepChecklistSection] {
        var sections: [PrepChecklistSection] = []
        if !entryItems.isEmpty {
            sections.append(PrepChecklistSection(id: "entry", title: "Entry Requirements", items: entryItems))
        }
        if !universalItems.isEmpty {
            sections.append(PrepChecklistSection(id: "universal", title: "Essential Prep", items: universalItems))
        }
        sections.append(contentsOf: citySections)
        return sections
    }
}

enum PrepProgressMetrics {
    static func processedCount(
        items: [ChecklistItem],
        status: (ChecklistItem) -> ChecklistItemStatus
    ) -> Int {
        items.filter {
            let s = status($0)
            return s == .done || s == .skipped
        }.count
    }

    static func isComplete(items: [ChecklistItem], status: (ChecklistItem) -> ChecklistItemStatus) -> Bool {
        !items.isEmpty && processedCount(items: items, status: status) == items.count
    }
}

enum PrepChecklistAssembler {
    static func assemble(
        allItems: [ChecklistItem],
        context: PrepChecklistContext,
        cities: [City]
    ) -> PrepChecklistResult {
        let entry = allItems
            .filter { $0.type == .entry && $0.matchesEntry(countryCode: context.countryCode) }
            .sorted { $0.sortOrder < $1.sortOrder }

        let universal = allItems
            .filter { $0.type == .universal }
            .sorted { $0.sortOrder < $1.sortOrder }

        let showsCityPlaceholder = !context.hasSavedItinerary
        var citySections: [PrepChecklistSection] = []

        if context.hasSavedItinerary {
            let cityItems = allItems
                .filter { $0.type == .city && $0.matchesCity(cityIds: context.itineraryCityIds) }
                .sorted { $0.sortOrder < $1.sortOrder }

            let cityNameById = Dictionary(uniqueKeysWithValues: cities.map { ($0.id, $0.name) })
            var grouped: [String: [ChecklistItem]] = [:]
            for item in cityItems {
                let key = primaryCityId(for: item, itineraryCityIds: context.itineraryCityIds) ?? "other"
                grouped[key, default: []].append(item)
            }

            for cityId in context.itineraryCityIds {
                guard let items = grouped[cityId], !items.isEmpty else { continue }
                let name = cityNameById[cityId] ?? items.first?.groupTitle ?? cityId.capitalized
                citySections.append(PrepChecklistSection(id: "city-\(cityId)", title: name, items: items))
            }
            for (cityId, items) in grouped where !context.itineraryCityIds.contains(cityId) && cityId != "other" {
                let name = cityNameById[cityId] ?? items.first?.groupTitle ?? cityId.capitalized
                citySections.append(PrepChecklistSection(id: "city-\(cityId)", title: name, items: items))
            }
            if let other = grouped["other"], !other.isEmpty {
                citySections.append(PrepChecklistSection(id: "city-other", title: "City Specific", items: other))
            }
        }

        return PrepChecklistResult(
            entryItems: entry,
            universalItems: universal,
            citySections: citySections,
            showsCityPlaceholder: showsCityPlaceholder
        )
    }

    private static func primaryCityId(for item: ChecklistItem, itineraryCityIds: [String]) -> String? {
        if !item.targetCities.isEmpty {
            for cid in itineraryCityIds where item.targetCities.contains(cid) { return cid }
            return item.targetCities.first
        }
        if let cityId = item.cityId { return cityId }
        return nil
    }
}

extension SampleItinerary {
    /// City IDs in first-seen order from day activities (matches trip planning flow).
    static func orderedCityIds(from trip: SampleItinerary) -> [String] {
        var seen = Set<String>()
        var ordered: [String] = []
        for day in trip.days {
            for act in day.activities {
                guard let cid = act.cityId, !cid.isEmpty, !seen.contains(cid) else { continue }
                seen.insert(cid)
                ordered.append(cid)
            }
            if let exp = day.experienceCityId, !exp.isEmpty, !seen.contains(exp) {
                seen.insert(exp)
                ordered.append(exp)
            }
        }
        if !ordered.isEmpty { return ordered }
        return trip.routeSummary
            .split(separator: "·")
            .map { $0.trimmingCharacters(in: .whitespaces).lowercased().replacingOccurrences(of: " ", with: "_") }
            .filter { !$0.isEmpty }
    }
}

extension ChecklistItem {
    func matchesEntry(countryCode: String) -> Bool {
        if targetNationalities.isEmpty { return true }
        guard !countryCode.isEmpty else { return false }
        return targetNationalities.contains(countryCode)
    }

    func matchesCity(cityIds: [String]) -> Bool {
        guard !cityIds.isEmpty else { return false }
        if !targetCities.isEmpty {
            return !Set(targetCities).isDisjoint(with: cityIds)
        }
        if let cityId { return cityIds.contains(cityId) }
        return false
    }

    /// Legacy repository filter — nationality only applies to entry items.
    func matchesFilter(cityIds: [String], countryCode: String) -> Bool {
        switch type {
        case .entry:
            return matchesEntry(countryCode: countryCode)
        case .universal:
            return true
        case .city:
            return matchesCity(cityIds: cityIds)
        }
    }

}

enum ChecklistItemStatus: String, Codable, Hashable {
    case pending
    case done
    case skipped
}

struct ChecklistStatusEntry: Codable, Hashable {
    let status: ChecklistItemStatus
    let type: ChecklistItemType
}
