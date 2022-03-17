import SwiftUI

/// A type of chart that displays a line connecting the data points
public struct LineChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle

	/// The content and behavior of the `LineChart`.
	///
	///
    public var body: some View {
        Line(chartData: data, style: style)
    }
    
    public init() {}
}
struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
    LineChart()
        .data([0, 4, 6, 3, 8, 9])
        .chartStyle(ChartStyle(backgroundColor: .yellow.opacity(0.1),
                               foregroundColor: ColorGradient(.yellow.opacity(0.2), .yellow)))
        
        
    }
}
