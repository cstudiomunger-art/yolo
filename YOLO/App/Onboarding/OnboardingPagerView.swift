import SwiftUI

struct OnboardingPagerView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var page = 0

    private let pages: [(title: String, body: String, symbol: String)] = [
        ("Plan Your China Trip", "AI builds a day-by-day itinerary from real attractions in your chosen cities.", "map"),
        ("Prepare Like a Pro", "Personalized checklists for visa, payments, and city-specific must-dos.", "checklist"),
        ("Explore with Depth", "Literary audio guides for China's greatest landmarks.", "headphones")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Skip") { finish() }
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 16)

            TabView(selection: $page) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 20) {
                        Image(systemName: item.symbol)
                            .font(.system(size: 56, weight: .light))
                            .foregroundStyle(Theme.ColorToken.accent)
                            .padding(.top, 40)
                        Text(item.title)
                            .font(Theme.FontToken.playfair(26, weight: .semibold))
                            .multilineTextAlignment(.center)
                        Text(item.body)
                            .font(Theme.FontToken.inter(14))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            Button(page == pages.count - 1 ? "Get Started" : "Next") {
                if page < pages.count - 1 {
                    withAnimation { page += 1 }
                } else {
                    finish()
                }
            }
            .font(Theme.FontToken.inter(14, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.ColorToken.textPrimary)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 32)
        }
        .background(Theme.ColorToken.background)
    }

    private func finish() {
        appEnv.preferences.markIntroOnboardingCompleted()
    }
}
