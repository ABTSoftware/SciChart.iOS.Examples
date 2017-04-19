//
//  SCSBandChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSBandChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min:SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let data = SCSDataManager.getDampedSinewave(1.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        let moreData = SCSDataManager.getDampedSinewave(1.0, dampingFactor: 0.05, pointCount: 1000, freq: 12)

        let dataSeries = SCIXyyDataSeries.init(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.appendRangeX(data.xValues, y1: data.yValues, y2: moreData.yValues, count: data.size)
        
        let bandRenderableSeries = SCIBandRenderableSeries()
        bandRenderableSeries.dataSeries = dataSeries
        bandRenderableSeries.style.brush1 = SCISolidBrushStyle(colorCode: 0x33279B27)
        bandRenderableSeries.style.brush2 = SCISolidBrushStyle(colorCode: 0x33FF1919)
        bandRenderableSeries.style.pen1 = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        bandRenderableSeries.style.pen2 = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1.0)

        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
        chartSurface.renderableSeries.add(bandRenderableSeries)
        
        chartSurface.chartModifier = SCIModifierGroup(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        
        chartSurface.invalidateElement()
    }
}
