//
//  SCSDigitalMountainChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 3/15/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalMountainChartView: UIView {
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
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.hitTestMode = .vertical
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries () {
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0xAAFF8D42,
                                                finish: 0x88090E11,
                                                direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xAAFFC9A8, withThickness: 1.0)
        
        surface.renderableSeries.add(getMountainRenderSeries(withBrush: brush, and: pen))
        
    }
    
    
    fileprivate func getMountainRenderSeries(withBrush brush:SCILinearGradientBrushStyle, and pen: SCISolidPenStyle) -> SCIFastMountainRenderableSeries {
        let dataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .float)
        SCSDataManager.getPriceIndu(dataSeries: dataSeries, fileName: "INDU_Daily")
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.zeroLineY = 10000
        mountainRenderSeries.isDigitalLine = true
        mountainRenderSeries.areaStyle = brush
        mountainRenderSeries.style.strokeStyle = pen
        mountainRenderSeries.dataSeries = dataSeries
        mountainRenderSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        return mountainRenderSeries
    }
}
