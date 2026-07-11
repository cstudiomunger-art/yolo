import SwiftUI

struct GuideCultureTipsView: View {
    let tips: [CultureTip]
    let onSelectTip: (CultureTip) -> Void

    @State private var expandedCategories: Set<CultureTipCategory> = []

    private var grouped: [(CultureTipCategory, [CultureTip])] {
        CultureTipCategory.allCases.compactMap { category in
            let items = tips.filter { $0.category == category }
            return items.isEmpty ? nil : (category, items)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(grouped, id: \.0) { category, categoryTips in
                    categorySection(category: category, tips: categoryTips)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 8)
        }
        .navigationTitle("Cultural Tips")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func categorySection(category: CultureTipCategory, tips: [CultureTip]) -> some View {
        let isExpanded = expandedCategories.contains(category)
        return VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isExpanded {
                        expandedCategories.remove(category)
                    } else {
                        expandedCategories.insert(category)
                    }
                }
            } label: {
                HStack {
                    Text(category.emoji)
                    Text(category.title)
                        .font(Theme.FontToken.inter(14, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)

            if isExpanded {
                ForEach(tips) { tip in
                    Button {
                        onSelectTip(tip)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tip.title)
                                    .font(Theme.FontToken.inter(13))
                                    .foregroundStyle(Theme.ColorToken.textPrimary)
                                Text(MarkdownContentView.plainText(from: tip.preview))
                                    .font(Theme.FontToken.inter(11))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Text("›")
                                .foregroundStyle(Theme.ColorToken.textGhost)
                        }
                        .padding(.vertical, 10)
                        .padding(.leading, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}

struct CultureTipDetailView: View {
    let tip: CultureTip

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MarkdownContentView(content: tip.body, lineSpacing: 6)

                if let doText = tip.doText, !doText.isEmpty {
                    comparisonRow(label: "Do this", text: doText, positive: true)
                }
                if let dontText = tip.dontText, !dontText.isEmpty {
                    comparisonRow(label: "Don't do this", text: dontText, positive: false)
                }
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("\(tip.emoji) \(tip.title)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationSwipeBackEnabled()
    }

    private func comparisonRow(label: String, text: String, positive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(positive ? Theme.ColorToken.accent : Theme.ColorToken.urgent)
            MarkdownContentView(content: text, fontSize: 13)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
        .cardBorderStyle()
    }
}
