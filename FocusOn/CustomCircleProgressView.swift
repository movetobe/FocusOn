/* derived from https://gist.github.com/agelessman/789ae1b475ac02ca801fb09bd5b19b98 */
import SwiftUI

struct CustomCircleProgressView: View {
    let gradient = Gradient(colors: [Utils.colorBase, Utils.colorBG])
    let sliceSize = Utils.sliceSize
    let progress: Double
    private let percentageFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }()

    var strokeGradient: AngularGradient {
        AngularGradient(gradient: gradient, center: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/, angle: .degrees(-10))
    }

    var rotateAngle: Angle {
        .degrees(90 + sliceSize * 360 * 0.5)
    }

    init(_ progress: Double = 0.3) {
        self.progress = progress
    }

    private func strokeStyle(_ proxy: GeometryProxy) -> StrokeStyle {
        StrokeStyle(lineWidth: 0.1 * min(proxy.size.width, proxy.size.height),
                    lineCap: .round)
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Group {
                    Circle()
                        .trim(from: 0, to: 1 - CGFloat(self.sliceSize))
                        .stroke(self.strokeGradient,
                                style: self.strokeStyle(proxy))
                        .padding(Utils.paddingSize)
                    Circle()
                        .trim(from: 0, to: CGFloat(self.progress * (1 - self.sliceSize)))
                        .stroke(Utils.colorFocusOn,
                                style: self.strokeStyle(proxy))
                        .padding(Utils.paddingSize)
                }
                .rotationEffect(self.rotateAngle, anchor: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                .offset(x: 0, y: 0.1 * min(proxy.size.width, proxy.size.height))
            }
        }
    }
}
