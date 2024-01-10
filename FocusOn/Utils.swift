import SwiftUI

struct Utils {
    static let lineWidth: CGFloat = 2.0
    static let fontSize: CGFloat = 14
    static let imageSize: CGFloat = 13
    static let colorBGAll = Color.white.opacity(0.8)
    static let colorBG = Color(red: 0.2, green: 0.6, blue: 1.0).opacity(0.05)
    static let colorFocusOn = Color(red: 0.2, green: 0.6, blue: 1.0).opacity(0.5)
    static let color = Color.black.opacity(0.8)
    static let colorBase = Color.gray.opacity(0.3)
    static let contentW = 250.0
    static let contentH = 120.0
    static let progressR = 120.0
    static let dayProgressR = 100.0
    static let running = 1
    static let paused = 2
    static let reset = 3
    static let paddingSize = 8.0
    static let progressOffet = 12.0
    static let sliceSize = 0.42
    static let cornerR = 10.0
    static let appDataJson = "FocusOnAppData.json"
    static let taskFile = "FocusOnTask.log"
    static let appName = "FocusOn"
    static let version = " Version 0.1.0"
    static let notificationTime = 5.0
}
