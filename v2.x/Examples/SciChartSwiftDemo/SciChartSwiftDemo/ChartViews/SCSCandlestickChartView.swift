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
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(colorCode: 0xFFff9c0f)
        let downBrush = SCISolidBrushStyle(colorCode: 0xFFffff66)
        let upWickPen = SCILinearGradientPenStyle(colorCodeStart: 0xFFf9af16, finish: 0xFFf9af16, direction: .vertical, thickness: 0.2)
        let downWickPen = SCILinearGradientPenStyle(colorCodeStart: 0xFFf9af16, finish: 0xFFf9af16, direction: .vertical, thickness: 0.7)
        
        chartSurface.renderableSeries.add(getCandleRenderSeries(false, upBodyBrush: upBrush, upWickPen: upWickPen, downBodyBrush: downBrush, downWickPen: downWickPen, count: 30))
        
        chartSurface.invalidateElement()
        
        
        
    }
    
    fileprivate func getCandleRenderSeries(_ isReverse: Bool,
                                       upBodyBrush: SCISolidBrushStyle,
                                       upWickPen: SCILinearGradientPenStyle,
                                       downBodyBrush: SCISolidBrushStyle,
                                       downWickPen: SCILinearGradientPenStyle,
                                       count: Int) -> SCIFastCandlestickRenderableSeries {
        
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        
        SCSDataManager.loadPriceData(into: ohlcDataSeries,
                                     fileName: "FinanceData",
                                     isReversed: isReverse,
                                     count: count)
        

        ohlcDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let candleRendereSeries = SCIFastCandlestickRenderableSeries()
        candleRendereSeries.dataSeries = ohlcDataSeries
        candleRendereSeries.style.drawBorders = true
        candleRendereSeries.style.fillUpBrushStyle = upBodyBrush
        candleRendereSeries.style.fillDownBrushStyle = downBodyBrush
        candleRendereSeries.style.strokeUpStyle = upWickPen
        candleRendereSeries.style.strokeDownStyle = downWickPen
        
        
        return candleRendereSeries
    }
    
}
