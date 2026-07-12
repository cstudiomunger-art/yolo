import SwiftUI

/// Tappable address row that opens an installed map app (with picker when several are available).
struct AddressNavigationRow: View {
    let destination: MapDestination
    var fontSize: CGFloat = 11
    var showsPin = true
    var showsTrailingArrow = true
    var showsCopyButton = false

    @State private var showNavPicker = false
    @State private var navProviders: [MapNavigationProvider] = []
    @State private var copied = false

    var body: some View {
        if destination.canOpenInMaps, let line = destination.displayAddressLine {
            HStack(alignment: .top, spacing: 4) {
                Button(action: requestNavigation) {
                    HStack(alignment: .top, spacing: 4) {
                        if showsPin {
                            Text("📍")
                                .font(Theme.FontToken.inter(fontSize))
                        }
                        Text(line)
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

                if showsCopyButton, let copyText = copyText {
                    Button(action: { copy(copyText) }) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(copied ? Color.green : Theme.ColorToken.accent)
                    }
                    .buttonStyle(.plain)
                }
            }
            .confirmationDialog(
                String(localized: "Open in Maps"),
                isPresented: $showNavPicker,
                titleVisibility: .visible
            ) {
                ForEach(navProviders) { provider in
                    Button(provider.localizedName) {
                        MapNavigation.open(destination: destination, provider: provider)
                    }
                }
                Button(String(localized: "Cancel"), role: .cancel) {}
            }
        }
    }

    private var copyText: String? {
        destination.addressZh?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
            ?? destination.addressEn?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
    }

    private func requestNavigation() {
        switch MapNavigation.openBestAvailable(destination: destination) {
        case .opened:
            break
        case .chooseFrom(let providers):
            navProviders = providers
            showNavPicker = true
        case .unavailable:
            break
        }
    }

    private func copy(_ text: String) {
        UIPasteboard.general.string = text
        withAnimation(.easeInOut(duration: 0.15)) { copied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) { copied = false }
        }
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
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
        showsCopyButton: true
    )
    .padding()
}
