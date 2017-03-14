//
//  SCSCandlestickChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSCandlestickChartView: SCSBaseChartView {
    
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(colorCode: 0x9000AA00)
        let downBrush = SCISolidBrushStyle(colorCode: 0x90FF0000)
        let upWickPen = SCISolidPenStyle(colorCode: 0xFF00AA00, withThickness: 0.7)
        let downWickPen = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 0.7)
        
        chartSurface.renderableSeries.add(getCandleRenderSeries(false, upBodyBrush: upBrush, upWickPen: upWickPen, downBodyBrush: downBrush, downWickPen: downWickPen, count: 30))
        
        chartSurface.invalidateElement()
        
        
        
    }
    
    fileprivate func getCandleRenderSeries(_ isReverse: Bool,
                                       upBodyBrush: SCISolidBrushStyle,
                                       upWickPen: SCISolidPenStyle,
                                       downBodyBrush: SCISolidBrushStyle,
                                       downWickPen: SCISolidPenStyle,
                                       count: Int) -> SCIFastCandlestickRenderableSeries {
        
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        
        SCSDataManager.loadPriceData(into: ohlcDataSeries,
                                     fileName: "FinanceData",
                                     isReversed: isReverse,
                                     count: count)
        
        let candleRendereSeries = SCIFastCandlestickRenderableSeries()
        candleRendereSeries.dataSeries = ohlcDataSeries
        candleRendereSeries.style.drawBorders = false
        candleRendereSeries.style.fillUpBrushStyle = upBodyBrush
        candleRendereSeries.style.fillDownBrushStyle = downBodyBrush
        candleRendereSeries.style.strokeUpStyle = upWickPen
        candleRendereSeries.style.strokeDownStyle = downWickPen
        
        return candleRendereSeries
    }
    
}
