import SwiftUI

enum PlanRoute: Hashable {
    case cityOverview(City)
    case generator
    case itineraryDetail(SampleItinerary)
}

// MARK: - City Overview

struct CityOverviewView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let city: City
    var onOpenGenerator: () -> Void = {}
    @State private var routes: [CityRoute] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                coverHeader
                infoSection
                routesSection
                actionButtons
            }
        }
        .background(Theme.ColorToken.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("← Plan") { dismiss() }
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .task {
            routes = (try? await appEnv.content.fetchCityRoutes(cityId: city.id)) ?? []
        }
    }

    private var coverHeader: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Theme.ColorToken.backgroundSubtle)
                .frame(height: 160)
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(Theme.FontToken.playfair(28, weight: .semibold))
                Text(city.chineseName)
                    .font(Theme.FontToken.inter(14))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(Theme.screenPadding)
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            FlowLayoutTags(tags: city.bestFor)
            if let note = city.seasonNote {
                Text("📅 \(city.bestTimeToVisit ?? "")\n❄️ \(note)")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .lineSpacing(4)
            }
            if let days = city.avgDaysRecommended {
                Text("📍 Recommended stay: \(days)–\(days + 2) days")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
        }
        .padding(Theme.screenPadding)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private var routesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended Routes")
                .sectionTitleStyle()
            ForEach(routes) { route in
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(route.days) days")
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                    Text(route.title)
                        .font(Theme.FontToken.playfair(15, weight: .semibold))
                    Text(route.summary)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineSpacing(3)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
            }
        }
        .padding(Theme.screenPadding)
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button {
                appEnv.navigation.openAssistantPlanning()
                dismiss()
            } label: {
                Text("🤖 Plan with AI Chat")
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)

            Button {
                onOpenGenerator()
            } label: {
                Text("⚡ Quick Plan")
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(Theme.screenPadding)
    }
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

// MARK: - Generator

struct ItineraryGeneratorView: View {
    @Environment(AppEnvironment.self) private var appEnv

    var onGenerated: (SampleItinerary) -> Void = { _ in }

    @State private var selectedCities: Set<String> = []
    @State private var tripDays = 10
    @State private var styles: Set<String> = ["History", "Food"]
    @State private var isGenerating = false
    @State private var cities: [City] = []

    private let styleOptions = ["History", "Culture", "Food", "Nature", "Nightlife"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Quick Plan")
                    .font(Theme.FontToken.playfair(22, weight: .semibold))

                Text("Cities")
                    .sectionTitleStyle()
                ForEach(cities) { city in
                    Button {
                        toggleCity(city.id)
                    } label: {
                        HStack {
                            Text("\(city.emoji ?? "") \(city.name)")
                            Spacer()
                            if selectedCities.contains(city.id) {
                                Image(systemName: "checkmark").foregroundStyle(Theme.ColorToken.accent)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }

                Stepper("Trip length: \(tripDays) days", value: $tripDays, in: 3...21)

                Text("Travel style")
                    .sectionTitleStyle()
                WrapStyleChips(options: styleOptions, selection: $styles)

                Button {
                    generate()
                } label: {
                    HStack {
                        if isGenerating {
                            ProgressView().tint(.white)
                        }
                        Text(isGenerating ? "Crafting your itinerary..." : "Generate Itinerary")
                    }
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Theme.ColorToken.textPrimary)
                }
                .buttonStyle(.plain)
                .disabled(isGenerating || selectedCities.isEmpty)
            }
            .padding(Theme.screenPadding)
        }
        .task {
            cities = (try? await appEnv.content.fetchCities()) ?? []
            selectedCities = Set(appEnv.preferences.selectedCityIds)
        }
    }

    private func toggleCity(_ id: String) {
        if selectedCities.contains(id) {
            selectedCities.remove(id)
        } else {
            selectedCities.insert(id)
        }
    }

    private func generate() {
        isGenerating = true
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            let style = styles.sorted().joined(separator: ", ")
            if let trip = try? await AIService.generateItinerary(
                content: appEnv.content,
                cities: Array(selectedCities),
                days: tripDays,
                style: style
            ) {
                appEnv.preferences.selectedCityIds = Array(selectedCities)
                appEnv.preferences.saveItinerary(trip)
                onGenerated(trip)
                Task { await appEnv.profileSync.pushToRemote() }
            }
            isGenerating = false
        }
    }
}

struct WrapStyleChips: View {
    let options: [String]
    @Binding var selection: Set<String>

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(options, id: \.self) { option in
                Button {
                    if selection.contains(option) {
                        selection.remove(option)
                    } else {
                        selection.insert(option)
                    }
                } label: {
                    Text(option)
                        .font(Theme.FontToken.inter(11))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(selection.contains(option) ? Theme.ColorToken.textPrimary : Theme.ColorToken.background)
                        .foregroundStyle(selection.contains(option) ? .white : Theme.ColorToken.textPrimary)
                        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// Simple flow layout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var frames: [CGRect] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
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
                BookYourTripView(itinerary: itinerary)
            }
        }
        .background(Theme.ColorToken.background)
        .sheet(isPresented: $showShare) {
            ShareItinerarySheet(itinerary: itinerary)
        }
        .sheet(isPresented: $showEdit) {
            ItineraryEditSheet(itinerary: itinerary)
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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(itinerary.days) { day in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(day.dateLabel)
                                .font(Theme.FontToken.playfair(14, weight: .semibold))
                            Spacer()
                            if let cost = day.costEstimate {
                                Text(cost)
                                    .font(Theme.FontToken.inter(11))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                            }
                        }
                        ForEach(day.activities) { activity in
                            HStack(alignment: .top, spacing: 10) {
                                Text(activity.timeSlot)
                                    .font(Theme.FontToken.inter(10, weight: .medium))
                                    .foregroundStyle(Theme.ColorToken.textDisabled)
                                    .frame(width: 28, alignment: .leading)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(activity.name)
                                        .font(Theme.FontToken.inter(13))
                                    Text(activity.detail)
                                        .font(Theme.FontToken.inter(11))
                                        .foregroundStyle(Theme.ColorToken.textMuted)
                                }
                                if activity.hasAudio, let aid = activity.attractionId {
                                    Button("🎧") {
                                        appEnv.navigation.openGuide(attractionId: aid, cityId: nil)
                                    }
                                    .font(Theme.FontToken.inter(10))
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                }
            }
            .padding(Theme.screenPadding)
        }
    }
}

struct ItineraryEditSheet: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let itinerary: SampleItinerary
    @State private var title: String = ""
    @State private var meta: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Meta (dates, style)", text: $meta)
            }
            .navigationTitle("Edit Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = SampleItinerary(
                            id: itinerary.id,
                            title: title,
                            meta: meta,
                            routeSummary: itinerary.routeSummary,
                            estimatedBudget: itinerary.estimatedBudget,
                            days: itinerary.days
                        )
                        appEnv.preferences.saveItinerary(updated)
                        dismiss()
                    }
                }
            }
            .onAppear {
                title = itinerary.title
                meta = itinerary.meta
            }
        }
    }
}

// MARK: - Book

struct BookYourTripView: View {
    @Environment(AppEnvironment.self) private var appEnv

    let itinerary: SampleItinerary
    @State private var hotels: [Hotel] = []
    @State private var hotelCity: String?
    @State private var showHotels = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                bookBlock(title: "✈️ Flights to Beijing", subtitle: "Dates pre-filled from your trip") {
                    flightButtons
                }
                ForEach(appEnv.preferences.selectedCityIds, id: \.self) { cityId in
                    bookBlock(title: "🏨 \(cityId.capitalized)", subtitle: "Foreigner-friendly hotels") {
                        Button {
                            hotelCity = cityId
                            Task {
                                hotels = (try? await appEnv.content.fetchHotels(cityId: cityId)) ?? []
                                showHotels = true
                            }
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
        .sheet(isPresented: $showHotels) {
            if let hotelCity {
                HotelSearchView(cityName: hotelCity.capitalized, hotels: hotels)
            }
        }
    }

    private var flightButtons: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                flightLink("Skyscanner")
                flightLink("Google Flights")
            }
            HStack(spacing: 8) {
                flightLink("Trip.com")
                flightLink("Kayak")
            }
        }
    }

    private func flightLink(_ name: String) -> some View {
        Link("\(name) →", destination: URL(string: "https://www.google.com/travel/flights")!)
            .font(Theme.FontToken.inter(11, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
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

struct HotelSearchView: View {
    let cityName: String
    let hotels: [Hotel]
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

                    ForEach(hotels) { hotel in
                        HotelCardView(hotel: hotel)
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
            Text(hotel.name)
                .font(Theme.FontToken.playfair(16, weight: .semibold))
            Text(String(repeating: "★", count: hotel.stars))
                .font(Theme.FontToken.inter(11))
            if let note = hotel.englishStaffNote {
                Text("✅ \(note)")
                    .font(Theme.FontToken.inter(11))
            } else if !hotel.hasEnglishStaff {
                Text("⚠️ No English-speaking staff")
                    .font(Theme.FontToken.inter(11))
            }
            Text("✅ Registered for foreign guests")
                .font(Theme.FontToken.inter(11))
            if let loc = hotel.locationNote {
                Text("📍 \(loc)")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Text("From $\(hotel.priceMinUsd)/night")
                .font(Theme.FontToken.inter(12, weight: .medium))
            HStack {
                ForEach(hotel.bookingPlatforms, id: \.self) { platform in
                    Link(platform, destination: URL(string: "https://www.booking.com")!)
                        .font(Theme.FontToken.inter(10, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                }
            }
            if let tip = hotel.languageTip {
                Text(tip)
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
