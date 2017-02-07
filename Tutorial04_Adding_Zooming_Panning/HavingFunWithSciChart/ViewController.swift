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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        chartView = SCIChartSurfaceView(frame: self.view.bounds)
        chartView?.translatesAutoresizingMaskIntoConstraints = true
        
        if let chartSurfaceView = chartView {
            self.view.addSubview(chartSurfaceView)
            
            chartSurface = SCIChartSurface(view: chartSurfaceView)
            
            chartSurface?.xAxes.add(SCINumericAxis())
            chartSurface?.yAxes.add(SCINumericAxis())
            
            createDataSeries()
            createRenderableSeries()
            addModifiers()
            
            chartSurface?.invalidateElement()
        }
    }
    
    func createDataSeries(){
        // Init line data series
        lineDataSeries = SCIXyDataSeries(xType: .int16, yType: .int16, seriesType: .defaultType)
        for i in 0..<10{
            lineDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(i*2))
        }
        
        // Init scatter data series
        scatterDataSeries = SCIXyDataSeries(xType: .int16, yType: .int16, seriesType: .defaultType)
        for i in 0..<10{
            scatterDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(i*2 - i))
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
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier])
        
        chartSurface?.chartModifier = groupModifier
    }
}
