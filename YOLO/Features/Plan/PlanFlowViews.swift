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
            endDate: saved?.endDate ?? itinerary.endDate
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
                ForEach(editableDays) { day in
                    Section {
                        daySectionHeader(day)

                        if day.isExperienceSuggestions {
                            ExperienceSuggestionsDayCard(
                                day: day,
                                cityDisplayName: experienceCityDisplayName(day)
                            )
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 10, trailing: 16))
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
                .onMove(perform: moveDays)
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
        guard let cid = day.experienceCityId else { return "" }
        return cityNameById[cid] ?? cid.capitalized
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
            .onChange(of: mode) { _, newMode in
                switch newMode {
                case .image:
                    if shareImage == nil, imageRenderError == nil {
                        Task { await generateImage() }
                    }
                case .link:
                    Task { await ensureShareLink() }
                }
            }
            .task {
                switch mode {
                case .image:
                    await generateImage()
                case .link:
                    await ensureShareLink()
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
