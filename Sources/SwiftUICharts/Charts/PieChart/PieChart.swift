import SwiftUI

/// A type of chart that displays a slice of "pie" for each data point
public struct PieChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle

	/// The content and behavior of the `PieChart`.
	///
	///
    public var body: some View {
        PieChartRow(chartData: data, style: style)
    }

    public init() {}
}
struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            PieChart()
                .data([("k1", 4), ("k2", 3), ("k3", 9), ("k4", 5), ("k5", 6), ("k6", 2)])
                
                .chartStyle(ChartStyle(backgroundColor: .white,
                                       foregroundColor: ColorGradient(.yellow, .yellow)))
                .padding()
    PieChart()
                .data([("Other", 32), ("Books", 45), ("Food", 9), ("Transport", 5), ("Tech", 123), ("Coffee", 2)])
        
        .chartStyle(ChartStyle(backgroundColor: .white,
                               foregroundColor: ColorGradient(.yellow, .yellow)))
        
        }
        
    }
}
