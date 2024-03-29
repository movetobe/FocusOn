import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State private var todayDate: String = ""
    @State private var isShowHelpView = false
    @State private var showAllTasks = false

    var body: some View {
        VStack {
            HStack {
                MenuButton(label: Image(systemName: "gearshape")) {
                    Button("Show All Tasks") {
                        showAllTasks.toggle()
                    }
                    Button("About FocusOn") {
                        isShowHelpView.toggle()
                    }

                    Button("Quit FocusOn") {
                        saveAppData(userData: userData)
                        NSApplication.shared.terminate(self)
                    }
                }
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .frame(width: Utils.imageSize)
                .foregroundColor(Utils.color)

                Spacer()
                Text(Utils.appName)
                    .foregroundColor(Utils.color)
                Spacer()
                Text(todayDate)
                    .foregroundColor(Utils.color)
            }
            .onAppear {
                updateTodayDate()
            }
            FocusOnProgressView(currState: $userData.currState, selectedTime: $userData.selectedTime, totalCountdownSeconds: $userData.totalCountdownSeconds, totalCountdownEnd: $userData.totalCountdownEnd, selectedTarget: $userData.selectedTarget, countdownSeconds: $userData.countdownSeconds)
                .background(Utils.colorBG)
                .cornerRadius(Utils.cornerR)
                .frame(width: Utils.contentW)

            TodoListView(todoItems: $userData.todoItems)
                .background(Utils.colorBG)
                .cornerRadius(Utils.cornerR)
                .frame(width: Utils.contentW)
        }
        .padding(Utils.paddingSize)
        .background(Utils.colorBGAll)
        .popover(isPresented: $isShowHelpView, arrowEdge: .leading) {
            HelpView(isShowHelpView: $isShowHelpView)
        }
        .popover(isPresented: $showAllTasks, arrowEdge: .leading) {
            ScrollView {
                let showHdr = "Created     " + "  Completed  " + " Deleted     " + " Task\n"
                let showText = showHdr + (TaskFileManager.shared.readFromFile() ?? "NO TASKS")
                Text(showText)
            }
            .padding(Utils.paddingSize)
        }
    }

    private func saveAppData(userData: UserData) {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Utils.appDataJson) else { return }
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

    private func updateTodayDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let dateString = dateFormatter.string(from: currentDate)
        self.todayDate = dateString
    }
}
