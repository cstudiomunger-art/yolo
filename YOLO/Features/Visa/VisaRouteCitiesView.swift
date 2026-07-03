import SwiftUI

/// City chain inside a visa route card. Keeps a single horizontal row when it fits;
/// otherwise wraps onto multiple lines so names stay readable.
struct VisaRouteCitiesView: View {
    let cityNames: [String]
    var addedCity: String? = nil

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 6) { routeItems }
            WrappingRouteChainLayout(spacing: 6, lineSpacing: 6) { routeItems }
        }
    }

    @ViewBuilder
    private var routeItems: some View {
        ForEach(Array(cityNames.enumerated()), id: \.offset) { idx, name in
            cityLabel(name)
            if idx < cityNames.count - 1 || addedCity != nil {
                arrow
            }
        }
        if let added = addedCity {
            addedLabel(added)
        }
    }

    private func cityLabel(_ name: String) -> some View {
        Text(name)
            .font(Theme.FontToken.playfair(13, weight: .semibold))
            .fixedSize(horizontal: true, vertical: false)
    }

    private var arrow: some View {
        Image(systemName: "arrow.right")
            .font(.system(size: 9))
            .foregroundStyle(Theme.ColorToken.textGhost)
            .fixedSize()
    }

    private func addedLabel(_ name: String) -> some View {
        Text("+ " + name)
            .font(Theme.FontToken.playfair(13, weight: .semibold))
            .foregroundStyle(Theme.ColorToken.success)
            .fixedSize(horizontal: true, vertical: false)
    }
}

// MARK: - Wrapping layout

private struct WrappingRouteChainLayout: Layout {
    var spacing: CGFloat
    var lineSpacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let (_, height) = computeLines(maxWidth: maxWidth, subviews: subviews)
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let (lines, _) = computeLines(maxWidth: bounds.width, subviews: subviews)
        var y = bounds.minY
        for (lineIndex, line) in lines.enumerated() {
            var x = bounds.minX
            let rowHeight = line.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for (idx, subview) in line.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                if idx < line.count - 1 { x += size.width + spacing }
                else { x += size.width }
            }
            if lineIndex < lines.count - 1 { y += rowHeight + lineSpacing }
        }
    }

    private func computeLines(maxWidth: CGFloat, subviews: Subviews) -> ([[LayoutSubviews.Element]], CGFloat) {
        var lines: [[LayoutSubviews.Element]] = [[]]
        var x: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let needsSpacing = !lines.last!.isEmpty
            let nextX = x + (needsSpacing ? spacing : 0) + size.width

            if nextX > maxWidth && needsSpacing {
                let rowHeight = lines.last!.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
                totalHeight += rowHeight + (lines.count > 1 ? lineSpacing : 0)
                lines.append([])
                x = 0
            }

            if !lines.last!.isEmpty { x += spacing }
            lines[lines.count - 1].append(subview)
            x += size.width
        }

        if let last = lines.last, !last.isEmpty {
            totalHeight += last.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
        }
        return (lines, totalHeight)
    }
}
