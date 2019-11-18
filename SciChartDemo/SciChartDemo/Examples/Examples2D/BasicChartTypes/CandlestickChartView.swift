//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CandlestickChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class CandlestickChartView: SingleChartLayout {
    
    override func initExample() {
        let SCDPriceSeries = SCDDataManager.getPriceDataIndu()
        let size = Double(SCDPriceSeries.count)
        
        let xAxis = SCICategoryDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: size - 30, max: size)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        dataSeries.append(x: SCDPriceSeries.dateData, open: SCDPriceSeries.openData, high: SCDPriceSeries.highData, low: SCDPriceSeries.lowData, close: SCDPriceSeries.closeData)
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeUpStyle = SCISolidPenStyle(colorCode: 0xFF00AA00, thickness: 1.0)
        rSeries.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0x9000AA00)
        rSeries.strokeDownStyle = SCISolidPenStyle(colorCode: 0xFFFF0000, thickness: 1.0)
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0x90FF0000)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())
            
            SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
