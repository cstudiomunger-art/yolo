import SwiftUI

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
    @State private var visaRec: VisaRecommendation?
    @State private var visaRoutes: [VisaRoute] = []
    @State private var visaQuery: VisaQuery?
    @State private var swapPlan: VisaTripChecker.SwapPlan?
    @State private var swapPicks: Set<String> = []
    @State private var visaChecking = false
    @State private var showVisaDetector = false
    // Visa inputs collected on the dates page so the check is accurate (not coarse defaults).
    @State private var natCode = ""      // 国籍 / 护照国, default from preferences
    @State private var depCode = ""      // 出发国, default = nationality
    @State private var onwardCode = ""   // 下一程国 / 回程国, default = nationality; "" = 还没定
    @State private var editingCountry: PlanCountryField?
    @State private var passportValidEnough = true   // 护照有效期是否满足最低要求(后台可配, 默认3个月)
    @State private var hasChinaVisa = false          // 已持中国签证 → 跳过免签核对

    private let visaCountries: [PassportCountry] = ISO3166.all

    private enum PlanCountryField: Int, Identifiable {
        case nationality, departure, onward
        var id: Int { rawValue }
        var title: String {
            switch self {
            case .nationality: return "国籍 / 护照"
            case .departure: return "从哪国出发"
            case .onward: return "下一程去哪 / 回哪国"
            }
        }
    }

    private enum Step {
        case cities
        case dates
        case visa
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
            case .visa:
                visaStep
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
        // On the visa step the system back should return to the dates step (an in-flow step),
        // not pop the whole create flow.
        .navigationBarBackButtonHidden(step == .visa)
        .toolbar {
            if step == .visa {
                ToolbarItem(placement: .topBarLeading) {
                    Button { step = .dates } label: {
                        Image(systemName: "chevron.left").font(.system(size: 17, weight: .semibold))
                    }
                }
            }
        }
        .task { await loadCities() }
        .sheet(isPresented: $showArrivalPicker) {
            planDateSheet(
                title: String(localized: "Start date"),
                selection: $arrivalDate,
                range: Date()...Date.distantFuture
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
        .sheet(isPresented: $showVisaDetector) {
            VisaDetectorView(presetCitySlugs: Array(selectedCityIds),
                             presetStart: arrivalDate, presetEnd: departureDate)
        }
        .sheet(item: $editingCountry) { field in
            countryPickerSheet(field)
        }
    }

    private var navigationTitle: String {
        switch step {
        case .cities: String(localized: "Choose cities")
        case .dates: String(localized: "Travel dates")
        case .visa: String(localized: "签证核对")
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
            }
            .padding(Theme.screenPadding)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                primaryButton(String(localized: "Continue")) {
                    step = .dates
                }
                .disabled(selectedCityIds.isEmpty)
                .opacity(selectedCityIds.isEmpty ? 0.45 : 1)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 6)
            }
            .background(Theme.ColorToken.background)
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
                    VStack(alignment: .leading, spacing: 0) {
                        cityCover(city)
                        VStack(alignment: .leading, spacing: 4) {
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
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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

    @ViewBuilder
    private func cityCover(_ city: City) -> some View {
        if let path = city.coverImagePath?.trimmingCharacters(in: .whitespacesAndNewlines),
           !path.isEmpty {
            CoverImageView(path: path, height: 88, cornerRadius: 0)
        } else {
            ZStack {
                Theme.ColorToken.backgroundSubtle
                Text(city.emoji ?? "📍")
                    .font(.system(size: 30))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
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

                visaInputsSection

                primaryButton(String(localized: "Generate itinerary")) {
                    enterVisaCheck()
                }
            }
            .padding(Theme.screenPadding)
        }
    }

    // 签证相关输入: 国籍 / 出发国 / 下一程国 — 让生成前的签证核对更准(尤其过境 240h 依赖下一程)。
    private var visaInputsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("签证信息(让签证核对更准)")
                .font(Theme.FontToken.inter(12, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textSecondary)
            VStack(spacing: 0) {
                planCountryRow(.nationality, code: natCode)
                Rectangle().fill(Theme.ColorToken.border).frame(height: 0.5)
                planCountryRow(.departure, code: depCode)
                Rectangle().fill(Theme.ColorToken.border).frame(height: 0.5)
                planCountryRow(.onward, code: onwardCode)
                Rectangle().fill(Theme.ColorToken.border).frame(height: 0.5)
                Toggle(isOn: $passportValidEnough) {
                    Text("护照有效期 ≥ \(minValidityMonths) 个月")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
                .tint(Theme.ColorToken.success)
                .padding(.vertical, 8)
                Rectangle().fill(Theme.ColorToken.border).frame(height: 0.5)
                Toggle(isOn: $hasChinaVisa) {
                    Text("我已持有中国签证")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
                .tint(Theme.ColorToken.success)
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 12)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("默认按往返同国判定。若下一程是第三国/港澳,可能触发过境免签。护照有效期不足 \(minValidityMonths) 个月将无法免签也无法办签证。")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
    }

    private var minValidityMonths: Int { appEnv.visaData.data.minPassportValidityMonths }

    private func planCountryRow(_ field: PlanCountryField, code: String) -> some View {
        Button { editingCountry = field } label: {
            HStack {
                Text(field.title).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                Spacer()
                Text(planCountryLabel(code)).font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textGhost)
            }
            .contentShape(Rectangle())
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }

    private func planCountryLabel(_ code: String) -> String {
        if code.isEmpty { return "❓ 还没定" }
        if let c = visaCountries.first(where: { $0.code.caseInsensitiveCompare(code) == .orderedSame }) {
            return "\(c.flag) \(c.name)"
        }
        return code
    }

    @ViewBuilder
    private func countryPickerSheet(_ field: PlanCountryField) -> some View {
        CountrySelectSheet(
            title: field.title,
            countries: visaCountries,
            includeUndecided: field == .onward,
            selected: field == .nationality ? natCode : field == .departure ? depCode : onwardCode
        ) { code in
            switch field {
            case .nationality:
                natCode = code
                appEnv.preferences.countryCode = code   // keep profile nationality in sync
            case .departure: depCode = code
            case .onward: onwardCode = code
            }
            editingCountry = nil
        }
    }

    // MARK: - Visa check (在生成前按护照+城市+真实日期判定; 够用静默放行, 不够用给推荐路线)

    private var visaStep: some View {
        Group {
            if visaChecking {
                VStack(spacing: 20) {
                    Spacer()
                    ProgressView().scaleEffect(1.3)
                    Text("正在核对签证…").font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textMuted)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let rec = visaRec {
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        visaVerdictHeader(rec)

                        ForEach(visaRoutes) { route in
                            visaRouteCard(route)
                        }

                        if let plan = swapPlan {
                            swapCard(plan)
                        }

                        // Route cards are each selectable; only show the standalone continue
                        // button when there are none (GATE0 / passport-validity block).
                        if visaRoutes.isEmpty {
                            primaryButton(String(localized: "保持原行程继续")) { startGeneration() }
                                .padding(.top, 4)
                        }

                        Button {
                            showVisaDetector = true
                        } label: {
                            Text("精细核对(出发地 / 口岸 / 续程票)")
                                .font(Theme.FontToken.inter(12, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.accent)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)

                        Text("按常见默认粗判(往返同国、主要机场进出、已出续程票)。以边检最终判定为准。")
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    .padding(Theme.screenPadding)
                }
            } else {
                Color.clear
            }
        }
    }

    private func visaVerdictHeader(_ rec: VisaRecommendation) -> some View {
        let isGate0 = rec.chosenPolicyId == "GATE0"
        let needVisa = rec.level == .red
        let title: String
        let detail: String
        if isGate0 {
            title = "护照有效期不足"
            detail = "有效期不足 \(minValidityMonths) 个月，免签和签证都无法办理。请先换发护照再出行。"
        } else {
            title = needVisa ? "这条线默认可能需要签证" : "这条线有条件免签，建议核对"
            var d = "下面给出更省事的走法，签证友好那条经引擎复核为全程免签。"
            if let days = rec.maxStayDays { d = "免签停留上限约 \(days) 天。" + d }
            detail = d
        }
        return HStack(alignment: .top, spacing: 9) {
            Text("🛂")
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(Theme.FontToken.inter(13, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text(detail).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.warning.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func visaRouteCard(_ route: VisaRoute) -> some View {
        let tone: Color = {
            switch route.badgeTone {
            case .warn: return Theme.ColorToken.warning
            case .ok: return Theme.ColorToken.success
            case .neutral: return Theme.ColorToken.textMuted
            }
        }()
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(route.title).font(Theme.FontToken.inter(12, weight: .semibold))
                Spacer()
                Text(route.badge)
                    .font(Theme.FontToken.inter(9, weight: .semibold))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .foregroundStyle(tone)
                    .overlay(Capsule().stroke(tone, lineWidth: 1))
            }
            HStack(spacing: 6) {
                ForEach(Array(route.cities.enumerated()), id: \.offset) { idx, city in
                    Text(cityDisplayName(city)).font(Theme.FontToken.playfair(13, weight: .semibold))
                    if idx < route.cities.count - 1 || route.addedCity != nil {
                        Image(systemName: "arrow.right").font(.system(size: 9)).foregroundStyle(Theme.ColorToken.textGhost)
                    }
                }
                if let added = route.addedCity {
                    Text("+ " + added).font(Theme.FontToken.playfair(13, weight: .semibold)).foregroundStyle(Theme.ColorToken.success)
                }
            }
            Text(route.note).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            // Every route is selectable. Friendly = filled success CTA; original = outline.
            Button { adoptVisaRoute(route) } label: {
                Text(route.kind == .friendly ? "按推荐确认并生成" : "选这条 · 办 L 签生成")
                    .font(Theme.FontToken.inter(12, weight: .semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .foregroundStyle(route.kind == .friendly ? Color.white : Theme.ColorToken.textPrimary)
                    .background(route.kind == .friendly ? Theme.ColorToken.success : Theme.ColorToken.backgroundSubtle)
                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(route.kind == .friendly ? Color.clear : Theme.ColorToken.border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 11))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(route.kind == .friendly ? Theme.ColorToken.success : Theme.ColorToken.border, lineWidth: route.kind == .friendly ? 1.5 : 1))
    }

    private func cityDisplayName(_ slug: String) -> String {
        cities.first { $0.id == slug }?.name ?? slug.capitalized
    }

    // 换城(自选): list the engine-verified qualifying cities and let the user choose which
    // one(s) to swap in for the blocker city(ies), then re-verify before generating.
    private func swapCard(_ plan: VisaTripChecker.SwapPlan) -> some View {
        let ready = swapPicks.count == plan.need
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("✓ 签证友好 · 换城(自选)").font(Theme.FontToken.inter(12, weight: .semibold))
                Spacer()
                Text("换城免签 · 城数不变")
                    .font(Theme.FontToken.inter(9, weight: .semibold))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .foregroundStyle(Theme.ColorToken.success)
                    .overlay(Capsule().stroke(Theme.ColorToken.success, lineWidth: 1))
            }
            Text("需签证的城市：\(plan.blockerNames)。换成下面任一座免签可达的城市(选 \(plan.need) 座)，经引擎复核为全程免签。")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)

            VStack(spacing: 0) {
                ForEach(plan.candidates) { cand in
                    let picked = swapPicks.contains(cand.slug)
                    Button { toggleSwapPick(cand.slug, need: plan.need) } label: {
                        HStack(spacing: 10) {
                            Image(systemName: picked ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 16))
                                .foregroundStyle(picked ? Theme.ColorToken.success : Theme.ColorToken.textGhost)
                            Text(cand.name).font(Theme.FontToken.inter(13))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 9)
                    }
                    .buttonStyle(.plain)
                    if cand.id != plan.candidates.last?.id {
                        Rectangle().fill(Theme.ColorToken.border).frame(height: 0.5)
                    }
                }
            }
            .padding(.horizontal, 12)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Button { confirmSwap(plan) } label: {
                Text(ready ? "按所选换城确认并生成" : "请选择 \(plan.need) 座替换城市")
                    .font(Theme.FontToken.inter(12, weight: .semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(ready ? Theme.ColorToken.success : Theme.ColorToken.textGhost)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 11))
            }
            .buttonStyle(.plain)
            .disabled(!ready)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.success, lineWidth: 1.5))
    }

    private func toggleSwapPick(_ slug: String, need: Int) {
        if need == 1 {
            swapPicks = swapPicks.contains(slug) ? [] : [slug]
        } else if swapPicks.contains(slug) {
            swapPicks.remove(slug)
        } else if swapPicks.count < need {
            swapPicks.insert(slug)
        }
    }

    private func confirmSwap(_ plan: VisaTripChecker.SwapPlan) {
        guard swapPicks.count == plan.need, let q = visaQuery else { return }
        let picks = Array(swapPicks)
        guard VisaTripChecker.verifySwap(query: q, keptSlugs: plan.keptSlugs, picks: picks,
                                         data: appEnv.visaData.data) else { return }
        selectedCityIds = Set(plan.keptSlugs + picks)
        startGeneration()
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
                )
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
        do {
            cities = try await appEnv.content.fetchCities()
        } catch {
            cities = []
            TelemetryService.shared.recordError(error, context: "plan_create_cities")
        }
        selectedCityIds = Set(appEnv.preferences.selectedCityIds)
        departureDate = appEnv.preferences.departureDate
        departureDate = PlanTripDateMath.clampDeparture(departureDate, arrival: arrivalDate)
        let cc = appEnv.preferences.countryCode.trimmingCharacters(in: .whitespaces).uppercased()
        natCode = cc
        depCode = cc
        onwardCode = cc   // default round-trip; user can pick a third country to enable transit免签
        await appEnv.visaData.load()   // so the 护照有效期 label reflects the CMS value
    }

    private func toggleCity(_ id: String) {
        if selectedCityIds.contains(id) {
            selectedCityIds.remove(id)
        } else {
            selectedCityIds.insert(id)
        }
    }

    /// Judge the chosen cities + real dates against the user's passport before generating.
    /// CN / unknown passport → skip (engine judges foreigners entering China). Green/enough →
    /// silent pass straight to generation. Not enough → show engine-verified route options.
    private func enterVisaCheck() {
        step = .visa
        visaChecking = true
        visaRec = nil
        visaRoutes = []
        Task {
            // Already holds a China visa → visa-free routing is moot, skip the whole check.
            if hasChinaVisa { startGeneration(); return }
            let cc = natCode.trimmingCharacters(in: .whitespaces).uppercased()
            if cc.isEmpty || cc == "CN" { startGeneration(); return }
            await appEnv.visaData.load()
            let data = appEnv.visaData.data
            let slugs = Array(selectedCityIds)
            // Passport-validity gate: pass nil when sufficient (no GATE0); 0 when the user says
            // it's below the floor → engine returns GATE0 red (neither visa-free nor a visa works).
            let validMonths: Int? = passportValidEnough ? nil : 0
            guard let query = VisaCoarseCheck.query(citySlugs: slugs, start: arrivalDate,
                                                    end: departureDate, countryCode: cc, data: data,
                                                    departure: depCode, onward: onwardCode,
                                                    passportValidMonths: validMonths) else {
                startGeneration(); return
            }
            let rec = VisaPolicyEngine.recommend(query, data: data)
            // GATE0 (passport validity) — no route helps; show the renew-passport warning only.
            if rec.chosenPolicyId == "GATE0" {
                visaQuery = query; visaRec = rec; visaRoutes = []
                swapPlan = nil; swapPicks = []; visaChecking = false
                return
            }
            if rec.isEnough { startGeneration(); return }
            let catalog = cities.map { (slug: $0.id, popularity: $0.attractionCount) }
            let plan = VisaTripChecker.swapPlan(query: query, appCities: slugs, catalog: catalog, data: data, rec: rec)
            var rs = VisaTripChecker.routes(query: query, appCities: slugs, data: data, recommendation: rec)
            // Prefer the interactive 换城 card over the auto 删城 route when a swap pool exists.
            if plan != nil { rs.removeAll { $0.kind == .friendly && $0.title.contains("去掉拖累城") } }
            // Drop the 备选·办L签 card — it's identical to 纯兴趣 (keep original + L visa), and the
            // 纯兴趣 card is now selectable on its own.
            rs.removeAll { $0.kind == .applyVisa }
            visaQuery = query
            swapPlan = plan
            swapPicks = []
            visaRoutes = rs
            visaRec = rec
            visaChecking = false
        }
    }

    /// Adopt a recommended route → drive the itinerary. The route's own cities are always
    /// used; if it advises an extra city (e.g. 港澳 transit) AND that city now exists in the
    /// content catalog, fold it in as a real stop so the itinerary actually visits it. Until
    /// the content city exists this is a no-op (the add stays advisory). Generic, so future
    /// 海南/邮轮 route cards flow through the same path.
    private func adoptVisaRoute(_ route: VisaRoute) {
        var ids = route.cities
        if let slug = route.addedCitySlug,
           cities.contains(where: { $0.id == slug }),
           !ids.contains(slug) {
            ids.append(slug)
        }
        selectedCityIds = Set(ids)
        startGeneration()
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
        attractionCache = await PlanItineraryHelpers.attractionCache(for: trip, content: appEnv.content)
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
        guard let trip = draftItinerary, trip.days.indices.contains(dayIndex) else { return }
        let day = trip.days[dayIndex]
        var days = trip.days
        days[dayIndex] = day.withActivities(day.activities.filter { $0.id != activityId })
        draftItinerary = trip.withDays(days)
    }

    private func appendAttraction(_ attraction: Attraction, dayIndex: Int) {
        guard let trip = draftItinerary, trip.days.indices.contains(dayIndex) else { return }
        let day = trip.days[dayIndex]
        var days = trip.days
        days[dayIndex] = day.withActivities(day.activities + [PlanItineraryHelpers.activity(from: attraction)])
        draftItinerary = trip.withDays(days)
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
        do {
            attractions = try await appEnv.content.fetchAttractions(cityId: cityId)
        } catch {
            attractions = []
            TelemetryService.shared.recordError(error, context: "plan_picker_attractions")
        }
    }
}
