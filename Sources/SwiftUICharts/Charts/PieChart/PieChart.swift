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
                .data([("sdjfg", 4), ("kdfgklf2", 3), ("kfgsdfj3", 9), ("ksdfg4", 5), ("ksgfd5", 6), ("gsdf", 0.7)])
                
                .chartStyle(ChartStyle(backgroundColor: .white,
                                       foregroundColor: ColorGradient(.yellow, .yellow)))
                .padding()
    
        
        }
        
    }
}
