//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSLineChartView: UIView {
    
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
        
        let marker = SCIEllipsePointMarker()
        marker.width = 20
        marker.height = 20
        marker.strokeStyle = SCISolidPenStyle(colorCode:0xFF390032,withThickness:0.5)
        marker.fillStyle = SCISolidBrushStyle(colorCode:0xE1245120)
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        rolloverModifier.style.pointMarker = marker
        
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
        SCIUpdateSuspender.usingWithSuspendable(surface) {[unowned self] in
            self.addAxes()
            self.addSeries()
            self.addDefaultModifiers()
        }
    }
    
    // MARK: Private Functions

    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min:SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.dataSeries = fourierDataSeries
        fourierRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        
        let animation = SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        
        animation.start(afterDelay: 0.3)
        fourierRenderSeries.addAnimation(animation)
        
        surface.renderableSeries.add(fourierRenderSeries)
        
    }
}
