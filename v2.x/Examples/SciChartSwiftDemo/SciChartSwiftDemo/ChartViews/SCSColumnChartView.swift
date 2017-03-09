//
//  SCSColumnChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart


class SCSColumnChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDataSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        
        let axisStyle = generateDefaultAxisStyle()
        
        chartSurface.xAxes.add(SCSFactoryAxis.createDefaultDateTimeAxis(withAxisStyle: axisStyle))
        
        chartSurface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
        
        addDefaultModifiers()
        
    }
    
    fileprivate func addDataSeries() {
        
        let brushColorsStart: [uint] = [0xFFa9d34f, 0xFFfc9930, 0xFFd63b3f]
        let brushColorsFinish: [uint] = [0xFF93b944, 0xFFd17f28, 0xFFbc3337]
        let penColors: [uint] = [0xFF232323, 0xFF232323, 0xFF232323]
        
        var i = 0
        while i < 3 {
            let brush = SCILinearGradientBrushStyle(colorCodeStart: brushColorsStart[i],
                                                            finish: brushColorsFinish[i],
                                                        direction: .vertical)
            let pen = SCISolidPenStyle(colorCode: penColors[i], withThickness: 0.4)
            chartSurface.renderableSeries.add(getColumnRenderableSeries(brush, pen: pen, order: Int(i)))
            i = i + 1
        }
        chartSurface.invalidateElement()
        
    }
    
    fileprivate func getColumnRenderableSeries(_ fillBrush: SCILinearGradientBrushStyle, pen: SCISolidPenStyle, order: Int) -> SCIFastColumnRenderableSeries {
        
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        
        
        SCSDataManager.loadData(into: dataSeries,
                                fileName: "ColumnData",
                                startIndex: order,
                                increment: 3,
                                reverse: false)
                
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        columnRenderableSeries.style.fillBrush = fillBrush
        columnRenderableSeries.style.borderPen = pen
        columnRenderableSeries.style.dataPointWidth = 0.3
        
        columnRenderableSeries.dataSeries = dataSeries
        
        return columnRenderableSeries
    }
    
    
    
}
