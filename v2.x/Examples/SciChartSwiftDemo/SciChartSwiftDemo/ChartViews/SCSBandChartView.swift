//
//  SCSBandChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSBandChartView: UIView {
    
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
        
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min:SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let data = SCSDataManager.getDampedSinewave(1.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        let moreData = SCSDataManager.getDampedSinewave(1.0, dampingFactor: 0.05, pointCount: 1000, freq: 12)

        let dataSeries = SCIXyyDataSeries.init(xType: .double, yType: .double)
        dataSeries.appendRangeX(data.xValues, y1: data.yValues, y2: moreData.yValues, count: data.size)
        
        let bandRenderableSeries = SCIFastBandRenderableSeries()
        bandRenderableSeries.dataSeries = dataSeries
        bandRenderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: 0x33279B27)
        bandRenderableSeries.fillY1BrushStyle = SCISolidBrushStyle(colorCode: 0x33FF1919)
        bandRenderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        bandRenderableSeries.strokeY1Style = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1.0)
        
        let animation = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animation.start(afterDelay: 0.3)
        bandRenderableSeries.addAnimation(animation)

        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(bandRenderableSeries)
        
        surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        
        
    }
}
