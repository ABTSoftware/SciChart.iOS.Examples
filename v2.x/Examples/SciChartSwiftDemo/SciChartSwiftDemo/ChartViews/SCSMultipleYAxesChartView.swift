//
//  SCSMultipleYAxesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSMultipleYAxesChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let btf = SCITextFormattingStyle()
        btf.fontSize = 12
        
        let xAxis = SCINumericAxis()
        xAxis.axisTitle = "Bottom Axis"
        xAxis.style.labelStyle = btf
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.xAxes.add(xAxis)
        
        let rtf = SCITextFormattingStyle()
        rtf.fontSize = 12
        rtf.colorCode = 0xFF279B27
        
        let yAxis = SCINumericAxis()
        yAxis.axisId = "rightAxisId"
        yAxis.axisTitle = "Right Axis"
        yAxis.axisAlignment = .right
        yAxis.style.labelStyle = rtf
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxis)
        
        let ltf = SCITextFormattingStyle()
        ltf.fontSize = 12
        ltf.colorCode = 0xFF4083B7
        
        let yLeftAxis = SCINumericAxis()
        yLeftAxis.axisId = "leftAxisId"
        yLeftAxis.axisTitle = "Left Axis"
        yLeftAxis.axisAlignment = .left
        yLeftAxis.style.labelStyle = ltf
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yLeftAxis)
    }
    
    fileprivate func addSeries() {
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        
        let lineDataSeries =  SCSDataManager.getDampedSinewave(3.0, phase: 0.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = lineDataSeries
        renderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        renderSeries.yAxisId = "rightAxisId"
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF0944CF, withThickness: 2.0)
        fourierRenderSeries.yAxisId = "leftAxisId"
        fourierRenderSeries.dataSeries = fourierDataSeries
        
        chartSurface.renderableSeries.add(fourierRenderSeries)
        chartSurface.renderableSeries.add(renderSeries)
        
        chartSurface.invalidateElement()
    }
}
