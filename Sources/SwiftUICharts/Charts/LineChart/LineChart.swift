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
        
            NavigationView{
                VStack{
                    LineChart()
                        .data([("03.03", 3400), ("04.03", 8000), ("05.03", 2400), ("06.03", 6000), ("07.03", 7500), ("08.03", 4500)])
                        .chartStyle(ChartStyle(backgroundColor: .yellow.opacity(0.1),
                                               foregroundColor: ColorGradient(.yellow.opacity(0.2), .yellow)))
                        .frame(height: 100)
                        .padding(.vertical)
                    LineChart()
                        .data([("03.03", 34), ("04.03", 12), ("05.03", 3), ("06.03", 23), ("07.03", 75), ("08.03", 45)])
                        .chartStyle(ChartStyle(backgroundColor: .green.opacity(0.1),
                                               foregroundColor: ColorGradient(.green.opacity(0.2), .green)))
                        .frame(height: 100)
                        .padding(.vertical)
                  Spacer()
                }
                
            }
           
       
    }
}
