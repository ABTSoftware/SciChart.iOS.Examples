//
//  TraderViewModel.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

enum TraderIndicators: Int, EnumCollection, CustomStringConvertible {
    case movingAverage50
    case movingAverage100
    case rsiPanel
    case macdPanel
    case axisMarkers
    
    var description: String {
        switch self {
        case .movingAverage50:
            return "Moving Average 50"
        case .movingAverage100:
            return "Moving Average 100"
        case .rsiPanel:
            return "RSI Panel"
        case .macdPanel:
            return "MACD Panel"
        case .axisMarkers:
            return "Axis Markers"
        }
    }
    
}


struct TraderViewModel {
    
    let stockType: StockIndex!
    let timeScale: TimeScale!
    let timePeriod: TimePeriod!
    let stockPrices: SCIOhlcDataSeries!
    let volume: SCIXyDataSeries!
    let averageLow: SCIXyDataSeries!
    let averageHigh: SCIXyDataSeries!
    let rsi: SCIXyDataSeries!
    let mcad: SCIXyyDataSeries!
    let histogram: SCIXyDataSeries!
    var traderIndicators: [TraderIndicators] = TraderIndicators.allValues
    
    init(_ stock: StockIndex,
         _ scale: TimeScale,
         _ period: TimePeriod,
         dataSeries: (ohlc: SCIOhlcDataSeries, volume: SCIXyDataSeries, averageLow: SCIXyDataSeries, averageHigh: SCIXyDataSeries, rsi: SCIXyDataSeries, mcad: SCIXyyDataSeries, histogram: SCIXyDataSeries)) {
        
        stockType = stock
        timeScale = scale
        timePeriod = period
        stockPrices = dataSeries.ohlc
        volume = dataSeries.volume
        averageHigh = dataSeries.averageHigh
        averageLow = dataSeries.averageLow
        rsi = dataSeries.rsi
        mcad = dataSeries.mcad
        histogram = dataSeries.histogram
        
        stockPrices.seriesName = "Candlestick"
        volume.seriesName = "Volume"
        averageLow.seriesName = "Low"
        averageHigh.seriesName = "High"
        rsi.seriesName = "RSI"
        histogram.seriesName = "Histogram"
        mcad.seriesName = "MCAD"
        
    }
    
}
