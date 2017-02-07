//
//  ViewController.swift
//  HavingFunWithSciChart
//
//  Created by Yaroslav Pelyukh on 31/01/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

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
            
            let yAxis = SCINumericAxis()
            yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
            chartSurface?.yAxes.add(yAxis)
            
            createDataSeries()
            createRenderableSeries()
            addModifiers()
            
            chartSurface?.invalidateElement()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if nil == timer{
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: updatingDataPoints)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if nil != timer{
            timer?.invalidate()
            timer = nil
        }
    }
    
    func updatingDataPoints(timer:Timer){
        
        for i in 0..<500 {
            lineDataSeries.update(at: Int32(i), x: SCIGeneric(i), y: SCIGeneric(sin(Double(i)*0.1 + phase)))
            scatterDataSeries.update(at: Int32(i), x: SCIGeneric(i), y: SCIGeneric(cos(Double(i)*0.1 + phase)))
            
            phase += 0.01
            
            chartSurface?.invalidateElement()
        }
    }
    
    func createDataSeries(){
        // Init line data series
        lineDataSeries = SCIXyDataSeries(xType: .int16, yType: .double, seriesType: .defaultType)
        lineDataSeries.seriesName = "line series"
        for i in 0..<500{
            lineDataSeries.appendX( SCIGeneric(i), y: SCIGeneric(sin(Double(i)*0.1)))
        }
        
        // Init scatter data series
        scatterDataSeries = SCIXyDataSeries(xType: .int16, yType: .double, seriesType: .defaultType)
        scatterDataSeries.seriesName = "scatter series"
        for i in 0..<500{
            scatterDataSeries.appendX( SCIGeneric(i), y: SCIGeneric(cos(Double(i)*0.1)))
        }
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
