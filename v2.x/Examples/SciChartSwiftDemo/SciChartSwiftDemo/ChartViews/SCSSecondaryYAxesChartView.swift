//
//  SCSSecondaryYAxesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSSecondaryYAxesChartView: UIView {
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
        xAxis.axisTitle = "Bottom Axis"
        
        let rightYAxis = SCINumericAxis()
        rightYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        rightYAxis.axisId = "rightAxisId"
        rightYAxis.axisTitle = "Right Axis"
        rightYAxis.axisAlignment = .right
        rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
        
        let leftYAxis = SCINumericAxis()
        leftYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        leftYAxis.axisId = "leftAxisId"
        leftYAxis.axisTitle = "Left Axis"
        leftYAxis.axisAlignment = .left
        leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;
        
        let fourierDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dampedSinewave = SCSDataManager.getDampedSinewave(3.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        lineDataSeries.appendRangeX(dampedSinewave.xValues, y: dampedSinewave.yValues, count: dampedSinewave.size)

        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.dataSeries = fourierDataSeries
        fourierRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4083B7, withThickness: 2.0)
        fourierRenderSeries.yAxisId = "leftAxisId"
        fourierRenderSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))

        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        lineRenderableSeries.yAxisId = "rightAxisId"
        lineRenderableSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(leftYAxis)
        surface.yAxes.add(rightYAxis)
        surface.renderableSeries.add(fourierRenderSeries)
        surface.renderableSeries.add(lineRenderableSeries)
        
        
    }
}
