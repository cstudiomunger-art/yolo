import SwiftUI

struct AssistantView: View {
    @Environment(AppEnvironment.self) private var appEnv

    var initialPrefill: String? = nil
    var initialScenarioId: String? = nil

    @State private var input = ""
    @State private var messages: [ChatMessage] = []
    @State private var showEmergency = false
    @State private var chips: [AssistantChip] = []
    @State private var isThinking = false
    @State private var isStreaming = false
    @State private var streamingText = ""
    @State private var didApplyPrefill = false
    @State private var didApplyScenario = false

    struct ChatMessage: Identifiable {
        let id = UUID()
        let isUser: Bool
        let text: String
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            if messages.count <= 1 {
                chipRow
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(messages) { message in
                        chatBubble(message)
                    }
                    if isThinking {
                        HStack {
                            ProgressView()
                            Text("Thinking…")
                                .font(Theme.FontToken.inter(12))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.vertical, 16)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            inputBar
        }
        .background(Theme.ColorToken.background)
        .sheet(isPresented: $showEmergency) {
            EmergencyView()
        }
        .task {
            if chips.isEmpty {
                chips = (try? await appEnv.content.fetchAssistantChips()) ?? []
            }
        }
        .onAppear {
            if messages.isEmpty {
                messages.append(ChatMessage(isUser: false, text: greeting))
            }
            applyPrefillIfNeeded()
            applyScenarioIfNeeded()
        }
    }

    private var greeting: String {
        appEnv.contentMode.branding.assistantGreetingGeneral
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Assistant")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text("Your in-China helper")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(chips) { chip in
                    Button { handleChip(chip.scenarioId) } label: {
                        Text(chip.label)
                            .font(Theme.FontToken.inter(11))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 10)
        }
    }

    private func chatBubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }
            Text(message.text)
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(message.isUser ? .white : Theme.ColorToken.textPrimary)
                .padding(12)
                .background(message.isUser ? Theme.ColorToken.chatUser : Theme.ColorToken.chatAI)
                .overlay(alignment: .leading) {
                    if !message.isUser {
                        Rectangle().fill(Theme.ColorToken.accent).frame(width: 2)
                    }
                }
            if !message.isUser { Spacer(minLength: 40) }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Ask anything about traveling in China...", text: $input)
                .font(Theme.FontToken.inter(14))
                .textFieldStyle(.plain)
            Button("Send") { sendMessage() }
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .disabled(isThinking || input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.vertical, 12)
        .background(Theme.ColorToken.background)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private func applyPrefillIfNeeded() {
        guard !didApplyPrefill, let prefill = initialPrefill?.trimmingCharacters(in: .whitespacesAndNewlines), !prefill.isEmpty else { return }
        didApplyPrefill = true
        input = prefill
        sendMessage()
    }

    private func applyScenarioIfNeeded() {
        guard !didApplyScenario, let scenarioId = initialScenarioId, !scenarioId.isEmpty else { return }
        didApplyScenario = true
        handleChip(scenarioId)
    }

    private func handleChip(_ scenarioId: String) {
        if scenarioId == "emergency" {
            showEmergency = true
            return
        }
        Task {
            if let reply = try? await appEnv.content.fetchAssistantReply(scenarioId: scenarioId),
               let userMessage = reply.userMessage, !userMessage.isEmpty {
                input = userMessage
            }
            sendMessage(scenarioId: scenarioId)
        }
    }

    private func formatAssistantText(_ raw: String) -> String {
        raw.replacingOccurrences(of: "\\n", with: "\n")
    }

    private func sendMessage(scenarioId: String? = nil) {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messages.append(ChatMessage(isUser: true, text: text))
        input = ""
        Task { await respond(scenarioId: scenarioId) }
    }

    private func respond(scenarioId: String?) async {
        if scenarioId == "emergency" {
            showEmergency = true
            return
        }

        if appEnv.contentMode.effectiveUseRemoteAI {
            isThinking = true
            defer { isThinking = false }
            let userText = messages.last(where: \.isUser)?.text ?? ""
            let history = messages.dropLast().suffix(12).map { msg in
                (role: msg.isUser ? "user" : "assistant", content: msg.text)
            }
            let reply = await AIService.chatAssistant(
                message: userText,
                history: Array(history),
                scenarioId: scenarioId
            )
            messages.append(ChatMessage(isUser: false, text: formatAssistantText(reply)))
            return
        }

        if let sid = scenarioId,
           let reply = try? await appEnv.content.fetchAssistantReply(scenarioId: sid) {
            messages.append(ChatMessage(isUser: false, text: formatAssistantText(reply.assistantMessage)))
        } else {
            messages.append(ChatMessage(isUser: false, text: "I'm here to help with your China trip."))
        }
    }
}

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
