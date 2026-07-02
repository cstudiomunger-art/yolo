import SwiftUI

/// Phase 2 §1: the moment a Plan route is ready, judge it once (coarse defaults) and — only
/// if it's not visa-enough — float a hint that opens the detector for a full, editable
/// re-check. 够用 → 不打扰（renders nothing）。措辞兜底「以边检最终判定为准」。
struct VisaPlanHintBanner: View {
    @Environment(AppEnvironment.self) private var appEnv
    let citySlugs: [String]
    let start: Date?
    let end: Date?

    @State private var rec: VisaRecommendation?
    @State private var showDetector = false

    var body: some View {
        Group {
            if let rec, !rec.isEnough {
                banner(rec)
            }
        }
        .task(id: taskKey) {
            await appEnv.visaData.load()
            rec = VisaCoarseCheck.recommendation(
                citySlugs: citySlugs, start: start, end: end,
                countryCode: appEnv.preferences.countryCode, data: appEnv.visaData.data)
        }
        .sheet(isPresented: $showDetector) {
            VisaDetectorView(presetCitySlugs: citySlugs, presetStart: start, presetEnd: end)
        }
    }

    private var taskKey: String { citySlugs.joined(separator: ",") + "|" + (start?.timeIntervalSince1970.description ?? "") }

    private func banner(_ rec: VisaRecommendation) -> some View {
        Button { showDetector = true } label: {
            HStack(spacing: 10) {
                Text("🛂").font(.system(size: 18))
                VStack(alignment: .leading, spacing: 2) {
                    Text(rec.level == .amber ? "Conditional visa-free entry — verify details" : "This route may require a visa by default")
                        .font(Theme.FontToken.inter(12, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text("Based on common defaults (round-trip same country, major airports). Tap to adjust departure/port/onward ticket and see visa-friendly routes.")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.warning)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.ColorToken.warning.opacity(0.08))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.warning.opacity(0.4), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
