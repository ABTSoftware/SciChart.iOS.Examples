//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// IndexDateAxisChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************


class IndexDateAxisChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let historicalData = SCIOhlcDataSeries(xType: .date, yType: .double)
        let priceSeries = SCDDataManager.getPriceDataIndex()
        let count = priceSeries.count
        let dateData = priceSeries.dateData
        let indexDataProvider = SCIDataSeriesIndexDataProvider(dataSeriesValues: historicalData)
        
        let xAxis = SCIIndexDateAxis()
        xAxis.setIndexDataProvider(indexDataProvider)
        xAxis.visibleRange = SCIDateRange(min: dateData.getValueAt(count - 30), max: dateData.getValueAt(count - 1))
        xAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.1)
        
        historicalData.append(x: dateData, open: priceSeries.openData, high: priceSeries.highData, low: priceSeries.lowData, close: priceSeries.closeData)
        
        let arrayOfDates = ["2023.01.03","2023.02.03","2023.03.02","2023.03.06","2023.03.13","2023.03.22"]
        let yData = [124.17,157.38,143.90,156.30,147.70,162.14]
        let formatter = DateFormatter()
        let xValues = SCIDateValues()
        let yValues = SCIDoubleValues()
        formatter.dateFormat = "yyyy.MM.dd"
        for i in 0..<arrayOfDates.count {
            yValues.add(yData[i])
            xValues.add(formatter.date(from: arrayOfDates[i]) ?? Date())
        }
        
        let lineDataSeries = SCIXyDataSeries(xType: .date, yType: .double)
        lineDataSeries.append(x: xValues, y: yValues)
        
        let movingAverageDataSeries = SCIXyDataSeries(xType: .date, yType: .double)
        movingAverageDataSeries.append(x: dateData, y: SCDDataManager.computeMovingAverage(of: priceSeries.lowData, length: 14))
        
        let historicalPrices = SCIFastCandlestickRenderableSeries()
        historicalPrices.strokeUpStyle = SCISolidPenStyle(color: 0xAA67BDAF, thickness: 1.0)
        historicalPrices.fillUpBrushStyle = SCISolidBrushStyle(color: 0xAA67BDAF)
        historicalPrices.strokeDownStyle = SCISolidPenStyle(color: 0xFFDC7969, thickness: 1.0)
        historicalPrices.fillDownBrushStyle = SCISolidBrushStyle(color: 0x77DC7969)
        historicalPrices.dataSeries = historicalData
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(color: 0xFFF48420, thickness: 3)
        
        let averageSeries = SCIFastLineRenderableSeries()
        averageSeries.dataSeries = movingAverageDataSeries
        averageSeries.strokeStyle = SCISolidPenStyle(color: 0xFFDC7969, thickness: 2)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: historicalPrices,lineSeries,averageSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            SCIAnimations.wave(historicalPrices, duration: 1.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(lineSeries, duration: 1.0, delay: 1.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(averageSeries, duration: 1.0, delay: 1.0, andEasingFunction: SCICubicEase())
        }
    }
}

