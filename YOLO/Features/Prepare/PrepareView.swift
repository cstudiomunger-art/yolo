import SwiftUI

struct PrepareView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var phase: PreparePhase = .citySelect
    @State private var cities: [City] = []
    @State private var draftCityIds: Set<String> = []
    @State private var checklist: [ChecklistItem] = []
    @State private var shopping: [ShoppingItem] = []
    @State private var reading: [ReadingItem] = []
    @State private var panel: PreparePanel = .checklist
    @State private var showShoppingList = false
    @State private var showReadingList = false

    enum PreparePhase {
        case citySelect
        case main
    }

    enum PreparePanel {
        case checklist
        case done
    }

    private var completedCount: Int {
        checklist.filter { appEnv.preferences.completedChecklistIds.contains($0.id) }.count
    }

    var body: some View {
        Group {
            switch phase {
            case .citySelect:
                citySelectView
            case .main:
                mainView
            }
        }
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

    private var citySelectView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Where are you going?")
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                Text("We'll customise your preparation checklist.")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .padding(.top, 4)
                    .padding(.bottom, 18)

                Text("Popular destinations")
                    .sectionTitleStyle()
                    .padding(.bottom, 10)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(cities) { city in
                        CityChipView(
                            city: city,
                            isSelected: draftCityIds.contains(city.id)
                        ) {
                            if draftCityIds.contains(city.id) {
                                draftCityIds.remove(city.id)
                            } else {
                                draftCityIds.insert(city.id)
                            }
                        }
                    }
                }

                Text("Going to multiple cities? Tap to select more.")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                Button {
                    guard !draftCityIds.isEmpty else { return }
                    appEnv.preferences.selectedCityIds = Array(draftCityIds)
                    phase = .main
                    Task {
                        await loadContent()
                        await appEnv.profileSync.pushToRemote()
                    }
                } label: {
                    Text("Continue with \(primaryCityName) →")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(.white)
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Theme.ColorToken.textPrimary)
                }
                .buttonStyle(.plain)
                .disabled(draftCityIds.isEmpty)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
    }

    private var primaryCityName: String {
        cities.first { draftCityIds.contains($0.id) }?.name ?? "Trip"
    }

    private var mainView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Button {
                    phase = .citySelect
                } label: {
                    Text("← Change city")
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

                let groups = Dictionary(grouping: checklist, by: \.groupTitle)
                ForEach(groups.keys.sorted(), id: \.self) { group in
                    Text(group)
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textDisabled)
                        .textCase(.uppercase)
                        .padding(.top, 16)
                        .padding(.bottom, 8)

                    ForEach(groups[group] ?? []) { item in
                        ChecklistRowView(
                            item: item,
                            isDone: appEnv.preferences.completedChecklistIds.contains(item.id)
                        ) {
                            appEnv.preferences.toggleChecklistItem(item.id)
                        }

                        if let tip = item.culturalTip, !tip.isEmpty {
                            Text("\"\(tip)\"")
                                .font(Theme.FontToken.inter(10))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.ColorToken.backgroundSubtle)
                                .overlay(alignment: .leading) {
                                    Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
                                }
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
                            Text(note)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
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
                    Text(item.synopsisEn)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                        .lineSpacing(3)
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

                completionAction(icon: "🗺", title: "Plan my Beijing trip", sub: "Build your itinerary with AI") {
                    appEnv.navigation.openAssistantPlanning()
                }
                completionAction(icon: "🏨", title: "Find foreigner-friendly hotels", sub: "Curated list, English staff noted") {
                    appEnv.navigation.openPlanGenerator()
                }
                completionAction(icon: "📖", title: "Explore Beijing audio guides", sub: "Prepare your tour experience") {
                    appEnv.navigation.openGuide(attractionId: "beijing_forbidden_city", cityId: "beijing")
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
        draftCityIds = Set(appEnv.preferences.selectedCityIds)
        await loadCities()
        if !appEnv.preferences.selectedCityIds.isEmpty {
            phase = .main
            await loadContent()
        }
    }

    private func loadCities() async {
        cities = (try? await appEnv.content.fetchCities()) ?? []
    }

    private func loadContent() async {
        let ids = appEnv.preferences.selectedCityIds
        checklist = (try? await appEnv.content.fetchChecklistItems(cityIds: ids)) ?? []
        shopping = (try? await appEnv.content.fetchShoppingItems(cityIds: ids)) ?? []
        reading = (try? await appEnv.content.fetchReadingItems(cityIds: ids)) ?? []
    }
}

struct CityChipView: View {
    let city: City
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                if let emoji = city.emoji {
                    Text(emoji).font(.system(size: 18))
                }
                Text(city.name)
                    .font(Theme.FontToken.playfair(13, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : Theme.ColorToken.textPrimary)
                Text(city.chineseName)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(isSelected ? .white.opacity(0.6) : Theme.ColorToken.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(isSelected ? Theme.ColorToken.textPrimary : Theme.ColorToken.background)
            .overlay(Rectangle().stroke(isSelected ? Theme.ColorToken.textPrimary : Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct ChecklistRowView: View {
    let item: ChecklistItem
    let isDone: Bool
    let onToggle: () -> Void

    var body: some View {
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
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
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
                        Text(note).font(.caption).foregroundStyle(.secondary)
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
