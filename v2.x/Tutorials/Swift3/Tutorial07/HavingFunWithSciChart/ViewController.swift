import UIKit
import SciChart

class ViewController: UIViewController {
    
    var sciChartSurface: SCIChartSurface?
    
    var lineDataSeries: SCIXyDataSeries!
    var scatterDataSeries: SCIXyDataSeries!
    
    var lineRenderableSeries: SCIFastLineRenderableSeries!
    var scatterRenderableSeries: SCIXyScatterRenderableSeries!
    
    var timer: Timer?
    var phase = 0.0
    var i = 0
    let totalCapacity = 500.0
    
    // annotation collection property, used to store all annotations
    let annotationGroup = SCIAnnotationCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sciChartSurface = SCIChartSurface(frame: self.view.bounds)
        sciChartSurface?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        sciChartSurface?.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(sciChartSurface!)
        
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        sciChartSurface?.xAxes.add(xAxis)
        
        // adding some paddding for Y axis
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        sciChartSurface?.yAxes.add(yAxis)
        
        createDataSeries()
        createRenderableSeries()
        addModifiers()
        
        // set chartSurface's annotation property to annotationGroup
        sciChartSurface?.annotations = annotationGroup
        
        // calling this forces SciChart to redraw/update all visual data
        sciChartSurface?.invalidateElement()

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
        
        if (i%100 == 0){
            
            let customAnnotation = SCICustomAnnotation()
            let customAnnotationContentView = UILabel(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
            customAnnotationContentView.text = "Y"
            customAnnotationContentView.backgroundColor = UIColor.lightGray
            
            customAnnotation.contentView = customAnnotationContentView
            customAnnotation.x1 = SCIGeneric(i)
            customAnnotation.y1 = SCIGeneric(0.5)
            customAnnotation.coordinateMode = .relativeY
            
            // adding new custom annotation into the annotationGroup property
            annotationGroup.add(customAnnotation)
            
            // removing annotations that are out of visible range
            let customAn = annotationGroup.item(at: 0) as! SCICustomAnnotation
            
            if(SCIGenericDouble(customAn.x1) < Double(i) - totalCapacity){
                // since the contentView is UIView element - we have to call removeFromSuperView method to remove it from screen
                customAn.contentView.removeFromSuperview()
                annotationGroup.remove(customAn)
            }
        }
        
        // as ususally - DON'T  forget to call invalidateElement method to update the visual part of SciChart
        sciChartSurface?.zoomExtents()
        sciChartSurface?.invalidateElement()
    }
    
    func createDataSeries(){
        // Init line data series
        lineDataSeries = SCIXyDataSeries(xType: .int16, yType: .double)
        lineDataSeries.fifoCapacity = Int32(totalCapacity)
        lineDataSeries.seriesName = "line series"
        
        // Init scatter data series
        scatterDataSeries = SCIXyDataSeries(xType: .int16, yType: .double)
        scatterDataSeries.fifoCapacity = Int32(totalCapacity)
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
        
        sciChartSurface?.renderableSeries.add(lineRenderableSeries)
        sciChartSurface?.renderableSeries.add(scatterRenderableSeries)
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
        let legend = SCILegendModifier()
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, legend, rolloverModifier])
        
        sciChartSurface?.chartModifiers = groupModifier
    }
    
}
