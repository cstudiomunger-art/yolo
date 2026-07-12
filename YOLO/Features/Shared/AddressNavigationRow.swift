import SwiftUI

/// Tappable address rows — English and Chinese addresses are separate, each opens the nav-app picker.
struct AddressNavigationRow: View {
    let destination: MapDestination
    var fontSize: CGFloat = 11
    var showsPin = true
    var showsTrailingArrow = true
    var showsCopyButton = false

    @State private var showNavPicker = false
    @State private var navProviders: [MapNavigationProvider] = []
    @State private var pendingDestination: MapDestination?
    @State private var copiedLine: String?

    private var lines: [(text: String, destination: MapDestination)] {
        destination.navigationLines
    }

    var body: some View {
        if destination.canOpenInMaps, !lines.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                    addressLine(
                        text: line.text,
                        destination: line.destination,
                        showsPin: showsPin && index == 0
                    )
                }
            }
            .confirmationDialog(
                String(localized: "Choose navigation app"),
                isPresented: $showNavPicker,
                titleVisibility: .visible
            ) {
                ForEach(navProviders) { provider in
                    Button(provider.localizedName) {
                        if let pendingDestination {
                            MapNavigation.open(destination: pendingDestination, provider: provider)
                        }
                    }
                }
                Button(String(localized: "Cancel"), role: .cancel) {}
            }
        }
    }

    @ViewBuilder
    private func addressLine(
        text: String,
        destination lineDestination: MapDestination,
        showsPin: Bool
    ) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Button {
                requestNavigation(for: lineDestination)
            } label: {
                HStack(alignment: .top, spacing: 4) {
                    if showsPin {
                        Text("📍")
                            .font(Theme.FontToken.inter(fontSize))
                    }
                    Text(text)
                        .font(Theme.FontToken.inter(fontSize))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                    if showsTrailingArrow {
                        Text(String(localized: "Maps →"))
                            .font(Theme.FontToken.inter(max(fontSize - 1, 10), weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                }
            }
            .buttonStyle(.plain)

            if showsCopyButton {
                Button(action: { copy(text) }) {
                    Image(systemName: copiedLine == text ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(copiedLine == text ? Color.green : Theme.ColorToken.accent)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func requestNavigation(for lineDestination: MapDestination) {
        switch MapNavigation.navigationChoice(for: lineDestination) {
        case .chooseFrom(let providers):
            pendingDestination = lineDestination
            navProviders = providers
            showNavPicker = true
        case .unavailable:
            break
        }
    }

    private func copy(_ text: String) {
        UIPasteboard.general.string = text
        withAnimation(.easeInOut(duration: 0.15)) { copiedLine = text }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                if copiedLine == text { copiedLine = nil }
            }
        }
    }
}

#Preview {
    AddressNavigationRow(
        destination: MapDestination(
            name: "Forbidden City",
            addressZh: "北京市东城区景山前街4号",
            addressEn: "4 Jingshan Front St, Dongcheng, Beijing",
            latitude: 39.9163,
            longitude: 116.3972
        ),
        fontSize: 12,
        showsPin: false,
        showsCopyButton: true
    )
    .padding()
}
