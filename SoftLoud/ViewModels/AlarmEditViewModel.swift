import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class AlarmEditViewModel {
    var time: Date = Date()
    var label: String = "Alarm"
    var volume: Float = 0.8
    var soundName: String = "Classic"
    var isGradual: Bool = false
    var gradualDuration: Int = 30
    var snoozeEnabled: Bool = true
    var snoozeDuration: Int = 9
    var repeatDays: [Int] = []
    var selectedPreset: VolumePreset?

    let presets = VolumePreset.builtIn
    let availableSounds = [
        "Classic", "Beacon", "Chime", "Crystal",
        "Horizon", "Pulse", "Ripple", "Summit"
    ]

    var isNewAlarm: Bool = true
    private var editingAlarm: Alarm?
    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext, alarm: Alarm? = nil) {
        self.modelContext = modelContext
        if let alarm {
            editingAlarm = alarm
            isNewAlarm = false
            time = alarm.time
            label = alarm.label
            volume = alarm.volume
            soundName = alarm.soundName
            isGradual = alarm.isGradual
            gradualDuration = alarm.gradualDuration
            snoozeEnabled = alarm.snoozeEnabled
            snoozeDuration = alarm.snoozeDuration
            repeatDays = alarm.repeatDays
        }
    }

    func applyPreset(_ preset: VolumePreset) {
        selectedPreset = preset
        volume = preset.volume
        isGradual = preset.isGradual
        gradualDuration = preset.gradualDuration
    }

    func save() {
        guard let modelContext else { return }

        if let editingAlarm {
            editingAlarm.time = time
            editingAlarm.label = label
            editingAlarm.volume = volume
            editingAlarm.soundName = soundName
            editingAlarm.isGradual = isGradual
            editingAlarm.gradualDuration = gradualDuration
            editingAlarm.snoozeEnabled = snoozeEnabled
            editingAlarm.snoozeDuration = snoozeDuration
            editingAlarm.repeatDays = repeatDays
            editingAlarm.presetName = selectedPreset?.name

            AlarmScheduler.shared.cancelAlarm(alarm: editingAlarm)
            if editingAlarm.isEnabled {
                AlarmScheduler.shared.scheduleAlarm(alarm: editingAlarm)
            }
        } else {
            let alarm = Alarm(
                time: time,
                label: label,
                volume: volume,
                soundName: soundName,
                isGradual: isGradual,
                gradualDuration: gradualDuration,
                snoozeEnabled: snoozeEnabled,
                snoozeDuration: snoozeDuration
            )
            alarm.repeatDays = repeatDays
            alarm.presetName = selectedPreset?.name
            modelContext.insert(alarm)
            AlarmScheduler.shared.scheduleAlarm(alarm: alarm)
        }

        try? modelContext.save()
    }

    var volumeColor: String {
        if volume < 0.3 { return "green" }
        if volume < 0.7 { return "orange" }
        return "red"
    }
}
