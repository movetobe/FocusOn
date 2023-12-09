import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State private var todayDate: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    NSApp.terminate(self)
                }) {
                    Image(systemName: "xmark.square")
                }
                .buttonStyle(.borderless)
                .foregroundColor(Utils.color)
                Spacer()
                Text("FocusOnTodoList")
                    .foregroundColor(Utils.color)
                Spacer()
                Text(todayDate)
                    .foregroundColor(Utils.color)
            }
            .onAppear {
                updateTodayDate()
            }
            HStack(alignment: .bottom) {
                CircleDividerView(currState: $userData.currState, selectedTime: $userData.selectedTime, totalCountdownSeconds: $userData.totalCountdownSeconds, totalCountdownEnd: $userData.totalCountdownEnd, selectedTarget: $userData.selectedTarget, countdownSeconds: $userData.countdownSeconds)
                    .frame(width: Utils.circleR, height: Utils.circleR)
                Spacer()
                OnedayTotalRecView(currState: $userData.currState, totalCountdownSeconds: $userData.totalCountdownSeconds, selectedTarget: $userData.selectedTarget)
                    .frame(width: Utils.rectW, height: Utils.circleR)
            }
            .padding(Utils.paddingSize)
            .background(Utils.colorBG)
            .cornerRadius(Utils.cornerR)
            
            TodoListView(todoItems: $userData.todoItems)
                .background(Utils.colorBG)
                .cornerRadius(Utils.cornerR)
                .frame(width: Utils.circleR + Utils.rectW + Utils.paddingSize * 4)

        }
        .padding(Utils.paddingSize)
    }
    
    private func updateTodayDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let dateString = dateFormatter.string(from: currentDate)
        self.todayDate = dateString
    }
}
