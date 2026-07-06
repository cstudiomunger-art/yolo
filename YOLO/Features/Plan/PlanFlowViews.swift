import SwiftUI

enum PlanRoute: Hashable {
    case create
    case detail(SampleItinerary)
}

struct PlanSectionCard<Content: View>: View {
    let title: String
    var subtitle: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.FontToken.inter(12, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textSecondary)
            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            VStack(spacing: 0) {
                content()
            }
            .padding(.horizontal, 12)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct FlowLayoutTags: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 96), spacing: 8, alignment: .leading)],
            alignment: .leading,
            spacing: 8
        ) {
            ForEach(tags, id: \.self) { tag in
                selectedCityChip(tag)
            }
        }
    }

    private func selectedCityChip(_ name: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: "star.fill")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Theme.ColorToken.accent)
            Text(name)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Theme.ColorToken.accent.opacity(0.35), lineWidth: 1))
        .fixedSize(horizontal: true, vertical: false)
    }
}

// MARK: - Detail

struct ItineraryDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let itinerary: SampleItinerary
    @State private var segment: DetailSegment = .itinerary
    @State private var showShare = false
    @State private var showEdit = false
    @State private var editableDays: [ItineraryDay] = []
    @State private var editMode: EditMode = .inactive
    @State private var attractionCache: [String: Attraction] = [:]
    @State private var cities: [City] = []
    @State private var addAttractionContext: PlanAddAttractionContext?
    @State private var intercityTripSnapshot: [ItineraryDay]?
    @State private var intercityAdjustmentsSnapshot: [String] = []
    @State private var endpointTripSnapshot: [ItineraryDay]?
    @State private var endpointAdjustmentsSnapshot: [String] = []
    @State private var endpointScheduleBaselineDays: [ItineraryDay]?
    @State private var droppedAttractionIds: [String]?
    @State private var internationalArrivalTime: String?
    @State private var internationalDepartureTime: String?
    @State private var endpointArrivalReplanTask: Task<Void, Never>?
    @State private var endpointDepartureReplanTask: Task<Void, Never>?
    @State private var arrivalReplanTask: Task<Void, Never>?
    @State private var schedulingAdjustments: [String] = []

    enum DetailSegment { case itinerary, book }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("← Plan") { dismiss() }
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                HStack(spacing: 16) {
                    Button("Edit") { showEdit = true }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .textCase(.uppercase)
                    Button("⬆ Share") { showShare = true }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .textCase(.uppercase)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(itinerary.title)
                    .font(Theme.FontToken.playfair(18, weight: .semibold))
                Text(itinerary.meta)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Text(String(format: String(localized: "%lld days total"), currentItinerary.days.count))
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 12)

            VisaPlanHintBanner(citySlugs: tripCityIds,
                               start: currentItinerary.startDate,
                               end: currentItinerary.endDate)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, 12)

            HStack(spacing: 0) {
                detailSeg("Itinerary", segment == .itinerary) { segment = .itinerary }
                detailSeg("Book Your Trip", segment == .book) { segment = .book }
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
            }

            if segment == .itinerary {
                itineraryScroll
            } else {
                BookYourTripView(itinerary: currentItinerary)
            }
        }
        .background(Theme.ColorToken.background)
        .sheet(isPresented: $showShare) {
            ShareItinerarySheet(itinerary: currentItinerary)
        }
        .sheet(isPresented: $showEdit) {
            ItineraryEditorView(itinerary: currentItinerary) { updated in
                editableDays = updated.days
            }
        }
        .onAppear {
            editableDays = itinerary.days
            schedulingAdjustments = itinerary.schedulingAdjustments ?? []
            internationalArrivalTime = itinerary.internationalArrivalTime
            internationalDepartureTime = itinerary.internationalDepartureTime
            endpointScheduleBaselineDays = itinerary.endpointScheduleBaselineDays
            droppedAttractionIds = itinerary.droppedAttractionIds
            if endpointScheduleBaselineDays == nil,
               internationalArrivalTime == nil,
               internationalDepartureTime == nil {
                endpointScheduleBaselineDays = itinerary.days
            }
        }
        .task(id: itinerary.id) {
            do {
                cities = try await appEnv.content.fetchCities()
            } catch {
                cities = []
                TelemetryService.shared.recordError(error, context: "plan_detail_cities")
            }
            await loadAttractionCache()
        }
        .onChange(of: editableDays) { _, _ in
            guard !editMode.isEditing else { return }
            Task { await loadAttractionCache() }
        }
        .onChange(of: editMode) { _, mode in
            guard !mode.isEditing else { return }
            Task { await loadAttractionCache() }
        }
        .onChange(of: segment) { _, _ in
            // Hotels added in the Book tab persist to the store but not into the
            // parent's editableDays; re-sync on tab switch so they show immediately.
            guard !editMode.isEditing else { return }
            if let saved = appEnv.preferences.savedItineraries.first(where: { $0.id == itinerary.id }) {
                editableDays = saved.days
                internationalArrivalTime = saved.internationalArrivalTime
                internationalDepartureTime = saved.internationalDepartureTime
                endpointScheduleBaselineDays = saved.endpointScheduleBaselineDays ?? endpointScheduleBaselineDays
                droppedAttractionIds = saved.droppedAttractionIds
                schedulingAdjustments = saved.schedulingAdjustments ?? []
            }
        }
        .sheet(item: $addAttractionContext) { ctx in
            PlanAttractionPickerSheet(cityIds: ctx.cityIds, dayIndex: ctx.dayIndex) { attraction in
                appendAttraction(attraction, dayIndex: ctx.dayIndex)
                addAttractionContext = nil
            }
        }
    }

    private func loadAttractionCache() async {
        attractionCache = await PlanItineraryHelpers.attractionCache(for: currentItinerary, content: appEnv.content)
    }

    private var tripCityIds: [String] {
        PlanTripCities.cityIds(
            itinerary: currentItinerary,
            selectedCityIds: appEnv.preferences.selectedCityIds,
            attractionCache: attractionCache
        )
    }

    private var cityNameById: [String: String] {
        Dictionary(uniqueKeysWithValues: cities.map { ($0.id, $0.name) })
    }

    private func appendAttraction(_ attraction: Attraction, dayIndex: Int) {
        guard editableDays.indices.contains(dayIndex) else { return }
        let day = editableDays[dayIndex]
        editableDays[dayIndex] = day.withActivities(day.activities + [PlanItineraryHelpers.activity(from: attraction)])
        attractionCache[attraction.id] = attraction
        persistItineraryOrder()
    }

    private func applyIntercityArrivalTime(dayIndex: Int, arrivalTime: String?) {
        arrivalReplanTask?.cancel()
        arrivalReplanTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            guard let dayIdx = editableDays.firstIndex(where: { $0.dayIndex == dayIndex }) else { return }
            let day = editableDays[dayIdx]
            guard day.intercityHop != nil else { return }

            if intercityTripSnapshot == nil {
                intercityTripSnapshot = editableDays
                intercityAdjustmentsSnapshot = schedulingAdjustments
            }

            if arrivalTime == nil, let snapshot = intercityTripSnapshot {
                editableDays = snapshot
                schedulingAdjustments = intercityAdjustmentsSnapshot
                intercityTripSnapshot = nil
                intercityAdjustmentsSnapshot = []
                persistItineraryOrder()
                return
            }

            let (newDays, adjustments) = PlanItineraryIntercityReplanner.replan(
                days: editableDays,
                dayIndex: dayIndex,
                arrivalTime: arrivalTime,
                options: PlanItineraryIntercityReplanner.Options(
                    pace: resolvedTripPace,
                    catalogById: attractionCache,
                    droppedAttractionIds: currentItinerary.droppedAttractionIds ?? []
                )
            )
            editableDays = fillDaysAfterReplan(newDays)
            schedulingAdjustments.append(contentsOf: adjustments)
            persistItineraryOrder()
        }
    }

    private func endpointReplannerOptions() -> PlanItineraryEndpointReplanner.Options {
        PlanItineraryEndpointReplanner.Options(
            pace: resolvedTripPace,
            catalogById: attractionCache,
            visitOrder: currentItinerary.visitOrder ?? tripCityIds,
            droppedAttractionIds: currentItinerary.droppedAttractionIds ?? []
        )
    }

    private func mergeDroppedIds(existing: [String]?, newIds: [String]) -> [String]? {
        guard !newIds.isEmpty else { return existing }
        var merged = existing ?? []
        for id in newIds where !merged.contains(id) {
            merged.append(id)
        }
        return merged
    }

    private func endpointBaselineDays() -> [ItineraryDay] {
        endpointScheduleBaselineDays ?? endpointTripSnapshot ?? editableDays
    }

    private func applyEndpointTimes(
        arrival: String?,
        departure: String?,
        clearingArrival: Bool = false,
        clearingDeparture: Bool = false
    ) {
        let baseline = endpointBaselineDays()
        let finalArrival: String? = clearingArrival ? nil : arrival
        let finalDeparture: String? = clearingDeparture ? nil : departure

        if !clearingArrival, !clearingDeparture, finalArrival != nil || finalDeparture != nil {
            if endpointScheduleBaselineDays == nil {
                endpointScheduleBaselineDays = baseline
            }
            if endpointTripSnapshot == nil {
                endpointTripSnapshot = endpointScheduleBaselineDays ?? baseline
                endpointAdjustmentsSnapshot = schedulingAdjustments
            }
        }

        let result = PlanItineraryEndpointReplanner.replan(
            days: baseline,
            entryCityId: resolvedEntryCityId,
            exitCityId: resolvedExitCityId,
            arrivalTime: finalArrival,
            departureTime: finalDeparture,
            options: endpointReplannerOptions()
        )

        editableDays = fillDaysAfterReplan(result.days)
        internationalArrivalTime = finalArrival
        internationalDepartureTime = finalDeparture
        droppedAttractionIds = mergeDroppedIds(existing: droppedAttractionIds, newIds: result.droppedAttractionIds)

        if clearingArrival || clearingDeparture {
            if finalArrival == nil, finalDeparture == nil {
                schedulingAdjustments = endpointAdjustmentsSnapshot
            } else if !endpointAdjustmentsSnapshot.isEmpty {
                schedulingAdjustments = endpointAdjustmentsSnapshot + result.adjustments
            } else {
                schedulingAdjustments = result.adjustments
            }
            endpointTripSnapshot = nil
            endpointAdjustmentsSnapshot = []
        } else {
            schedulingAdjustments.append(contentsOf: result.adjustments)
        }

        persistItineraryOrder()
    }

    private func applyInternationalArrivalTime(_ arrivalTime: String?) {
        endpointArrivalReplanTask?.cancel()
        endpointArrivalReplanTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            applyEndpointTimes(
                arrival: arrivalTime,
                departure: internationalDepartureTime,
                clearingArrival: arrivalTime == nil,
                clearingDeparture: false
            )
        }
    }

    private func applyInternationalDepartureTime(_ departureTime: String?) {
        endpointDepartureReplanTask?.cancel()
        endpointDepartureReplanTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            applyEndpointTimes(
                arrival: internationalArrivalTime,
                departure: departureTime,
                clearingArrival: false,
                clearingDeparture: departureTime == nil
            )
        }
    }

    private var internationalArrivalBookendCard: some View {
        let entryId = resolvedEntryCityId
        let name = cityNameById[entryId] ?? CityTravelHints.displayName(for: entryId)
        let trip = currentItinerary
        let order = trip.visitOrder ?? tripCityIds
        let linkedIdx = CityTravelHints.entrySightseeingDayArrayIndex(
            days: trip.days,
            visitOrder: order,
            entryCityId: entryId
        )
        let linkedDay = linkedIdx.map { trip.days[$0] }
        return InternationalEndpointDaySection(
            kind: .inbound,
            cityId: entryId,
            cityDisplayName: name,
            calendarDate: trip.startDate,
            flightTime: internationalArrivalTime,
            linkedDay: linkedDay,
            onTimeChange: applyInternationalArrivalTime
        ) {
            if let linkedIdx {
                ForEach(trip.days[linkedIdx].activities) { activity in
                    activityRow(activity, dayId: trip.days[linkedIdx].id)
                }
            }
        } addAttractionButton: {
            if !editMode.isEditing, let linkedIdx {
                Button {
                    addAttractionContext = PlanAddAttractionContext(
                        dayIndex: linkedIdx,
                        cityIds: [entryId]
                    )
                } label: {
                    addAttractionButtonLabel
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.ColorToken.accent)
            }
        }
    }

    private var internationalDepartureBookendCard: some View {
        let exitId = resolvedExitCityId
        let name = cityNameById[exitId] ?? CityTravelHints.displayName(for: exitId)
        let trip = currentItinerary
        let order = trip.visitOrder ?? tripCityIds
        let linkedIdx = CityTravelHints.exitSightseeingDayArrayIndex(
            days: trip.days,
            visitOrder: order,
            exitCityId: exitId
        )
        let linkedDay = linkedIdx.map { trip.days[$0] }
        return InternationalEndpointDaySection(
            kind: .outbound,
            cityId: exitId,
            cityDisplayName: name,
            calendarDate: trip.endDate,
            flightTime: internationalDepartureTime,
            linkedDay: linkedDay,
            onTimeChange: applyInternationalDepartureTime
        ) {
            if let linkedIdx {
                ForEach(trip.days[linkedIdx].activities) { activity in
                    activityRow(activity, dayId: trip.days[linkedIdx].id)
                }
            }
        } addAttractionButton: {
            if !editMode.isEditing, let linkedIdx {
                Button {
                    addAttractionContext = PlanAddAttractionContext(
                        dayIndex: linkedIdx,
                        cityIds: [exitId]
                    )
                } label: {
                    addAttractionButtonLabel
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.ColorToken.accent)
            }
        }
    }

    private func bookendRelocation(for day: ItineraryDay) -> CityTravelHints.BookendActivityRelocation {
        let trip = currentItinerary
        let order = trip.visitOrder ?? tripCityIds
        return CityTravelHints.bookendActivityRelocation(
            day: day,
            days: trip.days,
            visitOrder: order,
            entryCityId: resolvedEntryCityId,
            exitCityId: resolvedExitCityId,
            arrivalTime: internationalArrivalTime ?? trip.internationalArrivalTime,
            departureTime: internationalDepartureTime ?? trip.internationalDepartureTime
        )
    }

    @ViewBuilder
    private func bookendRelocationHint(_ relocation: CityTravelHints.BookendActivityRelocation) -> some View {
        let text: LocalizedStringKey = switch relocation {
        case .arrivalCard: "Planned sights shown under International arrival above"
        case .departureCard: "Planned sights shown under International departure below"
        case .none: ""
        }
        Text(text)
            .font(Theme.FontToken.inter(11))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ColorToken.background)
            .moveDisabled(true)
    }

    private var resolvedTripPace: TripPace {
        if let raw = currentItinerary.pace, let pace = TripPace(rawValue: raw) {
            return pace
        }
        let days = editableDays.isEmpty ? itinerary.days : editableDays
        return PlanItinerarySlotBudget.inferTripPace(from: days)
    }

    private var currentItinerary: SampleItinerary {
        let days = editableDays.isEmpty ? itinerary.days : editableDays
        let saved = appEnv.preferences.savedItineraries.first(where: { $0.id == itinerary.id })
        return SampleItinerary(
            id: itinerary.id,
            title: itinerary.title,
            meta: itinerary.meta,
            routeSummary: itinerary.routeSummary,
            estimatedBudget: itinerary.estimatedBudget,
            days: days,
            shareSlug: saved?.shareSlug ?? itinerary.shareSlug,
            isShared: saved?.isShared ?? itinerary.isShared,
            startDate: saved?.startDate ?? itinerary.startDate,
            endDate: saved?.endDate ?? itinerary.endDate,
            visitOrder: saved?.visitOrder ?? itinerary.visitOrder,
            userEdited: saved?.userEdited ?? itinerary.userEdited,
            droppedAttractionIds: droppedAttractionIds ?? saved?.droppedAttractionIds ?? itinerary.droppedAttractionIds,
            schedulingAdjustments: schedulingAdjustments.isEmpty
                ? (saved?.schedulingAdjustments ?? itinerary.schedulingAdjustments)
                : schedulingAdjustments,
            seasonHints: saved?.seasonHints ?? itinerary.seasonHints,
            pace: saved?.pace ?? itinerary.pace,
            internationalArrivalTime: internationalArrivalTime ?? saved?.internationalArrivalTime ?? itinerary.internationalArrivalTime,
            internationalDepartureTime: internationalDepartureTime ?? saved?.internationalDepartureTime ?? itinerary.internationalDepartureTime,
            endpointScheduleBaselineDays: endpointScheduleBaselineDays ?? saved?.endpointScheduleBaselineDays ?? itinerary.endpointScheduleBaselineDays
        )
    }

    private var resolvedEntryCityId: String {
        let order = currentItinerary.visitOrder ?? tripCityIds
        return order.first?.lowercased() ?? tripCityIds.first?.lowercased() ?? "beijing"
    }

    private var resolvedExitCityId: String {
        let order = currentItinerary.visitOrder ?? tripCityIds
        if order.count <= 1 { return resolvedEntryCityId }
        return order.last?.lowercased() ?? resolvedEntryCityId
    }

    private var addAttractionButtonLabel: some View {
        HStack(spacing: 3) {
            Image(systemName: "plus")
                .font(.system(size: 7, weight: .medium))
            Text(String(localized: "Add attraction"))
                .font(Theme.FontToken.inter(9, weight: .medium))
        }
    }

    private func detailSeg(_ title: String, _ active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(active ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(alignment: .bottom) {
                    if active { Rectangle().fill(Theme.ColorToken.textPrimary).frame(height: 1) }
                }
        }
        .buttonStyle(.plain)
    }

    private var itineraryScroll: some View {
        VStack(spacing: 0) {
            Text("Drag to reorder days and activities. Tap Done when finished.")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.vertical, 10)
                .background(Theme.ColorToken.backgroundSubtle)

            List {
                Section {
                    internationalArrivalBookendCard
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Theme.ColorToken.background)
                        .listRowSeparator(.hidden)
                }

                ForEach(editableDays) { day in
                    Section {
                        daySectionHeader(day)

                        let relocation = bookendRelocation(for: day)
                        if relocation != .none {
                            bookendRelocationHint(relocation)
                        } else if day.intercityHop != nil && day.isExperienceSuggestions {
                            ExperienceSuggestionsDayCard(
                                day: day,
                                cityDisplayName: experienceCityDisplayName(day),
                                showsActivities: false,
                                onArrivalTimeChange: { applyIntercityArrivalTime(dayIndex: day.dayIndex, arrivalTime: $0) }
                            )
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                            .moveDisabled(true)

                            ForEach(day.activities) { activity in
                                activityRow(activity, dayId: day.id)
                            }
                            .onMove { source, destination in
                                moveActivities(dayId: day.id, from: source, to: destination)
                            }
                            .onDelete { offsets in
                                deleteActivities(dayId: day.id, at: offsets)
                            }

                            Button {
                                guard let dayIndex = editableDays.firstIndex(where: { $0.id == day.id }) else { return }
                                let cityIds: [String] = {
                                    if let cid = day.experienceCityId, !cid.isEmpty { return [cid] }
                                    return tripCityIds
                                }()
                                addAttractionContext = PlanAddAttractionContext(
                                    dayIndex: dayIndex,
                                    cityIds: cityIds
                                )
                            } label: {
                                addAttractionButtonLabel
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.ColorToken.accent)
                            .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                            .moveDisabled(true)
                        } else if day.isExperienceSuggestions || PlanItineraryDayFill.isBlank(day) {
                            let trip = currentItinerary
                            let displayDay = day.isExperienceSuggestions
                                ? day
                                : (PlanItineraryDayFill.fillEmptyDays(
                                    [day],
                                    visitOrder: trip.visitOrder ?? tripCityIds,
                                    pace: resolvedTripPace,
                                    arrivalTime: internationalArrivalTime ?? trip.internationalArrivalTime,
                                    departureTime: internationalDepartureTime ?? trip.internationalDepartureTime
                                ).first ?? day)
                            ExperienceSuggestionsDayCard(
                                day: displayDay,
                                cityDisplayName: experienceCityDisplayName(displayDay),
                                onArrivalTimeChange: displayDay.intercityHop != nil
                                    ? { applyIntercityArrivalTime(dayIndex: day.dayIndex, arrivalTime: $0) }
                                    : nil
                            )
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                            .moveDisabled(true)

                            Button {
                                guard let dayIndex = editableDays.firstIndex(where: { $0.id == day.id }) else { return }
                                let cityIds: [String] = {
                                    if let cid = displayDay.experienceCityId, !cid.isEmpty { return [cid] }
                                    return tripCityIds
                                }()
                                addAttractionContext = PlanAddAttractionContext(
                                    dayIndex: dayIndex,
                                    cityIds: cityIds
                                )
                            } label: {
                                addAttractionButtonLabel
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.ColorToken.accent)
                            .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                            .moveDisabled(true)

                            if day.isExperienceSuggestions, day.intercityHop == nil {
                                Button {
                                    convertExperienceDayToStandard(dayId: day.id)
                                } label: {
                                    Label(String(localized: "Use as sightseeing day"), systemImage: "sun.max")
                                        .font(Theme.FontToken.inter(11, weight: .medium))
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(Theme.ColorToken.textSecondary)
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Theme.ColorToken.background)
                                .moveDisabled(true)
                            }
                        } else if day.intercityHop != nil {
                            let split = PlanItineraryHopUI.splitActivities(day)
                            ForEach(split.morning) { activity in
                                activityRow(activity, dayId: day.id)
                            }
                            .onMove { source, destination in
                                moveActivities(dayId: day.id, from: source, to: destination)
                            }
                            .onDelete { offsets in
                                deleteActivities(dayId: day.id, at: offsets)
                            }
                            if let hop = day.intercityHop {
                                IntercityHopCard(hop: hop) { time in
                                    applyIntercityArrivalTime(dayIndex: day.dayIndex, arrivalTime: time)
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Theme.ColorToken.background)
                                .moveDisabled(true)
                            }
                            ForEach(split.afternoon) { activity in
                                activityRow(activity, dayId: day.id)
                            }
                            .onMove { source, destination in
                                let offset = split.morning.count
                                moveActivities(
                                    dayId: day.id,
                                    from: IndexSet(source.map { $0 + offset }),
                                    to: destination + offset
                                )
                            }
                            .onDelete { offsets in
                                let offset = split.morning.count
                                deleteActivities(
                                    dayId: day.id,
                                    at: IndexSet(offsets.map { $0 + offset })
                                )
                            }

                            Button {
                                guard let dayIndex = editableDays.firstIndex(where: { $0.id == day.id }) else { return }
                                addAttractionContext = PlanAddAttractionContext(
                                    dayIndex: dayIndex,
                                    cityIds: tripCityIds
                                )
                            } label: {
                                addAttractionButtonLabel
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.ColorToken.accent)
                            .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                            .moveDisabled(true)
                        } else {
                            if PlanItineraryDayFill.isBlank(day) {
                                let trip = currentItinerary
                                let displayDay = PlanItineraryDayFill.fillEmptyDays(
                                    [day],
                                    visitOrder: trip.visitOrder ?? tripCityIds,
                                    pace: resolvedTripPace,
                                    arrivalTime: internationalArrivalTime ?? trip.internationalArrivalTime,
                                    departureTime: internationalDepartureTime ?? trip.internationalDepartureTime
                                ).first ?? day
                                ExperienceSuggestionsDayCard(
                                    day: displayDay,
                                    cityDisplayName: experienceCityDisplayName(displayDay)
                                )
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Theme.ColorToken.background)
                                .moveDisabled(true)

                                Button {
                                    guard let dayIndex = editableDays.firstIndex(where: { $0.id == day.id }) else { return }
                                    let cityIds: [String] = {
                                        if let cid = displayDay.experienceCityId, !cid.isEmpty { return [cid] }
                                        return tripCityIds
                                    }()
                                    addAttractionContext = PlanAddAttractionContext(
                                        dayIndex: dayIndex,
                                        cityIds: cityIds
                                    )
                                } label: {
                                    addAttractionButtonLabel
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(Theme.ColorToken.accent)
                                .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 6, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Theme.ColorToken.background)
                                .moveDisabled(true)
                            } else {
                            ForEach(day.activities) { activity in
                                activityRow(activity, dayId: day.id)
                            }
                            .onMove { source, destination in
                                moveActivities(dayId: day.id, from: source, to: destination)
                            }
                            .onDelete { offsets in
                                deleteActivities(dayId: day.id, at: offsets)
                            }

                            Button {
                                guard let dayIndex = editableDays.firstIndex(where: { $0.id == day.id }) else { return }
                                addAttractionContext = PlanAddAttractionContext(
                                    dayIndex: dayIndex,
                                    cityIds: tripCityIds
                                )
                            } label: {
                                addAttractionButtonLabel
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Theme.ColorToken.accent)
                            .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                            .moveDisabled(true)
                            }
                        }
                    }
                }
                .onMove(perform: moveDays)

                Section {
                    internationalDepartureBookendCard
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Theme.ColorToken.background)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .environment(\.editMode, $editMode)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if editMode.isEditing {
                    Button("Done") {
                        editMode = .inactive
                        reindexDayNumbers()
                        persistItineraryOrder()
                    }
                    .font(Theme.FontToken.inter(12, weight: .medium))
                } else {
                    Button("Reorder") {
                        editMode = .active
                    }
                    .font(Theme.FontToken.inter(12, weight: .medium))
                }
            }
        }
    }

    private func experienceCityDisplayName(_ day: ItineraryDay) -> String {
        if let hop = day.intercityHop {
            return CityTravelHints.hopDayRouteLabel(fromCityId: hop.fromCityId, toCityId: hop.toCityId)
        }
        guard let cid = day.experienceCityId else { return "" }
        return cityNameById[cid] ?? cid.capitalized
    }

    private func daySectionHeader(_ day: ItineraryDay) -> some View {
        let visited = CityTravelHints.daySectionCityLabel(
            day: day,
            cityNameById: cityNameById,
            attractionCache: attractionCache
        )
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Day \(day.dayIndex) · \(day.dateLabel)")
                    .font(Theme.FontToken.playfair(14, weight: .semibold))
                Spacer()
                if let cost = day.costEstimate {
                    Text(cost)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            if !visited.isEmpty {
                Text(visited)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 4, trailing: 16))
        .listRowSeparator(.hidden, edges: .top)
        .listRowBackground(Theme.ColorToken.background)
        .moveDisabled(true)
    }

    private func activityRow(_ activity: ItineraryActivity, dayId: String) -> some View {
        let dayIndex = editableDays.firstIndex(where: { $0.id == dayId }) ?? 0
        let activityCityId = activity.cityId ?? activity.attractionId.flatMap { attractionCache[$0]?.cityId }
        let showCity = tripCityIds.count > 1
        let cityLabel = activityCityId.flatMap { cityNameById[$0] }
        let isEditing = editMode.isEditing

        let rowContent = HStack(alignment: .top, spacing: 10) {
            if !isEditing {
                activityCoverThumbnail(activity)
            }

            VStack(alignment: .leading, spacing: 4) {
                if showCity, let cityLabel {
                    Text(cityLabel)
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textDisabled)
                }
                if let aid = activity.attractionId,
                   attractionCache[aid]?.requiresAdvanceBooking == true {
                    Text(String(localized: "Reservation"))
                        .font(Theme.FontToken.inter(9, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.warning)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.ColorToken.warningBackground)
                        .clipShape(Capsule())
                }
                Text(activity.name)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text(HTMLContentView.plainText(from: activity.detail))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .lineLimit(isEditing ? 2 : 3)
            }

            Spacer(minLength: 0)

            if activity.hasAudio {
                Text("🎧")
                    .font(Theme.FontToken.inter(10))
            }
        }
        .padding(.vertical, 4)

        return Group {
            if isEditing {
                rowContent
            } else if let aid = activity.attractionId {
                Button {
                    appEnv.navigation.openGuide(
                        attractionId: aid,
                        cityId: activityCityId,
                        presentation: .planDay(dayIndex: dayIndex)
                    )
                } label: {
                    rowContent
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }
        }
        .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 6, trailing: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Theme.ColorToken.background)
    }

    private func activityCoverThumbnail(_ activity: ItineraryActivity) -> some View {
        let path: String? = {
            guard let aid = activity.attractionId else { return nil }
            let attraction = attractionCache[aid]
            return attraction?.coverImagePath ?? attraction?.coverImages.first
        }()
        return CoverImageView(path: path, height: 56, cornerRadius: 4)
            .frame(width: 56, height: 56)
            .fixedSize()
    }

    private func deleteActivities(dayId: String, at offsets: IndexSet) {
        guard let dayIndex = editableDays.firstIndex(where: { $0.id == dayId }) else { return }
        var activities = editableDays[dayIndex].activities
        activities.remove(atOffsets: offsets)
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
        persistItineraryOrder()
    }

    private func moveDays(from source: IndexSet, to destination: Int) {
        editableDays.move(fromOffsets: source, toOffset: destination)
    }

    private func reindexDayNumbers() {
        editableDays = editableDays.enumerated().map { index, day in
            day.withDayIndex(index + 1)
        }
    }

    private func moveActivities(dayId: String, from source: IndexSet, to destination: Int) {
        guard let dayIndex = editableDays.firstIndex(where: { $0.id == dayId }) else { return }
        var activities = editableDays[dayIndex].activities
        activities.move(fromOffsets: source, toOffset: destination)
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
    }

    private func persistItineraryOrder() {
        editableDays = normalizeDays(editableDays)
        let updated = currentItinerary.markingUserEdited()
        appEnv.preferences.saveItinerary(updated)
    }

    private func convertExperienceDayToStandard(dayId: String) {
        guard let index = editableDays.firstIndex(where: { $0.id == dayId }) else { return }
        let day = editableDays[index]
        editableDays[index] = ItineraryDay(
            id: day.id,
            dayIndex: day.dayIndex,
            dateLabel: day.dateLabel,
            cityName: day.cityName,
            costEstimate: day.costEstimate,
            activities: mapActivities(day.activities),
            dayKind: .standard,
            experienceItems: [],
            experienceCityId: nil
        )
        persistItineraryOrder()
    }

    private func mapActivities(_ activities: [ItineraryActivity]) -> [ItineraryActivity] {
        activities.map { act in
            let resolvedCityId = act.cityId ?? act.attractionId.flatMap { attractionCache[$0]?.cityId }
            return ItineraryActivity(
                id: act.id,
                timeSlot: act.timeSlot,
                name: act.name,
                detail: act.detail,
                attractionId: act.attractionId,
                cityId: resolvedCityId,
                hasAudio: act.hasAudio,
                kind: act.kind,
                hotelId: act.hotelId,
                sourcePlatform: act.sourcePlatform
            )
        }
    }

    private func fillDaysAfterReplan(_ days: [ItineraryDay]) -> [ItineraryDay] {
        let trip = currentItinerary
        let visitOrder = trip.visitOrder ?? tripCityIds
        let cityMap = PlanItineraryIntercityAnnotator.completeCityIdByDayIndex(
            from: days,
            visitOrder: visitOrder,
            seed: timelineCityIdByDay(from: days, visitOrder: visitOrder)
        )
        let replenished = PlanItineraryDayFill.replenishBlankSightseeingDays(
            days,
            visitOrder: visitOrder,
            pace: resolvedTripPace,
            catalogById: attractionCache,
            droppedAttractionIds: droppedAttractionIds ?? trip.droppedAttractionIds ?? [],
            cityIdByDayIndex: cityMap
        )
        return PlanItineraryDayFill.fillEmptyDays(
            replenished,
            visitOrder: visitOrder,
            pace: resolvedTripPace,
            arrivalTime: internationalArrivalTime ?? trip.internationalArrivalTime,
            departureTime: internationalDepartureTime ?? trip.internationalDepartureTime,
            cityIdByDayIndex: cityMap
        )
    }

    private func timelineCityIdByDay(from days: [ItineraryDay], visitOrder: [String]) -> [Int: String] {
        var map: [Int: String] = [:]
        for day in days {
            if let cid = day.experienceCityId?.lowercased(), !cid.isEmpty {
                map[day.dayIndex] = cid
            } else if let hop = day.intercityHop {
                map[day.dayIndex] = hop.toCityId.lowercased()
            } else if let cid = day.activities.compactMap(\.cityId).first?.lowercased(), !cid.isEmpty {
                map[day.dayIndex] = cid
            }
        }
        return map
    }

    private func normalizeDays(_ days: [ItineraryDay]) -> [ItineraryDay] {
        days.map { day in
            let mapped = mapActivities(day.activities)
            if day.isExperienceSuggestions {
                let resolvedCityName: String
                if let hop = day.intercityHop {
                    resolvedCityName = CityTravelHints.hopDayRouteLabel(
                        fromCityId: hop.fromCityId,
                        toCityId: hop.toCityId
                    )
                } else {
                    resolvedCityName = day.experienceCityId.map { CityTravelHints.displayName(for: $0) } ?? day.cityName
                }
                return ItineraryDay(
                    id: day.id,
                    dayIndex: day.dayIndex,
                    dateLabel: day.dateLabel,
                    cityName: resolvedCityName,
                    costEstimate: day.costEstimate,
                    activities: mapped,
                    dayKind: .experienceSuggestions,
                    experienceItems: day.experienceItems,
                    experienceCityId: day.experienceCityId,
                    intercityHop: day.intercityHop
                )
            }
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: day.cityName,
                costEstimate: day.costEstimate,
                activities: mapped,
                experienceCityId: day.experienceCityId,
                intercityHop: day.intercityHop
            )
        }
    }
}

// MARK: - Book

private struct HotelSheetCity: Identifiable {
    let id: String
    let displayName: String
}

/// Lets a hotel card add itself to a chosen day of the active trip (booking trace).
struct HotelTripAdder {
    /// Standard (non-experience) days available to pick.
    let days: [ItineraryDay]
    /// Hotel ids already traced into the trip (to show "已加入").
    let addedHotelIds: Set<String>
    let add: (Hotel, ItineraryDay) -> Void
}

struct BookYourTripView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let itinerary: SampleItinerary
    @State private var hotelSheetCity: HotelSheetCity?
    /// Mutable working copy so added hotels persist and reflect immediately.
    @State private var working: SampleItinerary?

    private var activeItinerary: SampleItinerary { working ?? itinerary }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                bookBlock(title: "✈️ Flights to Beijing", subtitle: "Dates pre-filled from your trip") {
                    flightButtons
                }
                ForEach(appEnv.preferences.selectedCityIds, id: \.self) { cityId in
                    bookBlock(title: "🏨 \(cityId.capitalized)", subtitle: "Foreigner-friendly hotels") {
                        Button {
                            let normalized = cityId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                            hotelSheetCity = HotelSheetCity(id: normalized, displayName: cityId.capitalized)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Search foreigner-friendly hotels")
                                        .font(Theme.FontToken.inter(13))
                                    Text("Curated options, English staff noted")
                                        .font(Theme.FontToken.inter(11))
                                        .foregroundStyle(Theme.ColorToken.textMuted)
                                }
                                Spacer()
                                Text("→")
                            }
                            .padding(14)
                            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(Theme.screenPadding)
        }
        .sheet(item: $hotelSheetCity) { city in
            HotelSearchSheet(cityId: city.id, cityName: city.displayName, adder: hotelAdder())
        }
        .onAppear { if working == nil { working = itinerary } }
    }

    private func hotelAdder() -> HotelTripAdder {
        let itin = activeItinerary
        let standardDays = itin.days.filter { !$0.isExperienceSuggestions }
        let addedHotelIds = Set(
            itin.days.flatMap(\.activities).compactMap { $0.kind == .hotel ? $0.hotelId : nil }
        )
        return HotelTripAdder(days: standardDays, addedHotelIds: addedHotelIds) { hotel, day in
            addHotel(hotel, to: day)
        }
    }

    private func addHotel(_ hotel: Hotel, to day: ItineraryDay) {
        var itin = activeItinerary
        guard let di = itin.days.firstIndex(where: { $0.id == day.id }) else { return }
        let activity = ItineraryActivity(
            id: "hotel_\(UUID().uuidString.prefix(8))",
            name: hotel.name,
            detail: hotel.chineseName == hotel.name ? "" : hotel.chineseName,
            attractionId: nil,
            cityId: day.activities.first?.cityId,
            hasAudio: false,
            kind: .hotel,
            hotelId: hotel.id,
            sourcePlatform: "platform"
        )
        var days = itin.days
        days[di] = days[di].withActivities(days[di].activities + [activity])
        itin = itin.withDays(days).markingUserEdited()
        working = itin
        appEnv.preferences.saveItinerary(itin)
    }

    private var flightButtons: some View {
        let platforms = appEnv.contentMode.branding.flightPlatforms
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(platforms) { platform in
                if let url = URL(string: platform.urlTemplate) {
                    Link("\(platform.label) →", destination: url)
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                }
            }
        }
    }

    private func bookBlock<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.FontToken.inter(13, weight: .medium))
            Text(subtitle)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
            content()
        }
    }
}

/// Loads hotels when the sheet opens (avoids empty/stale list from sheet timing).
private struct HotelSearchSheet: View {
    @Environment(AppEnvironment.self) private var appEnv
    let cityId: String
    let cityName: String
    var adder: HotelTripAdder? = nil

    @State private var hotels: [Hotel] = []
    @State private var isLoading = true
    @State private var loadError: String?

    var body: some View {
        HotelSearchView(
            cityName: cityName,
            hotels: hotels,
            isLoading: isLoading,
            loadError: loadError,
            usesLiveContent: appEnv.contentMode.useRemoteContent,
            adder: adder
        )
        .task(id: cityId) {
            await loadHotels()
        }
    }

    private func loadHotels() async {
        isLoading = true
        loadError = nil
        await ContentCacheStore.shared.remove(key: ContentCacheKey.hotels(cityId: cityId))
        do {
            hotels = try await appEnv.content.fetchHotels(cityId: cityId)
            loadError = nil
        } catch {
            hotels = []
            loadError = JSONCoding.describe(error)
        }
        isLoading = false
    }
}

struct HotelSearchView: View {
    let cityName: String
    let hotels: [Hotel]
    var isLoading: Bool = false
    var loadError: String? = nil
    var usesLiveContent: Bool = true
    var adder: HotelTripAdder? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Text("✅ Showing foreigner-friendly hotels only")
                        .font(Theme.FontToken.inter(11))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Theme.ColorToken.backgroundSubtle)

                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                    } else if let loadError {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Could not load hotels")
                                .font(Theme.FontToken.inter(13, weight: .medium))
                            Text(loadError)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 24)
                    } else if hotels.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("No hotels found for this city.")
                                .font(Theme.FontToken.inter(13, weight: .medium))
                            Text(usesLiveContent
                                ? "Check the admin: city, enabled status, and foreign-guest acceptance must match this trip."
                                : "Turn on Live content in app settings to load hotels from the CMS.")
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(hotels) { hotel in
                            HotelCardView(hotel: hotel, adder: adder)
                        }
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
            }
            .navigationTitle(cityName)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct HotelCardView: View {
    let hotel: Hotel
    var adder: HotelTripAdder? = nil
    @State private var showDayPicker = false

    @ViewBuilder
    private var addToTripControl: some View {
        if let adder {
            if adder.addedHotelIds.contains(hotel.id) {
                Label("Added", systemImage: "checkmark.circle.fill")
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.success)
            } else {
                Button {
                    showDayPicker = true
                } label: {
                    Label("Add to trip", systemImage: "plus")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .confirmationDialog("Add to which day?", isPresented: $showDayPicker, titleVisibility: .visible) {
                    ForEach(adder.days) { day in
                        Button("Day \(day.dayIndex) · \(day.dateLabel.isEmpty ? "Day \(day.dayIndex)" : day.dateLabel)") {
                            adder.add(hotel, day)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CoverImageView(path: hotel.coverImagePath, height: 140, cornerRadius: 6)

            HStack(alignment: .top, spacing: 8) {
                Text(hotel.name)
                    .font(Theme.FontToken.playfair(16, weight: .semibold))
                Spacer(minLength: 0)
                addToTripControl
            }
            if hotel.chineseName != hotel.name {
                Text(hotel.chineseName)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Text(String(repeating: "★", count: max(hotel.stars, 1)))
                .font(Theme.FontToken.inter(11))
            if let note = hotel.englishStaffNote, !note.isEmpty {
                HStack(alignment: .top, spacing: 4) {
                    Text("✅")
                        .font(Theme.FontToken.inter(11))
                    Text(HTMLContentView.plainText(from: note))
                        .font(Theme.FontToken.inter(11))
                }
            } else if !hotel.hasEnglishStaff {
                Text("⚠️ No English-speaking staff")
                    .font(Theme.FontToken.inter(11))
            }
            Text("✅ Registered for foreign guests")
                .font(Theme.FontToken.inter(11))
            if let address = hotel.displayAddressLine, hotel.canOpenInMaps {
                Button {
                    MapNavigation.open(
                        name: hotel.name,
                        addressZh: hotel.addressZh,
                        addressEn: hotel.addressEn,
                        latitude: hotel.latitude,
                        longitude: hotel.longitude
                    )
                } label: {
                    HStack(alignment: .top, spacing: 4) {
                        Text("📍")
                            .font(Theme.FontToken.inter(11))
                        Text(address)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.accent)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        Text("Maps →")
                            .font(Theme.FontToken.inter(10, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                }
                .buttonStyle(.plain)
            } else if let address = hotel.displayAddressLine {
                HStack(alignment: .top, spacing: 4) {
                    Text("📍")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    Text(address)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            if let loc = hotel.locationNote, !loc.isEmpty {
                HStack(alignment: .top, spacing: 4) {
                    Text("📍")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    Text(HTMLContentView.plainText(from: loc))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            Text("From $\(hotel.priceMinUsd)/night")
                .font(Theme.FontToken.inter(12, weight: .medium))
            if !hotel.bookingLinks.isEmpty {
                HStack(spacing: 8) {
                    ForEach(hotel.bookingLinks) { link in
                        if let url = URL(string: link.url) {
                            Link(link.label, destination: url)
                                .font(Theme.FontToken.inter(10, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                        }
                    }
                }
            }
            if let tip = hotel.languageTip, !tip.isEmpty {
                Text(HTMLContentView.plainText(from: tip))
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}

// MARK: - Share

struct ShareItinerarySheet: View {
    private enum ShareMode: String, CaseIterable, Identifiable {
        case image
        case link

        var id: String { rawValue }

        var title: String {
            switch self {
            case .image: String(localized: "Image")
            case .link: String(localized: "Link")
            }
        }
    }

    @Environment(AppEnvironment.self) private var appEnv
    let itinerary: SampleItinerary
    @Environment(\.dismiss) private var dismiss

    @State private var mode: ShareMode = .image
    @State private var shareImage: UIImage?
    @State private var imageRenderError: String?

    @State private var shareSlug: String?
    @State private var isSavingLink = false
    @State private var linkSaveError: String?
    @State private var linkCopied = false

    @State private var showSystemShare = false
    @State private var systemShareItems: [Any] = []
    @State private var showLogin = false

    private var canShareLink: Bool {
        appEnv.auth.isAuthenticated || AppConfig.useMock
    }

    init(itinerary: SampleItinerary) {
        self.itinerary = itinerary
        _shareSlug = State(initialValue: itinerary.shareSlug)
    }

    private var branding: AppBranding { appEnv.contentMode.branding }

    private var shareURL: URL? {
        guard let slug = shareSlug else { return nil }
        return ItineraryShareService.shareURL(slug: slug, branding: branding)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Share Itinerary"))
                    .font(Theme.FontToken.playfair(18, weight: .semibold))
                Text(itinerary.title)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                Picker(String(localized: "Share as"), selection: $mode) {
                    ForEach(ShareMode.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                switch mode {
                case .image:
                    imageSection
                case .link:
                    linkSection
                }
            }
            .padding(Theme.screenPadding)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
            .sheet(isPresented: $showSystemShare) {
                ShareSheet(items: systemShareItems)
            }
            .loginSheet(isPresented: $showLogin, appEnv: appEnv)
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated, mode == .link {
                    Task { await ensureShareLink() }
                }
            }
            .onChange(of: mode) { _, newMode in
                switch newMode {
                case .image:
                    if shareImage == nil, imageRenderError == nil {
                        Task { await generateImage() }
                    }
                case .link:
                    if canShareLink {
                        Task { await ensureShareLink() }
                    }
                }
            }
            .task {
                switch mode {
                case .image:
                    await generateImage()
                case .link:
                    if canShareLink {
                        await ensureShareLink()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var imageSection: some View {
        Text(String(localized: "Create a trip poster you can send to friends."))
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)

        if let shareImage {
            ScrollView {
                Image(uiImage: shareImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            }
            .frame(maxHeight: 360)

            Button {
                systemShareItems = [shareImage]
                showSystemShare = true
                TelemetryService.shared.logEvent("itinerary_share_image")
            } label: {
                Text(String(localized: "Share Image"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.ColorToken.accent)
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        } else if let imageRenderError {
            Text(imageRenderError)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(.red)
            Button(String(localized: "Try Again")) {
                Task { await generateImage() }
            }
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
        } else {
            ProgressView(String(localized: "Creating image…"))
                .frame(maxWidth: .infinity, minHeight: 180)
        }
    }

    @ViewBuilder
    private var linkSection: some View {
        if !canShareLink {
            AccountSignInPrompt(
                title: String(localized: "Sign in to share a link"),
                message: String(localized: "Trip links are saved to your account so friends can open them in the app or browser.")
            ) {
                showLogin = true
            }
        } else {
            linkShareContent
        }
    }

    @ViewBuilder
    private var linkShareContent: some View {
        Text(String(localized: "Anyone with the link can view this trip read-only in a browser or the app."))
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)

        if AppConfig.useMock {
            Text(String(localized: "Link sharing requires a signed-in Supabase account."))
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.warning)
        } else if let shareURL {
            Text(shareURL.absoluteString)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.accent)
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.ColorToken.backgroundSubtle)

            HStack(spacing: 10) {
                Button {
                    UIPasteboard.general.string = shareURL.absoluteString
                    linkCopied = true
                } label: {
                    Text(linkCopied ? String(localized: "Copied!") : String(localized: "Copy Link"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.ColorToken.textPrimary)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                Button {
                    systemShareItems = [shareURL]
                    showSystemShare = true
                    TelemetryService.shared.logEvent("itinerary_share_link")
                } label: {
                    Text(String(localized: "Share Link"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.ColorToken.accent)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        } else if isSavingLink {
            ProgressView(String(localized: "Preparing link…"))
                .frame(maxWidth: .infinity, minHeight: 120)
        } else if let linkSaveError {
            Text(linkSaveError)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(.red)
            Button(String(localized: "Try Again")) {
                Task { await ensureShareLink() }
            }
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
        }
    }

    private func generateImage() async {
        imageRenderError = nil
        shareImage = nil
        await Task.yield()
        guard let image = ItineraryShareImageRenderer.render(itinerary: itinerary) else {
            imageRenderError = String(localized: "Could not create share image. Please try again.")
            return
        }
        shareImage = image
    }

    private func ensureShareLink() async {
        guard canShareLink else { return }
        guard !AppConfig.useMock else { return }
        if isSavingLink { return }

        if let existing = shareSlug ?? itinerary.shareSlug, !existing.isEmpty, itinerary.isShared {
            shareSlug = existing
            return
        }

        isSavingLink = true
        linkSaveError = nil
        linkCopied = false
        defer { isSavingLink = false }

        let slug = shareSlug ?? itinerary.shareSlug ?? ItineraryShareService.makeSlug()
        var updated = itinerary
        updated.shareSlug = slug
        updated.isShared = true
        shareSlug = slug

        appEnv.preferences.updateItineraryShareState(updated)
        await appEnv.profileSync.syncItineraries()
        TelemetryService.shared.logEvent("itinerary_share_link_enabled")
    }
}
