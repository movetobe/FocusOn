import SwiftUI

struct CircleDividerView: View {
    @Binding var currState: Int
    @Binding var selectedTime: Int
    @Binding var totalCountdownSeconds: Int
    @Binding var totalCountdownEnd: Date
    @Binding var selectedTarget: Int
    @Binding var countdownSeconds: Int
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            let remainS = selectedTimeInSeconds() - countdownSeconds
            let remainMin = Int(ceil(Double(remainS) / Double(60)))
            
            /*
             Circle()
             .stroke(colorBase, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, dash: [5]))
             .frame(width: 80, height: 80)
             */
            Circle()
                .stroke(Utils.colorBase, lineWidth: Utils.lineWidth)
                .frame(width: Utils.circleR, height: Utils.circleR)
                .overlay(
                    VStack {
                        if currState == Utils.reset {
                            Stepper("\(selectedTime) min", value: $selectedTime, in: 5...120, step: 5)
                                .foregroundColor(Utils.color)
                        } else {
                            if (remainMin > 1) {
                                Text("\(remainMin) min")
                                    .foregroundColor(Utils.color)
                            } else {
                                Text("\(remainS) s")
                                    .foregroundColor(Utils.color)
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
                )
            // draw progress
            ForEach(0..<Utils.divisionCount, id: \.self) { index in
                let point = positionForNow(i: index)
                let pointColor = countdownSeconds > secondsFor(index) ? Utils.color : Utils.colorBase
                
                //Circle()
                Rectangle()
                    .frame(width: Utils.markerWidth, height: Utils.markerHeight)
                    .position(x: point.x, y: point.y)
                    .foregroundColor(pointColor)
            }
        }
        .frame(width: Utils.circleR, height: Utils.circleR)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Focus Finish"),
                message: Text("Congratulations on completing a focus"),
                primaryButton: .default(
                    Text("Take a break"),
                    action: {
                        showAlert = false
                    }
                ),
                secondaryButton: .default(
                    Text("Start Next Focus"),
                    action: {
                        startCountdown()
                    }
                )
            )
        }
    }

    private func positionForNow(i: Int) -> CGPoint {
        let radius: CGFloat = Utils.circlePointR
        let centerX: CGFloat = Utils.circleR / 2
        let centerY: CGFloat = Utils.circleR / 2
        let angleIncrement = 360.0 / Double(Utils.divisionCount)

        let angle = Double(i) * angleIncrement
        let radians = angle * Double.pi / 180.0
            
        let x = centerX + radius * CGFloat(cos(radians))
        let y = centerY + radius * CGFloat(sin(radians))
            
        return CGPoint(x: x, y: y)
    }
    
    private func secondsFor(_ index: Int) -> Int {
        let sectorTime = Double(selectedTimeInSeconds()) / Double(Utils.divisionCount)
        return Int(sectorTime * Double(index))
    }

    private func startCountdown() {
        if currState != Utils.running {
            currState = Utils.running
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if currState == Utils.running {
                    if countdownSeconds < selectedTimeInSeconds() {
                        countdownSeconds += 1
                    } else {
                        timer.invalidate()
                        resetCountdown()
                        showAlert = true
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
}
