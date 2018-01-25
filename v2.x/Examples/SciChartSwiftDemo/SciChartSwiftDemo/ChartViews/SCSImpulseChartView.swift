//
//  SCSImpulseChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/15/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSImpulseChartView: UIView {
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
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
       
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))

        let ds1Points = SCSDataManager.getDampedSinewave(1.0, dampingFactor: 0.05, pointCount: 50, freq: 5)
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        dataSeries.appendRangeX(ds1Points.xValues, y: ds1Points.yValues, count: ds1Points.size)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF0066FF)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let impulseSeries = SCIFastImpulseRenderableSeries()
        impulseSeries.dataSeries = dataSeries
        impulseSeries.strokeStyle = SCISolidPenStyle(colorCode:0xFF0066FF, withThickness: 0.7)
        impulseSeries.style.pointMarker = ellipsePointMarker
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        impulseSeries.addAnimation(animation)
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(impulseSeries)
        addDefaultModifiers()
        
        
    }
}
