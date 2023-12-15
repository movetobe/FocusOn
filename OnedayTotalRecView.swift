import SwiftUI

struct OnedayTotalRecView: View {
    @Binding var currState: Int
    @Binding var totalCountdownSeconds: Int
    @Binding var selectedTarget: Int
    
    var body: some View {
        VStack {
            //ZStack(alignment: .bottom) {
            ZStack(alignment: .leading) {
                if (totalCountdownSeconds < selectedTimeInSeconds()) {
                    Rectangle()
                    //.frame(width: 78, height: (Double(totalCountdownSeconds) * Utils.rectH) / Double(selectedTimeInSeconds()))
                        .frame(width: (Double(totalCountdownSeconds) * (Utils.rectW - 2 * Utils.lineWidth)) / Double(selectedTimeInSeconds()), height: Utils.rectH - 2 * Utils.lineWidth)
                        .foregroundColor(Utils.colorBase)
                        .offset(x: Utils.lineWidth)
                } else {
                    Rectangle()
                    //.frame(width: 78, height: (Double(totalCountdownSeconds) * Utils.rectH) / Double(selectedTimeInSeconds()))
                        .frame(width: Utils.rectW - 2 * Utils.lineWidth, height: Utils.rectH - 2 * Utils.lineWidth)
                        .foregroundColor(Utils.colorBase)
                        .offset(x: Utils.lineWidth)
                }
                HStack(spacing: -Utils.lineWidth) {
                    Rectangle()
                    //.frame(width: 80, height: Utils.rectH)
                        .frame(width: Utils.rectW, height: Utils.rectH)
                        .border(Utils.colorBase, width: Utils.lineWidth)
                        .foregroundColor(Color.clear)
                        .cornerRadius(Utils.cornerR / 3)
                        .overlay {
                            VStack {
                                if currState != Utils.reset {
                                    Text("Daily Goal")
                                        .foregroundColor(Utils.color)
                                    Text("\(selectedTarget) Hours")
                                        .foregroundColor(Utils.color)
                                } else {
                                    Text("Daily Goal")
                                        .foregroundColor(Utils.color)
                                    Stepper("\(selectedTarget) Hours", value: $selectedTarget, in: 1...12, step: 1)
                                        .foregroundColor(Utils.color)
                                }
                            }
                        }
                    Rectangle()
                        .frame(width: Utils.markerWidth * 2, height: Utils.markerHeight * 4)
                        //.border(Utils.colorBase, width: Utils.lineWidth)
                        .cornerRadius(Utils.cornerR / 3)
                        .foregroundColor(Utils.colorBase)
                }
            }
            
            Text("Finished \(String(format: "%.1f", (Double(totalCountdownSeconds) / 3600))) H")
                .foregroundColor(Utils.color)
        }
    }
    
    private func selectedTimeInSeconds() -> Int {
        return selectedTarget * 60 * 60
    }
}
