import Foundation
import AppKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    func showNotification(selectedTime: Int) {
        let alert = NSAlert()
        alert.messageText = "FocusOn"
        alert.informativeText = "Focus On \(selectedTime) Minutes"
        alert.addButton(withTitle: "OK")

        DispatchQueue.main.asyncAfter(deadline: .now() + Utils.notificationTime) {
            NSApp.stopModal()
        }
        alert.runModal()
    }
}

