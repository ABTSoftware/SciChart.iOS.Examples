//
//  SCSColumnChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class ColumnsTripleColorPalette : SCIPaletteProvider {
    let style1 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    let style2 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    let style3 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    
    override init() {
        super.init()
        style1.fillBrush = SCILinearGradientBrushStyle(colorCodeStart: 0xFFa9d34f,
                                                       finish: 0xFF93b944,
                                                       direction: .vertical)
        style1.borderPen = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
        
        style2.fillBrush = SCILinearGradientBrushStyle(colorCodeStart: 0xFFfc9930,
                                                       finish: 0xFFd17f28,
                                                       direction: .vertical)
        style2.borderPen = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
        
        style3.fillBrush = SCILinearGradientBrushStyle(colorCodeStart: 0xFFd63b3f,
                                                       finish: 0xFFbc3337,
                                                       direction: .vertical)
        style3.borderPen = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        let styleIndex : Int32 = index % 3;
        if (styleIndex == 0) {
            return style1;
        } else if (styleIndex == 1) {
            return style2;
        } else {
            return style3;
        }
    }
}

class SCSColumnChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCIDateTimeAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        
        SCSDataManager.loadData(into: dataSeries,
                                fileName: "ColumnData",
                                startIndex: 0,
                                increment: 1,
                                reverse: false)
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.paletteProvider = ColumnsTripleColorPalette()
        columnRenderableSeries.dataSeries = dataSeries
        
        chartSurface.renderableSeries.add(columnRenderableSeries)
        
        chartSurface.invalidateElement()
        
    }
    
}
