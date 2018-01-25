//
//  SCSStackedColumnChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 11/10/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedBarChartView: UIView {
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
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        
        let xAxis = SCINumericAxis()
        xAxis.axisAlignment = .right
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.flipCoordinates = true
        yAxis.axisAlignment = .bottom
        surface.yAxes.add(yAxis)
    }
   
    fileprivate func addDataSeries() {
        let stackedGroup = SCIVerticallyStackedColumnsCollection()
        stackedGroup.add(self.p_getRenderableSeries(0, andFillColorStart: 0xff3D5568, andFinish: 0xff567893))
        stackedGroup.add(self.p_getRenderableSeries(1, andFillColorStart: 0xff439aaf, andFinish: 0xffACBCCA))
        stackedGroup.add(self.p_getRenderableSeries(2, andFillColorStart: 0xffb6c1c3, andFinish: 0xffdbe0e1))
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        
        stackedGroup.addAnimation(animation)
        
        surface.renderableSeries.add(stackedGroup)
    }
    
    fileprivate func p_getRenderableSeries(_ index: Int, andFillColorStart fillColor: uint, andFinish finishColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: fillColor, finish: finishColor, direction: .horizontal)
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: fillColor, withThickness: 0.5)
        renderableSeries.dataSeries = SCSDataManager.stackedBarChartSeries()[index]
        
        return renderableSeries
    }
    
}
