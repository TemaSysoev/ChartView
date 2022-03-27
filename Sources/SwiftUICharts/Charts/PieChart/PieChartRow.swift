import SwiftUI

/// A single "row" (slice) of data, a view in a `PieChart`

extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

public struct PieChartRow: View {
    @ObservedObject var chartData: ChartData
    @EnvironmentObject var chartValue: ChartValue

    var style: ChartStyle
    var colors = [Color(0xFFDB8B), Color(0xFFCF40), Color(0xFFCF40)]
    var slices: [PieSlice] {
        var tempSlices: [PieSlice] = []
        var lastEndDeg: Double = 0
        let maxValue: Double = chartData.points.reduce(0, +)
       
        var index = 0
        for slice in chartData.points {
            
            let normalized: Double = Double(slice) / (maxValue == 0 ? 1 : maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice, label: chartData.values[index]))
            index += 1
        }
        
        return tempSlices
    }

    @State private var currentTouchedIndex = -1 {
        didSet {
            if oldValue != currentTouchedIndex {
                chartValue.interactionInProgress = currentTouchedIndex != -1
                guard currentTouchedIndex != -1 else { return }
                chartValue.currentValue = slices[currentTouchedIndex].value
            }
        }
    }
 
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<self.slices.count) { index in
                   
                    PieChartCell(
                        rect: geometry.frame(in: .local),
                        startDeg: self.slices[index].startDeg,
                        endDeg: self.slices[index].endDeg,
                        index: index,
                        backgroundColor: Color.white,
                        accentColor: .accentColor)
                    
                    .scaleEffect(currentTouchedIndex == index ? 1.05 : 1)
                    .animation(Animation.spring())
                    
                    Text("\(slices[index].label)")
                        
                        .font(.system(size: 9))
                        .offset(x: 45)
                        .rotationEffect(.degrees((self.slices[index].startDeg + self.slices[index].endDeg)/2))
                        .scaleEffect(currentTouchedIndex == index ? 1.1 : 1)
                           
                           
                    
                }
            }
           
            .gesture(DragGesture()
                        .onChanged({ value in
                            let rect = geometry.frame(in: .local)
                            let isTouchInPie = isPointInCircle(point: value.location, circleRect: rect)
                            if isTouchInPie {
                                let touchDegree = degree(for: value.location, inCircleRect: rect)
                                currentTouchedIndex = slices.firstIndex(where: { $0.startDeg < touchDegree && $0.endDeg > touchDegree }) ?? -1
                            } else {
                                currentTouchedIndex = -1
                            }
                        })
                        .onEnded({ value in
                            currentTouchedIndex = -1
                        })
            )
        }
    }
}
