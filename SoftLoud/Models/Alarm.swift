import SwiftData
import Foundation

@Model
final class Alarm {
    @Attribute(.unique) var id: UUID
    var time: Date
    var label: String
    var isEnabled: Bool
    var repeatDays: [Int]
    var volume: Float
    var soundName: String
    var isGradual: Bool
    var gradualDuration: Int
    var presetName: String?
    var snoozeEnabled: Bool
    var snoozeDuration: Int

    init(
        time: Date,
        label: String = "Alarm",
        volume: Float = 0.8,
        soundName: String = "Classic",
        isGradual: Bool = false,
        gradualDuration: Int = 30,
        snoozeEnabled: Bool = true,
        snoozeDuration: Int = 9
    ) {
        self.id = UUID()
        self.time = time
        self.label = label
        self.isEnabled = true
        self.repeatDays = []
        self.volume = volume
        self.soundName = soundName
        self.isGradual = isGradual
        self.gradualDuration = gradualDuration
        self.presetName = nil
        self.snoozeEnabled = snoozeEnabled
        self.snoozeDuration = snoozeDuration
    }
}
