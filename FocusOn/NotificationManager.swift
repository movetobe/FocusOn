import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert, .providesAppNotificationSettings, .provisional]) { granted, error in }
    }

    func showNotification(selectedTime: Int) {
        let content = UNMutableNotificationContent()
        content.title = "FocusOn"
        content.body = "Focus On " + String(selectedTime) + " Minutes"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in }
    }
}

