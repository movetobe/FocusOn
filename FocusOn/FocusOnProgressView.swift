import SwiftUI

struct FocusOnProgressView: View {
    @Binding var currState: Int
    @Binding var selectedTime: Int
    @Binding var totalCountdownSeconds: Int
    @Binding var totalCountdownEnd: Date
    @Binding var selectedTarget: Int
    @Binding var countdownSeconds: Int

    var body: some View {
        HStack {
            let remainS = selectedTimeInSeconds() - countdownSeconds
            let remainMin = Int(ceil(Double(remainS) / Double(60)))
            Spacer()
            ZStack {
                CustomCircleProgressView(Double(countdownSeconds) / Double(selectedTimeInSeconds()))
                    .frame(width: Utils.progressR, height: Utils.progressR)
                VStack (alignment: .center) {
                    if currState == Utils.reset {
                        Stepper("\(selectedTime) min", value: $selectedTime, in: 5...120, step: 5)
                            .foregroundColor(Utils.color)
                    } else {
                        if (remainMin > 1) {
                            Text("\(remainMin) min")
                                .foregroundColor(Utils.color)
                            //.padding(.trailing, Utils.paddingSize)
                        } else {
                            Text("\(remainS) s")
                                .foregroundColor(Utils.color)
                            //.padding(Utils.paddingSize)
                        }
                    }
                    HStack {
                        if currState != Utils.running {
                            Button(action: {
                                startCountdown()
                            }) {
                                Image(systemName: "play.circle")
                            }
                            .buttonStyle(.borderless)
                            .foregroundColor(Utils.color)
                        }
                        if currState == Utils.running {
                            Button(action: {
                                stopCountdown()
                            }) {
                                Image(systemName: "pause.circle")
                            }
                            .buttonStyle(.borderless)
                            .foregroundColor(Utils.color)
                        }
                        Button(action: {
                            resetCountdown()
                        }) {
                            Image(systemName: "arrow.clockwise.circle")
                        }
                        .buttonStyle(.borderless)
                        .foregroundColor(Utils.color)
                    }
                }
                .offset(y: Utils.progressOffet)
            }
            Spacer()
            ZStack {
                if (Double(totalCountdownSeconds) > Double(selectedTargetInSeconds())) {
                    CustomCircleProgressView(1.0)
                        .frame(width: Utils.dayProgressR, height: Utils.dayProgressR)
                } else {
                    CustomCircleProgressView(Double(totalCountdownSeconds) / Double(selectedTargetInSeconds()))
                        .frame(width: Utils.dayProgressR, height: Utils.dayProgressR)
                }
                VStack {
                    if currState != Utils.reset {
                        //Text("Daily Goal")
                        //    .foregroundColor(Utils.color)
                        Text("\(selectedTarget) Hours")
                            .foregroundColor(Utils.color)
                    } else {
                        //Text("Daily Goal")
                        //    .foregroundColor(Utils.color)
                        Stepper("\(selectedTarget) Hours", value: $selectedTarget, in: 1...12, step: 1)
                            .foregroundColor(Utils.color)
                    }
                    Text("Focus on \(String(format: "%.1f", (Double(totalCountdownSeconds) / 3600))) H")
                        .foregroundColor(Utils.color)
                        .offset(y: Utils.progressOffet)
                }
                .offset(y: Utils.progressOffet)
            }
            Spacer()
        }
    }
    private func startCountdown() {
        if currState != Utils.running {
            currState = Utils.running
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if currState == Utils.running {
                    if countdownSeconds < selectedTimeInSeconds() {
                        countdownSeconds += 1
                        //print("countdownSeconds = ", countdownSeconds)
                    } else {
                        timer.invalidate()
                        resetCountdown()
                        NotificationManager.shared.showNotification(selectedTime: selectedTime)
                    }
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    private func stopCountdown() {
        if currState == Utils.running {
            currState = Utils.paused
        }
    }

    private func resetCountdown() {
        // clear totalCountdownSeconds when next day's midnight
        if (totalCountdownSeconds == 0) {
            totalCountdownEnd = todayOverTime()
        }
        totalCountdownSeconds += countdownSeconds
        countdownSeconds = 0
        currState = Utils.reset
    }

    private func selectedTimeInSeconds() -> Int {
        return selectedTime * 60
    }

    private func todayOverTime() -> Date {
        let now = Date()
        let calendar = Calendar.current

        if let overTime = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) {
            return overTime
        }
        return now
    }

    private func selectedTargetInSeconds() -> Int {
        return selectedTarget * 60 * 60
    }
}
