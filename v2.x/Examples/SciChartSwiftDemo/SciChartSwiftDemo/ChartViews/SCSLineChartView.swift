//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSLineChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addSeries()
        addDefaultModifiers()
    }
    
    // MARK: Private Functions

    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min:SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.setFourierDataInto(fourierDataSeries, amplitude: 1.0, phaseShift: 0.1, count: 5000)
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.dataSeries = fourierDataSeries
        fourierRenderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        chartSurface.renderableSeries.add(fourierRenderSeries)
        
        chartSurface.invalidateElement()
    }
}
