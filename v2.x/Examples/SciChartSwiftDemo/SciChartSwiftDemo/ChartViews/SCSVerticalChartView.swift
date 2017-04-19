//
//  SCSVerticalChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/5/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart


class SCSVerticalChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let textFormatting = SCITextFormattingStyle()
        textFormatting.fontSize = 12
        
        let xAxis = SCINumericAxis()
        xAxis.axisTitle = "X-Axis"
        xAxis.style.labelStyle = textFormatting
        xAxis.axisAlignment = .left
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.01), max: SCIGeneric(0.01))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.axisTitle = "Y-Axis"
        yAxis.axisAlignment = .top
        yAxis.style.labelStyle = textFormatting
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.getRandomDoubleSeries(data: dataSeries1, count: 20)
        
        let dataSeries2 = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.getRandomDoubleSeries(data: dataSeries2, count: 20)
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries1
        renderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 2.0)
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF00FF00, withThickness: 2.0)
        fourierRenderSeries.dataSeries = dataSeries2
        
        chartSurface.renderableSeries.add(fourierRenderSeries)
        chartSurface.renderableSeries.add(renderSeries)
        
        chartSurface.invalidateElement()
    }
}
