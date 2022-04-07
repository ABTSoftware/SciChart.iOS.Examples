import UIKit
import SciChart

class ViewController: UIViewController {
    private let fifoCapacity = 500
    private let pointsCount = 200
    private var timer: Timer!
    private var count: Int = 0
    
    private lazy var lineDataSeries: SCIXyDataSeries = {
        let lineDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        lineDataSeries.seriesName = "Line Series"
        lineDataSeries.fifoCapacity = fifoCapacity
        return lineDataSeries
    }()
    private lazy var scatterDataSeries: SCIXyDataSeries = {
        let scatterDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        scatterDataSeries.seriesName = "Scatter Series"
        scatterDataSeries.fifoCapacity = fifoCapacity
        return scatterDataSeries
    }()
    private lazy var mountainDataSeries: SCIXyDataSeries = {
        let mountainDataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        mountainDataSeries.seriesName = "Mountain Series"
        mountainDataSeries.fifoCapacity = fifoCapacity
        return mountainDataSeries
    }()
    
    
    private let surface = SCIChartSurface()
    private let surface2 = SCIChartSurface()
    
    override func loadView() {
        view = UIView()
        surface.translatesAutoresizingMaskIntoConstraints = false
        surface2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(surface)
        view.addSubview(surface2)
        
        let layoutDictionary = ["SciChart1" : surface, "SciChart2" : surface2]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|", options: [], metrics: nil, views: layoutDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart2]-(0)-|", options: [], metrics: nil, views: layoutDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[SciChart1(SciChart2)]-(0)-[SciChart2(SciChart1)]-(0)-|", options: [], metrics: nil, views: layoutDictionary))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< pointsCount {
            lineDataSeries.append(x: Int(i), y: sin(Double(i) * 0.1))
            scatterDataSeries.append(x: Int(i), y: cos(Double(i) * 0.1))
            mountainDataSeries.append(x: Int(i), y: cos(Double(i) * 0.1))
            count += 1
        }
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.yAxisId = "Primary Y-Axis"
        lineSeries.dataSeries = lineDataSeries
        
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.fillStyle = SCISolidBrushStyle(color: 0xFF32CD32)
        pointMarker.size = CGSize(width: 10, height: 10)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.yAxisId = "Secondary Y-Axis"
        scatterSeries.dataSeries = scatterDataSeries
        scatterSeries.pointMarker = pointMarker
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.renderableSeries.add(items: lineSeries, scatterSeries)
        }
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.yAxisId = "Primary Y-Axis"
        mountainSeries.dataSeries = scatterDataSeries
        mountainSeries.strokeStyle = SCISolidPenStyle(color: 0xFF0271B1, thickness: 2)
        mountainSeries.areaStyle = SCISolidBrushStyle(color: 0x990271B1)
        
        SCIUpdateSuspender.usingWith(surface2) {
            self.surface2.renderableSeries.add(mountainSeries)
        }
        
        setupSurface(surface: surface)
        setupSurface(surface: surface2)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        let x = count
        SCIUpdateSuspender.usingWith(surface) {
            self.lineDataSeries.append(x: x, y: sin(Double(x) * 0.1))
            self.scatterDataSeries.append(x: x, y: cos(Double(x) * 0.1))
            self.mountainDataSeries.append(x: x, y: cos(Double(x) * 0.1))
            
            self.tryAddAnnotation(at: x)
            
            // zoom series to fit viewport size into X-Axis direction
            self.surface.zoomExtentsX()
            self.surface2.zoomExtentsX()
            self.count += 1
        }
    }
    
    fileprivate func setupSurface(surface: SCIChartSurface) {
        // Create another numeric axis, right-aligned
        let yAxisRight = SCINumericAxis()
        yAxisRight.axisTitle = "Primary Y-Axis"
        yAxisRight.axisId = "Primary Y-Axis"
        yAxisRight.axisAlignment = .right
        
        // Create another numeric axis, left-aligned
        let yAxisLeft = SCINumericAxis()
        yAxisLeft.axisTitle = "Secondary Y-Axis"
        yAxisLeft.axisId = "Secondary Y-Axis"
        yAxisLeft.axisAlignment = .left
        yAxisLeft.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.receiveHandledEvents = true
        rolloverModifier.eventsGroupTag = "SharedEventGroup"
                
        SCIUpdateSuspender.usingWith(surface) {
            surface.xAxes.add(items: SCINumericAxis())
            surface.yAxes.add(items: yAxisRight, yAxisLeft)
            surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCIPinchZoomModifier(), rolloverModifier, SCIXAxisDragModifier(), SCIYAxisDragModifier())
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
            
            label.yAxisId = x % 200 == 0 ? "Primary Y-Axis" : "Secondary Y-Axis"
            
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
