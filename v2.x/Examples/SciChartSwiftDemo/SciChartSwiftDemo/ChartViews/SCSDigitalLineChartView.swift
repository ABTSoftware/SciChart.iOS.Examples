//
//  DigitalLineView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalLineChartView: UIView {
    
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
        addDefaultModifiers()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1.0), max: SCIGeneric(1.25))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(2.3), max: SCIGeneric(3.3))
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.5), max: SCIGeneric(0.5))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = fourierDataSeries
        renderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 1.0)
        renderSeries.style.isDigitalLine = true
        renderSeries.hitTestProvider().hitTestMode = .verticalInterpolate
        
        renderSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
        
        surface.renderableSeries.add(renderSeries)
        
    }
}
