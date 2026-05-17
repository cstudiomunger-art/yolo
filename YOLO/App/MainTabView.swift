import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case prepare
    case plan
    case assistant
    case guide

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .prepare: "Prepare"
        case .plan: "Plan"
        case .assistant: "Assistant"
        case .guide: "Guide"
        }
    }

    var icon: String {
        switch self {
        case .home: "house"
        case .prepare: "circle"
        case .plan: "square"
        case .assistant: "diamond"
        case .guide: "line.3.horizontal"
        }
    }
}

struct MainTabView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var selectedTab: Binding<AppTab> {
        Binding(
            get: { appEnv.navigation.selectedTab },
            set: { appEnv.navigation.selectedTab = $0 }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch appEnv.navigation.selectedTab {
                case .home: HomeView()
                case .prepare: PrepareView()
                case .plan: PlanView()
                case .assistant: AssistantView()
                case .guide: GuideView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(appEnv.contentRevision)

            ChinaGoTabBar(selectedTab: selectedTab)
        }
        .background(Theme.ColorToken.background)
    }
}

struct ChinaGoTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Theme.ColorToken.border)
                .frame(height: 1)

            HStack {
                ForEach(AppTab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 17))
                            Text(tab.title)
                                .font(Theme.FontToken.inter(9, weight: .medium))
                                .textCase(.uppercase)
                                .kerning(0.5)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(selectedTab == tab ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 8)
        }
        .frame(height: Theme.tabBarHeight)
        .background(Theme.ColorToken.background)
    }
}
