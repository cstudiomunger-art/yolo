import SwiftUI

/// App-wide floating audio player: a draggable note button that expands into a mini control bar
/// (previous / play-pause / next / scrubber / playlist). The note's X badge stops audio and hides it.
struct MiniAudioPlayerView: View {
    @Environment(AppEnvironment.self) private var appEnv
    var player: AudioQueuePlayer

    @State private var scrub: Double = 0
    @State private var isScrubbing = false
    @State private var showPlaylist = false
    @State private var paywallTrack: AudioTrack?

    private let buttonSize: CGFloat = 52

    var body: some View {
        GeometryReader { geo in
            Group {
                if player.isExpanded {
                    VStack {
                        Spacer()
                        expandedCard
                            .padding(.horizontal, 16)
                            .padding(.bottom, 96)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    FloatingNoteButton(player: player, canvasSize: geo.size, buttonSize: buttonSize)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.82), value: player.isExpanded)
        .sheet(item: $paywallTrack) { track in
            if let attraction = track.attraction {
                MembershipPlansView(
                    attraction: attraction,
                    guide: track.guide,
                    priceTierId: track.subArea?.priceTierId ?? attraction.priceTierId,
                    purchaseTargetId: track.subArea?.id,
                    displayTitle: track.subArea?.nameEn
                ) {
                    player.refreshCurrentTrackAccess()
                }
                .environment(appEnv)
            }
        }
        .onAppear {
            player.onTrialEnded = { track in paywallTrack = track }
            if isScrubbing == false { scrub = player.progress }
        }
        .onChange(of: player.progress) { _, newValue in
            if !isScrubbing { scrub = newValue }
        }
        .onChange(of: player.currentTrackId) { _, _ in
            scrub = player.progress
        }
        .onChange(of: appEnv.preferences.purchasedAttractionIds) { _, _ in
            player.refreshCurrentTrackAccess()
        }
        .onChange(of: appEnv.purchase.isProActive) { _, _ in
            player.refreshCurrentTrackAccess()
        }
        .onChange(of: appEnv.membershipRevision) { _, _ in
            player.refreshCurrentTrackAccess()
        }
    }

    // MARK: - Expanded control bar

    private var expandedCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "music.note")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.accent)
                Text(player.currentTrack?.title ?? "")
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .lineLimit(1)
                Spacer()
                Button {
                    withAnimation { player.isExpanded = false }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                Button {
                    player.close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }

            transportRow

            scrubRow

            if let track = player.currentTrack {
                AudioTrackVoiceSwitcher(track: track) { variant in
                    player.applyVoiceVariant(variant, at: player.currentIndex)
                }
            }

            if player.currentTrackIsPreview {
                Text(String(localized: "Preview · unlock the full guide"))
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            Button {
                withAnimation { showPlaylist.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 12, weight: .medium))
                    Text(String(localized: "Playlist"))
                        .font(Theme.FontToken.inter(12, weight: .medium))
                    Spacer()
                    Text("\(player.queue.count)")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    Image(systemName: showPlaylist ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)

            if showPlaylist {
                playlist
            }
        }
        .padding(16)
        .frame(maxWidth: 380)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 20, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Theme.ColorToken.border, lineWidth: 0.5)
        )
        .frame(maxWidth: .infinity)
    }

    private var transportRow: some View {
        HStack(spacing: 28) {
            Button { player.previous() } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 18, weight: .medium))
            }
            .buttonStyle(.plain)
            .foregroundStyle(player.canGoPrevious ? Theme.ColorToken.textPrimary : Theme.ColorToken.textMuted)
            .disabled(!player.canGoPrevious)

            Button { player.togglePlay() } label: {
                Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 40, weight: .regular))
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.ColorToken.textPrimary)
            .disabled(!player.canPlay)

            Button { player.next() } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 18, weight: .medium))
            }
            .buttonStyle(.plain)
            .foregroundStyle(player.canGoNext ? Theme.ColorToken.textPrimary : Theme.ColorToken.textMuted)
            .disabled(!player.canGoNext)
        }
        .frame(maxWidth: .infinity)
    }

    private var scrubRow: some View {
        let maxValue = max(player.currentTrackIsPreview ? player.previewMaxSeconds : Double(player.durationSeconds), 1)
        return VStack(spacing: 2) {
            Slider(
                value: Binding(
                    get: { min(scrub, maxValue) },
                    set: { newValue in
                        scrub = newValue
                        if !isScrubbing { player.seek(to: newValue) }
                    }
                ),
                in: 0...maxValue,
                onEditingChanged: { editing in
                    isScrubbing = editing
                    if !editing { player.seek(to: scrub) }
                }
            )
            .tint(Theme.ColorToken.accent)
            .disabled(!player.canPlay)

            HStack {
                Text(formatTime(Int(scrub)))
                Spacer()
                Text(formatTime(Int(maxValue)))
            }
            .font(Theme.FontToken.inter(10))
            .foregroundStyle(Theme.ColorToken.textMuted)
        }
    }

    private var playlist: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(player.queue.enumerated()), id: \.element.id) { index, track in
                    let isCurrent = index == player.currentIndex
                    let locked = !(player.resolveAccess?(track).hasFullAccess ?? true)
                    HStack(spacing: 6) {
                        Button {
                            player.playTrack(at: index)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: isCurrent ? (player.isPlaying ? "speaker.wave.2.fill" : "pause.fill") : "music.note")
                                    .font(.system(size: 11))
                                    .foregroundStyle(isCurrent ? Theme.ColorToken.accent : Theme.ColorToken.textMuted)
                                    .frame(width: 16)
                                Text(track.title)
                                    .font(Theme.FontToken.inter(12, weight: isCurrent ? .semibold : .regular))
                                    .foregroundStyle(isCurrent ? Theme.ColorToken.textPrimary : Theme.ColorToken.textSecondary)
                                    .lineLimit(1)
                                Spacer()
                                if locked {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 9))
                                        .foregroundStyle(Theme.ColorToken.textMuted)
                                }
                                Text(formatTime(max(track.guide.durationSeconds, 0)))
                                    .font(Theme.FontToken.inter(10))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        AudioTrackVoiceSwitcher(track: track) { variant in
                            player.applyVoiceVariant(variant, at: index)
                        }
                    }
                    .padding(.vertical, 8)

                    if index < player.queue.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .frame(maxHeight: 200)
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

// MARK: - Draggable note button

/// The collapsed floating note. The live position is written to `player.dragPosition` on every
/// drag tick so the button follows the finger in real time. Because only this small view reads
/// `dragPosition` (the parent's body never does), each tick re-renders just this button — so the
/// drag stays both live and smooth, untouched by the parent's playback-driven re-renders.
private struct FloatingNoteButton: View {
    var player: AudioQueuePlayer
    let canvasSize: CGSize
    let buttonSize: CGFloat

    /// Anchor captured at gesture start so the absolute position can be derived from translation.
    @State private var dragStart: CGPoint?

    var body: some View {
        let position = player.dragPosition ?? defaultPosition

        return ZStack(alignment: .topTrailing) {
            // Plain view (NOT a Button): a Button's built-in tap gesture swallows the continuous
            // touch stream, so the drag's onChanged never fires mid-drag (only onEnded). Tapping is
            // handled by onTapGesture; dragging by the high-priority DragGesture below.
            Image(systemName: player.isPlaying ? "waveform" : "music.note")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.onSurfaceEmphasis)
                .frame(width: buttonSize, height: buttonSize)
                .background(Circle().fill(Theme.ColorToken.surfaceEmphasis))
                .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
                .contentShape(Circle())
                .onTapGesture {
                    withAnimation { player.isExpanded = true }
                }

            Button {
                player.close()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .frame(width: 18, height: 18)
                    .background(Circle().fill(Theme.ColorToken.surfaceFloating))
                    .overlay(Circle().stroke(Theme.ColorToken.border, lineWidth: 0.5))
                    .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
            }
            .buttonStyle(.plain)
            .offset(x: 5, y: -5)
        }
        .frame(width: buttonSize + 10, height: buttonSize + 10, alignment: .topTrailing)
        .position(position)
        .highPriorityGesture(
            DragGesture(minimumDistance: 6, coordinateSpace: .global)
                .onChanged { value in
                    let start = dragStart ?? position
                    if dragStart == nil { dragStart = start }
                    let raw = CGPoint(
                        x: start.x + value.translation.width,
                        y: start.y + value.translation.height
                    )
                    player.dragPosition = clamp(raw)
                }
                .onEnded { _ in
                    dragStart = nil
                }
        )
    }

    private var defaultPosition: CGPoint {
        CGPoint(x: canvasSize.width - (buttonSize / 2) - 16, y: canvasSize.height - buttonSize - 110)
    }

    private func clamp(_ point: CGPoint) -> CGPoint {
        let margin = buttonSize / 2 + 8
        return CGPoint(
            x: min(max(point.x, margin), canvasSize.width - margin),
            y: min(max(point.y, margin + 40), canvasSize.height - margin - 90)
        )
    }
}
