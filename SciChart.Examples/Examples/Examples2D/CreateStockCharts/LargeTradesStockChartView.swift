//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CreateLargeTradesStockChartFragment.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LargeTradesStockChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let historicalData = SCIOhlcDataSeries(xType: .date, yType: .double)
        let largeSellTradesData = SCIXyzDataSeries(xType: .date, yType: .double, zType: .double)
        let largeBuyTradesData = SCIXyzDataSeries(xType: .date, yType: .double, zType: .double)
        
        let largeTradeGenerator = SCDLargeTradeGenerator()
        
        let priceSeries = SCDDataManager.getPriceDataIndu()
        let largeSellTradesList = largeTradeGenerator.generateLargeTrades(for: priceSeries)
        let largeBuyTradesList = largeTradeGenerator.generateLargeTrades(for: priceSeries)
        
        let count = priceSeries.count
        let dateData = priceSeries.dateData
        
        historicalData.append(x: dateData, open: priceSeries.openData, high: priceSeries.highData, low: priceSeries.lowData, close: priceSeries.closeData)
        largeSellTradesData.appendLargeTrades(largeSellTradesList)
        largeBuyTradesData.appendLargeTrades(largeBuyTradesList)
        
        let indexDataProvider = SCIDataSeriesIndexDataProvider(dataSeriesValues: historicalData)
        let xAxis = SCIIndexDateAxis()
        xAxis.setIndexDataProvider(indexDataProvider)
        xAxis.visibleRange = SCIDateRange(min: dateData.getValueAt(count - 30), max: dateData.getValueAt(count - 1))
        xAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.1)
        
        let historicalPrices = SCIFastCandlestickRenderableSeries()
        historicalPrices.dataSeries = historicalData
        
        let largeBuyTrades = SCIFastBubbleRenderableSeries()
        largeBuyTrades.dataSeries = largeBuyTradesData
        largeBuyTrades.bubbleBrushStyle = SCISolidBrushStyle(color: 0x774248F5)
        largeBuyTrades.autoZRange = false
        largeBuyTrades.strokeStyle = SCISolidPenStyle.transparent
        
        let largeSellTrades = SCIFastBubbleRenderableSeries()
        largeSellTrades.dataSeries = largeSellTradesData
        largeSellTrades.bubbleBrushStyle = SCISolidBrushStyle(color: 0x77F542AA)
        largeSellTrades.autoZRange = false
        largeSellTrades.strokeStyle = SCISolidPenStyle.transparent
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: historicalPrices, largeBuyTrades, largeSellTrades)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.wave(historicalPrices, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(largeBuyTrades, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(largeSellTrades, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}

fileprivate extension ISCIXyzDataSeries {
    func appendLargeTrades(_ largeTradesList: [SCDLargeTradeBar]) {
        for largeTradeBar in largeTradesList {
            let date = largeTradeBar.date
            
            for largeTrade in largeTradeBar.largeTrades {
                append(x: date, y: largeTrade.price, z: largeTrade.volume)
            }
        }
    }
}
