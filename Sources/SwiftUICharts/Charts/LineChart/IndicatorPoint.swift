import SwiftUI

/// A dot representing a single data point as user moves finger over line in `LineChart`
struct IndicatorPoint: View {
	/// The content and behavior of the `IndicatorPoint`.
	///
	/// A filled circle with a thick white outline and a shadow
    public let color: Color
    public var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .stroke(color, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 14, height: 14)
       
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint(color: Color.yellow)
    }
}
