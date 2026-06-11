import SwiftUI

struct PlanAddAttractionContext: Identifiable {
    let id = UUID()
    let dayIndex: Int
    let cityIds: [String]
}

enum PlanTripCities {
    static func cityIds(
        itinerary: SampleItinerary,
        selectedCityIds: [String],
        attractionCache: [String: Attraction] = [:]
    ) -> [String] {
        var ids = Set(selectedCityIds)
        for day in itinerary.days {
            for act in day.activities {
                if let cid = act.cityId, !cid.isEmpty { ids.insert(cid) }
                if let aid = act.attractionId, let cityId = attractionCache[aid]?.cityId {
                    ids.insert(cityId)
                }
            }
            let legacy = day.cityName.trimmingCharacters(in: .whitespacesAndNewlines)
            if !legacy.isEmpty {
                ids.insert(legacy.lowercased().replacingOccurrences(of: " ", with: "_"))
            }
        }
        if ids.isEmpty, !itinerary.routeSummary.isEmpty {
            itinerary.routeSummary
                .components(separatedBy: CharacterSet(charactersIn: "→·,"))
                .map { $0.trimmingCharacters(in: .whitespaces).lowercased().replacingOccurrences(of: " ", with: "_") }
                .filter { !$0.isEmpty }
                .forEach { ids.insert($0) }
        }
        return ids.sorted()
    }

    static func visitedCityNames(
        day: ItineraryDay,
        cityNameById: [String: String],
        attractionCache: [String: Attraction]
    ) -> String {
        var seen: [String] = []
        for act in day.activities {
            let cid = act.cityId ?? act.attractionId.flatMap { attractionCache[$0]?.cityId }
            guard let cid, let name = cityNameById[cid], !seen.contains(name) else { continue }
            seen.append(name)
        }
        return seen.joined(separator: " · ")
    }
}

/// Non-conversational flow: cities → dates → AI generate → edit card → save.
struct PlanCreateFlowView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var onSaved: (SampleItinerary) -> Void = { _ in }

    @State private var step: Step = .cities
    @State private var search = ""
    @State private var cities: [City] = []
    @State private var selectedCityIds: Set<String> = []
    @State private var arrivalDate = Date()
    @State private var departureDate = Calendar.current.date(byAdding: .day, value: 9, to: Date()) ?? Date()
    @State private var showArrivalPicker = false
    @State private var showDeparturePicker = false
    @State private var generationMessage = ""
    @State private var failureMessage: String?
    @State private var draftItinerary: SampleItinerary?
    @State private var attractionCache: [String: Attraction] = [:]
    @State private var addAttractionContext: PlanAddAttractionContext?

    private enum Step {
        case cities
        case dates
        case generating
        case failed
        case review
    }

    private var filteredCities: [City] {
        guard !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return cities }
        let q = search.lowercased()
        return cities.filter {
            $0.name.lowercased().contains(q)
                || $0.chineseName.lowercased().contains(q)
                || $0.id.lowercased().contains(q)
        }
    }

    private var popularCities: [City] {
        Array(cities.sorted { $0.attractionCount > $1.attractionCount }.prefix(6))
    }

    private var activityDays: Int {
        PlanTripDateMath.activityDayCount(arrival: arrivalDate, departure: departureDate)
    }

    var body: some View {
        Group {
            switch step {
            case .cities:
                citiesStep
            case .dates:
                datesStep
            case .generating:
                generatingStep
            case .failed:
                failedStep
            case .review:
                reviewStep
            }
        }
        .background(Theme.ColorToken.background)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .task { await loadCities() }
        .sheet(isPresented: $showArrivalPicker) {
            planDateSheet(
                title: String(localized: "Start date"),
                selection: $arrivalDate,
                range: Date()...
            ) {
                departureDate = PlanTripDateMath.clampDeparture(departureDate, arrival: arrivalDate)
                showArrivalPicker = false
            }
        }
        .sheet(isPresented: $showDeparturePicker) {
            planDateSheet(
                title: String(localized: "End date"),
                selection: $departureDate,
                range: PlanTripDateMath.departureRange(forArrival: arrivalDate)
            ) {
                showDeparturePicker = false
            }
        }
        .sheet(item: $addAttractionContext) { ctx in
            PlanAttractionPickerSheet(cityIds: ctx.cityIds, dayIndex: ctx.dayIndex) { attraction in
                appendAttraction(attraction, dayIndex: ctx.dayIndex)
                addAttractionContext = nil
            }
        }
    }

    private var navigationTitle: String {
        switch step {
        case .cities: String(localized: "Choose cities")
        case .dates: String(localized: "Travel dates")
        case .generating: String(localized: "Creating trip")
        case .failed: String(localized: "Something went wrong")
        case .review: String(localized: "Your itinerary")
        }
    }

    // MARK: - Cities (4.3)

    private var citiesStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Select one or more cities for your trip.")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    TextField(String(localized: "Search cities"), text: $search)
                        .font(Theme.FontToken.inter(13))
                }
                .padding(12)
                .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))

                if !selectedCityIds.isEmpty {
                    selectedCityChips
                }

                if !popularCities.isEmpty && search.isEmpty {
                    Text("Popular")
                        .sectionTitleStyle()
                    cityGrid(popularCities)
                }

                Text("All cities")
                    .sectionTitleStyle()
                cityGrid(filteredCities)

                Group {
                    primaryButton(String(localized: "Continue")) {
                        step = .dates
                    }
                }
                .disabled(selectedCityIds.isEmpty)
                .opacity(selectedCityIds.isEmpty ? 0.45 : 1)
            }
            .padding(Theme.screenPadding)
        }
    }

    private var selectedCityChips: some View {
        FlowLayoutTags(tags: cities.filter { selectedCityIds.contains($0.id) }.map(\.name))
    }

    private func cityGrid(_ items: [City]) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(items) { city in
                Button {
                    toggleCity(city.id)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(city.emoji ?? "📍")
                            .font(.title2)
                        Text(city.name)
                            .font(Theme.FontToken.inter(13, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.textPrimary)
                            .lineLimit(1)
                        Text(city.chineseName)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        selectedCityIds.contains(city.id)
                            ? Theme.ColorToken.backgroundSubtle
                            : Theme.ColorToken.background
                    )
                    .overlay(
                        Rectangle().stroke(
                            selectedCityIds.contains(city.id)
                                ? Theme.ColorToken.accent
                                : Theme.ColorToken.border,
                            lineWidth: 1
                        )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Dates (4.4)

    private var datesStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Pick your trip start and end dates. Activity days exclude both travel days.")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                dateRow(label: String(localized: "Start date"), date: arrivalDate) {
                    showArrivalPicker = true
                }
                dateRow(label: String(localized: "End date"), date: departureDate) {
                    showDeparturePicker = true
                }

                Text(String(format: String(localized: "%lld activity days"), activityDays))
                    .font(Theme.FontToken.inter(12, weight: .medium))
                Text(String(localized: "Excludes start and end days"))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                primaryButton(String(localized: "Generate itinerary")) {
                    startGeneration()
                }
            }
            .padding(Theme.screenPadding)
        }
    }

    // MARK: - Generating (4.5) / Failed (4.6)

    private var generatingStep: some View {
        VStack(spacing: 24) {
            Spacer()
            ProgressView()
                .scaleEffect(1.4)
            Text(generationMessage)
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var failedStep: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Text(failureMessage ?? String(localized: "Could not generate your itinerary."))
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            primaryButton(String(localized: "Try again")) {
                startGeneration()
            }
            .padding(.horizontal, Theme.screenPadding)
            Button(String(localized: "Back to dates")) {
                step = .dates
            }
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textMuted)
            Spacer()
        }
    }

    // MARK: - Review (4.7–4.10)

    private var reviewStep: some View {
        VStack(spacing: 0) {
            if let draftItinerary {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(draftItinerary.title)
                                .font(Theme.FontToken.playfair(18, weight: .semibold))
                            Text(draftItinerary.meta)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                            Text(draftItinerary.routeSummary)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textSecondary)
                        }

                        ForEach(draftItinerary.days.indices, id: \.self) { dayIndex in
                            reviewDaySection(dayIndex: dayIndex, day: draftItinerary.days[dayIndex])
                        }
                    }
                    .padding(Theme.screenPadding)
                    .padding(.bottom, 80)
                }

                VStack(spacing: 0) {
                    Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                    primaryButton(String(localized: "Save trip")) {
                        saveDraft()
                    }
                    .padding(Theme.screenPadding)
                    .background(Theme.ColorToken.background)
                }
            }
        }
    }

    @ViewBuilder
    private func reviewDaySection(dayIndex: Int, day: ItineraryDay) -> some View {
        let cityNameById = Dictionary(uniqueKeysWithValues: cities.map { ($0.id, $0.name) })
        let visited = day.isExperienceSuggestions
            ? (day.experienceCityId.flatMap { cityNameById[$0] } ?? "")
            : PlanTripCities.visitedCityNames(
                day: day,
                cityNameById: cityNameById,
                attractionCache: attractionCache
            )

        VStack(alignment: .leading, spacing: 12) {
            Text(day.dateLabel)
                .font(Theme.FontToken.playfair(14, weight: .semibold))
            if !visited.isEmpty {
                Text(visited)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            if day.isExperienceSuggestions {
                ExperienceSuggestionsDayCard(
                    day: day,
                    cityDisplayName: visited
                ) {
                    askAssistantForExperience(day: day, cityName: visited)
                }
            } else {
                ForEach(day.activities) { activity in
                    reviewActivityRow(activity, dayIndex: dayIndex)
                }

                Button {
                    let ids = reviewTripCityIds()
                    addAttractionContext = PlanAddAttractionContext(dayIndex: dayIndex, cityIds: ids)
                } label: {
                    Label(String(localized: "Add attraction"), systemImage: "plus")
                        .font(Theme.FontToken.inter(12, weight: .medium))
                }
                .buttonStyle(.plain)
                .foregroundStyle(Theme.ColorToken.accent)
            }
        }
        .padding(16)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
    }

    private func askAssistantForExperience(day: ItineraryDay, cityName: String) {
        let topics = day.experienceItems.prefix(5).joined(separator: ", ")
        let prefill = cityName.isEmpty
            ? "Tell me more about these local experience ideas: \(topics)"
            : "Tell me more about local experiences in \(cityName): \(topics)"
        appEnv.navigation.presentAssistant(prefill: prefill)
    }

    private func reviewActivityRow(_ activity: ItineraryActivity, dayIndex: Int) -> some View {
        let tripIds = reviewTripCityIds()
        let activityCityId = activity.cityId ?? activity.attractionId.flatMap { attractionCache[$0]?.cityId }
        let cityLabel = activityCityId.flatMap { id in cities.first(where: { $0.id == id })?.name }

        return HStack(alignment: .top, spacing: 12) {
            Button {
                if let aid = activity.attractionId {
                    appEnv.navigation.openGuide(
                        attractionId: aid,
                        cityId: activityCityId,
                        presentation: .planDay(dayIndex: dayIndex)
                    )
                }
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    if let aid = activity.attractionId,
                       let path = attractionCache[aid]?.coverImagePath ?? attractionCache[aid]?.coverImages.first {
                        CoverImageView(path: path, height: 72, cornerRadius: 4)
                            .frame(width: 72, height: 72)
                            .fixedSize()
                    } else {
                        CoverImageView(path: nil, height: 72, cornerRadius: 4)
                            .frame(width: 72, height: 72)
                            .fixedSize()
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        if tripIds.count > 1, let cityLabel {
                            Text(cityLabel)
                                .font(Theme.FontToken.inter(10, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.textDisabled)
                        }
                        Text(activity.name)
                            .font(Theme.FontToken.inter(13, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.textPrimary)
                        Text(HTMLContentView.plainText(from: activity.detail))
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                            .lineLimit(3)
                        if activity.attractionId != nil {
                            Text(String(localized: "View in Guide →"))
                                .font(Theme.FontToken.inter(10, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.accent)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            .buttonStyle(.plain)

            Button {
                removeActivity(dayIndex: dayIndex, activityId: activity.id)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.ColorToken.urgent)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Actions

    private func loadCities() async {
        cities = (try? await appEnv.content.fetchCities()) ?? []
        selectedCityIds = Set(appEnv.preferences.selectedCityIds)
        departureDate = appEnv.preferences.departureDate
        departureDate = PlanTripDateMath.clampDeparture(departureDate, arrival: arrivalDate)
    }

    private func toggleCity(_ id: String) {
        if selectedCityIds.contains(id) {
            selectedCityIds.remove(id)
        } else {
            selectedCityIds.insert(id)
        }
    }

    private func startGeneration() {
        step = .generating
        failureMessage = nil
        generationMessage = String(localized: "Planning your days…")
        Task {
            let messages = [
                String(localized: "Planning your days…"),
                String(localized: "Matching attractions…"),
                String(localized: "Almost ready…"),
            ]
            for (i, msg) in messages.enumerated() {
                generationMessage = msg
                try? await Task.sleep(for: .milliseconds(i == 0 ? 400 : 700))
            }
            do {
                let trip = try await AIService.generateItinerary(
                    content: appEnv.content,
                    cities: Array(selectedCityIds),
                    days: activityDays,
                    useRemoteAI: appEnv.contentMode.effectiveUseRemoteAI,
                    userNotes: buildAINotes()
                )
                let enriched = enrichItinerary(trip)
                draftItinerary = enriched
                await loadAttractionCache(for: enriched)
                step = .review
            } catch {
                failureMessage = error.localizedDescription
                step = .failed
            }
        }
    }

    private func buildAINotes() -> String {
        "Arrival \(PlanTripDateMath.formatDisplayDate(arrivalDate)); departure \(PlanTripDateMath.formatDisplayDate(departureDate)); \(activityDays) full activity days (exclude arrival and departure). Days are date-only (not tied to one city). A single day may include attractions from multiple cities. Do not assign AM/PM time slots."
    }

    private func enrichItinerary(_ trip: SampleItinerary) -> SampleItinerary {
        let labels = PlanTripDateMath.activityDateLabels(arrival: arrivalDate, count: trip.days.count)
        let cityNames = cities.filter { selectedCityIds.contains($0.id) }.map(\.name)
        let route = cityNames.isEmpty ? trip.routeSummary : cityNames.joined(separator: " → ")
        let days = trip.days.enumerated().map { index, day in
            let label = labels.indices.contains(index) ? labels[index] : day.dateLabel
            return ItineraryDay(
                id: day.id,
                dayIndex: index + 1,
                dateLabel: label,
                cityName: "",
                costEstimate: day.costEstimate,
                activities: day.isExperienceSuggestions ? [] : day.activities.map { act in
                    ItineraryActivity(
                        id: act.id,
                        name: act.name,
                        detail: act.detail,
                        attractionId: act.attractionId,
                        cityId: act.cityId,
                        hasAudio: act.hasAudio
                    )
                },
                dayKind: day.dayKind,
                experienceItems: day.experienceItems,
                experienceCityId: day.experienceCityId
            )
        }
        return SampleItinerary(
            id: trip.id.isEmpty ? UUID().uuidString : trip.id,
            title: trip.title,
            meta: PlanTripDateMath.formatTripMeta(arrival: arrivalDate, departure: departureDate),
            routeSummary: route,
            estimatedBudget: trip.estimatedBudget,
            days: days,
            startDate: arrivalDate,
            endDate: departureDate
        )
    }

    private func loadAttractionCache(for trip: SampleItinerary) async {
        var cache: [String: Attraction] = [:]
        let ids = Set(trip.days.flatMap(\.activities).compactMap(\.attractionId))
        for id in ids {
            if let a = try? await appEnv.content.fetchAttraction(id: id) {
                cache[id] = a
            }
        }
        attractionCache = cache
    }

    private func reviewTripCityIds() -> [String] {
        let ids = PlanTripCities.cityIds(
            itinerary: draftItinerary ?? SampleItinerary(
                id: "", title: "", meta: "", routeSummary: "", estimatedBudget: "", days: []
            ),
            selectedCityIds: Array(selectedCityIds),
            attractionCache: attractionCache
        )
        if !ids.isEmpty { return ids }
        return Array(selectedCityIds)
    }

    private func removeActivity(dayIndex: Int, activityId: String) {
        guard var trip = draftItinerary, trip.days.indices.contains(dayIndex) else { return }
        var day = trip.days[dayIndex]
        day = day.withActivities(day.activities.filter { $0.id != activityId })
        var days = trip.days
        days[dayIndex] = day
        draftItinerary = SampleItinerary(
            id: trip.id,
            title: trip.title,
            meta: trip.meta,
            routeSummary: trip.routeSummary,
            estimatedBudget: trip.estimatedBudget,
            days: days
        )
    }

    private func appendAttraction(_ attraction: Attraction, dayIndex: Int) {
        guard var trip = draftItinerary, trip.days.indices.contains(dayIndex) else { return }
        var day = trip.days[dayIndex]
        let activity = ItineraryActivity(
            id: UUID().uuidString,
            name: attraction.name,
            detail: HTMLContentView.plainText(from: attraction.summary ?? attraction.shortDescription ?? ""),
            attractionId: attraction.id,
            cityId: attraction.cityId,
            hasAudio: attraction.audioGuideCount > 0
        )
        day = day.withActivities(day.activities + [activity])
        var days = trip.days
        days[dayIndex] = day
        draftItinerary = SampleItinerary(
            id: trip.id,
            title: trip.title,
            meta: trip.meta,
            routeSummary: trip.routeSummary,
            estimatedBudget: trip.estimatedBudget,
            days: days
        )
        attractionCache[attraction.id] = attraction
    }

    private func saveDraft() {
        guard let trip = draftItinerary else { return }
        appEnv.preferences.selectedCityIds = Array(selectedCityIds)
        appEnv.preferences.departureDate = departureDate
        appEnv.preferences.saveItinerary(trip)
        onSaved(trip)
        dismiss()
    }

    // MARK: - UI helpers

    private func dateRow(label: String, date: Date, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(Theme.FontToken.inter(13))
                Spacer()
                Text(PlanTripDateMath.formatDisplayDate(date))
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
            .padding(.vertical, 12)
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func primaryButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.FontToken.inter(12, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Theme.ColorToken.textPrimary)
        }
        .buttonStyle(.plain)
    }

    private func planDateSheet(
        title: String,
        selection: Binding<Date>,
        range: PartialRangeFrom<Date>,
        onDone: @escaping () -> Void
    ) -> some View {
        NavigationStack {
            DatePicker(title, selection: selection, in: range, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: onDone)
                    }
                }
        }
        .presentationDetents([.medium])
    }

    private func planDateSheet(
        title: String,
        selection: Binding<Date>,
        range: ClosedRange<Date>,
        onDone: @escaping () -> Void
    ) -> some View {
        NavigationStack {
            DatePicker(title, selection: selection, in: range, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: onDone)
                    }
                }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Attraction picker (4.9)

struct PlanAttractionPickerSheet: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let cityIds: [String]
    let dayIndex: Int
    var onSelect: (Attraction) -> Void

    @State private var allCities: [City] = []
    @State private var selectedCityId: String = ""
    @State private var attractions: [Attraction] = []
    @State private var search = ""
    @State private var preview: Attraction?

    private var tripCities: [City] {
        allCities.filter { cityIds.contains($0.id) }
    }

    private var filteredAttractions: [Attraction] {
        let q = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return attractions }
        return attractions.filter {
            $0.name.lowercased().contains(q)
                || $0.chineseName.lowercased().contains(q)
                || ($0.summary ?? "").lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if tripCities.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tripCities) { city in
                                Button {
                                    selectCity(city.id)
                                } label: {
                                    Text("\(city.emoji ?? "") \(city.name)")
                                        .font(Theme.FontToken.inter(11, weight: .medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedCityId == city.id
                                                ? Theme.ColorToken.textPrimary
                                                : Theme.ColorToken.backgroundSubtle
                                        )
                                        .foregroundStyle(
                                            selectedCityId == city.id ? .white : Theme.ColorToken.textSecondary
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, Theme.screenPadding)
                        .padding(.vertical, 10)
                    }
                    Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                }

                List(filteredAttractions) { attraction in
                    Button {
                        onSelect(attraction)
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            CoverImageView(
                                path: attraction.coverImagePath ?? attraction.coverImages.first,
                                height: 56,
                                cornerRadius: 4
                            )
                            .frame(width: 56, height: 56)
                            .fixedSize()
                            VStack(alignment: .leading, spacing: 4) {
                                Text(attraction.name)
                                    .font(Theme.FontToken.inter(13, weight: .medium))
                                    .foregroundStyle(Theme.ColorToken.textPrimary)
                                Text(HTMLContentView.plainText(from: attraction.summary ?? attraction.shortDescription ?? ""))
                                    .font(Theme.FontToken.inter(11))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .leading) {
                        Button {
                            preview = attraction
                        } label: {
                            Label(String(localized: "Preview"), systemImage: "eye")
                        }
                    }
                }
                .listStyle(.plain)
            }
            .searchable(text: $search, prompt: String(localized: "Search attractions"))
            .navigationTitle(String(localized: "Add attraction"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .task { await bootstrap() }
            .onChange(of: selectedCityId) { _, cityId in
                guard !cityId.isEmpty else { return }
                Task { await loadAttractions(cityId: cityId) }
            }
            .sheet(item: $preview) { attraction in
                NavigationStack {
                    AttractionDetailView(
                        listPreview: attraction,
                        route: GuideAttractionRoute(
                            attractionId: attraction.id,
                            cityId: attraction.cityId,
                            presentation: .planAddToDay(dayIndex: dayIndex)
                        )
                    )
                    .onAppear {
                        appEnv.navigation.guideAddToItineraryHandler = { selected in
                            onSelect(selected)
                            preview = nil
                            dismiss()
                        }
                    }
                    .onDisappear {
                        appEnv.navigation.guideAddToItineraryHandler = nil
                    }
                }
            }
        }
    }

    private func bootstrap() async {
        allCities = (try? await appEnv.content.fetchCities()) ?? []
        let available = tripCities
        let initial = available.first?.id ?? cityIds.first ?? ""
        selectedCityId = initial
        if !initial.isEmpty {
            await loadAttractions(cityId: initial)
        }
    }

    private func selectCity(_ cityId: String) {
        guard selectedCityId != cityId else { return }
        selectedCityId = cityId
    }

    private func loadAttractions(cityId: String) async {
        attractions = (try? await appEnv.content.fetchAttractions(cityId: cityId)) ?? []
    }
}
