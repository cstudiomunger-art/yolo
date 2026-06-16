import SwiftUI

private enum TabBarMotion {
    static let selection = Animation.spring(response: 0.38, dampingFraction: 0.82)
}

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case plan
    case guide

    var id: String { rawValue }

    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    var title: String {
        switch self {
        case .home: "Home"
        case .plan: "Plan"
        case .guide: "Guide"
        }
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .plan: "calendar"
        case .guide: "safari"
        }
    }
}

struct MainTabView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var sharedTripLink: SharedTripLink?

    private var selectedTab: Binding<AppTab> {
        Binding(
            get: { appEnv.navigation.selectedTab },
            set: { newTab in
                guard newTab != appEnv.navigation.selectedTab else { return }
                withAnimation(TabBarMotion.selection) {
                    appEnv.navigation.selectedTab = newTab
                }
            }
        )
    }

    /// Tab bar only on each tab’s root screen (Home always).
    private var showsTabBar: Bool {
        switch appEnv.navigation.selectedTab {
        case .home: true
        case .guide: appEnv.navigation.guidePathCount == 0
        case .plan: appEnv.navigation.planPathCount == 0
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    tabPage(HomeView(), width: geometry.size.width, height: geometry.size.height)
                    tabPage(PlanView(), width: geometry.size.width, height: geometry.size.height)
                    tabPage(GuideView(), width: geometry.size.width, height: geometry.size.height)
                }
                .offset(x: -CGFloat(appEnv.navigation.selectedTab.index) * geometry.size.width)
                .animation(TabBarMotion.selection, value: appEnv.navigation.selectedTab)
            }
            .id(appEnv.contentRevision)
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if showsTabBar {
                    Color.clear.frame(height: Theme.tabBarHeight + 12)
                }
            }

            if showsTabBar {
                ChinaGoTabBar(selectedTab: selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
            }

            if appEnv.audioPlayer.isVisible {
                MiniAudioPlayerView(player: appEnv.audioPlayer)
                    .zIndex(100)
            }
        }
        .background(Theme.ColorToken.background)
        .onAppear {
            presentPendingShareIfNeeded()
        }
        .onChange(of: appEnv.navigation.pendingShareSlug) { _, _ in
            presentPendingShareIfNeeded()
        }
        .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated { presentPendingShareIfNeeded() }
        }
        .sheet(item: $sharedTripLink) { link in
            SharedItineraryView(slug: link.slug)
                .environment(appEnv)
        }
        .fullScreenCover(item: Binding(
            get: { appEnv.navigation.presentedModal },
            set: { appEnv.navigation.presentedModal = $0 }
        )) { modal in
            switch modal {
            case .prepare:
                NavigationStack { PrepareView() }
            case .emergency:
                EmergencyView()
            case .infoHub:
                InfoHubView()
            case .visaChecker:
                VisaDetectorView()
            case .paymentHelper:
                PaymentHelperHomeView()
            case .geniusBar:
                GeniusBarHomeView()
            }
        }
    }

    @ViewBuilder
    private func tabPage<Content: View>(_ content: Content, width: CGFloat, height: CGFloat) -> some View {
        content
            .frame(width: width, height: height, alignment: .top)
    }

    private func presentPendingShareIfNeeded() {
        if let slug = appEnv.navigation.consumePendingShareSlug() {
            sharedTripLink = SharedTripLink(slug: slug)
        }
    }
}

private struct SharedTripLink: Identifiable {
    let slug: String
    var id: String { slug }
}

struct ChinaGoTabBar: View {
    @Binding var selectedTab: AppTab

    private let pillInset: CGFloat = 2
    private let pillCornerRadius: CGFloat = 30
    private let barCornerRadius: CGFloat = 32

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    let isSelected = selectedTab == tab
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                        Text(tab.title)
                            .font(Theme.FontToken.inter(10, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .foregroundStyle(isSelected ? Theme.ColorToken.textPrimary : Theme.ColorToken.textMuted)
                    .scaleEffect(isSelected ? 1 : 0.96)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background {
            GeometryReader { geometry in
                let tabCount = CGFloat(AppTab.allCases.count)
                let tabWidth = geometry.size.width / tabCount

                RoundedRectangle(cornerRadius: pillCornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.55))
                    .frame(width: tabWidth - pillInset * 2, height: geometry.size.height)
                    .offset(x: CGFloat(selectedTab.index) * tabWidth + pillInset)
                    .animation(TabBarMotion.selection, value: selectedTab)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: barCornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 16, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: barCornerRadius, style: .continuous)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
        }
        .animation(TabBarMotion.selection, value: selectedTab)
        .fixedSize(horizontal: false, vertical: true)
    }
}
