//
//  SCSDragAxisToScaleChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDragAxisToScaleChartView: UIView {
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
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        
        let rightYAxis = SCINumericAxis()
        rightYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        rightYAxis.axisId = "RightAxisId"
        rightYAxis.axisAlignment = .right
        rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
        
        let leftYAxis = SCINumericAxis()
        leftYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        leftYAxis.axisId = "LeftAxisId"
        leftYAxis.axisAlignment = .left
        leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;

        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)

        SCSDataManager.setFourierDataInto(mountainDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dampedSinewave = SCSDataManager.getDampedSinewave(1500, amplitude: 3.0, phase: 0.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        lineDataSeries.appendRangeX(dampedSinewave.xValues, y: dampedSinewave.yValues, count: dampedSinewave.size)
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.dataSeries = mountainDataSeries
        mountainRenderSeries.areaStyle = SCISolidBrushStyle(colorCode: 0x771964FF)
        mountainRenderSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0944CF, withThickness: 2.0)
        mountainRenderSeries.yAxisId = "LeftAxisId"
        mountainRenderSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
        
        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        lineRenderableSeries.yAxisId = "RightAxisId"
        lineRenderableSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(rightYAxis)
        surface.yAxes.add(leftYAxis)
        surface.renderableSeries.add(mountainRenderSeries)
        surface.renderableSeries.add(lineRenderableSeries)
        
        let yLeftAxisDM = SCIYAxisDragModifier()
        yLeftAxisDM.axisId = "LeftAxisId"
        
        let yRightAxisDM = SCIYAxisDragModifier()
        yRightAxisDM.axisId = "RightAxisId"
        
        surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIXAxisDragModifier(), yLeftAxisDM, yRightAxisDM, SCIZoomExtentsModifier()])
 
        
    }
}
