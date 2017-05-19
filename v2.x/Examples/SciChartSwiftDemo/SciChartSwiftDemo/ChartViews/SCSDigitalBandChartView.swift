//
//  SCSBandChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalBandChartView: SCSBaseChartView {
    
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
        
        let bandRenderableSeries = SCIFastBandRenderableSeries()
        bandRenderableSeries.dataSeries = dataSeries
        bandRenderableSeries.style.isDigitalLine = true
        bandRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(colorCode: 0x33279B27)
        bandRenderableSeries.style.fillY1BrushStyle = SCISolidBrushStyle(colorCode: 0x33FF1919)
        bandRenderableSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        bandRenderableSeries.style.strokeY1Style = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1.0)
        
        xAxes.add(xAxis)
        yAxes.add(yAxis)
        renderableSeries.add(bandRenderableSeries)
        
        chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        
        invalidateElement()
    }
}
