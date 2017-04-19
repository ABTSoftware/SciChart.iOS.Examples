//
//  SCSUsingCursorModifierChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart

let PointsCount:Int32 = 500

class SCSUsingCursorModifierChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        
        let xAxis = SCINumericAxis();
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        
        let yAxis = SCINumericAxis();
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.05), max: SCIGeneric(0.05))
        yAxis.autoRange = .always
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        ds1.seriesName = "Green Series";
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        ds2.seriesName = "Red Series";
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        ds3.seriesName = "Gray Series";
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        ds4.seriesName = "Gold Series";
        
        let data1 = SCSDataManager.getNoisySinewave(300, phase: 1.0, pointCount: PointsCount, noiseAmplitude: 0.25)
        let data2 = SCSDataManager.getSinewave(100, phase: 2.0, pointCount: PointsCount)
        let data3 = SCSDataManager.getSinewave(200, phase: 1.5, pointCount: PointsCount)
        let data4 = SCSDataManager.getSinewave(50, phase: 0.1, pointCount: PointsCount)
        
        ds1.appendRangeX(data1.xValues, y: data1.yValues, count: data1.size)
        ds2.appendRangeX(data2.xValues, y: data2.yValues, count: data2.size)
        ds3.appendRangeX(data3.xValues, y: data3.yValues, count: data3.size)
        ds4.appendRangeX(data4.xValues, y: data4.yValues, count: data4.size)
        
        let rs1 = SCIFastLineRenderableSeries()
        rs1.dataSeries = ds1
        rs1.style.linePen = SCISolidPenStyle(colorCode: 0xFF177B17, withThickness: 2)
        
        let rs2 = SCIFastLineRenderableSeries()
        rs2.dataSeries = ds2
        rs2.style.linePen = SCISolidPenStyle(colorCode: 0xFFDD0909, withThickness: 2)
        
        let rs3 = SCIFastLineRenderableSeries()
        rs3.dataSeries = ds3
        rs3.style.linePen = SCISolidPenStyle(colorCode: 0xFF808080, withThickness: 2)
        
        let rs4 = SCIFastLineRenderableSeries()
        rs4.dataSeries = ds4
        rs4.style.linePen = SCISolidPenStyle(colorCode: 0xFFFFD700, withThickness: 2)
        rs4.isVisible = false
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
        chartSurface.renderableSeries.add(rs1)
        chartSurface.renderableSeries.add(rs2)
        chartSurface.renderableSeries.add(rs3)
        chartSurface.renderableSeries.add(rs4)
        
        let cursorModifier = SCICursorModifier()
        cursorModifier.style.colorMode = .seriesColorToDataView
        chartSurface.chartModifier = cursorModifier
        
        chartSurface.invalidateElement()
    }
}
