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
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.axisId = "rightAxisId"
        yAxis.axisAlignment = .right
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxis)
        
        let yLeftAxis = SCINumericAxis()
        yLeftAxis.axisId = "leftAxisId"
        yLeftAxis.axisAlignment = .left
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yLeftAxis)
    }
    
    override func addDefaultModifiers() {
        let zem = SCIZoomExtentsModifier()
        
        let xAxisDM = SCIXAxisDragModifier()
        
        let yLeftAxisDM = SCIYAxisDragModifier()
        yLeftAxisDM.axisId = "leftAxisId"
        yLeftAxisDM.dragMode = .scale
        
        let yRightAxisDM = SCIYAxisDragModifier()
        yRightAxisDM.axisId = "rightAxisId"
        yRightAxisDM.dragMode = .scale
        
        chartSurface.chartModifier = SCIModifierGroup(childModifiers: [zem, xAxisDM, yLeftAxisDM, yRightAxisDM])
    }
    
    fileprivate func addSeries() {
        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.setFourierDataInto(mountainDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        
        let lineDataSeries =  SCSDataManager.getDampedSinewave(3.0, phase: 0.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = lineDataSeries
        renderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        renderSeries.yAxisId = "rightAxisId"
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.style.areaBrush = SCISolidBrushStyle(colorCode: 0x771964FF)
        mountainRenderSeries.style.borderPen = SCISolidPenStyle(colorCode: 0xFF0944CF, withThickness: 2.0)
        mountainRenderSeries.yAxisId = "leftAxisId"
        mountainRenderSeries.dataSeries = mountainDataSeries
        
        chartSurface.renderableSeries.add(mountainRenderSeries)
        chartSurface.renderableSeries.add(renderSeries)
        
        chartSurface.invalidateElement()
    }
}
