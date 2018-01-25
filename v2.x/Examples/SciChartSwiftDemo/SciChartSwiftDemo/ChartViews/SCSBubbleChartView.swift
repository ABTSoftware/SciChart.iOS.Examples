//
//  SCSBubbleChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSBubbleChartView: UIView {
    
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
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
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, tooltipModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCIDateTimeAxis())
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.05), max: SCIGeneric(0.05))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let dataSeries = SCIXyzDataSeries(xType: .dateTime, yType: .float, zType: .float)
        SCSDataManager.getTradeTicks(dataSeries, fileName: "TradeTicks")
        
        let bubbleRenderable = SCIBubbleRenderableSeries()
        bubbleRenderable.bubbleBrushStyle = SCISolidBrushStyle(colorCode: 0x50CCCCCC)
        bubbleRenderable.strokeStyle = SCISolidPenStyle(colorCode: 0xFFCCCCCC, withThickness: 2.0)
        bubbleRenderable.style.detalization = 44
        bubbleRenderable.zScaleFactor = 1.0
        bubbleRenderable.dataSeries = dataSeries
        
        let animationBubble = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animationBubble.start(afterDelay: 0.3)
        bubbleRenderable.addAnimation(animationBubble)
        
        let lineRendSeries = SCIFastLineRenderableSeries()
        lineRendSeries.dataSeries = dataSeries
        lineRendSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xffff3333, withThickness: 2.0)
        
        let animationLine = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animationLine.start(afterDelay: 0.3)
        lineRendSeries.addAnimation(animationLine)

        
        surface.renderableSeries.add(lineRendSeries)
        surface.renderableSeries.add(bubbleRenderable)
        
    }
}
