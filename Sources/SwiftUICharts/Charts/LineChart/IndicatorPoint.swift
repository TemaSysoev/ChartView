import SwiftUI

/// A dot representing a single data point as user moves finger over line in `LineChart`
struct IndicatorPoint: View {
	/// The content and behavior of the `IndicatorPoint`.
	///
	/// A filled circle with a thick white outline and a shadow
    public let value: Double
    public var body: some View {
        VStack{
            Text("\(value)")
            ZStack {
                Circle()
                    .fill(ChartColors.indicatorKnob)
                Circle()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
            }
            .frame(width: 14, height: 14)
        }
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint(value: 23.0)
    }
}
