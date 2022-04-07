import UIKit
import SciChart

class ViewController: UIViewController {
    
    private let fifoCapacity = 300
    private let pointsCount = 200
    private var timer: Timer!
    private var count: Int = 0
    
    private let lineData = SCIDoubleValues()
    private lazy var lineDataSeries: SCIXyDataSeries = {
        let lineDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        lineDataSeries.seriesName = "Line Series"
        lineDataSeries.fifoCapacity = fifoCapacity
        return lineDataSeries
    }()
    private let scatterData = SCIDoubleValues()
    private lazy var scatterDataSeries: SCIXyDataSeries = {
        let scatterDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        scatterDataSeries.seriesName = "Scatter Series"
        scatterDataSeries.fifoCapacity = fifoCapacity
        return scatterDataSeries
    }()
    
    private var surface: SCIChartSurface {
        return view as! SCIChartSurface
    }
    
    override func loadView() {
        viewRespectsSystemMinimumLayoutMargins = false
        view = SCIChartSurface()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xValues = SCIIntegerValues()
        for i in 0 ..< pointsCount {
            xValues.add(Int32(i))
            lineData.add(sin(Double(i) * 0.1))
            scatterData.add(cos(Double(i) * 0.1))
            count += 1
        }
        lineDataSeries.append(x: xValues, y: lineData)
        scatterDataSeries.append(x: xValues, y: scatterData)
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.fillStyle = SCISolidBrushStyle(color: 0xFF32CD32)
        pointMarker.size = CGSize(width: 10, height: 10)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = scatterDataSeries
        scatterSeries.pointMarker = pointMarker
        
        let legendModifier = SCILegendModifier()
        legendModifier.orientation = .horizontal
        legendModifier.position = [.bottom, .centerHorizontal]
        legendModifier.margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.surface.xAxes.add(items: SCINumericAxis())
            self.surface.yAxes.add(items: SCINumericAxis())
            self.surface.renderableSeries.add(items: lineSeries, scatterSeries)
            self.surface.chartModifiers.add(items: SCIPinchZoomModifier(), SCIZoomExtentsModifier())
            self.surface.chartModifiers.add(items: SCIRolloverModifier(), legendModifier)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        let x = count
        SCIUpdateSuspender.usingWith(surface) {
            self.lineDataSeries.append(x: x, y: sin(Double(x) * 0.1))
            self.scatterDataSeries.append(x: x, y: cos(Double(x) * 0.1))
            
            self.tryAddAnnotation(at: x)
            
            // zoom series to fit viewport size into X-Axis direction
            self.surface.zoomExtents()
            self.count += 1
        }
    }
    
    fileprivate func tryAddAnnotation(at x: Int) {
        // add label every 100 data points
        if (x % 100 == 0) {
            let label = SCITextAnnotation()
            label.text = "N"
            label.set(x1: x)
            label.set(y1: 0)
            label.horizontalAnchorPoint = .center
            label.verticalAnchorPoint = .center
            label.fontStyle = SCIFontStyle(fontSize: 30, andTextColor: .white)
            
            // add label into annotation collection
            self.surface.annotations.add(label)
            
            // if we add annotation and x > fifoCapacity
            // then we need to remove annotation which goes out of the screen
            if (x > fifoCapacity) {
                self.surface.annotations.remove(at: 0)
            }
        }
    }
}
