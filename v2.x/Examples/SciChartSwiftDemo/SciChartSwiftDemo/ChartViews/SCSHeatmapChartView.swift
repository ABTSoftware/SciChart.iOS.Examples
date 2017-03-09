//
//  SCSHeatmapChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSHeatmapChartView: SCSBaseChartView {
    
    var heatmapDataSeries : SCIUniformHeatmapDataSeries!
    var size: Int32 = 100
    var increment = 1
    var timer: Timer!
    var scale = 0.1
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addModifiers()
        addDataSeries()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(SCSHeatmapChartView.updateHeatmapData),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    func addModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.modifierName = xAxisDragModifierName
        xAxisDragmodifier.axisId = axisXId
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.modifierName = yAxisDragModifierName
        yAxisDragmodifier.axisId = axisYId
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        extendZoomModifier.modifierName = extendZoomModifierName
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.modifierName = pinchZoomModifierName
        
        let tooltipModifier = SCITooltipModifier()
        tooltipModifier.modifierName = "TooltipModifier"
        tooltipModifier.style.colorMode = .seriesColor
        //        rolloverModifier.style.tooltipSize = CGSizeMake(200, CGFloat.NaN)
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, tooltipModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if timer != nil {
            timer.invalidate()
        }
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let axisStyle = generateDefaultAxisStyle()
        chartSurface.xAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
        chartSurface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
    }
    
    fileprivate func addDataSeries() {
        
        let array2d = SCIArrayController2D(type: .double, sizeX: 100, y: 100)
        for i in 0...size-1 {
            for j in 0...size-1{
                array2d?.setValue(SCIGeneric(i*j/10), atX: Int32(i), y: Int32(j))
            }
        }
        
        heatmapDataSeries = SCIUniformHeatmapDataSeries(zValues: array2d, startX: SCIGeneric(0.0), stepX: SCIGeneric(0.1), startY: SCIGeneric(0.0), stepY: SCIGeneric(0.1))
        heatmapDataSeries.seriesName = "HeatSeriesName"
        
        let heatRenderableSeries = SCIFastUniformHeatmapRenderableSeries()
        heatRenderableSeries.style.max = SCIGeneric(1)
        heatRenderableSeries.dataSeries = heatmapDataSeries
        
        
        chartSurface.renderableSeries.add(heatRenderableSeries)
        chartSurface.invalidateElement()
        
    }
    
    func updateHeatmapData() {
        
        let seriesPeriod = 30.0
        let angle = M_PI*scale/seriesPeriod
        
        for i in 0...size-1 {
            for j in 0...size-1{
                let x = Double(i)
                let y = Double(j)
                var v = (1.0 + sin(x * 0.04 + angle)) * 50.0
                v = v +  (1.0 + sin(y * 0.1 + angle)) * 50.0 * (1.0 + sin(angle * 2.0))
                let r = sqrt(x * x + y * y)
                var exp = (1.0 - r * 0.008)
                exp = exp > 0.0 ? exp : 0.0
                let d = (v * exp + Double(arc4random() % 2))/100.0
                heatmapDataSeries.updateZ(atXIndex: i, yIndex: j, withValue: SCIGeneric(d))
            }
        }
        
        heatmapDataSeries.updateZ(atXIndex: 0, yIndex: 0, withValue: SCIGeneric(0))
        scale += 0.5
        chartSurface.invalidateElement()
        
    }
    
    
    
    
}
