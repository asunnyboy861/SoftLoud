@preconcurrency import AVFoundation
import UIKit
import Combine

@MainActor
final class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()

    private var audioPlayer: AVAudioPlayer?
    private var targetVolume: Float = 0.8
    private var gradualTimer: Timer?
    private var fadeTimer: Timer?

    @Published var isPlaying: Bool = false

    private init() {}

    func playAlarm(
        soundName: String,
        volume: Float,
        isGradual: Bool,
        gradualDuration: Int
    ) {
        stopAlarm()
        targetVolume = volume

        configureAudioSession()
        preparePlayer(soundName: soundName)

        if isGradual {
            startGradualPlayback(duration: gradualDuration)
        } else {
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        }

        isPlaying = true
    }

    func stopAlarm() {
        gradualTimer?.invalidate()
        gradualTimer = nil
        fadeTimer?.invalidate()
        fadeTimer = nil
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        deactivateAudioSession()
    }

    func snooze() {
        stopAlarm()
    }

    func fadeOutAndStop(duration: TimeInterval = 2.0) {
        guard let player = audioPlayer else { return }
        let steps: Float = 20
        let volumeStep = player.volume / steps
        let initialVolume = player.volume

        var currentStep: Float = 0

        fadeTimer = Timer.scheduledTimer(
            withTimeInterval: duration / TimeInterval(steps),
            repeats: true
        ) { [weak self] timer in
            Task { @MainActor in
                guard let self else {
                    timer.invalidate()
                    return
                }
                currentStep += 1
                let newVolume = max(initialVolume - volumeStep * currentStep, 0)
                self.audioPlayer?.volume = newVolume

                if currentStep >= steps || newVolume <= 0 {
                    timer.invalidate()
                    self.fadeTimer = nil
                    self.stopAlarm()
                }
            }
        }
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    private func deactivateAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Deactivation error: \(error)")
        }
    }

    private func preparePlayer(soundName: String) {
        guard let url = Bundle.main.url(
            forResource: soundName,
            withExtension: "mp3"
        ) else {
            print("Sound file not found: \(soundName)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Player init error: \(error)")
        }
    }

    private func startGradualPlayback(duration: Int) {
        audioPlayer?.volume = 0.0
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()

        let steps = Float(duration) * 2
        let volumeStep = targetVolume / steps
        let finalVolume = targetVolume
        var currentStep: Float = 0

        gradualTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: true
        ) { [weak self] timer in
            Task { @MainActor in
                guard let self else {
                    timer.invalidate()
                    return
                }
                currentStep += 1
                let newVolume = min(volumeStep * currentStep, finalVolume)
                self.audioPlayer?.volume = newVolume

                if currentStep >= steps {
                    timer.invalidate()
                    self.gradualTimer = nil
                }
            }
        }
    }
}
