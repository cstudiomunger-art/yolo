import Foundation

/// Maps Supabase payment CMS rows into Payment Guide UI models (English-first).
enum PaymentGuideCMSMapper {

    static func pickLocalized(zh: String?, en: String?) -> String {
        let enTrimmed = en?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let zhTrimmed = zh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !enTrimmed.isEmpty { return enTrimmed }
        return zhTrimmed
    }

    // MARK: - Node copy

    static func nodeText(
        _ texts: [PaymentNodeText],
        nodeKey: String,
        slot: String
    ) -> String? {
        let match = texts
            .filter { $0.nodeKey == nodeKey && $0.slot == slot }
            .sorted { ($0.ord ?? 0) < ($1.ord ?? 0) }
        guard let first = match.first else { return nil }
        let value = pickLocalized(zh: first.textZh, en: first.textEn)
        return value.isEmpty ? nil : value
    }

    static func nodeCallouts(
        _ texts: [PaymentNodeText],
        nodeKey: String
    ) -> [String] {
        texts
            .filter { $0.nodeKey == nodeKey && $0.slot == "callout" }
            .sorted { ($0.ord ?? 0) < ($1.ord ?? 0) }
            .compactMap {
                let v = pickLocalized(zh: $0.textZh, en: $0.textEn)
                return v.isEmpty ? nil : v
            }
    }

    // MARK: - Flow steps

    static func flowSteps(
        _ steps: [PaymentFlowStep],
        nodeKey: String,
        tool: String? = nil
    ) -> [PaymentFlowStep] {
        steps
            .filter { step in
                guard step.nodeKey == nodeKey else { return false }
                if let tool {
                    return (step.tool ?? "") == tool
                }
                return true
            }
            .sorted { ($0.stepOrder ?? 0) < ($1.stepOrder ?? 0) }
    }

    static func toGuideSteps(_ steps: [PaymentFlowStep]) -> [PaymentGuideStep] {
        steps.enumerated().map { index, step in
            let title = pickLocalized(zh: step.titleZh, en: step.titleEn)
            let instruction = pickLocalized(zh: step.instructionMdZh, en: step.instructionMdEn)
            let failNotes = step.failReasons?.enumerated().map { i, row in
                PaymentGuideFailNote(
                    id: "\(step.id)-f\(i)",
                    trigger: row.reason,
                    body: row.fix
                )
            }
            return PaymentGuideStep(
                id: step.id,
                number: String(format: "%02d", index + 1),
                title: title.isEmpty ? "Step \(index + 1)" : title,
                note: instruction.isEmpty ? nil : instruction,
                sayChinese: nil,
                sayTranslation: nil,
                failNotes: failNotes?.isEmpty == true ? nil : failNotes
            )
        }
    }

    static func setupSteps(
        _ steps: [PaymentFlowStep],
        tool: String
    ) -> [PaymentGuideStep] {
        let nodes = ["register", "bind", "verify"]
        var ordered: [PaymentFlowStep] = []
        for node in nodes {
            ordered.append(contentsOf: flowSteps(steps, nodeKey: node, tool: tool))
        }
        return toGuideSteps(ordered)
    }

    static func mobileHowSegments(_ steps: [PaymentFlowStep]) -> [PaymentGuideSegmentOption] {
        let useSteps = flowSteps(steps, nodeKey: "use", tool: "")
        guard !useSteps.isEmpty else { return [] }
        return useSteps.enumerated().map { index, step in
            let title = pickLocalized(zh: step.titleZh, en: step.titleEn)
            let body = pickLocalized(zh: step.instructionMdZh, en: step.instructionMdEn)
            return PaymentGuideSegmentOption(
                id: index + 1,
                title: title.isEmpty ? "Option \(index + 1)" : title,
                prefLabel: index == 0 ? "Try this first" : nil,
                steps: body.isEmpty ? [] : [body]
            )
        }
    }

    static func installBeforeFlySteps(_ steps: [PaymentFlowStep]) -> [PaymentGuideStep] {
        let installSteps = flowSteps(steps, nodeKey: "install")
            .sorted { lhs, rhs in
                let lo = lhs.stepOrder ?? 0
                let ro = rhs.stepOrder ?? 0
                if lo != ro { return lo < ro }
                return (lhs.tool ?? "") < (rhs.tool ?? "")
            }
        return toGuideSteps(installSteps)
    }

    // MARK: - Rescue / cash / checklist / articles

    static func rescueSteps(_ rungs: [PaymentRescueRung]) -> [PaymentGuideStep] {
        rungs
            .sorted { ($0.rungOrder ?? 0) < ($1.rungOrder ?? 0) }
            .enumerated()
            .map { index, rung in
                let title = pickLocalized(zh: rung.titleZh, en: rung.titleEn)
                let detail = pickLocalized(zh: rung.detailMdZh, en: rung.detailMdEn)
                let subtitle = pickLocalized(zh: rung.subtitleZh, en: rung.subtitleEn)
                let note: String? = {
                    if !detail.isEmpty { return detail }
                    if !subtitle.isEmpty { return subtitle }
                    return nil
                }()
                return PaymentGuideStep(
                    id: rung.id,
                    number: String(format: "%02d", index + 1),
                    title: title.isEmpty ? "Step \(index + 1)" : title,
                    note: note,
                    sayChinese: nil,
                    sayTranslation: nil,
                    failNotes: nil
                )
            }
    }

    static func cashAmountRows(_ rules: [PaymentCashRule]) -> [PaymentGuideRow] {
        rules
            .sorted { ($0.optOrder ?? 0) < ($1.optOrder ?? 0) }
            .map { rule in
                let label = pickLocalized(zh: rule.labelZh, en: rule.labelEn)
                let amount = pickLocalized(zh: rule.amountMdZh, en: rule.amountMdEn)
                let note = pickLocalized(zh: rule.noteZh, en: rule.noteEn)
                return PaymentGuideRow(
                    id: rule.tripType,
                    label: label.isEmpty ? rule.tripType : label,
                    subtitle: note.isEmpty ? nil : note,
                    badge: nil,
                    amount: amount.isEmpty ? nil : amount
                )
            }
    }

    static func checklistEntries(_ items: [PaymentChecklistItem]) -> [PaymentGuideChecklistEntry] {
        items
            .sorted { ($0.itemOrder ?? 0) < ($1.itemOrder ?? 0) }
            .map { item in
                let label = pickLocalized(zh: item.labelZh, en: item.labelEn)
                return PaymentGuideChecklistEntry(id: item.id, label: label)
            }
    }

    static func articles(
        _ articles: [PaymentArticle],
        nodeKey: String
    ) -> [PaymentArticle] {
        articles
            .filter { $0.nodeKey == nodeKey && ($0.isPublished ?? true) }
            .sorted { ($0.displayOrder ?? 0) < ($1.displayOrder ?? 0) }
    }

    static func articleTitle(_ article: PaymentArticle) -> String {
        pickLocalized(zh: article.titleZh, en: article.titleEn)
    }

    static func articleBody(_ article: PaymentArticle) -> String {
        pickLocalized(zh: article.bodyMdZh, en: article.bodyMdEn)
    }

    static func cardNetworkRows(_ networks: [PaymentCardNetwork]) -> [PaymentGuideRow] {
        networks
            .sorted { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) }
            .map { net in
                let label = pickLocalized(zh: net.nameZh, en: net.nameEn)
                let note = pickLocalized(zh: net.noteZh, en: net.noteEn)
                let badge: PaymentGuideBadgeLevel? = {
                    let alipay = net.alipayOk == true
                    let wechat = net.wechatOk == true
                    if alipay && wechat { return .high }
                    if alipay { return .high }
                    if wechat { return .medium }
                    return .low
                }()
                return PaymentGuideRow(
                    id: net.id,
                    label: label.isEmpty ? net.id : label,
                    subtitle: note.isEmpty ? nil : note,
                    badge: badge,
                    amount: nil
                )
            }
    }

    static func helperLinks(_ links: [PaymentHelperLink], lane: String) -> [PaymentHelperLink] {
        links
            .filter { $0.lane == lane }
            .sorted { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) }
    }

    static func linkLabel(_ link: PaymentHelperLink) -> String {
        pickLocalized(zh: link.labelZh, en: link.labelEn)
    }
}
