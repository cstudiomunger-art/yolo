import SwiftUI

/// Three-route comparison for a not-enough trip: 纯兴趣 / 办签 / 签证友好.
/// Adopting a route copies its mainland cities to the trip selection (the transit
/// exit city is advisory — add it as the last stop manually).
struct PlanRouteVisaCompareView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    let routes: [VisaRoute]
    /// Optional adopt override (Plan create flow writes the local draft selection instead of
    /// preferences). Defaults to writing `preferences.selectedCityIds` (detector verdict path).
    var onAdopt: ((VisaRoute) -> Void)? = nil
    @State private var adopted: UUID?

    private var hasFriendly: Bool { routes.contains { $0.kind == .friendly } }

    private var introText: String {
        hasFriendly
            ? "This route likely requires a visa. Below are \(routes.count) options — the visa-friendly one needs no visa and may add a city."
            : "This route likely requires a visa, and no visa-free alternative was found (often due to stay limits or city scope). All \(routes.count) options below require an L tourist visa."
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
            .navigationTitle("Pick 1 of \(routes.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
        .sheetDragToDismiss()
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
            VisaRouteCitiesView(
                cityNames: route.cities.map { $0.capitalized },
                addedCity: route.addedCity
            )
            Text(route.note).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            if route.kind == .friendly {
                Button { adopt(route) } label: {
                    Text(adopted == route.id ? "✓ Adopted" : "Adopt this route")
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
        if let onAdopt {
            onAdopt(route)
        } else {
            appEnv.preferences.selectedCityIds = route.cities
        }
        adopted = route.id
    }

    private func toneColor(_ t: VisaRoute.Tone) -> Color {
        switch t { case .warn: return Theme.ColorToken.warning; case .ok: return Theme.ColorToken.success; case .neutral: return Theme.ColorToken.textMuted }
    }
}
