import SwiftUI

struct PrepareView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var cities: [City] = []
    @State private var allChecklistItems: [ChecklistItem] = []
    @State private var prepResult = PrepChecklistResult(
        entryItems: [],
        universalItems: [],
        citySections: [],
        showsCityPlaceholder: true
    )
    @State private var reading: [ReadingItem] = []
    @State private var cultureTips: [CultureTip] = []
    @State private var collapsedSections: Set<String> = []
    @State private var showReadingList = false
    @State private var selectedDetailItem: ChecklistItem?
    @State private var selectedCultureTip: CultureTip?
    @State private var restoreConfirmItem: ChecklistItem?
    @State private var checklistSettings = ChecklistSettings.fallback

    private var context: PrepChecklistContext {
        PrepChecklistContext(
            countryCode: appEnv.preferences.countryCode,
            activeItinerary: appEnv.preferences.activeItinerary
        )
    }

    private var items: [ChecklistItem] { prepResult.allItems }

    private func itemStatus(_ item: ChecklistItem) -> ChecklistItemStatus {
        appEnv.preferences.checklistStatus(for: item.id, type: item.type)
    }

    private var processedCount: Int {
        PrepProgressMetrics.processedCount(items: items, status: itemStatus)
    }

    private var isPrepComplete: Bool {
        PrepProgressMetrics.isComplete(items: items, status: itemStatus)
    }

    var body: some View {
        NavigationStack {
            mainScroll
                .background(Theme.ColorToken.background)
                .navigationDestination(item: $selectedDetailItem) { item in
                    ChecklistItemDetailView(item: item)
                }
                .navigationDestination(item: $selectedCultureTip) { tip in
                    CultureTipDetailView(tip: tip)
                }
        }
        .task { await bootstrap() }
        .onChange(of: appEnv.contentRevision) { _, _ in Task { await reloadContent(invalidateCache: true) } }
        .onChange(of: appEnv.preferences.activeItineraryId) { _, _ in Task { await reloadContent(invalidateCache: true) } }
        .onChange(of: appEnv.preferences.savedItineraries.count) { _, _ in Task { await reloadContent() } }
        .sheet(isPresented: $showReadingList) {
            ReadingListView(items: reading)
        }
        .alert("Restore this item?", isPresented: showRestoreAlert, presenting: restoreConfirmItem) { item in
            Button("Restore") {
                appEnv.preferences.restoreChecklistItem(item.id, type: item.type)
                restoreConfirmItem = nil
            }
            Button("Cancel", role: .cancel) { restoreConfirmItem = nil }
        }
    }

    private var showRestoreAlert: Binding<Bool> {
        Binding(get: { restoreConfirmItem != nil }, set: { if !$0 { restoreConfirmItem = nil } })
    }

    private var mainScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                if let banner = reminderBannerText {
                    reminderBanner(banner)
                }
                if isPrepComplete, !items.isEmpty {
                    completionBanner
                }
                progressSummary
                if appEnv.preferences.savedItineraries.count > 1 {
                    itineraryPicker
                }
                checklistSections
                if prepResult.showsCityPlaceholder {
                    cityPlaceholderCard
                }
                if context.hasSavedItinerary, !cultureTips.isEmpty {
                    cultureTipsSection
                }
                embeddedReading
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 24)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                appEnv.navigation.dismissModal()
                appEnv.navigation.openTab(.home)
            } label: {
                Text("← Home")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .buttonStyle(.plain)

            Text("Prepare")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
                .padding(.top, 2)

            Text(subtitleLine)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    private var subtitleLine: String {
        if let trip = context.activeItinerary {
            let names = context.itineraryCityIds.compactMap { id in cities.first { $0.id == id }?.name }
            let cityLine = names.isEmpty ? trip.routeSummary : names.joined(separator: " · ")
            return "Based on your \(cityLine) trip · \(appEnv.preferences.daysUntilDeparture) days"
        }
        return "Entry & essential prep · \(appEnv.preferences.daysUntilDeparture) days to departure"
    }

    private var completionBanner: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🎉 You're all set!")
                .font(Theme.FontToken.playfair(18, weight: .semibold))
            Text("Prep Complete")
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.success)
            Text("Your trip starts in \(appEnv.preferences.daysUntilDeparture) days. Enjoy China!")
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.success).frame(height: 2)
        }
        .padding(.bottom, 12)
    }

    private var progressSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(processedCount)")
                    .font(Theme.FontToken.playfair(28, weight: .bold))
                Text("/ \(max(items.count, 1)) done")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Theme.ColorToken.border).frame(height: 3)
                    Rectangle()
                        .fill(isPrepComplete ? Theme.ColorToken.success : Theme.ColorToken.accent)
                        .frame(width: geo.size.width * progressFraction, height: 3)
                }
            }
            .frame(height: 3)
        }
        .padding(.bottom, 12)
    }

    private var pendingCount: Int { max(items.count - processedCount, 0) }

    private var reminderBannerText: String? {
        PrepReminderService.bannerText(
            settings: checklistSettings,
            daysUntilDeparture: appEnv.preferences.daysUntilDeparture,
            pendingCount: pendingCount
        )
    }

    private func reminderBanner(_ text: String) -> some View {
        Text(text)
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(Theme.ColorToken.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.yellow.opacity(0.25))
            .padding(.bottom, 10)
    }

    private var progressFraction: CGFloat {
        guard !items.isEmpty else { return 0 }
        return CGFloat(processedCount) / CGFloat(items.count)
    }

    private var itineraryPicker: some View {
        Menu {
            ForEach(appEnv.preferences.savedItineraries) { trip in
                Button(trip.title) {
                    appEnv.preferences.activeItineraryId = trip.id
                    let cityIds = SampleItinerary.orderedCityIds(from: trip)
                    if !cityIds.isEmpty {
                        appEnv.preferences.selectedCityIds = cityIds
                    }
                }
            }
        } label: {
            HStack {
                Text(context.activeItinerary?.title ?? "Select trip")
                    .font(Theme.FontToken.inter(12, weight: .medium))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(Theme.ColorToken.textPrimary)
            .padding(.vertical, 8)
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var checklistSections: some View {
        ForEach(prepResult.displaySections) { section in
            checklistSectionHeader(section)
            if !collapsedSections.contains(section.id) {
                ForEach(section.items) { item in
                    ChecklistRowView(
                        item: item,
                        status: itemStatus(item),
                        onToggle: {
                            appEnv.preferences.toggleChecklistItem(item.id, type: item.type)
                        },
                        onOpenDetail: { selectedDetailItem = item },
                        onSkip: {
                            appEnv.preferences.skipChecklistItem(item.id, type: item.type)
                        },
                        onRestoreRequest: { restoreConfirmItem = item }
                    )
                }
            }
        }
    }

    private func checklistSectionHeader(_ section: PrepChecklistSection) -> some View {
        let isCollapsed = collapsedSections.contains(section.id)
        let doneCount = section.items.filter { itemStatus($0) == .done || itemStatus($0) == .skipped }.count
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                if isCollapsed {
                    collapsedSections.remove(section.id)
                } else {
                    collapsedSections.insert(section.id)
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(section.title)
                    .font(Theme.FontToken.inter(10, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textDisabled)
                    .textCase(.uppercase)
                Spacer()
                if isCollapsed {
                    Text("\(doneCount)/\(section.items.count)")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textGhost)
                }
                Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var cityPlaceholderCard: some View {
        VStack(spacing: 12) {
            Text("🗺")
                .font(.largeTitle)
            Text("Add your destination to see city-specific prep")
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
            Button {
                appEnv.navigation.dismissModal()
                appEnv.navigation.openTab(.plan)
            } label: {
                Text("Plan a Trip →")
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        .padding(.top, 16)
    }

    private var universalCultureTips: [CultureTip] {
        cultureTips.filter { $0.cityId == nil }
    }

    private var cityCultureTipGroups: [(cityName: String, tips: [CultureTip])] {
        context.itineraryCityIds.compactMap { cityId in
            let tips = cultureTips.filter { $0.cityId == cityId }
            guard !tips.isEmpty else { return nil }
            let name = cities.first { $0.id == cityId }?.name ?? cityId
            return (cityName: name, tips: tips)
        }
    }

    @ViewBuilder
    private var cultureTipsSection: some View {
        Text("Culture Tips")
            .font(Theme.FontToken.inter(10, weight: .medium))
            .foregroundStyle(Theme.ColorToken.textDisabled)
            .textCase(.uppercase)
            .padding(.top, 16)
            .padding(.bottom, 8)

        ForEach(universalCultureTips) { tip in
            cultureTipRow(tip)
        }

        ForEach(cityCultureTipGroups, id: \.cityName) { group in
            Text("\(group.cityName) Tips")
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textDisabled)
                .textCase(.uppercase)
                .padding(.top, 12)
                .padding(.bottom, 8)
            ForEach(group.tips) { tip in
                cultureTipRow(tip)
            }
        }
    }

    private func cultureTipRow(_ tip: CultureTip) -> some View {
        Button { selectedCultureTip = tip } label: {
            HStack(spacing: 10) {
                Text(tip.emoji)
                    .font(.system(size: 16))
                VStack(alignment: .leading, spacing: 3) {
                    Text(tip.title)
                        .font(Theme.FontToken.inter(14))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text(HTMLContentView.plainText(from: tip.preview))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Text(">")
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
            .padding(.vertical, 11)
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private var embeddedReading: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("📚 Read Before You Go")
                    .sectionTitleStyle()
                Spacer()
                Button("Full list →") { showReadingList = true }
                    .font(Theme.FontToken.inter(10, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
                    .textCase(.uppercase)
            }
            ForEach(reading.prefix(2)) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(Theme.FontToken.playfair(15, weight: .semibold))
                    Text("\(item.author) · \(item.genre)")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    HTMLContentView(content: item.synopsisEn, fontSize: 12, lineSpacing: 3)
                }
                .padding(.vertical, 8)
            }
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .leading) {
            Rectangle().fill(Theme.ColorToken.border).frame(width: 2)
        }
        .padding(.top, 16)
    }

    private func bootstrap() async {
        await loadCities()
        await reloadContent(invalidateCache: true)
    }

    private func loadCities() async {
        cities = (try? await appEnv.content.fetchCities()) ?? []
    }

    private func reloadContent(invalidateCache: Bool = false) async {
        let ctx = context
        let cityIds = ctx.hasSavedItinerary ? ctx.itineraryCityIds : []
        if ctx.hasSavedItinerary, !cityIds.isEmpty {
            appEnv.preferences.selectedCityIds = cityIds
        }

        if invalidateCache, let repo = appEnv.content as? CachingContentRepository {
            await repo.invalidateCultureTips()
        }

        allChecklistItems = (try? await appEnv.content.fetchChecklistItems(
            cityIds: cityIds,
            countryCode: appEnv.preferences.countryCode
        )) ?? []

        prepResult = PrepChecklistAssembler.assemble(
            allItems: allChecklistItems,
            context: ctx,
            cities: cities
        )

        let readingCityIds = cityIds.isEmpty ? appEnv.preferences.selectedCityIds : cityIds
        reading = (try? await appEnv.content.fetchReadingItems(cityIds: readingCityIds)) ?? []
        cultureTips = (try? await appEnv.content.fetchCultureTips(cityIds: cityIds)) ?? []
        checklistSettings = (try? await appEnv.content.fetchChecklistSettings()) ?? .fallback

        PrepReminderService.scheduleIfNeeded(
            settings: checklistSettings,
            daysUntilDeparture: appEnv.preferences.daysUntilDeparture,
            pendingCount: pendingCount
        )
        await appEnv.rescheduleTripReminders()
    }
}

struct ChecklistRowView: View {
    let item: ChecklistItem
    let status: ChecklistItemStatus
    let onToggle: () -> Void
    let onOpenDetail: () -> Void
    let onSkip: () -> Void
    let onRestoreRequest: () -> Void

    private var isDone: Bool { status == .done }
    private var isSkipped: Bool { status == .skipped }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Button(action: onToggle) {
                    checkbox
                }
                .buttonStyle(.plain)
                .disabled(isSkipped)

                Button(action: onOpenDetail) {
                    HStack(spacing: 8) {
                        Text(item.titleEn)
                            .font(Theme.FontToken.inter(14))
                            .foregroundStyle(rowTextColor)
                            .strikethrough(isDone)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        if isSkipped {
                            Button(action: onRestoreRequest) {
                                Text("Skipped")
                                    .font(Theme.FontToken.inter(9, weight: .medium))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        } else {
                            Text(">")
                                .font(Theme.FontToken.inter(11, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.textGhost)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 11)
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if !isSkipped, !isDone {
                Button(action: onSkip) {
                    Text("Skip")
                }
                .tint(.orange)
            }
        }
    }

    private var checkbox: some View {
        ZStack {
            Rectangle()
                .stroke(Theme.ColorToken.border, lineWidth: 1)
                .frame(width: 14, height: 14)
            if isDone {
                Image(systemName: "checkmark")
                    .font(.system(size: 9, weight: .bold))
            }
        }
    }

    private var rowTextColor: Color {
        if isSkipped { return Theme.ColorToken.textDisabled }
        return isDone ? Theme.ColorToken.textMuted : Theme.ColorToken.textPrimary
    }
}

struct ReadingListView: View {
    let items: [ReadingItem]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(items) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title).font(Theme.FontToken.playfair(16, weight: .semibold))
                    Text("\(item.author) · \(item.genre)")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    Text(item.synopsisEn)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Reading List")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .sheetDragToDismiss()
    }
}
