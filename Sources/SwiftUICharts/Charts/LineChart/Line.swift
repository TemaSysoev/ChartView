import SwiftUI

/// A single line of data, a view in a `LineChart`
public struct Line: View {
    @EnvironmentObject var chartValue: ChartValue
    @ObservedObject var chartData: ChartData
    
    var style: ChartStyle
    
    @State private var showIndicator: Bool = false
    @State private var touchLocation: CGPoint = .zero
    @State private var showBackground: Bool = true
    @State private var didCellAppear: Bool = false
    
    @State private var currentDate = ""
    var curvedLines: Bool = true
    var path: Path {
        Path.quadCurvedPathWithPoints(points: chartData.normalisedPoints,
                                      step: CGPoint(x: 1.0, y: 1.0))
    }
    
    /// The content and behavior of the `Line`.
    /// Draw the background if showing the full line (?) and the `showBackground` option is set. Above that draw the line, and then the data indicator if the graph is currently being touched.
    /// On appear, set the frame so that the data graph metrics can be calculated. On a drag (touch) gesture, highlight the closest touched data point.
    /// TODO: explain rotation
    public var body: some View {
        
        
        GeometryReader { geometry in
            
            
            
            
            ZStack(alignment: .bottom){
                
                
                
                
                if self.didCellAppear && self.showBackground {
                    LineBackgroundShapeView(chartData: chartData,
                                            geometry: geometry,
                                            style: style)
                    
                }
                LineShapeView(chartData: chartData,
                              geometry: geometry,
                              style: style,
                              trimTo: didCellAppear ? 1.0 : 0.0)
                .animation(.easeIn)
                
                if self.showIndicator {
                    /*
                     Rectangle()
                     .frame(width: 2, height: 3000)
                     .position(x:self.getClosestPointOnPath(geometry: geometry,
                     touchLocation: self.touchLocation).x, y: 0)
                     .foregroundColor(style.foregroundColor[0].endColor.opacity(0.2))
                     */
                    
                    IndicatorPoint(color: style.foregroundColor[0].endColor)
                        .position(self.getClosestPointOnPath(geometry: geometry,
                                                             touchLocation: self.touchLocation))
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                   
                        VStack(alignment: .center){
                            HStack{
                                Image(systemName: "calendar")
                                    .imageScale(.small)
                                    .foregroundColor(style.foregroundColor[0].endColor)
                                Text(currentDate)
                                    .font(.system(size: 12))
                                    .foregroundColor(style.foregroundColor[0].endColor)
                            }
                            .padding(.top, 5)
                            .padding(.horizontal, 7)
                            HStack{
                               
                                Text("\(String(format: "%.0f", self.chartValue.currentValue))")
                                    .bold()
                                    .foregroundColor(style.foregroundColor[0].endColor)
                            }
                            .padding(.top, 0.1)
                            .padding(.bottom, 3)
                            
                            
                        }
                        
                        
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                            .frame(maxWidth: 170)
                            .position(x: self.getClosestPointOnPath(geometry: geometry,
                                                                    touchLocation: self.touchLocation).x, y: -self.getClosestPointOnPath(geometry: geometry,
                                                                                                                                         touchLocation: self.touchLocation).y + 40)
                        
                    
                }
                
            }
            
            
            
            
            
            .onAppear {
                didCellAppear = true
            }
            .onDisappear() {
                didCellAppear = false
            }
            
            .gesture(DragGesture()
                .onChanged({ value in
                    self.touchLocation = value.location
                    self.showIndicator = true
                    self.getClosestDataPoint(geometry: geometry, touchLocation: value.location)
                    self.chartValue.interactionInProgress = true
                })
                    .onEnded({ value in
                        self.touchLocation = .zero
                        self.showIndicator = false
                        self.chartValue.interactionInProgress = false
                    })
            )
            
        }
    }
}

// MARK: - Private functions

extension Line {
    /// Calculate point closest to where the user touched
    /// - Parameter touchLocation: location in view where touched
    /// - Returns: `CGPoint` of data point on chart
    private func getClosestPointOnPath(geometry: GeometryProxy, touchLocation: CGPoint) -> CGPoint {
        let geometryWidth = geometry.frame(in: .local).width
        let normalisedTouchLocationX = (touchLocation.x / geometryWidth) * CGFloat(chartData.normalisedPoints.count - 1)
        let closest = self.path.point(to: normalisedTouchLocationX)
        var denormClosest = closest.denormalize(with: geometry)
        denormClosest.x = denormClosest.x / CGFloat(chartData.normalisedPoints.count - 1)
        denormClosest.y = denormClosest.y / CGFloat(chartData.normalisedRange)
        return denormClosest
    }
    
    //	/// Figure out where closest touch point was
    //	/// - Parameter point: location of data point on graph, near touch location
    private func getClosestDataPoint(geometry: GeometryProxy, touchLocation: CGPoint){
        let geometryWidth = geometry.frame(in: .local).width
        let index = Int(round((touchLocation.x / geometryWidth) * CGFloat(chartData.points.count - 1)))
        if (index >= 0 && index < self.chartData.data.count){
            self.chartValue.currentValue = self.chartData.points[index]
            currentDate = self.chartData.values[index]
        }
        
    }
}

struct Line_Previews: PreviewProvider {
    /// Predefined style, black over white, for preview
    static let blackLineStyle = ChartStyle(backgroundColor: ColorGradient(.white), foregroundColor: ColorGradient(.black))
    
    /// Predefined style red over white, for preview
    static let redLineStyle = ChartStyle(backgroundColor: .whiteBlack, foregroundColor: ColorGradient(.red))
    
    static var previews: some View {
        Group {
            Line(chartData:  ChartData([8, 23, 32, 7, 23, -4]), style: blackLineStyle)
            
            Line(chartData:  ChartData([8, 23, 32, 7, 23, 43]), style: redLineStyle)
        }
    }
}

