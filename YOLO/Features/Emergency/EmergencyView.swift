import SwiftUI

struct EmergencyView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var data: EmergencyData?
    @State private var loadError: String?

    var body: some View {
        NavigationStack {
            Group {
                if let data {
                    List {
                        Section("Emergency Numbers") {
                            ForEach(data.contacts) { contact in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(contact.label): \(contact.number)")
                                    if let note = contact.note {
                                        Text(note).font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        if !data.helpPhrases.isEmpty {
                            Section("Helpful Phrases") {
                                ForEach(data.helpPhrases) { phrase in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(phrase.chinese)
                                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                                        Text(phrase.pinyin)
                                            .font(Theme.FontToken.inter(11))
                                            .foregroundStyle(Theme.ColorToken.textMuted)
                                        Text(phrase.english)
                                            .font(Theme.FontToken.inter(12))
                                            .foregroundStyle(Theme.ColorToken.textSecondary)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        Section {
                            HTMLContentView(content: data.embassyNote, fontSize: 12)
                        }
                    }
                } else if let loadError {
                    ContentUnavailableView(
                        "Unable to load",
                        systemImage: "exclamationmark.triangle",
                        description: Text(loadError)
                    )
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Emergency")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task { await load() }
        }
    }

    private func load() async {
        do {
            data = try await appEnv.content.fetchEmergencyData()
            loadError = nil
        } catch {
            loadError = error.localizedDescription
            data = nil
        }
    }
}
