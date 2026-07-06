import Foundation

struct SampleItinerary: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let meta: String
    let routeSummary: String
    let estimatedBudget: String
    let days: [ItineraryDay]
    var shareSlug: String?
    var isShared: Bool
    /// 行程首日（到达日）。新建行程写入；老行程可能为 nil（回退到 meta 解析）。
    var startDate: Date?
    /// 行程末日（离开日）。
    var endDate: Date?
    /// Canonical visit order derived from the day timeline (optional; from AI `visit_order`).
    var visitOrder: [String]?
    /// When true, skip auto-normalize / re-schedule on save (user hand-edited).
    var userEdited: Bool
    /// Attractions omitted because the trip was too tight (optional).
    var droppedAttractionIds: [String]?
    /// Human-readable scheduling fixes applied after AI draft (optional).
    var schedulingAdjustments: [String]?
    /// Non-blocking season / month hints (optional).
    var seasonHints: [String]?
    /// Trip pace used when generating (optional; for replanner parity).
    var pace: String?
    /// International landing time (HH:mm), set on Review bookend card.
    var internationalArrivalTime: String?
    /// International departure time (HH:mm), set on Review bookend card.
    var internationalDepartureTime: String?
    /// Days before any international endpoint replan (for toggle-off restore).
    var endpointScheduleBaselineDays: [ItineraryDay]?

    init(
        id: String,
        title: String,
        meta: String,
        routeSummary: String,
        estimatedBudget: String,
        days: [ItineraryDay],
        shareSlug: String? = nil,
        isShared: Bool = false,
        startDate: Date? = nil,
        endDate: Date? = nil,
        visitOrder: [String]? = nil,
        userEdited: Bool = false,
        droppedAttractionIds: [String]? = nil,
        schedulingAdjustments: [String]? = nil,
        seasonHints: [String]? = nil,
        pace: String? = nil,
        internationalArrivalTime: String? = nil,
        internationalDepartureTime: String? = nil,
        endpointScheduleBaselineDays: [ItineraryDay]? = nil
    ) {
        self.id = id
        self.title = title
        self.meta = meta
        self.routeSummary = routeSummary
        self.estimatedBudget = estimatedBudget
        self.days = days
        self.shareSlug = shareSlug
        self.isShared = isShared
        self.startDate = startDate
        self.endDate = endDate
        self.visitOrder = visitOrder
        self.userEdited = userEdited
        self.droppedAttractionIds = droppedAttractionIds
        self.schedulingAdjustments = schedulingAdjustments
        self.seasonHints = seasonHints
        self.pace = pace
        self.internationalArrivalTime = internationalArrivalTime
        self.internationalDepartureTime = internationalDepartureTime
        self.endpointScheduleBaselineDays = endpointScheduleBaselineDays
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        meta = try c.decode(String.self, forKey: .meta)
        routeSummary = try c.decode(String.self, forKey: .routeSummary)
        estimatedBudget = try c.decode(String.self, forKey: .estimatedBudget)
        days = try c.decode([ItineraryDay].self, forKey: .days)
        shareSlug = try c.decodeIfPresent(String.self, forKey: .shareSlug)
        isShared = try c.decodeIfPresent(Bool.self, forKey: .isShared) ?? false
        startDate = try c.decodeIfPresent(Date.self, forKey: .startDate)
        endDate = try c.decodeIfPresent(Date.self, forKey: .endDate)
        visitOrder = try c.decodeIfPresent([String].self, forKey: .visitOrder)
        userEdited = try c.decodeIfPresent(Bool.self, forKey: .userEdited) ?? false
        droppedAttractionIds = try c.decodeIfPresent([String].self, forKey: .droppedAttractionIds)
        schedulingAdjustments = try c.decodeIfPresent([String].self, forKey: .schedulingAdjustments)
        seasonHints = try c.decodeIfPresent([String].self, forKey: .seasonHints)
        pace = try c.decodeIfPresent(String.self, forKey: .pace)
        internationalArrivalTime = try c.decodeIfPresent(String.self, forKey: .internationalArrivalTime)
        internationalDepartureTime = try c.decodeIfPresent(String.self, forKey: .internationalDepartureTime)
        endpointScheduleBaselineDays = try c.decodeIfPresent([ItineraryDay].self, forKey: .endpointScheduleBaselineDays)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(meta, forKey: .meta)
        try c.encode(routeSummary, forKey: .routeSummary)
        try c.encode(estimatedBudget, forKey: .estimatedBudget)
        try c.encode(days, forKey: .days)
        try c.encodeIfPresent(shareSlug, forKey: .shareSlug)
        try c.encode(isShared, forKey: .isShared)
        try c.encodeIfPresent(startDate, forKey: .startDate)
        try c.encodeIfPresent(endDate, forKey: .endDate)
        try c.encodeIfPresent(visitOrder, forKey: .visitOrder)
        if userEdited { try c.encode(userEdited, forKey: .userEdited) }
        try c.encodeIfPresent(droppedAttractionIds, forKey: .droppedAttractionIds)
        try c.encodeIfPresent(schedulingAdjustments, forKey: .schedulingAdjustments)
        try c.encodeIfPresent(seasonHints, forKey: .seasonHints)
        try c.encodeIfPresent(pace, forKey: .pace)
        try c.encodeIfPresent(internationalArrivalTime, forKey: .internationalArrivalTime)
        try c.encodeIfPresent(internationalDepartureTime, forKey: .internationalDepartureTime)
        try c.encodeIfPresent(endpointScheduleBaselineDays, forKey: .endpointScheduleBaselineDays)
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, meta, routeSummary, estimatedBudget, days, shareSlug, isShared, startDate, endDate
        case visitOrder = "visit_order"
        case userEdited = "user_edited"
        case droppedAttractionIds = "dropped_attraction_ids"
        case schedulingAdjustments = "scheduling_adjustments"
        case seasonHints = "season_hints"
        case pace
        case internationalArrivalTime = "international_arrival_time"
        case internationalDepartureTime = "international_departure_time"
        case endpointScheduleBaselineDays = "endpoint_schedule_baseline_days"
    }

    /// Copy with replaced days; preserves share state and trip dates.
    func withDays(_ days: [ItineraryDay]) -> SampleItinerary {
        SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days,
            shareSlug: shareSlug,
            isShared: isShared,
            startDate: startDate,
            endDate: endDate,
            visitOrder: visitOrder,
            userEdited: userEdited,
            droppedAttractionIds: droppedAttractionIds,
            schedulingAdjustments: schedulingAdjustments,
            seasonHints: seasonHints,
            pace: pace,
            internationalArrivalTime: internationalArrivalTime,
            internationalDepartureTime: internationalDepartureTime,
            endpointScheduleBaselineDays: endpointScheduleBaselineDays
        )
    }

    /// Records pre-endpoint-replan days once (first write wins).
    func withEndpointBaseline(_ baselineDays: [ItineraryDay]) -> SampleItinerary {
        guard endpointScheduleBaselineDays == nil else { return self }
        return SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days,
            shareSlug: shareSlug,
            isShared: isShared,
            startDate: startDate,
            endDate: endDate,
            visitOrder: visitOrder,
            userEdited: userEdited,
            droppedAttractionIds: droppedAttractionIds,
            schedulingAdjustments: schedulingAdjustments,
            seasonHints: seasonHints,
            pace: pace,
            internationalArrivalTime: internationalArrivalTime,
            internationalDepartureTime: internationalDepartureTime,
            endpointScheduleBaselineDays: baselineDays
        )
    }

    func withInternationalFlightTimes(arrival: String?, departure: String?) -> SampleItinerary {
        SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days,
            shareSlug: shareSlug,
            isShared: isShared,
            startDate: startDate,
            endDate: endDate,
            visitOrder: visitOrder,
            userEdited: userEdited,
            droppedAttractionIds: droppedAttractionIds,
            schedulingAdjustments: schedulingAdjustments,
            seasonHints: seasonHints,
            pace: pace,
            internationalArrivalTime: arrival,
            internationalDepartureTime: departure,
            endpointScheduleBaselineDays: endpointScheduleBaselineDays
        )
    }

    func withDroppedAttractionIds(_ ids: [String]?) -> SampleItinerary {
        SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days,
            shareSlug: shareSlug,
            isShared: isShared,
            startDate: startDate,
            endDate: endDate,
            visitOrder: visitOrder,
            userEdited: userEdited,
            droppedAttractionIds: ids,
            schedulingAdjustments: schedulingAdjustments,
            seasonHints: seasonHints,
            pace: pace,
            internationalArrivalTime: internationalArrivalTime,
            internationalDepartureTime: internationalDepartureTime,
            endpointScheduleBaselineDays: endpointScheduleBaselineDays
        )
    }

    func markingUserEdited() -> SampleItinerary {
        SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days,
            shareSlug: shareSlug,
            isShared: isShared,
            startDate: startDate,
            endDate: endDate,
            visitOrder: visitOrder,
            userEdited: true,
            droppedAttractionIds: droppedAttractionIds,
            schedulingAdjustments: schedulingAdjustments,
            seasonHints: seasonHints,
            pace: pace,
            internationalArrivalTime: internationalArrivalTime,
            internationalDepartureTime: internationalDepartureTime,
            endpointScheduleBaselineDays: endpointScheduleBaselineDays
        )
    }
}

enum ItineraryDayKind: String, Codable, Hashable {
    case standard
    case experienceSuggestions = "experience_suggestions"
}

/// Inline intercity hop on a standard day (morning city A → commute card → afternoon city B).
struct ItineraryIntercityHop: Codable, Hashable {
    let fromCityId: String
    let toCityId: String
    let travelHours: Double
    let items: [String]
    /// User-set arrival at destination (HH:mm) from Review; triggers replan when set.
    let arrivalTimeAtDestination: String?

    init(
        fromCityId: String,
        toCityId: String,
        travelHours: Double,
        items: [String],
        arrivalTimeAtDestination: String? = nil
    ) {
        self.fromCityId = fromCityId
        self.toCityId = toCityId
        self.travelHours = travelHours
        self.items = items
        self.arrivalTimeAtDestination = arrivalTimeAtDestination
    }

    func withArrivalTime(_ time: String?) -> ItineraryIntercityHop {
        ItineraryIntercityHop(
            fromCityId: fromCityId,
            toCityId: toCityId,
            travelHours: travelHours,
            items: CityTravelHints.buildHopCardContentWithArrival(
                fromCityId: fromCityId,
                toCityId: toCityId,
                hours: travelHours,
                arrivalAtDestination: time
            ),
            arrivalTimeAtDestination: time
        )
    }

    private enum CodingKeys: String, CodingKey {
        case fromCityId = "from_city_id"
        case toCityId = "to_city_id"
        case travelHours = "travel_hours"
        case items
        case arrivalTimeAtDestination = "arrival_time_at_destination"
    }
}

struct ItineraryDay: Identifiable, Codable, Hashable {
    let id: String
    let dayIndex: Int
    let dateLabel: String
    let cityName: String
    let costEstimate: String?
    let dayKind: ItineraryDayKind
    let experienceItems: [String]
    let experienceCityId: String?
    let intercityHop: ItineraryIntercityHop?
    let activities: [ItineraryActivity]

    var isExperienceSuggestions: Bool {
        dayKind == .experienceSuggestions
    }

    var isIntercityHopDay: Bool {
        intercityHop != nil
    }

    init(
        id: String,
        dayIndex: Int,
        dateLabel: String,
        cityName: String,
        costEstimate: String?,
        activities: [ItineraryActivity],
        dayKind: ItineraryDayKind = .standard,
        experienceItems: [String] = [],
        experienceCityId: String? = nil,
        intercityHop: ItineraryIntercityHop? = nil
    ) {
        self.id = id
        self.dayIndex = dayIndex
        self.dateLabel = dateLabel
        self.cityName = cityName
        self.costEstimate = costEstimate
        self.dayKind = dayKind
        self.experienceItems = experienceItems
        self.experienceCityId = experienceCityId
        self.intercityHop = intercityHop
        self.activities = activities
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        dayIndex = try c.decode(Int.self, forKey: .dayIndex)
        dateLabel = try c.decode(String.self, forKey: .dateLabel)
        cityName = try c.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        costEstimate = try c.decodeIfPresent(String.self, forKey: .costEstimate)
        dayKind = try c.decodeIfPresent(ItineraryDayKind.self, forKey: .dayKind) ?? .standard
        experienceItems = try c.decodeIfPresent([String].self, forKey: .experienceItems) ?? []
        experienceCityId = try c.decodeIfPresent(String.self, forKey: .experienceCityId)
        intercityHop = try c.decodeIfPresent(ItineraryIntercityHop.self, forKey: .intercityHop)
        activities = try c.decodeIfPresent([ItineraryActivity].self, forKey: .activities) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(dayIndex, forKey: .dayIndex)
        try c.encode(dateLabel, forKey: .dateLabel)
        try c.encode(cityName, forKey: .cityName)
        try c.encodeIfPresent(costEstimate, forKey: .costEstimate)
        if dayKind != .standard {
            try c.encode(dayKind, forKey: .dayKind)
        }
        if !experienceItems.isEmpty {
            try c.encode(experienceItems, forKey: .experienceItems)
        }
        try c.encodeIfPresent(experienceCityId, forKey: .experienceCityId)
        try c.encodeIfPresent(intercityHop, forKey: .intercityHop)
        try c.encode(activities, forKey: .activities)
    }

    private enum CodingKeys: String, CodingKey {
        case id, dayIndex, dateLabel, cityName, costEstimate, dayKind, experienceItems, experienceCityId, activities
        case intercityHop = "intercity_hop"
    }

    func withActivities(_ activities: [ItineraryActivity]) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: costEstimate,
            activities: activities,
            dayKind: dayKind,
            experienceItems: experienceItems,
            experienceCityId: experienceCityId,
            intercityHop: intercityHop
        )
    }

    func withDayIndex(_ dayIndex: Int) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: costEstimate,
            activities: activities,
            dayKind: dayKind,
            experienceItems: experienceItems,
            experienceCityId: experienceCityId,
            intercityHop: intercityHop
        )
    }

    func withIntercityHop(_ hop: ItineraryIntercityHop?) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: costEstimate,
            activities: activities,
            dayKind: dayKind,
            experienceItems: experienceItems,
            experienceCityId: experienceCityId,
            intercityHop: hop
        )
    }

    func withExperienceItems(_ items: [String]) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: costEstimate,
            activities: activities,
            dayKind: dayKind,
            experienceItems: items,
            experienceCityId: experienceCityId,
            intercityHop: intercityHop
        )
    }
}

/// What kind of itinerary entry this is. Defaults to `.attraction` so old payloads
/// (which never wrote this key) decode unchanged. `.hotel` marks a booking-trace hotel.
enum ActivityKind: String, Codable, Hashable {
    case attraction
    case hotel
}

struct ItineraryActivity: Identifiable, Codable, Hashable {
    let id: String
    let timeSlot: String
    let name: String
    let detail: String
    let attractionId: String?
    let cityId: String?
    let hasAudio: Bool
    /// Booking trace: attraction (default) or platform hotel added to the trip.
    let kind: ActivityKind
    /// Set when `kind == .hotel`; references the platform hotel.
    let hotelId: String?
    /// Provenance of a traced booking (e.g. "platform"); nil for plain activities.
    let sourcePlatform: String?

    init(
        id: String,
        timeSlot: String = "",
        name: String,
        detail: String,
        attractionId: String?,
        cityId: String? = nil,
        hasAudio: Bool,
        kind: ActivityKind = .attraction,
        hotelId: String? = nil,
        sourcePlatform: String? = nil
    ) {
        self.id = id
        self.timeSlot = timeSlot
        self.name = name
        self.detail = detail
        self.attractionId = attractionId
        self.cityId = cityId
        self.hasAudio = hasAudio
        self.kind = kind
        self.hotelId = hotelId
        self.sourcePlatform = sourcePlatform
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        timeSlot = try c.decodeIfPresent(String.self, forKey: .timeSlot) ?? ""
        name = try c.decode(String.self, forKey: .name)
        detail = try c.decodeIfPresent(String.self, forKey: .detail) ?? ""
        attractionId = try c.decodeIfPresent(String.self, forKey: .attractionId)
        cityId = try c.decodeIfPresent(String.self, forKey: .cityId)
        hasAudio = try c.decodeIfPresent(Bool.self, forKey: .hasAudio) ?? false
        kind = try c.decodeIfPresent(ActivityKind.self, forKey: .kind) ?? .attraction
        hotelId = try c.decodeIfPresent(String.self, forKey: .hotelId)
        sourcePlatform = try c.decodeIfPresent(String.self, forKey: .sourcePlatform)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        if !timeSlot.isEmpty { try c.encode(timeSlot, forKey: .timeSlot) }
        try c.encode(name, forKey: .name)
        try c.encode(detail, forKey: .detail)
        try c.encodeIfPresent(attractionId, forKey: .attractionId)
        try c.encodeIfPresent(cityId, forKey: .cityId)
        try c.encode(hasAudio, forKey: .hasAudio)
        if kind != .attraction { try c.encode(kind, forKey: .kind) }
        try c.encodeIfPresent(hotelId, forKey: .hotelId)
        try c.encodeIfPresent(sourcePlatform, forKey: .sourcePlatform)
    }

    private enum CodingKeys: String, CodingKey {
        case id, timeSlot, name, detail, attractionId, cityId, hasAudio, kind, hotelId, sourcePlatform
    }

    /// Copy with selected fields replaced; preserves all other fields (including
    /// `kind`/`hotelId`/`sourcePlatform`) so edits never silently drop booking trace.
    func with(
        name: String? = nil,
        detail: String? = nil,
        hasAudio: Bool? = nil
    ) -> ItineraryActivity {
        ItineraryActivity(
            id: id,
            timeSlot: timeSlot,
            name: name ?? self.name,
            detail: detail ?? self.detail,
            attractionId: attractionId,
            cityId: cityId,
            hasAudio: hasAudio ?? self.hasAudio,
            kind: kind,
            hotelId: hotelId,
            sourcePlatform: sourcePlatform
        )
    }
}

struct ContentItineraryRow: Codable {
    let id: String
    let kind: String
    let title: String
    let meta: String
    let routeSummary: String
    let estimatedBudget: String
    let days: [ItineraryDay]

    func asSampleItinerary() -> SampleItinerary {
        SampleItinerary(
            id: id,
            title: title,
            meta: meta,
            routeSummary: routeSummary,
            estimatedBudget: estimatedBudget,
            days: days
        )
    }
}
