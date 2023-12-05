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

struct TodoItem: Identifiable {
    let id = UUID()
    var task: String
    var isCompleted: Bool = false
    var isEditing: Bool = false
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
    var popover = NSPopover()
    var statusItem: NSStatusItem!
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
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { _ in
            self.popover.performClose(nil)
        }
    }

    @objc func togglePopover(_ sender: AnyObject) {
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
}
