import SwiftUI
import PhotosUI
import UIKit

// MARK: - Home (pick a human)

/// What a tap should open in the chat view. Driving navigation by intent lets us
/// push the chat screen instantly and create/resume the conversation inside it,
/// instead of greying the home grid while a network round-trip runs first.
enum ChatIntent: Hashable {
    case resume(SupportConversation)
    case start(agentId: String?, priority: String)
}

/// Presents Genius Bar for signed-in users; guests see a login prompt first.
struct GeniusBarGateView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var showLogin = false

    var body: some View {
        Group {
            if appEnv.mustSignInForAccountAction {
                accountSignInPlaceholder
            } else {
                GeniusBarHomeView()
            }
        }
        .loginSheet(isPresented: $showLogin, appEnv: appEnv)
        .onAppear {
            if appEnv.mustSignInForAccountAction {
                showLogin = true
            }
        }
        .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                showLogin = false
            }
        }
        .onChange(of: showLogin) { _, showing in
            if !showing, appEnv.mustSignInForAccountAction {
                appEnv.navigation.dismissModal()
            }
        }
    }

    private var accountSignInPlaceholder: some View {
        NavigationStack {
            AccountSignInPrompt(
                title: String(localized: "Sign in to use Genius Bar"),
                message: String(localized: "Chat with our team for trip help, payment issues, and emergency support in China.")
            ) {
                showLogin = true
            }
            .navigationTitle("Genius Bar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { appEnv.navigation.dismissModal() }
                }
            }
        }
    }
}

struct GeniusBarHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var chatIntent: ChatIntent?
    @State private var showHistory = false

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
                    Text("Pick someone to chat with (tap their avatar to start):")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                    grid
                    boundaryCard
                    if appEnv.auth.userId == nil {
                        Text("Sign in to start a conversation.")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.warning)
                    }
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("Genius Bar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
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
            .navigationDestination(item: $chatIntent) { GeniusBarChatView(intent: $0) }
            .navigationDestination(isPresented: $showHistory) { GeniusBarHistoryView() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Talk to a Human").font(Theme.FontToken.playfair(24, weight: .semibold))
            Text("Authenticity is our moat — we're not bots. We genuinely want to help.")
                .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
        }
    }

    private var sosCard: some View {
        Button { chatIntent = .start(agentId: nil, priority: "emergency") } label: {
            HStack(spacing: 13) {
                Text("🆘").font(.system(size: 26))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Emergency support in China").font(Theme.FontToken.playfair(15, weight: .semibold))
                    Text("Lost / theft & police / can't find help — remote support")
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
        .disabled(appEnv.auth.userId == nil)
    }

    private var inbox: some View {
        VStack(alignment: .leading, spacing: 14) {
            if !service.activeConversations.isEmpty {
                conversationSection("Active · Continue", convs: service.activeConversations, history: false)
            }
            if !service.historyConversations.isEmpty {
                historyButton
            }
        }
    }

    private var historyButton: some View {
        Button { showHistory = true } label: {
            HStack(spacing: 11) {
                Image(systemName: "clock.arrow.circlepath").font(.system(size: 17)).foregroundStyle(Theme.ColorToken.textSecondary)
                VStack(alignment: .leading, spacing: 1) {
                    Text("History").font(Theme.FontToken.inter(13, weight: .medium))
                    Text("View ended conversations").font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Text("\(service.historyConversations.count)").font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textGhost)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())  // whole button (incl. blank space) tappable, not just text/icons
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func conversationSection(_ title: String, convs: [SupportConversation], history: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textMuted).textCase(.uppercase)
            ForEach(convs) { conv in
                Button { chatIntent = .resume(conv) } label: { conversationRow(conv, history: history) }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            Task { await service.deleteMyConversation(conv.id) }
                        } label: { Label("Delete", systemImage: "trash") }
                    }
            }
            if history {
                Text("Long-press to delete history (removed on your device only)")
                    .font(Theme.FontToken.inter(9)).foregroundStyle(Theme.ColorToken.textGhost)
            }
        }
    }

    private func conversationRow(_ conv: SupportConversation, history: Bool) -> some View {
        HStack(spacing: 11) {
            Text(conv.priority == "emergency" ? "🆘" : "💬").font(.system(size: 18))
            VStack(alignment: .leading, spacing: 1) {
                Text(agentName(conv.agentId)).font(Theme.FontToken.inter(13, weight: .medium))
                Text(history ? "Ended · View history"
                     : (conv.priority == "emergency" ? "Emergency support chat" : "Continue chatting"))
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
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())  // make the whole row (incl. blank space) tappable, not just text/icons
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
        .opacity(history ? 0.7 : 1)
    }

    private func agentName(_ agentId: String?) -> String {
        guard let agentId, let a = service.agents.first(where: { $0.id == agentId }) else { return "Support" }
        return a.name
    }

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 11), GridItem(.flexible(), spacing: 11)], spacing: 11) {
            ForEach(service.agents) { agent in
                agentCard(agent)
            }
        }
    }

    private func agentCard(_ agent: SupportAgent) -> some View {
        Button { chatIntent = .start(agentId: agent.id, priority: "normal") } label: {
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
            .contentShape(Rectangle())  // whole card tappable, not just the avatar/text
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.ColorToken.borderLight, lineWidth: 1))
            .opacity(agent.isReachable ? 1 : 0.5)
        }
        .buttonStyle(.plain)
        .disabled(!agent.isReachable || appEnv.auth.userId == nil)
    }

    private var boundaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("✓ We can help").font(Theme.FontToken.inter(10, weight: .semibold)).foregroundStyle(Theme.ColorToken.success)
            Text("Pre-trip Q&A · finding local help · payment & card binding · emergency support in China")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            Text("— We can't help with").font(Theme.FontToken.inter(10, weight: .semibold)).foregroundStyle(Theme.ColorToken.textMuted).padding(.top, 4)
            Text("Major medical diagnoses · political or legal matters — contact official services first (110 / 120 / embassy)")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            Text("※ Boundary copy pending final team review").font(Theme.FontToken.inter(9)).foregroundStyle(Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ColorToken.borderLight, lineWidth: 1))
    }

    @ViewBuilder
    private func agentAvatar(_ agent: SupportAgent, size: CGFloat) -> some View {
        CachedAvatarImage(urlString: agent.avatarUrl) {
            Circle().fill(LinearGradient(colors: [Theme.ColorToken.accent, Theme.ColorToken.textPrimary], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(Text(agent.avatarSeed.isEmpty ? String(agent.name.prefix(1)) : agent.avatarSeed)
                    .font(Theme.FontToken.playfair(20, weight: .bold)).foregroundStyle(.white))
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private func statusColor(_ s: String) -> Color {
        switch s { case "online": return Theme.ColorToken.success; case "busy": return Theme.ColorToken.warning; default: return Theme.ColorToken.textGhost }
    }
    private func statusLabel(_ s: String) -> String {
        switch s { case "online": return "🟢 Online · usually replies in minutes"; case "busy": return "🟡 Busy · replies later"; default: return "Offline" }
    }

}

// MARK: - History (read-only list, left-swipe to delete)

struct GeniusBarHistoryView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var chatIntent: ChatIntent?
    private var service: SupportChatService { appEnv.supportChat }

    var body: some View {
        List {
            if service.historyConversations.isEmpty {
                Text("No conversation history")
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            } else {
                ForEach(service.historyConversations) { conv in
                    // In a List, a Button(.plain) only registers taps on its content, so
                    // blank space wouldn't respond — use a full-row contentShape + onTapGesture.
                    HStack(spacing: 11) {
                        Text(conv.priority == "emergency" ? "🆘" : "💬").font(.system(size: 18))
                        VStack(alignment: .leading, spacing: 1) {
                            Text(agentName(conv.agentId)).font(Theme.FontToken.inter(14, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                            Text("Ended · View history").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textGhost)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { chatIntent = .resume(conv) }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task { await service.deleteMyConversation(conv.id) }
                        } label: { Label("Delete", systemImage: "trash") }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationSwipeBackEnabled()
        .navigationDestination(item: $chatIntent) { GeniusBarChatView(intent: $0) }
    }

    private func agentName(_ agentId: String?) -> String {
        guard let agentId, let a = service.agents.first(where: { $0.id == agentId }) else { return "Support" }
        return a.name
    }
}

// MARK: - Chat

struct GeniusBarChatView: View {
    /// What to open. `nil` means the conversation is already set on the service
    /// (e.g. push-notification routing) — just load its messages.
    var intent: ChatIntent?

    @Environment(AppEnvironment.self) private var appEnv
    @State private var draft = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var showEndConfirm = false
    @State private var shownTranslations: Set<String> = []
    @FocusState private var inputFocused: Bool

    private var service: SupportChatService { appEnv.supportChat }

    /// Resolve the tapped intent — runs once when the (freshly pushed) chat view appears.
    private func resolveIntent() async {
        switch intent {
        case .resume(let conv):
            await service.openConversation(conv)
        case .start(let agentId, let priority):
            guard let uid = appEnv.auth.userId else { return }
            await service.startConversation(
                userId: uid, agentId: agentId, priority: priority,
                displayName: appEnv.preferences.displayName, email: appEnv.auth.userEmail
            )
        case nil:
            await service.loadMessages()
        }
    }

    private var closedBanner: some View {
        VStack(spacing: 8) {
            Text("Chat ended · starting again opens a new conversation")
                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            if let agentId = service.conversation?.agentId, let uid = appEnv.auth.userId {
                Button {
                    Task {
                        await service.startConversation(userId: uid, agentId: agentId,
                            displayName: appEnv.preferences.displayName, email: appEnv.auth.userEmail)
                    }
                } label: {
                    Text("Chat again")
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
        Group {
        if intent != nil && service.conversation == nil {
            VStack(spacing: 12) {
                Spacer()
                ProgressView()
                Text("Connecting…")
                    .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
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
                // Tap the message area (blank space included) or drag to dismiss the keyboard.
                .scrollDismissesKeyboard(.interactively)
                .simultaneousGesture(TapGesture().onEnded { inputFocused = false })
            }
            if service.conversation?.isClosed == false && service.agentIsTyping {
                Text("Typing…")
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
        }
        }
        .onChange(of: draft) { _, value in
            if !value.isEmpty { Task { await service.userIsTyping() } }
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .navigationSwipeBackEnabled()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    service.autoTranslate.toggle()
                    if service.autoTranslate { service.autoTranslateVisibleTail() }
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "globe").font(.system(size: 11, weight: .semibold))
                        Text("Translate").font(Theme.FontToken.inter(11, weight: .semibold))
                    }
                    .padding(.horizontal, 9).padding(.vertical, 5)
                    .foregroundStyle(service.autoTranslate ? .white : Theme.ColorToken.textSecondary)
                    .background(service.autoTranslate ? Theme.ColorToken.success : Theme.ColorToken.backgroundSubtle)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            if service.conversation?.isClosed == false {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("End chat") { showEndConfirm = true }
                        .font(Theme.FontToken.inter(12, weight: .medium))
                }
            }
        }
        .alert("End this chat?", isPresented: $showEndConfirm) {
            Button("End chat", role: .destructive) { Task { await service.endConversation() } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("It moves to History. You can start a new chat anytime.")
        }
        .task { await resolveIntent() }
        .onDisappear { Task { await service.leaveConversation() } }
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
                Text("Translating…").font(Theme.FontToken.inter(9)).foregroundStyle(Theme.ColorToken.textMuted)
            } else if (msg.bodyTranslated ?? "").isEmpty {
                Button("Translate") { Task { await service.translateMessage(msg) } }
                    .font(Theme.FontToken.inter(9, weight: .medium)).foregroundStyle(Theme.ColorToken.accent)
                    .buttonStyle(.plain)
            } else if !service.autoTranslate {
                Button(shownTranslations.contains(msg.id) ? "Hide translation" : "Show translation") {
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
            TextField("Message… (Chinese or English, auto-translated)", text: $draft, axis: .vertical)
                .font(Theme.FontToken.inter(13)).lineLimit(1...4)
                .focused($inputFocused)
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

/// In-memory cache for private chat images, keyed by stable storage path (the
/// signed download URL changes every time, so it can't be the cache key).
private enum ChatImageCache {
    private static let memory = NSCache<NSString, UIImage>()

    static func cached(_ path: String) -> UIImage? { memory.object(forKey: path as NSString) }

    static func image(path: String, service: SupportChatService) async -> UIImage? {
        if let mem = cached(path) { return mem }
        // Disk-first via ImageCacheService; only sign a fresh URL on a cache miss.
        let image = await ImageCacheService.shared.image(key: path) {
            await service.signedImageURL(for: path)
        }
        if let image { memory.setObject(image, forKey: path as NSString) }
        return image
    }
}

/// Renders a private chat image, cached by storage path so scrolling it off and
/// back on screen neither re-signs the URL nor re-downloads the bytes. Tap to preview
/// full screen.
private struct ChatImageView: View {
    let path: String
    let service: SupportChatService

    @State private var image: UIImage?
    @State private var showFullScreen = false

    init(path: String, service: SupportChatService) {
        self.path = path
        self.service = service
        if let mem = ChatImageCache.cached(path) {
            _image = State(initialValue: mem)
        }
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image).resizable().scaledToFill()
                    .frame(width: 180, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .contentShape(RoundedRectangle(cornerRadius: 14))
                    .onTapGesture { showFullScreen = true }
            } else {
                RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.15))
                    .frame(width: 180, height: 130)
                    .overlay(ProgressView())
            }
        }
        .task(id: path) {
            if let mem = ChatImageCache.cached(path) { image = mem; return }
            image = await ChatImageCache.image(path: path, service: service)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            if let image { ChatFullScreenImage(image: image) }
        }
    }
}

/// Full-screen chat image preview with pinch-zoom and double-tap. Uses the already
/// loaded UIImage, so opening is instant (no re-download).
private struct ChatFullScreenImage: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @GestureState private var pinch: CGFloat = 1

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable().scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(scale * pinch)
                .gesture(
                    MagnificationGesture()
                        .updating($pinch) { value, state, _ in state = value }
                        .onEnded { value in scale = min(max(scale * value, 1), 4) }
                )
                .onTapGesture(count: 2) { withAnimation { scale = scale > 1 ? 1 : 2.5 } }
                .ignoresSafeArea()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding()
            }
        }
    }
}
