import SwiftUI

@main
struct YourAppNameApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}

class UserData: ObservableObject {
    @Published var totalCountdownSeconds = 0
    @Published var selectedTime = 30
    @Published var selectedTarget = 6
    @Published var currState = Utils.reset
    @Published var countdownSeconds = 0
    @Published var todoItems: [TodoItem] = []
    @Published var showFocusOn: Bool = false
    @Published var showTodoList: Bool = false
    @Published var totalCountdownEnd = Date()
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static let shared = AppDelegate()
    var popover = NSPopover()
    var statusItem: NSStatusItem!
    var eventMonitor: AnyObject?
    @ObservedObject private var userData = UserData()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(named: "Image")
            button.image?.isTemplate = true
            button.action = #selector(togglePopover(_:))
        }

        NSApp.windows.first?.orderOut(nil)
        NSApp.setActivationPolicy(.accessory)

        // try to load data
        loadAppData(userData: userData)
        // if state is running in last quit, current state shall be set to pause
        if userData.currState == Utils.running {
            userData.currState = Utils.paused
        }
        // if today over, reset totalCountdownSeconds
        if (todayOver()) {
            userData.totalCountdownSeconds = 0
        }
        NotificationManager.shared.requestNotificationPermission()

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown, handler: { [weak self] (event: NSEvent) in
            self?.handleGlobalClick(event: event)
        }) as AnyObject?
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
            self.eventMonitor = nil
        }
    }

    func handleGlobalClick(event: NSEvent) {
        if popover.isShown {
            let clickLocation = event.locationInWindow
            if let contentView = popover.contentViewController?.view {
                let clickLocationRelativeToPopover = contentView.convert(clickLocation, from: nil)
                if !contentView.bounds.contains(clickLocationRelativeToPopover) {
                    popover.performClose(nil)
                }
            }
        }
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { _ in
            self.popover.performClose(nil)
        }
    }

    @objc func togglePopover(_ sender: AnyObject) {
        saveAppData(userData: userData)
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(_ sender: AnyObject) {
        if let button = statusItem.button {
            if (todayOver()) {
                userData.totalCountdownSeconds = 0
            }
            popover.contentViewController = NSHostingController(rootView: ContentView().environmentObject(userData))
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }

    private func todayOver() -> Bool {
        return (Date() > userData.totalCountdownEnd) ? true : false
    }

    private func saveAppData(userData: UserData) {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("appData.json") else { return }
        let dataToSave = AppData(totalCountdownSeconds: $userData.totalCountdownSeconds.wrappedValue,
                                 selectedTime: $userData.selectedTime.wrappedValue,
                                 selectedTarget: $userData.selectedTarget.wrappedValue,
                                 currState: $userData.currState.wrappedValue,
                                 countdownSeconds: $userData.countdownSeconds.wrappedValue,
                                 todoItems: $userData.todoItems.wrappedValue,
                                 showFocusOn: $userData.showFocusOn.wrappedValue,
                                 showTodoList: $userData.showTodoList.wrappedValue,
                                 totalCountdownEnd: $userData.totalCountdownEnd.wrappedValue)
        AppDataStore.shared.saveData(dataToSave, to: fileURL)
    }

    private func loadAppData(userData: UserData) {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("appData.json") else { return }

        if let loadedData = AppDataStore.shared.loadData(from: fileURL) {
            userData.totalCountdownSeconds = loadedData.totalCountdownSeconds
            userData.selectedTime = loadedData.selectedTime
            userData.selectedTarget = loadedData.selectedTarget
            userData.currState = loadedData.currState
            userData.countdownSeconds = loadedData.countdownSeconds
            userData.todoItems = loadedData.todoItems
            userData.showFocusOn = loadedData.showFocusOn
            userData.showTodoList = loadedData.showTodoList
            userData.totalCountdownEnd = loadedData.totalCountdownEnd
        }
    }
}
