import SwiftUI

enum PlanRoute: Hashable {
    case create
    case detail(SampleItinerary)
}

struct FlowLayoutTags: View {
    let tags: [String]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(tags, id: \.self) { tag in
                Text("★ \(tag)")
                    .font(Theme.FontToken.inter(10))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 3)
                    .background(Theme.ColorToken.backgroundSubtle)
                    .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
            }
        }
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
        }
        .task(id: itinerary.id) {
            cities = (try? await appEnv.content.fetchCities()) ?? []
            await loadAttractionCache()
        }
        .onChange(of: editableDays) { _, _ in
            Task { await loadAttractionCache() }
        }
        .sheet(item: $addAttractionContext) { ctx in
            PlanAttractionPickerSheet(cityIds: ctx.cityIds, dayIndex: ctx.dayIndex) { attraction in
                appendAttraction(attraction, dayIndex: ctx.dayIndex)
                addAttractionContext = nil
            }
        }
    }

    private func loadAttractionCache() async {
        var cache: [String: Attraction] = [:]
        let ids = Set(currentItinerary.days.flatMap(\.activities).compactMap(\.attractionId))
        for id in ids {
            if let a = try? await appEnv.content.fetchAttraction(id: id) {
                cache[id] = a
            }
        }
        attractionCache = cache
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
        let activity = ItineraryActivity(
            id: UUID().uuidString,
            name: attraction.name,
            detail: HTMLContentView.plainText(from: attraction.summary ?? attraction.shortDescription ?? ""),
            attractionId: attraction.id,
            cityId: attraction.cityId,
            hasAudio: attraction.audioGuideCount > 0
        )
        var day = editableDays[dayIndex]
        day = day.withActivities(day.activities + [activity])
        editableDays[dayIndex] = day
        attractionCache[attraction.id] = attraction
        persistItineraryOrder()
    }

    private var currentItinerary: SampleItinerary {
        SampleItinerary(
            id: itinerary.id,
            title: itinerary.title,
            meta: itinerary.meta,
            routeSummary: itinerary.routeSummary,
            estimatedBudget: itinerary.estimatedBudget,
            days: editableDays.isEmpty ? itinerary.days : editableDays
        )
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
                ForEach(editableDays.indices, id: \.self) { dayIndex in
                    let day = editableDays[dayIndex]
                    Section {
                        daySectionHeader(day)

                        if day.isExperienceSuggestions {
                            ExperienceSuggestionsDayCard(
                                day: day,
                                cityDisplayName: experienceCityDisplayName(day)
                            ) {
                                askAssistantForExperience(day: day)
                            }
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Theme.ColorToken.background)
                        } else {
                            ForEach(day.activities.indices, id: \.self) { actIndex in
                                activityRow(day.activities[actIndex], dayIndex: dayIndex)
                            }
                            .onMove { source, destination in
                                moveActivities(dayIndex: dayIndex, from: source, to: destination)
                            }
                            .onDelete { offsets in
                                deleteActivities(dayIndex: dayIndex, at: offsets)
                            }

                            Button {
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
                        }
                    }
                }
                .onMove(perform: moveDays)
            }
            .listStyle(.plain)
            .environment(\.editMode, $editMode)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if editMode.isEditing {
                    Button("Done") {
                        editMode = .inactive
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
        guard let cid = day.experienceCityId else { return "" }
        return cityNameById[cid] ?? cid.capitalized
    }

    private func askAssistantForExperience(day: ItineraryDay) {
        let city = experienceCityDisplayName(day)
        let topics = day.experienceItems.prefix(5).joined(separator: ", ")
        let prefill = city.isEmpty
            ? "Tell me more about these local experience ideas: \(topics)"
            : "Tell me more about local experiences in \(city): \(topics)"
        appEnv.navigation.presentAssistant(prefill: prefill)
    }

    private func daySectionHeader(_ day: ItineraryDay) -> some View {
        let visited = day.isExperienceSuggestions
            ? experienceCityDisplayName(day)
            : PlanTripCities.visitedCityNames(
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
    }

    private func activityRow(_ activity: ItineraryActivity, dayIndex: Int) -> some View {
        let activityCityId = activity.cityId ?? activity.attractionId.flatMap { attractionCache[$0]?.cityId }
        let showCity = tripCityIds.count > 1
        let cityLabel = activityCityId.flatMap { cityNameById[$0] }

        return Button {
            if let aid = activity.attractionId {
                appEnv.navigation.openGuide(
                    attractionId: aid,
                    cityId: activityCityId,
                    presentation: .planDay(dayIndex: dayIndex)
                )
            }
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.ColorToken.textGhost)
                    .opacity(editMode.isEditing ? 1 : 0)

                activityCoverThumbnail(activity)

                VStack(alignment: .leading, spacing: 4) {
                    if showCity, let cityLabel {
                        Text(cityLabel)
                            .font(Theme.FontToken.inter(10, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.textDisabled)
                    }
                    Text(activity.name)
                        .font(Theme.FontToken.inter(13, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text(activity.detail)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineLimit(3)
                }

                Spacer(minLength: 0)

                if activity.hasAudio {
                    Text("🎧")
                        .font(Theme.FontToken.inter(10))
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .disabled(activity.attractionId == nil && !editMode.isEditing)
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

    private func deleteActivities(dayIndex: Int, at offsets: IndexSet) {
        guard editableDays.indices.contains(dayIndex) else { return }
        var activities = editableDays[dayIndex].activities
        activities.remove(atOffsets: offsets)
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
        persistItineraryOrder()
    }

    private func moveDays(from source: IndexSet, to destination: Int) {
        editableDays.move(fromOffsets: source, toOffset: destination)
        editableDays = editableDays.enumerated().map { index, day in
            day.withDayIndex(index + 1)
        }
    }

    private func moveActivities(dayIndex: Int, from source: IndexSet, to destination: Int) {
        guard editableDays.indices.contains(dayIndex) else { return }
        var activities = editableDays[dayIndex].activities
        activities.move(fromOffsets: source, toOffset: destination)
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
    }

    private func persistItineraryOrder() {
        editableDays = normalizeDays(editableDays)
        let updated = currentItinerary
        appEnv.preferences.saveItinerary(updated)
    }

    private func normalizeDays(_ days: [ItineraryDay]) -> [ItineraryDay] {
        days.map { day in
            if day.isExperienceSuggestions {
                return ItineraryDay(
                    id: day.id,
                    dayIndex: day.dayIndex,
                    dateLabel: day.dateLabel,
                    cityName: "",
                    costEstimate: day.costEstimate,
                    activities: [],
                    dayKind: .experienceSuggestions,
                    experienceItems: day.experienceItems,
                    experienceCityId: day.experienceCityId
                )
            }
            return ItineraryDay(
                id: day.id,
                dayIndex: day.dayIndex,
                dateLabel: day.dateLabel,
                cityName: "",
                costEstimate: day.costEstimate,
                activities: day.activities.map { act in
                    let resolvedCityId = act.cityId ?? act.attractionId.flatMap { attractionCache[$0]?.cityId }
                    return ItineraryActivity(
                        id: act.id,
                        name: act.name,
                        detail: act.detail,
                        attractionId: act.attractionId,
                        cityId: resolvedCityId,
                        hasAudio: act.hasAudio
                    )
                }
            )
        }
    }
}

// MARK: - Book

private struct HotelSheetCity: Identifiable {
    let id: String
    let displayName: String
}

struct BookYourTripView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let itinerary: SampleItinerary
    @State private var hotelSheetCity: HotelSheetCity?

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
            HotelSearchSheet(cityId: city.id, cityName: city.displayName)
        }
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

    @State private var hotels: [Hotel] = []
    @State private var isLoading = true
    @State private var loadError: String?

    var body: some View {
        HotelSearchView(
            cityName: cityName,
            hotels: hotels,
            isLoading: isLoading,
            loadError: loadError,
            usesLiveContent: appEnv.contentMode.useRemoteContent
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
                                ? "Check the admin: city, 启用, and 接待外国客人 must match this trip."
                                : "Turn on Live content in app settings (远程内容) to load hotels from the CMS.")
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(hotels) { hotel in
                            HotelCardView(hotel: hotel)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CoverImageView(path: hotel.coverImagePath, height: 140, cornerRadius: 6)

            Text(hotel.name)
                .font(Theme.FontToken.playfair(16, weight: .semibold))
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
    let itinerary: SampleItinerary
    @Environment(\.dismiss) private var dismiss
    @State private var copied = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Share Itinerary")
                    .font(Theme.FontToken.playfair(18, weight: .semibold))
                Text(itinerary.title)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                ScrollView {
                    Text(shareText)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Theme.ColorToken.backgroundSubtle)
                }

                Button {
                    UIPasteboard.general.string = shareText
                    copied = true
                } label: {
                    Text(copied ? "Copied!" : "📋 Copy Text")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.ColorToken.textPrimary)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(Theme.screenPadding)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var shareText: String {
        var lines = ["🇨🇳 \(itinerary.title)", "──────────────────"]
        for day in itinerary.days {
            lines.append(day.dateLabel)
            for act in day.activities {
                lines.append("  • \(act.name)")
            }
        }
        lines.append("──────────────────")
        lines.append("Made with ChinaGo app")
        return lines.joined(separator: "\n")
    }
}
