import AVFoundation

enum AudioSessionService {
    private static var isPrepared = false

    /// Legacy alias — prefer `activateForPlayback()`.
    static func configureForPlayback() {
        _ = activateForPlayback()
    }

    static func prepareForPlayback() {
        guard !isPrepared else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowBluetoothA2DP]
            )
            isPrepared = true
        } catch {
            TelemetryService.shared.recordError(error, context: "audio_session_prepare")
            #if DEBUG
            print("[AudioSession] prepare failed: \(error)")
            #endif
        }
    }

    @discardableResult
    static func activateForPlayback() -> Bool {
        prepareForPlayback()
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: [])
            return true
        } catch {
            TelemetryService.shared.recordError(error, context: "audio_session_activate")
            #if DEBUG
            print("[AudioSession] activate failed: \(error)")
            #endif
            return false
        }
    }

    static func deactivateWhenIdle() {
        do {
            try AVAudioSession.sharedInstance().setActive(
                false,
                options: .notifyOthersOnDeactivation
            )
        } catch {
            TelemetryService.shared.recordError(error, context: "audio_session_deactivate")
        }
    }

    static func observeInterruptions(
        onBegan: @escaping () -> Void,
        onEndedShouldResume: @escaping () -> Void
    ) -> NSObjectProtocol {
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

            switch type {
            case .began:
                onBegan()
            case .ended:
                let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                guard options.contains(.shouldResume) else { return }
                _ = activateForPlayback()
                onEndedShouldResume()
            @unknown default:
                break
            }
        }
    }

    static func observeRouteChanges(
        onOldDeviceUnavailable: @escaping () -> Void
    ) -> NSObjectProtocol {
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue),
                  reason == .oldDeviceUnavailable else { return }
            onOldDeviceUnavailable()
        }
    }
}
