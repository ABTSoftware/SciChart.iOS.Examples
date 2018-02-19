//
//  SCSVerticalChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/5/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart


class SCSVerticalChartView: UIView {
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
        addAxes()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let textFormatting = SCITextFormattingStyle()
        textFormatting.fontSize = 12
        
        let xAxis = SCINumericAxis()
        xAxis.axisTitle = "X-Axis"
        xAxis.style.labelStyle = textFormatting
        xAxis.axisAlignment = .left
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.01), max: SCIGeneric(0.01))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.axisTitle = "Y-Axis"
        yAxis.axisAlignment = .top
        yAxis.style.labelStyle = textFormatting
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float)
        SCSDataManager.getRandomDoubleSeries(data: dataSeries1, count: 20)
        
        let dataSeries2 = SCIXyDataSeries(xType: .float, yType: .float)
        SCSDataManager.getRandomDoubleSeries(data: dataSeries2, count: 20)
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries1
        renderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 2.0)
        renderSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF00FF00, withThickness: 2.0)
        fourierRenderSeries.dataSeries = dataSeries2
        fourierRenderSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        surface.renderableSeries.add(fourierRenderSeries)
        surface.renderableSeries.add(renderSeries)
        
        
    }
}
