import SwiftUI

/// Aggregated booking trace for a trip — platform hotels and attractions added to
/// the itinerary, plus an external-links note. Derived purely from `days[].activities`
/// (booking trace = the itinerary itself; no separate storage). External ticket
/// links are not traced.
struct BookingTraceCard: View {
    let days: [ItineraryDay]

    private struct TracedItem: Identifiable {
        let id: String
        let title: String
        let subtitle: String
    }

    private func dayLabel(_ day: ItineraryDay) -> String {
        let label = day.dateLabel.isEmpty ? "Day \(day.dayIndex)" : day.dateLabel
        return "Day \(day.dayIndex) · \(label)"
    }

    private var hotels: [TracedItem] {
        days.flatMap { day in
            day.activities
                .filter { $0.kind == .hotel && !$0.name.isEmpty }
                .map { TracedItem(id: $0.id, title: $0.name, subtitle: dayLabel(day)) }
        }
    }

    private var attractions: [TracedItem] {
        days.flatMap { day in
            day.activities
                .filter { $0.kind == .attraction && ($0.attractionId?.isEmpty == false) && !$0.name.isEmpty }
                .map { TracedItem(id: $0.id, title: $0.name, subtitle: dayLabel(day)) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if !hotels.isEmpty {
                group(label: "🏨 已加入行程的酒店", items: hotels)
            }
            if !attractions.isEmpty {
                group(label: "📍 已加入行程的景点", items: attractions)
            }
            externalLinksNote
        }
        .background(Theme.ColorToken.background)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("My Booking Trace · 行程留痕")
                .font(Theme.FontToken.playfair(15, weight: .semibold))
                .foregroundStyle(.white)
            Text("平台内的预订与选择，聚合在这里")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(.white.opacity(0.62))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.textPrimary)
    }

    private func group(label: String, items: [TracedItem]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
            ForEach(items) { item in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(item.title)
                            .font(Theme.FontToken.inter(13))
                        Text(item.subtitle)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private var externalLinksNote: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🔗 购票链接（外部 · 不留痕）")
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
            Text("高铁 / 门票等外部购票入口为跳转链接，不记录在行程留痕中。")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}
