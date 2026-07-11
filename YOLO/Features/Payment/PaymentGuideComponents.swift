import SwiftUI

// MARK: - Layout

enum PaymentGuideLayout {
    static let horizontalPadding: CGFloat = Theme.screenPadding
    static let bottomPadding: CGFloat = 48
    static let subNavTopPadding: CGFloat = 8
}

// MARK: - Hero

struct PaymentGuideHero: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(PaymentGuideContent.hubEyebrow)
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .textCase(.uppercase)
                .kerning(1.2)
                .padding(.bottom, 12)

            Text(PaymentGuideContent.hubTitle)
                .font(Theme.FontToken.playfair(34, weight: .bold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .lineSpacing(2)
                .padding(.bottom, 12)

            (Text(PaymentGuideContent.hubIntroBold).fontWeight(.medium).foregroundStyle(Theme.ColorToken.textPrimary)
             + Text(PaymentGuideContent.hubIntroRest).fontWeight(.light).foregroundStyle(Theme.ColorToken.textSecondary))
                .font(Theme.FontToken.inter(13))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

struct PaymentGuideRule: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(PaymentGuideContent.coreRuleKick)
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .textCase(.uppercase)
                .kerning(1.1)
                .padding(.bottom, 4)

            Text(PaymentGuideContent.coreRuleHeadline)
                .font(Theme.FontToken.playfair(15, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .lineSpacing(3)
                .padding(.bottom, 6)

            Text(PaymentGuideContent.coreRuleBody)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .leading) {
            Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
        }
        .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
        .padding(.top, 18)
        .padding(.bottom, 4)
    }
}

// MARK: - Hub actions

struct PaymentGuideSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .sectionTitleStyle()
            .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
            .padding(.top, 28)
            .padding(.bottom, 12)
    }
}

struct PaymentGuideKeyTag: View {
    let text: String
    var dim: Bool = false

    var body: some View {
        Text(text)
            .font(Theme.FontToken.inter(9, weight: .medium))
            .foregroundStyle(dim ? Theme.ColorToken.textMuted : Theme.ColorToken.accent)
            .textCase(.uppercase)
            .kerning(0.7)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(dim ? Theme.ColorToken.border : Theme.ColorToken.accent, lineWidth: 1)
            )
    }
}

struct PaymentGuideActionRow: View {
    let action: PaymentGuideHubAction

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(action.number)
                .font(Theme.FontToken.playfair(11))
                .foregroundStyle(Theme.ColorToken.accent)
                .frame(width: 20, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(action.title)
                        .font(Theme.FontToken.inter(14))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    if let tag = action.keyTag {
                        PaymentGuideKeyTag(text: tag, dim: action.keyTagDim)
                    }
                }
                Text(action.description)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .lineSpacing(3)
            }

            Spacer(minLength: 0)

            Text("›")
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textGhost)
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
        .contentShape(Rectangle())
    }
}

struct PaymentGuideSOSBar: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("⚠")
                .font(.system(size: 14))
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 0) {
                (Text("Payment failed?").fontWeight(.medium).foregroundStyle(Theme.ColorToken.textPrimary)
                 + Text(" \(PaymentGuideContent.sosBody)").fontWeight(.light))
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .lineSpacing(4)

                Text(PaymentGuideContent.sosLink)
                    .font(Theme.FontToken.inter(10, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.warning)
                    .textCase(.uppercase)
                    .kerning(0.8)
                    .padding(.top, 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Theme.ColorToken.warningBackground)
        .overlay(alignment: .leading) {
            Rectangle().fill(Theme.ColorToken.warning).frame(width: 2)
        }
        .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
        .padding(.top, 22)
    }
}

struct PaymentGuideMiniTileView: View {
    let tile: PaymentGuideMiniTile

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(tile.eyebrow)
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textDisabled)
                .textCase(.uppercase)
                .kerning(1.1)
                .padding(.bottom, 6)
            Text(tile.title)
                .font(Theme.FontToken.playfair(14, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .padding(.bottom, 2)
            Text(tile.subtitle)
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .cardBorderStyle()
        .contentShape(Rectangle())
    }
}

// MARK: - Sub-page chrome

struct PaymentGuideSubNav: View {
    let title: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Text(title)
                .font(Theme.FontToken.playfair(16, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)

            HStack {
                Button { dismiss() } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11, weight: .medium))
                        Text("Back")
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .kerning(0.9)
                    }
                    .foregroundStyle(Theme.ColorToken.accent)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .padding(.top, PaymentGuideLayout.subNavTopPadding)
        .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
        .padding(.bottom, 14)
        .background(Theme.ColorToken.background)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }
}

struct PaymentGuideLead: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Theme.FontToken.playfair(22, weight: .semibold))
            .foregroundStyle(Theme.ColorToken.textPrimary)
            .lineSpacing(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PaymentGuideSub: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Theme.FontToken.inter(12))
            .foregroundStyle(Theme.ColorToken.textSecondary)
            .lineSpacing(4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 22)
    }
}

struct PaymentGuidePagePad<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
        .padding(.top, 12)
        .padding(.bottom, PaymentGuideLayout.bottomPadding)
    }
}

// MARK: - Content blocks

struct PaymentGuideSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .sectionTitleStyle()
                .padding(.bottom, 4)
            content()
        }
        .padding(.bottom, 26)
    }
}

struct PaymentGuideStepView: View {
    let step: PaymentGuideStep

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(step.number)
                .font(Theme.FontToken.playfair(11))
                .foregroundStyle(Theme.ColorToken.accent)
                .frame(width: 22, alignment: .leading)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 0) {
                PaymentGuideRichText(step.title, size: 13, weight: .light, color: Theme.ColorToken.textPrimary)

                if let note = step.note, !note.isEmpty {
                    Text(note)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineSpacing(3)
                        .padding(.top, 2)
                }

                if let chinese = step.sayChinese {
                    HStack(spacing: 0) {
                        PaymentGuideRichText(chinese, size: 11, weight: .semibold, color: Theme.ColorToken.textPrimary, serif: true)
                        if let tr = step.sayTranslation {
                            Text(" — \(tr)")
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 9)
                    .background(Theme.ColorToken.backgroundSubtle)
                    .overlay(alignment: .leading) {
                        Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
                    }
                    .padding(.top, 6)
                }

                if let notes = step.failNotes {
                    ForEach(notes) { note in
                        PaymentGuideFailDetails(note: note)
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}

struct PaymentGuideFailDetails: View {
    let note: PaymentGuideFailNote
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            PaymentGuideRichText(note.body, size: 11, weight: .light, color: Theme.ColorToken.textSecondary)
                .padding(.vertical, 8)
                .padding(.leading, 10)
                .overlay(alignment: .leading) {
                    Rectangle().fill(Theme.ColorToken.border).frame(width: 2)
                }
                .padding(.top, 4)
        } label: {
            Text(note.trigger)
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .textCase(.uppercase)
                .kerning(0.8)
        }
        .padding(.top, 4)
    }
}

struct PaymentGuideBadge: View {
    let level: PaymentGuideBadgeLevel

    var body: some View {
        Text(level.label)
            .font(Theme.FontToken.inter(9, weight: .medium))
            .foregroundStyle(foreground)
            .textCase(.uppercase)
            .kerning(0.7)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(border, lineWidth: 1)
            )
    }

    private var foreground: Color {
        switch level {
        case .high, .best, .ahead, .highest: return Theme.ColorToken.textPrimary
        case .medium, .hasFees: return Theme.ColorToken.textMuted
        case .low, .avoid: return Theme.ColorToken.warning
        }
    }

    private var border: Color {
        switch level {
        case .high, .best, .ahead, .highest: return Theme.ColorToken.textPrimary
        case .medium, .hasFees: return Theme.ColorToken.border
        case .low, .avoid: return Theme.ColorToken.warning
        }
    }
}

struct PaymentGuideRowView: View {
    let row: PaymentGuideRow

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 1) {
                Text(row.label)
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .lineSpacing(2)
                if let sub = row.subtitle {
                    Text(sub)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineSpacing(3)
                }
            }
            Spacer(minLength: 8)
            if let badge = row.badge {
                PaymentGuideBadge(level: badge)
            } else if let amount = row.amount {
                Text(amount)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 11)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}

struct PaymentGuideBrandChips: View {
    let chips: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(chips, id: \.self) { chip in
                Text(chip)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Theme.ColorToken.border, lineWidth: 1)
                    )
            }
        }
        .padding(.bottom, 20)
    }
}

struct PaymentGuideSegment: View {
    let options: [PaymentGuideSegmentOption]
    @Binding var selectedID: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(options) { option in
                    Button {
                        selectedID = option.id
                    } label: {
                        Text(option.title)
                            .font(Theme.FontToken.inter(10, weight: .medium))
                            .foregroundStyle(selectedID == option.id ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
                            .textCase(.uppercase)
                            .kerning(0.8)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .fill(selectedID == option.id ? Theme.ColorToken.textPrimary : Color.clear)
                                    .frame(height: 2)
                                    .offset(y: 1)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
            }
            .padding(.top, 8)

            if let option = options.first(where: { $0.id == selectedID }) {
                VStack(alignment: .leading, spacing: 0) {
                    if let pref = option.prefLabel {
                        PaymentGuideKeyTag(text: pref)
                            .padding(.bottom, 10)
                    }
                    ForEach(Array(option.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 6) {
                            Text("\(index + 1).")
                                .font(Theme.FontToken.inter(13))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                            PaymentGuideRichText(step, size: 13, weight: .light, color: Theme.ColorToken.textPrimary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.top, 14)
                .padding(.bottom, 2)
            }
        }
    }
}

struct PaymentGuideCallout: View {
    let text: String
    var warn: Bool = false

    var body: some View {
        PaymentGuideRichText(text, size: 12, weight: .light, color: warn ? Theme.ColorToken.textSecondary : Theme.ColorToken.textSecondary)
            .lineSpacing(4)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(warn ? Theme.ColorToken.warningBackground : Theme.ColorToken.backgroundSubtle)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(warn ? Theme.ColorToken.warning : Theme.ColorToken.accent)
                    .frame(width: 2)
            }
            .padding(.vertical, 18)
    }
}

struct PaymentGuideDeepLink: View {
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .textCase(.uppercase)
                .kerning(0.9)
        }
        .padding(.top, 12)
    }
}

// MARK: - Checklist

struct PaymentGuideChecklist: View {
    let items: [PaymentGuideChecklistEntry]
    let isDone: (String) -> Bool
    let onToggle: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items) { item in
                let done = isDone(item.id)
                Button { onToggle(item.id) } label: {
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(done ? Theme.ColorToken.success : Theme.ColorToken.border, lineWidth: 1)
                                .frame(width: 16, height: 16)
                                .background(done ? Theme.ColorToken.success : Color.clear)
                            if done {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.top, 2)

                        Text(item.label)
                            .font(Theme.FontToken.inter(13))
                            .foregroundStyle(done ? Theme.ColorToken.textDisabled : Theme.ColorToken.textPrimary)
                            .strikethrough(done)
                            .lineSpacing(3)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 11)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct PaymentGuideProgressHeader: View {
    let done: Int
    let total: Int

    private var detail: String {
        done == total ? "All set — you are ready to go" : "Tap each item to check it off"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(done)")
                    .font(Theme.FontToken.playfair(36, weight: .bold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text("/ \(total) done")
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
                    Rectangle()
                        .fill(Theme.ColorToken.accent)
                        .frame(width: total > 0 ? geo.size.width * CGFloat(done) / CGFloat(total) : 0, height: 1)
                        .animation(.easeInOut(duration: 0.3), value: done)
                }
            }
            .frame(height: 1)
            .padding(.top, 10)

            Text(detail)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .padding(.top, 6)
                .padding(.bottom, 18)
        }
    }
}

// MARK: - Phrases

struct PaymentGuidePhraseView: View {
    let phrase: PaymentGuidePhrase
    var onSpeak: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(phrase.labelEn)
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textDisabled)
                .textCase(.uppercase)
                .kerning(1.0)
                .padding(.bottom, 5)

            Text(phrase.chinese)
                .font(Theme.FontToken.playfair(20, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .lineSpacing(2)

            Text(phrase.translation)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .lineSpacing(3)
                .padding(.top, 4)

            if let onSpeak {
                Button(action: onSpeak) {
                    Label("Read aloud", systemImage: "speaker.wave.2.fill")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .padding(.top, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}

// MARK: - Rich text helper

struct PaymentGuideRichText: View {
    let markdown: String
    let size: CGFloat
    let weight: Font.Weight
    let color: Color
    var serif: Bool = false

    init(_ markdown: String, size: CGFloat, weight: Font.Weight, color: Color, serif: Bool = false) {
        self.markdown = markdown
        self.size = size
        self.weight = weight
        self.color = color
        self.serif = serif
    }

    var body: some View {
        MarkdownContentView(
            content: markdown,
            fontSize: size,
            foregroundColor: color,
            lineSpacing: 3
        )
    }
}
