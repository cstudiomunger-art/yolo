import SwiftUI

struct PrepareView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var cities: [City] = []
    @State private var checklist: [ChecklistItem] = []
    @State private var shopping: [ShoppingItem] = []
    @State private var reading: [ReadingItem] = []
    @State private var panel: PreparePanel = .checklist
    @State private var showShoppingList = false
    @State private var showReadingList = false

    enum PreparePanel {
        case checklist
        case done
    }

    private var completedCount: Int {
        checklist.filter { appEnv.preferences.completedChecklistIds.contains($0.id) }.count
    }

    var body: some View {
        mainView
            .background(Theme.ColorToken.background)
        .task {
            await bootstrap()
        }
        .onChange(of: appEnv.contentRevision) { _, _ in
            Task { await bootstrap() }
        }
        .sheet(isPresented: $showShoppingList) {
            ShoppingListView(items: shopping)
        }
        .sheet(isPresented: $showReadingList) {
            ReadingListView(items: reading)
        }
    }

    private var primarySelectedCityName: String {
        cities.first { appEnv.preferences.selectedCityIds.contains($0.id) }?.name ?? "China"
    }

    private var mainView: some View {
        VStack(spacing: 0) {
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
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 16)
            .padding(.bottom, 12)

            HStack(spacing: 0) {
                prepNavButton("Checklist", panel == .checklist) { panel = .checklist }
                prepNavButton("Done ✓", panel == .done) { panel = .done }
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
            }

            if panel == .checklist {
                checklistPanel
            } else {
                donePanel
            }
        }
    }

    private var subtitleLine: String {
        let names = cities.filter { appEnv.preferences.selectedCityIds.contains($0.id) }.map(\.name).joined(separator: " · ")
        return "\(names)  ·  \(appEnv.preferences.daysUntilDeparture) days to departure"
    }

    private func prepNavButton(_ title: String, _ active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(active ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(alignment: .bottom) {
                    if active {
                        Rectangle().fill(Theme.ColorToken.textPrimary).frame(height: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private var checklistPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                progressSummary

                ForEach(checklistSections, id: \.title) { section in
                    Text(section.title)
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textDisabled)
                        .textCase(.uppercase)
                        .padding(.top, 16)
                        .padding(.bottom, 8)

                    ForEach(section.items) { item in
                        ChecklistRowView(
                            item: item,
                            isDone: appEnv.preferences.completedChecklistIds.contains(item.id)
                        ) {
                            appEnv.preferences.toggleChecklistItem(item.id)
                        }
                    }
                }

                embeddedShopping
                embeddedReading
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
    }

    private struct ChecklistSection {
        let title: String
        let items: [ChecklistItem]
    }

    private var checklistSections: [ChecklistSection] {
        let entry = checklist.filter { $0.type == .entry }
        let universal = checklist.filter { $0.type == .universal }
        let cityItems = checklist.filter { $0.type == .city }
        var sections: [ChecklistSection] = []
        if !entry.isEmpty {
            sections.append(ChecklistSection(title: "Entry Requirements", items: entry))
        }
        if !universal.isEmpty {
            sections.append(ChecklistSection(title: "Essentials for Any Trip", items: universal))
        }
        let cityGroups = Dictionary(grouping: cityItems, by: \.groupTitle)
        for key in cityGroups.keys.sorted() {
            sections.append(ChecklistSection(title: key, items: cityGroups[key] ?? []))
        }
        return sections
    }

    private var progressSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(completedCount)")
                    .font(Theme.FontToken.playfair(28, weight: .bold))
                Text("of \(checklist.count) tasks complete")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Theme.ColorToken.border).frame(height: 2)
                    Rectangle()
                        .fill(Theme.ColorToken.accent)
                        .frame(width: geo.size.width * progressFraction, height: 2)
                }
            }
            .frame(height: 2)
            Text(remainingTimeLabel)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .padding(.bottom, 8)
    }

    private var remainingTimeLabel: String {
        let minutes = checklist
            .filter { !appEnv.preferences.completedChecklistIds.contains($0.id) }
            .compactMap(\.estimatedMinutes)
            .reduce(0, +)
        if minutes <= 0 { return "Almost done — finish your checklist" }
        return "~\(minutes) minutes of setup remaining"
    }

    private var progressFraction: CGFloat {
        guard !checklist.isEmpty else { return 0 }
        return CGFloat(completedCount) / CGFloat(checklist.count)
    }

    private var embeddedShopping: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("🛍 Pack Before You Go")
                    .sectionTitleStyle()
                Spacer()
                Button("View all →") { showShoppingList = true }
                    .font(Theme.FontToken.inter(10, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
                    .textCase(.uppercase)
            }
            ForEach(shopping.prefix(3)) { item in
                HStack(alignment: .top, spacing: 10) {
                    Rectangle()
                        .stroke(Theme.ColorToken.border, lineWidth: 1)
                        .frame(width: 14, height: 14)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.titleEn)
                            .font(Theme.FontToken.inter(12))
                        if let note = item.noteEn {
                            HTMLContentView(content: note, fontSize: 11, foregroundColor: Theme.ColorToken.textMuted)
                        }
                    }
                }
                .padding(.vertical, 7)
            }
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .leading) {
            Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
        }
        .padding(.top, 16)
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
        .padding(.top, 12)
    }

    private var donePanel: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("✅").font(.largeTitle)
                    Text("You're ready for China.")
                        .font(Theme.FontToken.playfair(20, weight: .semibold))
                    Text("\(subtitleLine.components(separatedBy: "·").first ?? "") preparation · \(completedCount)/\(checklist.count) tasks done")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Theme.ColorToken.backgroundSubtle)
                .overlay(alignment: .top) {
                    Rectangle().fill(Theme.ColorToken.success).frame(height: 2)
                }

                Text("What's next?")
                    .sectionTitleStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)
                    .padding(.bottom, 12)

                completionAction(icon: "🗺", title: "Plan my \(primarySelectedCityName) trip", sub: "Build your itinerary with AI") {
                    appEnv.navigation.openPlanGenerator()
                }
                completionAction(icon: "🏨", title: "Find foreigner-friendly hotels", sub: "Curated list, English staff noted") {
                    appEnv.navigation.openPlanGenerator()
                }
                completionAction(icon: "📖", title: "Explore \(primarySelectedCityName) audio guides", sub: "Prepare your tour experience") {
                    let cityId = appEnv.preferences.selectedCityIds.first ?? "beijing"
                    appEnv.navigation.openGuide(attractionId: "\(cityId)_forbidden_city", cityId: cityId)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 24)
        }
    }

    private func completionAction(icon: String, title: String, sub: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(icon)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(Theme.FontToken.inter(13))
                    Text(sub)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Text("→")
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            .padding(14)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
            .padding(.bottom, 10)
        }
        .buttonStyle(.plain)
    }

    private func bootstrap() async {
        await loadCities()
        if appEnv.preferences.selectedCityIds.isEmpty {
            appEnv.preferences.selectedCityIds = [cities.first?.id ?? "beijing"]
        }
        await loadContent()
    }

    private func loadCities() async {
        cities = (try? await appEnv.content.fetchCities()) ?? []
    }

    private func loadContent() async {
        let ids = appEnv.preferences.selectedCityIds
        checklist = (try? await appEnv.content.fetchChecklistItems(
            cityIds: ids,
            countryCode: appEnv.preferences.countryCode
        )) ?? []
        shopping = (try? await appEnv.content.fetchShoppingItems(cityIds: ids)) ?? []
        reading = (try? await appEnv.content.fetchReadingItems(cityIds: ids)) ?? []
    }
}

struct ChecklistRowView: View {
    let item: ChecklistItem
    let isDone: Bool
    let onToggle: () -> Void
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    ZStack {
                        Rectangle()
                            .stroke(Theme.ColorToken.border, lineWidth: 1)
                            .frame(width: 14, height: 14)
                        if isDone {
                            Image(systemName: "checkmark")
                                .font(.system(size: 9, weight: .bold))
                        }
                    }
                    Text(item.titleEn)
                        .font(Theme.FontToken.inter(14))
                        .foregroundStyle(isDone ? Theme.ColorToken.textMuted : Theme.ColorToken.textPrimary)
                        .strikethrough(isDone)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 6) {
                        ForEach(item.displayTags, id: \.self) { tag in
                            tagView(tag)
                        }
                        if let mins = item.estimatedMinutes {
                            Text("\(mins) min")
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                    }
                }
                .padding(.vertical, 11)
            }
            .buttonStyle(.plain)

            if hasDetail {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
                } label: {
                    Text(isExpanded ? "Hide details" : "Why this matters")
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 6)

                if isExpanded {
                    detailBlock
                        .padding(.bottom, 10)
                }
            }

            if let tip = item.culturalTip, !tip.isEmpty {
                HTMLContentView(content: tip, fontSize: 10, foregroundColor: Theme.ColorToken.textMuted)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.ColorToken.backgroundSubtle)
                    .overlay(alignment: .leading) {
                        Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
                    }
                    .padding(.bottom, 8)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private var hasDetail: Bool {
        item.whyImportant != nil || item.howToComplete != nil || !item.externalLinks.isEmpty
    }

    @ViewBuilder
    private var detailBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let why = item.whyImportant, !why.isEmpty {
                HTMLContentView(content: why, fontSize: 12)
            }
            if let how = item.howToComplete, !how.isEmpty {
                HTMLContentView(content: how, fontSize: 12, foregroundColor: Theme.ColorToken.textMuted)
            }
            ForEach(item.externalLinks, id: \.url) { link in
                if let url = URL(string: link.url) {
                    Link(link.label, destination: url)
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
    }

    @ViewBuilder
    private func tagView(_ tag: String) -> some View {
        let label = tag.capitalized
        let isUrgent = tag.lowercased() == "urgent"
        Text(label)
            .font(Theme.FontToken.inter(9, weight: .medium))
            .foregroundStyle(isUrgent ? Theme.ColorToken.urgent : Theme.ColorToken.accent)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .overlay(
                Rectangle().stroke(isUrgent ? Theme.ColorToken.urgent : Theme.ColorToken.accent, lineWidth: 1)
            )
    }
}

struct ShoppingListView: View {
    let items: [ShoppingItem]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.titleEn)
                    if let note = item.noteEn {
                        HTMLContentView(content: note, fontSize: 12, foregroundColor: Theme.ColorToken.textMuted)
                    }
                }
            }
            .navigationTitle("Pack Before You Go")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
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
    }
}
