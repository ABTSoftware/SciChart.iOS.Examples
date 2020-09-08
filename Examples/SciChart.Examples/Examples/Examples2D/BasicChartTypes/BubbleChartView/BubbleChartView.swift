//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BubbleChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class BubbleChartView: SCDBubbleChartViewControllerBase {
    
    override func initExample() {
        let xAxis = SCIDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let dataSeries = SCIXyzDataSeries(xType: .date, yType: .double, zType: .double)
        let tradeTicks = SCDDataManager.getTradeTicks()
    
        for i in 0 ..< tradeTicks.count {
            let tradeData = tradeTicks[i]
            dataSeries.append(x: tradeData.tradeDate, y: tradeData.tradePrice.doubleValue, z: tradeData.tradeSize.doubleValue)
        }
        
        rSeries = SCIFastBubbleRenderableSeries();
        rSeries.bubbleBrushStyle = SCISolidBrushStyle(colorCode: 0x50CCCCCC)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFCCCCCC, thickness: 3.0)
        rSeries.autoZRange = false
        rSeries.dataSeries = dataSeries
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xffff3333, thickness: 2.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(self.rSeries)
            self.surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCIRubberBandXyZoomModifier())
            
            SCIAnimations.scale(self.rSeries, withZeroLine: 10600.0, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(lineSeries, withZeroLine: 10600.0, duration: 3.0, andEasingFunction: SCIElasticEase())
        }
    }
}
