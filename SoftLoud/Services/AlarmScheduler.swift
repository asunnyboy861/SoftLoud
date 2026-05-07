import Foundation
import UserNotifications
import Combine

@MainActor
final class AlarmScheduler: ObservableObject {
    static let shared = AlarmScheduler()

    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {}

    func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    func scheduleAlarm(alarm: Alarm) {
        guard alarm.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "SoftLoud"
        content.body = alarm.label
        content.sound = nil
        content.userInfo = [
            "alarmId": alarm.id.uuidString,
            "volume": alarm.volume,
            "soundName": alarm.soundName,
            "isGradual": alarm.isGradual,
            "gradualDuration": alarm.gradualDuration
        ]
        content.categoryIdentifier = "ALARM_CATEGORY"

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: alarm.time)

        let trigger: UNCalendarNotificationTrigger
        if alarm.repeatDays.isEmpty {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
        } else {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )
        }

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error {
                print("Schedule error: \(error)")
            }
        }
    }

    func cancelAlarm(alarm: Alarm) {
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: [alarm.id.uuidString]
        )
    }

    func rescheduleAllAlarms(alarms: [Alarm]) {
        notificationCenter.removeAllPendingNotificationRequests()
        for alarm in alarms where alarm.isEnabled {
            scheduleAlarm(alarm: alarm)
        }
    }

    func setupNotificationCategories() {
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: []
        )
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "Snooze",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "ALARM_CATEGORY",
            actions: [dismissAction, snoozeAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        notificationCenter.setNotificationCategories([category])
    }
}
