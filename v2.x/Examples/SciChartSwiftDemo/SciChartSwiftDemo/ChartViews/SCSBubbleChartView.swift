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
        xAxisDragmodifier.modifierName = xAxisDragModifierName
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.modifierName = yAxisDragModifierName
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
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let axisStyle = generateDefaultAxisStyle()
        chartSurface.xAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
        chartSurface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
    }
    
    fileprivate func addDataSeries() {
        let dataSeries = SCIXyzDataSeries(xType: .float, yType: .float, zType: .float)
        putDataInto(dataSeries)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let bubbleRenderable = SCIBubbleRenderableSeries()
        bubbleRenderable.style.bubbleBrush = SCISolidBrushStyle(colorCode: 0xFFd63b3f)
        bubbleRenderable.style.borderPen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        bubbleRenderable.style.detalization = 44
        bubbleRenderable.zScaleFactor = 3.0
        bubbleRenderable.dataSeries = dataSeries
        
        
        chartSurface.renderableSeries.add(bubbleRenderable)
        chartSurface.invalidateElement()
        
    }
    
    fileprivate func putDataInto(_ dataSeries: SCIXyzDataSeries) {
        var i = 0
        while i < 20 {
            dataSeries.appendX(SCIGeneric(Float(i)),
                               y: SCIGeneric(sin(Float(i))),
                               z: SCIGeneric(Float(arc4random()%30)))
            i += 1
        }
    }
    
    
}
