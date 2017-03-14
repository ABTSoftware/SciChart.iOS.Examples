//
//  SCSBubbleChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSBubbleChartView: SCSBaseChartView  {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addModifiers()
        addDataSeries()
    }
    
    func addModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let tooltipModifier = SCITooltipModifier()
        tooltipModifier.style.colorMode = .seriesColor
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, tooltipModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCIDateTimeAxis())
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.05), max: SCIGeneric(0.05))
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let dataSeries = SCIXyzDataSeries(xType: .dateTime, yType: .float, zType: .float)
        SCSDataManager.getTradeTicks(dataSeries, fileName: "TradeTicks")
        
        let bubbleRenderable = SCIBubbleRenderableSeries()
        bubbleRenderable.style.bubbleBrush = SCISolidBrushStyle(colorCode: 0x50CCCCCC)
        bubbleRenderable.style.borderPen = SCISolidPenStyle(colorCode: 0xFFCCCCCC, withThickness: 2.0)
        bubbleRenderable.style.detalization = 44
        bubbleRenderable.zScaleFactor = 1.0
        bubbleRenderable.dataSeries = dataSeries
        
        let lineRendSeries = SCIFastLineRenderableSeries()
        lineRendSeries.dataSeries = dataSeries
        lineRendSeries.style.linePen = SCISolidPenStyle(colorCode: 0xffff3333, withThickness: 2.0)
        
        chartSurface.renderableSeries.add(lineRendSeries)
        chartSurface.renderableSeries.add(bubbleRenderable)
        chartSurface.invalidateElement()
    }
}
