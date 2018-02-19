//
//  SCSLogarithmicAxisChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/5/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//


import Foundation
import SciChart


class SCSLogarithmicAxisChartView: UIView {
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
        let xAxis = SCILogarithmicNumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)

        let yAxis = SCILogarithmicNumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float)
        let dataSeries2 = SCIXyDataSeries(xType: .float, yType: .float)
        let dataSeries3 = SCIXyDataSeries(xType: .float, yType: .float)
        
        SCSDataManager.getExponentialCurve(data: dataSeries1, count: 100, exponent: 1.8)
        SCSDataManager.getExponentialCurve(data: dataSeries2, count: 100, exponent: 2.25)
        SCSDataManager.getExponentialCurve(data: dataSeries3, count: 100, exponent: 3.59)
        
        let renderSeries1 = SCIFastLineRenderableSeries()
        renderSeries1.dataSeries = dataSeries1
        renderSeries1.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFFFF00, withThickness: 1.5)
        renderSeries1.style.pointMarker = getPointMarker(size: 5, color: 0xFFFFFF00)
        
        var animation = SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .linear)
        animation.start(afterDelay: 0.3)
        renderSeries1.addAnimation(animation)
        
        let renderSeries2 = SCIFastLineRenderableSeries()
        renderSeries2.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.5)
        renderSeries2.dataSeries = dataSeries2
        renderSeries2.style.pointMarker = getPointMarker(size: 5, color: 0xFF279B27)
        animation = SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .linear)
        animation.start(afterDelay: 0.3)
        renderSeries2.addAnimation(animation)
        
        let renderSeries3 = SCIFastLineRenderableSeries()
        renderSeries3.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1.5)
        renderSeries3.dataSeries = dataSeries3
        renderSeries3.style.pointMarker = getPointMarker(size: 5, color: 0xFFFF1919)
        animation = SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .linear)
        animation.start(afterDelay: 0.3)
        renderSeries3.addAnimation(animation)
        
        surface.renderableSeries.add(renderSeries1)
        surface.renderableSeries.add(renderSeries2)
        surface.renderableSeries.add(renderSeries3)
        
        
    }
    
    fileprivate func getPointMarker(size:Int, color:UInt)->SCIEllipsePointMarker{
        let ellipseMarker = SCIEllipsePointMarker()
        ellipseMarker.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFFFFFF, withThickness: 0.0)
        ellipseMarker.width = Float(size)
        ellipseMarker.height = Float(size)
        ellipseMarker.fillStyle = SCISolidBrushStyle(colorCode: UInt32(color))
        return ellipseMarker
    }
}
