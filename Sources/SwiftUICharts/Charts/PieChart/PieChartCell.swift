import SwiftUI

/// One slice of a `PieChartRow`
struct PieSlice: Identifiable{
    var id = UUID()
    var startDeg: Double
    var endDeg: Double
    var value: Double
    var label: String
}

/// A single row of data, a view in a `PieChart`
public struct PieChartCell: View {
    @State private var show: Bool = false
    var rect: CGRect
    var radius: CGFloat {
        return min(rect.width, rect.height)/2
    }
    var startDeg: Double
	var endDeg: Double

	/// Path representing this slice
    var path: Path {
        var path = Path()
        path.addArc(
            center: rect.mid,
            radius: self.radius,
            startAngle: Angle(degrees: self.startDeg),
            endAngle: Angle(degrees: self.endDeg),
            clockwise: false)
        path.addLine(to: rect.mid)
        path.closeSubpath()
        return path
    }
    var index: Int
    
    // Section line border color
    var backgroundColor: Color
    
    // Section color
    var accentColor: Color
    
	/// The content and behavior of the `PieChartCell`.
	///
	/// Fills and strokes with 2-pixel line (unless start/end degrees not yet set). Animates by scaling up to 100% when first appears.
    public var body: some View {
        Group {
            path
                .fill(self.accentColor)
                .overlay(path.stroke(self.backgroundColor, lineWidth: (startDeg == 0 && endDeg == 0 ? 0 : 2)))
                .scaleEffect(self.show ? 1 : 0)
                .animation(Animation.spring().delay(Double(self.index) * 0.04))
                .onAppear {
                    self.show = true
            }
            
        }
    }
}

struct PieChartCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            GeometryReader { geometry in
                PieChartCell(
                    rect: geometry.frame(in: .local),
                    startDeg: 00.0,
                    endDeg: 90.0,
                    index: 0,
                    backgroundColor: Color.red,
                    accentColor: .yellow)
                }.frame(width: 100, height: 100)
            
            GeometryReader { geometry in
            PieChartCell(
                rect: geometry.frame(in: .local),
                startDeg: 0.0,
                endDeg: 90.0,
                index: 0,
                backgroundColor: Color.green,
                accentColor: .green)
            }.frame(width: 100, height: 100)
            
            GeometryReader { geometry in
            PieChartCell(
                rect: geometry.frame(in: .local),
                startDeg: 100.0,
                endDeg: 135.0,
                index: 0,
                backgroundColor: Color.black,
                accentColor: .blue)
            }.frame(width: 100, height: 100)
            
            GeometryReader { geometry in
            PieChartCell(
                rect: geometry.frame(in: .local),
                startDeg: 185.0,
                endDeg: 290.0,
                index: 1,
                backgroundColor: Color.purple,
                accentColor: Color.purple)
            }.frame(width: 100, height: 100)
            
            
            
        }.previewLayout(.fixed(width: 125, height: 125))
    }
}
