import SwiftUI

/// Three-route comparison for a not-enough trip: 纯兴趣 / 办签 / 签证友好.
/// Adopting a route copies its mainland cities to the trip selection (the transit
/// exit city is advisory — add it as the last stop manually).
struct PlanRouteVisaCompareView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    let routes: [VisaRoute]
    @State private var adopted: VisaRoute.Kind?

    private var hasFriendly: Bool { routes.contains { $0.kind == .friendly } }

    private var introText: String {
        hasFriendly
            ? "这条线默认需签证。下面 \(routes.count) 条走法，签证友好那条不用办签、还可能多一座城。"
            : "这条线默认需签证，且暂未找到免签走法（多因停留超免签时限或城市超范围）。下面 \(routes.count) 条都需办 L 旅游签证。"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .top, spacing: 9) {
                        Text("🛂")
                        Text(introText)
                            .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                    }
                    .padding(12)
                    .background(Theme.ColorToken.backgroundSubtle)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    ForEach(routes) { route in
                        routeCard(route)
                    }
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("\(routes.count) 选 1")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } } }
        }
    }

    private func routeCard(_ route: VisaRoute) -> some View {
        let tone = toneColor(route.badgeTone)
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
                ForEach(Array(route.cities.enumerated()), id: \.offset) { _, city in
                    Text(city.capitalized).font(Theme.FontToken.playfair(13, weight: .semibold))
                    Image(systemName: "arrow.right").font(.system(size: 9)).foregroundStyle(Theme.ColorToken.textGhost)
                }
                if let added = route.addedCity {
                    Text("+ " + added).font(Theme.FontToken.playfair(13, weight: .semibold)).foregroundStyle(Theme.ColorToken.success)
                }
            }
            Text(route.note).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            if route.kind == .friendly {
                Button { adopt(route) } label: {
                    Text(adopted == .friendly ? "✓ 已采用" : "采用这条")
                        .font(Theme.FontToken.inter(12, weight: .semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Theme.ColorToken.success).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(route.kind == .friendly ? Theme.ColorToken.success : Theme.ColorToken.border, lineWidth: route.kind == .friendly ? 1.5 : 1))
    }

    private func adopt(_ route: VisaRoute) {
        appEnv.preferences.selectedCityIds = route.cities
        adopted = route.kind
    }

    private func toneColor(_ t: VisaRoute.Tone) -> Color {
        switch t { case .warn: return Theme.ColorToken.warning; case .ok: return Theme.ColorToken.success; case .neutral: return Theme.ColorToken.textMuted }
    }
}
