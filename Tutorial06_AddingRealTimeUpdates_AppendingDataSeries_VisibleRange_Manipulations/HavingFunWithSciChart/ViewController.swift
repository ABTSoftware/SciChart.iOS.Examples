import UIKit
import SciChart

class ViewController: UIViewController {
    
    var chartView: SCIChartSurfaceView?
    var chartSurface: SCIChartSurface?
    
    var lineDataSeries: SCIXyDataSeries!
    var scatterDataSeries: SCIXyDataSeries!
    
    var lineRenderableSeries: SCIFastLineRenderableSeries!
    var scatterRenderableSeries: SCIXyScatterRenderableSeries!
    
    var timer: Timer?
    var phase = 0.0
    var i = 0
    let totalCapacity = 500.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        chartView = SCIChartSurfaceView(frame: self.view.bounds)
        chartView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        chartView?.translatesAutoresizingMaskIntoConstraints = true
        
        if let chartSurfaceView = chartView {
            self.view.addSubview(chartSurfaceView)
            
            chartSurface = SCIChartSurface(view: chartSurfaceView)
            
            let xAxis = SCINumericAxis()
            xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
            chartSurface?.xAxes.add(xAxis)
            
            // adding some paddding for Y axis
            let yAxis = SCINumericAxis()
            yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
            chartSurface?.yAxes.add(yAxis)
            
            createDataSeries()
            createRenderableSeries()
            addModifiers()
            
            // calling this forces SciChart to redraw/update all visual data
            chartSurface?.invalidateElement()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if nil == timer{
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: updatingDataPoints)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // invalidating timer
        // Timer is a class which is not under ARC umrella, so we need to control it by ourselves
        if nil != timer{
            timer?.invalidate()
            timer = nil
        }
    }
    
    func updatingDataPoints(timer:Timer){
        
        i += 1
        
        // appending new data points into the line and scatter data series
        lineDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(sin(Double(i)*0.1 + phase)))
        scatterDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(cos(Double(i)*0.1 + phase)))
        
        phase += 0.01
        
        let minIndex = lineDataSeries.count() - Int32(totalCapacity)
        let maxIndex = lineDataSeries.count() - 1
        
        let max = SCIGenericDouble(lineDataSeries.xValues().value(at: maxIndex))
        let min = SCIGenericDouble(lineDataSeries.xValues().value(at: minIndex))
        
        let visibleRange = chartSurface!.xAxes.item(at: 0).visibleRange as! SCIDoubleRange
        let vMin = SCIGenericDouble(visibleRange.min) + 1.0
        let vMax = SCIGenericDouble(visibleRange.max) + totalCapacity * 0.1 + 1.0
        
        // calculating new visible range to simulate the auto scrolling functionality
        if vMin < min && vMax > max{
            visibleRange.min = SCIGeneric(SCIGenericDouble(visibleRange.min) + 1.0)
            visibleRange.max = SCIGeneric(SCIGenericDouble(visibleRange.max) + 1.0)
        }
        
        // as ususally - DON'T  forget to call invalidateElement method to update the visual part of SciChart
        chartSurface?.invalidateElement()
    }
    
    func createDataSeries(){
        // Init line data series
        lineDataSeries = SCIXyDataSeries(xType: .int16, yType: .double, seriesType: .defaultType)
        lineDataSeries.seriesName = "line series"
        
        // Init scatter data series
        scatterDataSeries = SCIXyDataSeries(xType: .int16, yType: .double, seriesType: .defaultType)
        scatterDataSeries.seriesName = "scatter series"
        
        for i in 0...Int32(totalCapacity){
            lineDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(sin(Double(i)*0.1)))
            scatterDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(cos(Double(i)*0.1)))
        }
        
        i = Int(lineDataSeries.count())
    }
    
    func createRenderableSeries(){
        lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        
        scatterRenderableSeries = SCIXyScatterRenderableSeries()
        scatterRenderableSeries.dataSeries = scatterDataSeries
        
        chartSurface?.renderableSeries.add(lineRenderableSeries)
        chartSurface?.renderableSeries.add(scatterRenderableSeries)
    }
    
    func addModifiers(){
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .pan
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        let legend = SCILegendCollectionModifier()
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, legend, rolloverModifier])
        
        chartSurface?.chartModifier = groupModifier
    }
    
}
