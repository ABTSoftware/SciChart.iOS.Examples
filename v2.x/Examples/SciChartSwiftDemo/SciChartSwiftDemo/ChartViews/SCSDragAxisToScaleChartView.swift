//
//  SCSDragAxisToScaleChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDragAxisToScaleChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()

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

        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)

        SCSDataManager.setFourierDataInto(mountainDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dampedSinewave = SCSDataManager.getDampedSinewave(1500, amplitude: 3.0, phase: 0.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        lineDataSeries.appendRangeX(dampedSinewave.xValues, y: dampedSinewave.yValues, count: dampedSinewave.size)
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.dataSeries = mountainDataSeries
        mountainRenderSeries.style.areaBrush = SCISolidBrushStyle(colorCode: 0x771964FF)
        mountainRenderSeries.style.borderPen = SCISolidPenStyle(colorCode: 0xFF0944CF, withThickness: 2.0)
        mountainRenderSeries.yAxisId = "LeftAxisId"
        
        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        lineRenderableSeries.yAxisId = "RightAxisId"
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(rightYAxis)
        chartSurface.yAxes.add(leftYAxis)
        chartSurface.renderableSeries.add(mountainRenderSeries)
        chartSurface.renderableSeries.add(lineRenderableSeries)
        
        let yLeftAxisDM = SCIYAxisDragModifier()
        yLeftAxisDM.axisId = "LeftAxisId"
        
        let yRightAxisDM = SCIYAxisDragModifier()
        yRightAxisDM.axisId = "RightAxisId"
        
        chartSurface.chartModifier = SCIModifierGroup(childModifiers: [SCIXAxisDragModifier(), yLeftAxisDM, yRightAxisDM, SCIZoomExtentsModifier()])
 
        chartSurface.invalidateElement()
    }
}
