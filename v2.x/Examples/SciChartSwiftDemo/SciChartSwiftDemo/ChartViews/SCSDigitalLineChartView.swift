//
//  DigitalLineView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalLineChartView: SCSBaseChartView {
    
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
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1.0), max: SCIGeneric(1.25))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(2.3), max: SCIGeneric(3.3))
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.5), max: SCIGeneric(0.5))
        chartSurface.yAxes.add(yAxis)

    }
    
    fileprivate func addSeries() {
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = fourierDataSeries
        renderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 1.0)
        renderSeries.style.isDigitalLine = true
        renderSeries.hitTestProvider().hitTestMode = .verticalInterpolate
        chartSurface.renderableSeries.add(renderSeries)
        chartSurface.invalidateElement()
        
    }
    
}
