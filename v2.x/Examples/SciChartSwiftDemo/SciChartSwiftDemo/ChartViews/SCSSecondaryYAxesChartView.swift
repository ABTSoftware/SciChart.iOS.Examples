//
//  SCSSecondaryYAxesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSSecondaryYAxesChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()

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
        
        let fourierDataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dampedSinewave = SCSDataManager.getDampedSinewave(3.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        lineDataSeries.appendRangeX(dampedSinewave.xValues, y: dampedSinewave.yValues, count: dampedSinewave.size)

        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.dataSeries = fourierDataSeries
        fourierRenderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF4083B7, withThickness: 2.0)
        fourierRenderSeries.yAxisId = "leftAxisId"

        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        lineRenderableSeries.yAxisId = "rightAxisId"
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(leftYAxis)
        chartSurface.yAxes.add(rightYAxis)
        chartSurface.renderableSeries.add(fourierRenderSeries)
        chartSurface.renderableSeries.add(lineRenderableSeries)
        
        chartSurface.invalidateElement()
    }
}
