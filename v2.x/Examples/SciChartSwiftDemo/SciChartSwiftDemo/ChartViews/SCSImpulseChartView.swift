//
//  SCSImpulseChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/15/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSImpulseChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()

        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
       
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))

        let ds1Points = SCSDataManager.getDampedSinewave(1.0, dampingFactor: 0.05, pointCount: 50, freq: 5)
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.appendRangeX(ds1Points.xValues, y: ds1Points.yValues, count: ds1Points.size)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF0066FF)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let impulseSeries = SCIFastImpulseRenderableSeries()
        impulseSeries.dataSeries = dataSeries
        impulseSeries.style.linePen = SCISolidPenStyle(colorCode:0xFF0066FF, withThickness: 0.7)
        impulseSeries.style.pointMarker = ellipsePointMarker
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
        chartSurface.renderableSeries.add(impulseSeries)
        addDefaultModifiers()
        
        chartSurface.invalidateElement()
    }
}
