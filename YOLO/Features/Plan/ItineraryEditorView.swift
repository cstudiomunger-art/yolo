import SwiftUI

/// Full trip editor: metadata + days/activities (reorder, add, remove).
struct ItineraryEditorView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let itinerary: SampleItinerary
    var onSave: (SampleItinerary) -> Void = { _ in }

    @State private var title: String = ""
    @State private var meta: String = ""
    @State private var routeSummary: String = ""
    @State private var estimatedBudget: String = ""
    @State private var editableDays: [ItineraryDay] = []
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationStack {
            List {
                if hasBookingTrace {
                    Section {
                        BookingTraceCard(days: editableDays)
                            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .listRowBackground(Color.clear)
                    } header: {
                        Text("Booking trace")
                    }
                }

                Section("Trip overview") {
                    TextField("Title", text: $title)
                    TextField("Dates", text: $meta)
                    TextField("Route summary", text: $routeSummary)
                    TextField("Estimated budget", text: $estimatedBudget)
                }

                Section {
                    ForEach(editableDays.indices, id: \.self) { dayIndex in
                        dayEditor(dayIndex: dayIndex)
                    }
                    .onMove(perform: moveDays)

                    Button {
                        addDay()
                    } label: {
                        Label("Add day", systemImage: "plus")
                    }
                } header: {
                    HStack {
                        Text("Daily schedule")
                        Spacer()
                        if editMode.isEditing {
                            Text("Drag days")
                                .font(Theme.FontToken.inter(10))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .environment(\.editMode, $editMode)
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    if editMode.isEditing {
                        Button("Done reorder") {
                            editMode = .inactive
                            reindexDays()
                        }
                        .font(Theme.FontToken.inter(12, weight: .medium))
                    } else {
                        Button("Reorder") {
                            editMode = .active
                        }
                        .font(Theme.FontToken.inter(12, weight: .medium))
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
            .onAppear(perform: loadFromItinerary)
        }
    }

    @ViewBuilder
    private func dayEditor(dayIndex: Int) -> some View {
        let day = editableDays[dayIndex]
        DisclosureGroup {
            TextField("Date label", text: dayStringBinding(dayIndex, keyPath: \.dateLabel))
            TextField("Cost estimate", text: optionalCostBinding(dayIndex))

            ForEach(day.activities.indices, id: \.self) { actIndex in
                activityEditor(dayIndex: dayIndex, actIndex: actIndex)
            }
            .onMove { source, destination in
                moveActivities(dayIndex: dayIndex, from: source, to: destination)
            }

            Button {
                addActivity(dayIndex: dayIndex)
            } label: {
                Label("Add activity", systemImage: "plus.circle")
            }

            Button(role: .destructive) {
                deleteDay(at: dayIndex)
            } label: {
                Label("Remove this day", systemImage: "trash")
            }
        } label: {
            Text("Day \(day.dayIndex) · \(day.dateLabel.isEmpty ? "Untitled" : day.dateLabel)")
                .font(Theme.FontToken.inter(13, weight: .medium))
        }
    }

    private func activityEditor(dayIndex: Int, actIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Activity name", text: activityNameBinding(dayIndex: dayIndex, actIndex: actIndex))
            TextField("Details", text: activityDetailBinding(dayIndex: dayIndex, actIndex: actIndex), axis: .vertical)
                .lineLimit(2...4)

            Toggle("Has audio guide", isOn: activityAudioBinding(dayIndex: dayIndex, actIndex: actIndex))

            Button(role: .destructive) {
                deleteActivity(dayIndex: dayIndex, actIndex: actIndex)
            } label: {
                Label("Remove activity", systemImage: "trash")
            }
            .font(Theme.FontToken.inter(11))
        }
        .padding(.vertical, 4)
    }

    private var hasBookingTrace: Bool {
        editableDays.contains { day in
            day.activities.contains { $0.kind == .hotel || ($0.attractionId?.isEmpty == false) }
        }
    }

    // MARK: - Bindings

    private func dayStringBinding(_ dayIndex: Int, keyPath: KeyPath<ItineraryDay, String>) -> Binding<String> {
        Binding(
            get: { editableDays[dayIndex][keyPath: keyPath] },
            set: { newValue in
                let d = editableDays[dayIndex]
                editableDays[dayIndex] = ItineraryDay(
                    id: d.id,
                    dayIndex: d.dayIndex,
                    dateLabel: keyPath == \.dateLabel ? newValue : d.dateLabel,
                    cityName: d.cityName,
                    costEstimate: d.costEstimate,
                    activities: d.activities,
                    dayKind: d.dayKind,
                    experienceItems: d.experienceItems,
                    experienceCityId: d.experienceCityId
                )
            }
        )
    }

    private func optionalCostBinding(_ dayIndex: Int) -> Binding<String> {
        Binding(
            get: { editableDays[dayIndex].costEstimate ?? "" },
            set: { newValue in
                let d = editableDays[dayIndex]
                editableDays[dayIndex] = d.withCostEstimate(newValue.isEmpty ? nil : newValue)
            }
        )
    }

    private func activityNameBinding(dayIndex: Int, actIndex: Int) -> Binding<String> {
        Binding(
            get: { editableDays[dayIndex].activities[actIndex].name },
            set: { newValue in
                updateActivity(dayIndex: dayIndex, actIndex: actIndex) { act in
                    act.with(name: newValue)
                }
            }
        )
    }

    private func activityDetailBinding(dayIndex: Int, actIndex: Int) -> Binding<String> {
        Binding(
            get: { editableDays[dayIndex].activities[actIndex].detail },
            set: { newValue in
                updateActivity(dayIndex: dayIndex, actIndex: actIndex) { act in
                    act.with(detail: newValue)
                }
            }
        )
    }

    private func activityAudioBinding(dayIndex: Int, actIndex: Int) -> Binding<Bool> {
        Binding(
            get: { editableDays[dayIndex].activities[actIndex].hasAudio },
            set: { newValue in
                updateActivity(dayIndex: dayIndex, actIndex: actIndex) { act in
                    act.with(hasAudio: newValue)
                }
            }
        )
    }

    private func updateActivity(
        dayIndex: Int,
        actIndex: Int,
        transform: (ItineraryActivity) -> ItineraryActivity
    ) {
        var activities = editableDays[dayIndex].activities
        activities[actIndex] = transform(activities[actIndex])
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
    }

    // MARK: - Mutations

    private func loadFromItinerary() {
        title = itinerary.title
        meta = itinerary.meta
        routeSummary = itinerary.routeSummary
        estimatedBudget = itinerary.estimatedBudget
        editableDays = itinerary.days
    }

    private func addDay() {
        let index = editableDays.count + 1
        let newDay = ItineraryDay(
            id: "day_\(UUID().uuidString.prefix(8))",
            dayIndex: index,
            dateLabel: "Day \(index)",
            cityName: "",
            costEstimate: nil,
            activities: [ItineraryEditorView.emptyActivity()]
        )
        editableDays.append(newDay)
    }

    private func deleteDay(at index: Int) {
        editableDays.remove(at: index)
        reindexDays()
    }

    private func addActivity(dayIndex: Int) {
        var activities = editableDays[dayIndex].activities
        activities.append(Self.emptyActivity())
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
    }

    private func deleteActivity(dayIndex: Int, actIndex: Int) {
        var activities = editableDays[dayIndex].activities
        activities.remove(at: actIndex)
        if activities.isEmpty {
            activities.append(Self.emptyActivity())
        }
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
    }

    private func moveDays(from source: IndexSet, to destination: Int) {
        editableDays.move(fromOffsets: source, toOffset: destination)
        reindexDays()
    }

    private func moveActivities(dayIndex: Int, from source: IndexSet, to destination: Int) {
        var activities = editableDays[dayIndex].activities
        activities.move(fromOffsets: source, toOffset: destination)
        editableDays[dayIndex] = editableDays[dayIndex].withActivities(activities)
    }

    private func reindexDays() {
        editableDays = editableDays.enumerated().map { index, day in
            day.withDayIndex(index + 1)
        }
    }

    private func save() {
        reindexDays()
        let updated = SampleItinerary(
            id: itinerary.id,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            meta: meta.trimmingCharacters(in: .whitespacesAndNewlines),
            routeSummary: routeSummary.trimmingCharacters(in: .whitespacesAndNewlines),
            estimatedBudget: estimatedBudget.trimmingCharacters(in: .whitespacesAndNewlines),
            days: editableDays,
            shareSlug: itinerary.shareSlug,
            isShared: itinerary.isShared,
            startDate: itinerary.startDate,
            endDate: itinerary.endDate,
            visitOrder: itinerary.visitOrder,
            userEdited: true,
            droppedAttractionIds: itinerary.droppedAttractionIds,
            schedulingAdjustments: itinerary.schedulingAdjustments,
            seasonHints: itinerary.seasonHints
        )
        appEnv.preferences.saveItinerary(updated)
        let cityIds = Set(
            editableDays
                .flatMap(\.activities)
                .compactMap(\.cityId)
                .filter { !$0.isEmpty }
        )
        if !cityIds.isEmpty {
            appEnv.preferences.selectedCityIds = Array(cityIds)
        }
        onSave(updated)
        dismiss()
    }

    private static func emptyActivity() -> ItineraryActivity {
        ItineraryActivity(
            id: "act_\(UUID().uuidString.prefix(8))",
            name: "",
            detail: "",
            attractionId: nil,
            hasAudio: false
        )
    }
}

// MARK: - ItineraryDay helpers

private extension ItineraryDay {
    func withCostEstimate(_ value: String?) -> ItineraryDay {
        ItineraryDay(
            id: id,
            dayIndex: dayIndex,
            dateLabel: dateLabel,
            cityName: cityName,
            costEstimate: value,
            activities: activities,
            dayKind: dayKind,
            experienceItems: experienceItems,
            experienceCityId: experienceCityId
        )
    }
}
