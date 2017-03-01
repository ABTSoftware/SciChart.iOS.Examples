import UIKit
import SciChart

class ViewController: UIViewController {
    
    var szem: SCIMultiSurfaceModifier!
    
    var chartView: SCIChartSurfaceView?
    var chartSurface: SCIChartSurface?
    
    var chartViewBottom: SCIChartSurfaceView?
    var chartSurfaceBottom: SCIChartSurface?
    
    var lineDataSeries: SCIXyDataSeries!
    var scatterDataSeries: SCIXyDataSeries!
    
    var lineRenderableSeries: SCIFastLineRenderableSeries!
    var scatterRenderableSeries: SCIXyScatterRenderableSeries!
    var mountainRenderableSeries: SCIFastMountainRenderableSeries!
    
    var timer: Timer?
    var phase = 0.0
    var i = 0
    let totalCapacity = 500.0
    
    // annotation collection property, used to store all annotations
    let annotationGroup = SCIAnnotationCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        chartView = SCIChartSurfaceView()
        chartView?.translatesAutoresizingMaskIntoConstraints = false

        chartViewBottom = SCIChartSurfaceView()
        chartViewBottom?.translatesAutoresizingMaskIntoConstraints = false

        
        if let chartSurfaceView = chartView, let chartSurfaceViewBottom = chartViewBottom{
            
            szem = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
            
            self.view.addSubview(chartSurfaceView)
            self.view.addSubview(chartSurfaceViewBottom)
            
            let layoutDictionary = ["SciChart1" : chartSurfaceView, "SciChart2" : chartSurfaceViewBottom]
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|",
                                                               options: NSLayoutFormatOptions(),
                                                               metrics: nil,
                                                               views: layoutDictionary))
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart2]-(0)-|",
                                                               options: NSLayoutFormatOptions(),
                                                               metrics: nil,
                                                               views: layoutDictionary))
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[SciChart1(SciChart2)]-(10)-[SciChart2(SciChart1)]-(0)-|",
                                                               options: NSLayoutFormatOptions(),
                                                               metrics: nil,
                                                               views: layoutDictionary))
            
            
            chartSurface = SCIChartSurface(view: chartSurfaceView)
            chartSurfaceBottom = SCIChartSurface(view: chartSurfaceViewBottom)
            
            addAxes(surface: chartSurface!)
            addAxes(surface: chartSurfaceBottom!)
            
            createDataSeries()
            createRenderableSeries()
            addModifiers()
            
            // set chartSurface's annotation property to annotationGroup
            chartSurface?.annotation = annotationGroup
            
            // calling this forces SciChart to redraw/update all visual data
            chartSurface?.invalidateElement()
            chartSurfaceBottom?.invalidateElement()
        }
    }
    
    func addAxes(surface: SCIChartSurface){
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)
        
        // adding some paddding for Y axis
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxis.axisId = "firstYAxis"
        surface.yAxes.add(yAxis)
        
        let yLeftAxis = SCINumericAxis()
        yLeftAxis.axisId = "secondaryYAxis"
        yLeftAxis.axisAlignment = .left
        yLeftAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(-2), max: SCIGeneric(2))
        yLeftAxis.autoRange = .never
        surface.yAxes.add(yLeftAxis)
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
        
        let xAxis = chartSurface!.xAxes.item(at: 0).visibleRange as! SCIDoubleRange
        xAxis.min = SCIGeneric( SCIGenericDouble(xAxis.min) + 1.0)
        xAxis.max = SCIGeneric( SCIGenericDouble(xAxis.max) + 1.0)
        
        let xAxisBottom = chartSurfaceBottom!.xAxes.item(at: 0).visibleRange as! SCIDoubleRange
        xAxisBottom.min = SCIGeneric( SCIGenericDouble(xAxisBottom.min) + 1.0)
        xAxisBottom.max = SCIGeneric( SCIGenericDouble(xAxisBottom.max) + 1.0)
        
        phase += 0.01
        
        if (i%100 == 0){
            
            let customAnnotation = SCICustomAnnotation()
            let customAnnotationContentView = UILabel(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
            customAnnotationContentView.text = "Y"
            customAnnotationContentView.backgroundColor = UIColor.lightGray
            
            customAnnotation.contentView = customAnnotationContentView
            customAnnotation.x1 = SCIGeneric(i)
            customAnnotation.y1 = SCIGeneric(0.0)
            customAnnotation.coordinateMode = .absolute
            
            
            customAnnotation.yAxisId = i%200 == 0 ? "secondaryYAxis" : "firstYAxis"
            
            
            
            // adding new custom annotation into the annotationGroup property
            annotationGroup.addItem(customAnnotation)
            
            // removing annotations that are out of visible range
            let customAn = annotationGroup.item(at: 0) as! SCICustomAnnotation
            
            if(SCIGenericDouble(customAn.x1) <= Double(i) - totalCapacity){
                // since the contentView is UIView element - we have to call removeFromSuperView method to remove it from screen
                customAn.contentView.removeFromSuperview()
                annotationGroup.removeItem(customAn)
            }
        }
        
        // as ususally - DON'T  forget to call invalidateElement method to update the visual part of SciChart
        chartSurface?.invalidateElement()
        chartSurfaceBottom?.invalidateElement()
    }
    
    func createDataSeries(){
        // Init line data series
        lineDataSeries = SCIXyDataSeries(xType: .int16, yType: .double, seriesType: .fifo)
        lineDataSeries.fifoCapacity = Int32(totalCapacity)
        lineDataSeries.seriesName = "line series"
        
        // Init scatter data series
        scatterDataSeries = SCIXyDataSeries(xType: .int16, yType: .double, seriesType: .fifo)
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
        lineRenderableSeries.yAxisId = "firstYAxis"
        
        scatterRenderableSeries = SCIXyScatterRenderableSeries()
        scatterRenderableSeries.dataSeries = scatterDataSeries
        scatterRenderableSeries.yAxisId = "secondaryYAxis"
        
        mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = lineDataSeries
        mountainRenderableSeries.yAxisId = "firstYAxis"
        
        chartSurface?.renderableSeries.add(lineRenderableSeries)
        chartSurface?.renderableSeries.add(scatterRenderableSeries)
        chartSurfaceBottom?.renderableSeries.add(mountainRenderableSeries)
    }
    
    func addModifiers(){
        
        let xDragModifierSync : SCIMultiSurfaceModifier = SCIMultiSurfaceModifier(modifierType: SCIXAxisDragModifier.self)
        let pinchZoomModifierSync : SCIMultiSurfaceModifier = SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self)
        let panZoomModifierSync : SCIMultiSurfaceModifier = SCIMultiSurfaceModifier(modifierType: SCIZoomPanModifier.self)

        let xAxisDragmodifier : SCIXAxisDragModifier = xDragModifierSync.modifier(forSurface: self.chartSurface) as! SCIXAxisDragModifier
        xAxisDragmodifier.modifierName = "xAxisDragModifierName"
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        let pinchZoomModifier : SCIPinchZoomModifier = pinchZoomModifierSync.modifier(forSurface: self.chartSurface) as! SCIPinchZoomModifier
        pinchZoomModifier.modifierName = "pinchZoomModifierName"
        
        let groupModifier = SCIModifierGroup(childModifiers: [xDragModifierSync, pinchZoomModifierSync, self.szem!, panZoomModifierSync])
        self.chartSurface?.chartModifier = groupModifier
        
        let xAxisDragmodifier2  : SCIXAxisDragModifier = xDragModifierSync.modifier(forSurface: self.chartSurfaceBottom) as! SCIXAxisDragModifier
        xAxisDragmodifier2.modifierName = "xAxisDragModifierName2"
        xAxisDragmodifier2.dragMode = .scale
        xAxisDragmodifier2.clipModeX = .none
        let pinchZoomModifier2 : SCIPinchZoomModifier = pinchZoomModifierSync.modifier(forSurface: self.chartSurfaceBottom) as! SCIPinchZoomModifier
        pinchZoomModifier2.modifierName = "pinchZoomModifierName2"

        let groupModifier2 = SCIModifierGroup(childModifiers: [xDragModifierSync, pinchZoomModifierSync, self.szem!, panZoomModifierSync])
        self.chartSurfaceBottom?.chartModifier = groupModifier2

        chartSurface?.chartModifier = groupModifier
        chartSurfaceBottom?.chartModifier = groupModifier
    }
    
}
