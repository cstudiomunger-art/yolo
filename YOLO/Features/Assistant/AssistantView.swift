import SwiftUI

struct AssistantView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var mode: AssistantMode = .general
    @State private var input = ""
    @State private var messages: [ChatMessage] = []
    @State private var planningCard: SampleItinerary?
    @State private var showEmergency = false

    enum AssistantMode {
        case planning
        case general
    }

    struct ChatMessage: Identifiable {
        let id = UUID()
        let isUser: Bool
        let text: String
    }

    @State private var chips: [AssistantChip] = []

    var body: some View {
        VStack(spacing: 0) {
            header
            segmentControl

            if mode == .general {
                chipRow
            } else {
                planningBanner
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(messages) { message in
                        chatBubble(message)
                    }
                    if let card = planningCard, mode == .planning {
                        ItineraryCardView(itinerary: card) {
                            appEnv.preferences.saveItinerary(card)
                            appEnv.navigation.openTab(.plan)
                        } onRedo: {
                            planningCard = nil
                            messages.append(ChatMessage(isUser: false, text: "Tell me what you'd like to change."))
                        }
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.vertical, 16)
            }

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
            if appEnv.navigation.assistantStartInPlanning {
                mode = .planning
                appEnv.navigation.assistantStartInPlanning = false
            }
        }
    }

    private var greeting: String {
        let branding = appEnv.contentMode.branding
        return mode == .planning
            ? branding.assistantGreetingPlanning
            : branding.assistantGreetingGeneral
    }

    private var planningBanner: some View {
        HStack(spacing: 4) {
            Text("Planning:")
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
            Text(appEnv.preferences.selectedCityIds.first?.capitalized ?? "Beijing")
                .font(Theme.FontToken.inter(10, weight: .medium))
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.vertical, 10)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Travel Assistant")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
            Text("Real-time help · \(appEnv.contentMode.contentModeLabel)")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    private var segmentControl: some View {
        HStack(spacing: 0) {
            segmentButton("🗺 Trip Planning", mode == .planning) {
                mode = .planning
                messages = [ChatMessage(isUser: false, text: greeting)]
                planningCard = nil
            }
            segmentButton("💬 General Help", mode == .general) {
                mode = .general
                messages = [ChatMessage(isUser: false, text: greeting)]
                planningCard = nil
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
    }

    private func segmentButton(_ title: String, _ active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(active ? Theme.ColorToken.textPrimary : Theme.ColorToken.textDisabled)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(alignment: .bottom) {
                    if active {
                        Rectangle().fill(Theme.ColorToken.textPrimary).frame(height: 1)
                    }
                }
        }
        .buttonStyle(.plain)
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
            TextField(mode == .planning ? "Refine your plan..." : "Ask a question...", text: $input)
                .font(Theme.FontToken.inter(14))
            Button("Send") { sendMessage() }
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.vertical, 12)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.ColorToken.border).frame(height: 1)
        }
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

    private func sendMessage(scenarioId: String? = nil) {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messages.append(ChatMessage(isUser: true, text: text))
        input = ""
        Task { await respond(scenarioId: scenarioId) }
    }

    private func respond(scenarioId: String?) async {
        if appEnv.contentMode.useRemoteAI {
            messages.append(ChatMessage(
                isUser: false,
                text: "远程 AI 尚未连接。请在 CMS 关闭「真实 AI」，或配置 Edge Function 后重试。"
            ))
            return
        }

        if mode == .planning {
            if planningCard == nil {
                messages.append(ChatMessage(isUser: false, text: "Perfect. Here's a rough structure — review the card below:"))
                planningCard = try? await AIService.planningItineraryCard(content: appEnv.content)
            } else {
                messages.append(ChatMessage(isUser: false, text: "Got it. I've noted your preferences. Tap Redo on the card to regenerate."))
            }
            return
        }

        let sid = scenarioId ?? "payment"
        if let reply = try? await appEnv.content.fetchAssistantReply(scenarioId: sid) {
            messages.append(ChatMessage(isUser: false, text: reply.assistantMessage))
        } else {
            messages.append(ChatMessage(isUser: false, text: "I'm here to help with your China trip."))
        }
    }
}

struct ItineraryCardView: View {
    let itinerary: SampleItinerary
    let onSave: () -> Void
    let onRedo: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(itinerary.title)
                .font(Theme.FontToken.playfair(16, weight: .semibold))
            Text(itinerary.meta)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)

            ForEach(itinerary.days.prefix(2)) { day in
                Text(day.dateLabel)
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                ForEach(day.activities.prefix(3)) { act in
                    HStack(alignment: .top, spacing: 8) {
                        Text(act.timeSlot)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textDisabled)
                            .frame(width: 28, alignment: .leading)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(act.name).font(Theme.FontToken.inter(12))
                            Text(act.detail).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                        }
                    }
                }
            }

            HStack {
                Text(itinerary.estimatedBudget)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                Button("🔄 Redo", action: onRedo)
                    .font(Theme.FontToken.inter(11))
                Button("✅ Save to Plan", action: onSave)
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
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
                        Section {
                            Text(data.embassyNote)
                                .font(Theme.FontToken.inter(12))
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
