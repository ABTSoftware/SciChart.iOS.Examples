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
    
    var sciChartSurface: SCIChartSurface?
    
    var lineDataSeries: SCIXyDataSeries!
    var scatterDataSeries: SCIXyDataSeries!
    
    var lineRenderableSeries: SCIFastLineRenderableSeries!
    var scatterRenderableSeries: SCIXyScatterRenderableSeries!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sciChartSurface = SCIChartSurface(frame: self.view.bounds)
        sciChartSurface?.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(sciChartSurface!)
        
        sciChartSurface?.xAxes.add(SCINumericAxis())
        sciChartSurface?.yAxes.add(SCINumericAxis())
        
        createDataSeries()
        createRenderableSeries()
        addModifiers()
        
        sciChartSurface?.invalidateElement()

    }
    
    func createDataSeries(){
        // Init line data series
        lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        lineDataSeries.seriesName = "Line Series"
        for i in 0..<500{
            lineDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(sin(Double(i))*0.1))
        }
        
        // Init scatter data series
        scatterDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        scatterDataSeries.seriesName = "Scatter Series"
        for i in 0..<500{
            scatterDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(cos(Double(i))*0.1))
        }
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
