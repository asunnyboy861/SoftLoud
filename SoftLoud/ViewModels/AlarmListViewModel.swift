import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class AlarmListViewModel {
    var alarms: [Alarm] = []
    var showOnboarding = false
    var ringingAlarmId: UUID?

    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchAlarms()
        checkFirstLaunch()
    }

    func fetchAlarms() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Alarm>(sortBy: [SortDescriptor(\.time)])
        do {
            alarms = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    func deleteAlarm(_ alarm: Alarm) {
        guard let modelContext else { return }
        AlarmScheduler.shared.cancelAlarm(alarm: alarm)
        modelContext.delete(alarm)
        try? modelContext.save()
        fetchAlarms()
    }

    func toggleAlarm(_ alarm: Alarm) {
        guard let modelContext else { return }
        alarm.isEnabled.toggle()
        if alarm.isEnabled {
            AlarmScheduler.shared.scheduleAlarm(alarm: alarm)
        } else {
            AlarmScheduler.shared.cancelAlarm(alarm: alarm)
        }
        try? modelContext.save()
        fetchAlarms()
    }

    func handleNotification(userInfo: [AnyHashable: Any]) {
        guard let alarmIdString = userInfo["alarmId"] as? String,
              let alarmId = UUID(uuidString: alarmIdString) else { return }

        let volume = userInfo["volume"] as? Float ?? 0.8
        let soundName = userInfo["soundName"] as? String ?? "Classic"
        let isGradual = userInfo["isGradual"] as? Bool ?? false
        let gradualDuration = userInfo["gradualDuration"] as? Int ?? 30

        ringingAlarmId = alarmId
        AudioPlayerManager.shared.playAlarm(
            soundName: soundName,
            volume: volume,
            isGradual: isGradual,
            gradualDuration: gradualDuration
        )
    }

    func dismissRingingAlarm() {
        AudioPlayerManager.shared.fadeOutAndStop()
        ringingAlarmId = nil
    }

    func snoozeRingingAlarm() {
        AudioPlayerManager.shared.snooze()
        ringingAlarmId = nil
    }

    private func checkFirstLaunch() {
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunched {
            showOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }

    func completeOnboarding() {
        showOnboarding = false
    }
}
