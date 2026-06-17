import SwiftUI
import PhotosUI

// MARK: - Home (pick a human)

struct GeniusBarHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var openChat = false
    @State private var starting = false

    private var service: SupportChatService { appEnv.supportChat }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    sosCard
                    if !service.myConversations.isEmpty {
                        inbox
                    }
                    Text("选一位伙伴和你聊（点头像即开始）：")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                    grid
                    boundaryCard
                    if appEnv.auth.userId == nil {
                        Text("登录后才能开始对话。")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.warning)
                    }
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("Genius Bar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } } }
            .task {
                await service.loadAgents()
                if let uid = appEnv.auth.userId { await service.loadMyConversations(userId: uid) }
                appEnv.enablePushRegistration()
            }
            .onAppear {
                if let uid = appEnv.auth.userId { service.subscribeHomeRealtime(userId: uid) }
            }
            .onDisappear {
                Task { await service.stopHomeRealtime() }
            }
            .navigationDestination(isPresented: $openChat) { GeniusBarChatView() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Talk to a Human").font(Theme.FontToken.playfair(24, weight: .semibold))
            Text("真诚是我们的护城河，不是机器人。我们是真心想帮你。")
                .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
        }
    }

    private var sosCard: some View {
        Button { start(agentId: nil, priority: "emergency") } label: {
            HStack(spacing: 13) {
                Text("🆘").font(.system(size: 26))
                VStack(alignment: .leading, spacing: 2) {
                    Text("在华紧急支援").font(Theme.FontToken.playfair(15, weight: .semibold))
                    Text("迷路 / 被偷报警 / 找不到帮手 — 远程支援")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(Theme.ColorToken.warningBackground)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ColorToken.warning.opacity(0.4), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .disabled(appEnv.auth.userId == nil || starting)
    }

    private var inbox: some View {
        VStack(alignment: .leading, spacing: 14) {
            if !service.activeConversations.isEmpty {
                conversationSection("进行中 · 继续聊", convs: service.activeConversations, history: false)
            }
            if !service.historyConversations.isEmpty {
                conversationSection("历史会话 · 只读", convs: service.historyConversations, history: true)
            }
        }
    }

    private func conversationSection(_ title: String, convs: [SupportConversation], history: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textMuted).textCase(.uppercase)
            ForEach(convs) { conv in
                Button { resume(conv) } label: { conversationRow(conv, history: history) }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            Task { await service.deleteMyConversation(conv.id) }
                        } label: { Label("删除记录", systemImage: "trash") }
                    }
            }
            if history {
                Text("长按可删除历史记录（仅从你这里移除）")
                    .font(Theme.FontToken.inter(9)).foregroundStyle(Theme.ColorToken.textGhost)
            }
        }
    }

    private func conversationRow(_ conv: SupportConversation, history: Bool) -> some View {
        HStack(spacing: 11) {
            Text(conv.priority == "emergency" ? "🆘" : "💬").font(.system(size: 18))
            VStack(alignment: .leading, spacing: 1) {
                Text(agentName(conv.agentId)).font(Theme.FontToken.inter(13, weight: .medium))
                Text(history ? "已结束 · 查看记录"
                     : (conv.priority == "emergency" ? "紧急支援会话" : "继续和 TA 聊"))
                    .font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
            if !history {
                let unread = service.unread(for: conv.id)
                if unread > 0 {
                    Text("\(unread)")
                        .font(Theme.FontToken.inter(10, weight: .bold)).foregroundStyle(.white)
                        .frame(minWidth: 18).padding(.horizontal, 5).padding(.vertical, 2)
                        .background(Theme.ColorToken.urgent).clipShape(Capsule())
                }
            }
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textGhost)
        }
        .padding(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
        .opacity(history ? 0.7 : 1)
    }

    private func agentName(_ agentId: String?) -> String {
        guard let agentId, let a = service.agents.first(where: { $0.id == agentId }) else { return "客服" }
        return a.name
    }

    private func resume(_ conv: SupportConversation) {
        Task { await service.openConversation(conv); openChat = true }
    }

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 11), GridItem(.flexible(), spacing: 11)], spacing: 11) {
            ForEach(service.agents) { agent in
                agentCard(agent)
            }
        }
    }

    private func agentCard(_ agent: SupportAgent) -> some View {
        Button { start(agentId: agent.id, priority: "normal") } label: {
            VStack(spacing: 6) {
                ZStack(alignment: .bottomTrailing) {
                    agentAvatar(agent, size: 56)
                    Circle().fill(statusColor(agent.status)).frame(width: 13, height: 13)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
                Text(agent.name).font(Theme.FontToken.playfair(15, weight: .semibold))
                Text(agent.role).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.accent)
                Text(statusLabel(agent.status)).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.ColorToken.borderLight, lineWidth: 1))
            .opacity(agent.isReachable ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!agent.isReachable || appEnv.auth.userId == nil || starting)
    }

    private var boundaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("✓ 我们能帮").font(Theme.FontToken.inter(10, weight: .semibold)).foregroundStyle(Theme.ColorToken.success)
            Text("行前答疑 · 帮你找帮手 · 付款绑卡协助 · 在华紧急联络支援")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            Text("— 暂不能帮").font(Theme.FontToken.inter(10, weight: .semibold)).foregroundStyle(Theme.ColorToken.textMuted).padding(.top, 4)
            Text("重大医疗诊断 · 涉政法律事务 — 请优先联系官方机构（110 / 120 / 使领馆）")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            Text("※ 边界文案待团队最终确认").font(Theme.FontToken.inter(9)).foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ColorToken.borderLight, lineWidth: 1))
    }

    @ViewBuilder
    private func agentAvatar(_ agent: SupportAgent, size: CGFloat) -> some View {
        if let urlStr = agent.avatarUrl, !urlStr.isEmpty, let url = URL(string: urlStr) {
            AsyncImage(url: url) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                Circle().fill(Theme.ColorToken.backgroundSubtle)
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
        } else {
            Circle().fill(LinearGradient(colors: [Theme.ColorToken.accent, Theme.ColorToken.textPrimary], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: size, height: size)
                .overlay(Text(agent.avatarSeed.isEmpty ? String(agent.name.prefix(1)) : agent.avatarSeed)
                    .font(Theme.FontToken.playfair(20, weight: .bold)).foregroundStyle(.white))
        }
    }

    private func statusColor(_ s: String) -> Color {
        switch s { case "online": return Theme.ColorToken.success; case "busy": return Theme.ColorToken.warning; default: return Theme.ColorToken.textGhost }
    }
    private func statusLabel(_ s: String) -> String {
        switch s { case "online": return "🟢 在线 · 通常几分钟回"; case "busy": return "🟡 忙 · 稍后回"; default: return "离线" }
    }

    private func start(agentId: String?, priority: String) {
        guard let uid = appEnv.auth.userId, !starting else { return }
        starting = true
        Task {
            await service.startConversation(
                userId: uid, agentId: agentId, priority: priority,
                displayName: appEnv.preferences.displayName, email: appEnv.auth.userEmail
            )
            starting = false
            if service.conversation != nil { openChat = true }
        }
    }
}

// MARK: - Chat

struct GeniusBarChatView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var draft = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var showEndConfirm = false
    @State private var shownTranslations: Set<String> = []

    private var service: SupportChatService { appEnv.supportChat }

    private var closedBanner: some View {
        VStack(spacing: 8) {
            Text("会话已结束 · 再次咨询将开启新会话")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            if let agentId = service.conversation?.agentId, let uid = appEnv.auth.userId {
                Button {
                    Task {
                        await service.startConversation(userId: uid, agentId: agentId,
                            displayName: appEnv.preferences.displayName, email: appEnv.auth.userEmail)
                    }
                } label: {
                    Text("再次咨询 TA")
                        .font(Theme.FontToken.inter(13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Theme.ColorToken.success).clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(service.messages) { msg in
                            bubble(msg).id(msg.id)
                                .onAppear {
                                    if service.shouldAutoTranslate(msg) {
                                        Task { await service.translateMessage(msg) }
                                    }
                                }
                        }
                    }
                    .padding(Theme.screenPadding)
                }
                .onChange(of: service.messages.count) { _, _ in
                    if let last = service.messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } }
                }
            }
            if service.conversation?.isClosed == false && service.agentIsTyping {
                Text("对方正在输入…")
                    .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Theme.screenPadding).padding(.bottom, 4)
            }
            if service.conversation?.isClosed == true {
                closedBanner
            } else {
                inputBar
            }
        }
        .onChange(of: draft) { _, value in
            if !value.isEmpty { Task { await service.userIsTyping() } }
        }
        .navigationTitle("对话")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Toggle("自动翻译收到的消息", isOn: Binding(
                        get: { service.autoTranslate },
                        set: { service.autoTranslate = $0; if $0 { service.autoTranslateVisibleTail() } }
                    ))
                } label: {
                    Image(systemName: service.autoTranslate ? "globe.badge.chevron.backward" : "globe")
                        .foregroundStyle(service.autoTranslate ? Theme.ColorToken.success : Theme.ColorToken.textMuted)
                }
            }
            if service.conversation?.isClosed == false {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("结束会话") { showEndConfirm = true }
                        .font(Theme.FontToken.inter(12, weight: .medium))
                }
            }
        }
        .confirmationDialog("结束这次会话？", isPresented: $showEndConfirm, titleVisibility: .visible) {
            Button("结束会话", role: .destructive) { Task { await service.endConversation() } }
            Button("取消", role: .cancel) {}
        } message: {
            Text("结束后会进入「历史会话」，需要时可再次咨询（开启新会话）。")
        }
        .task { await service.loadMessages() }
        .onDisappear { service.stopPolling() }
        .onChange(of: photoItem) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let uid = appEnv.auth.userId {
                    await service.sendImage(data, userId: uid)
                }
                photoItem = nil
            }
        }
    }

    @ViewBuilder
    private func bubble(_ msg: SupportMessage) -> some View {
        HStack {
            if msg.isFromUser { Spacer(minLength: 40) }
            VStack(alignment: msg.isFromUser ? .trailing : .leading, spacing: 3) {
                if let path = msg.imageUrl {
                    ChatImageView(path: path, service: service)
                } else {
                    Text(msg.bodyOriginal ?? "")
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(msg.isFromUser ? .white : Theme.ColorToken.textPrimary)
                        .padding(.horizontal, 13).padding(.vertical, 10)
                        .background(msg.isFromUser ? Theme.ColorToken.success : Theme.ColorToken.background)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(msg.isFromUser ? .clear : Theme.ColorToken.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    if translatedVisible(msg), let t = msg.bodyTranslated, !t.isEmpty {
                        Text("🌐 " + t).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    translateControl(msg)
                }
            }
            if !msg.isFromUser { Spacer(minLength: 40) }
        }
    }

    private func translatedVisible(_ msg: SupportMessage) -> Bool {
        guard (msg.bodyTranslated ?? "").isEmpty == false else { return false }
        return service.autoTranslate || shownTranslations.contains(msg.id)
    }

    @ViewBuilder
    private func translateControl(_ msg: SupportMessage) -> some View {
        if let body = msg.bodyOriginal, !body.isEmpty {
            if service.translatingIds.contains(msg.id) {
                Text("翻译中…").font(Theme.FontToken.inter(9)).foregroundStyle(Theme.ColorToken.textMuted)
            } else if (msg.bodyTranslated ?? "").isEmpty {
                Button("翻译") { Task { await service.translateMessage(msg) } }
                    .font(Theme.FontToken.inter(9, weight: .medium)).foregroundStyle(Theme.ColorToken.accent)
                    .buttonStyle(.plain)
            } else if !service.autoTranslate {
                Button(shownTranslations.contains(msg.id) ? "隐藏译文" : "显示译文") {
                    if shownTranslations.contains(msg.id) { shownTranslations.remove(msg.id) } else { shownTranslations.insert(msg.id) }
                }
                .font(Theme.FontToken.inter(9, weight: .medium)).foregroundStyle(Theme.ColorToken.accent)
                .buttonStyle(.plain)
            }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 9) {
            PhotosPicker(selection: $photoItem, matching: .images) {
                Image(systemName: "photo").font(.system(size: 18)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
            TextField("发消息…（中英都行，自动翻译）", text: $draft, axis: .vertical)
                .font(Theme.FontToken.inter(13)).lineLimit(1...4)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Theme.ColorToken.backgroundSubtle).clipShape(Capsule())
            Button { sendText() } label: {
                Image(systemName: "arrow.up.circle.fill").font(.system(size: 30)).foregroundStyle(Theme.ColorToken.success)
            }
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || service.isSending)
        }
        .padding(10)
        .background(.ultraThinMaterial)
    }

    private func sendText() {
        let text = draft
        draft = ""
        guard let uid = appEnv.auth.userId else { return }
        Task { await service.sendText(text, userId: uid) }
    }
}

/// Resolves a signed URL for a private chat image and renders it.
private struct ChatImageView: View {
    let path: String
    let service: SupportChatService
    @State private var url: URL?

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: { Color.gray.opacity(0.15) }
                .frame(width: 180, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.15)).frame(width: 180, height: 130)
            }
        }
        .task { url = await service.signedImageURL(for: path) }
    }
}
