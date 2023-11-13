//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DateAxisChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DateAxisChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCIDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        xAxis.drawMajorTicks = true
        xAxis.drawMinorTicks = true
        xAxis.drawLabels = true
        xAxis.labelProvider = CustomDateAxisProvider()

        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let dataSeries = SCIXyzDataSeries(xType: .date, yType: .double, zType: .double)
        let tradeTicks = SCDDataManager.getTradeTicks()
        for i in 0 ..< tradeTicks.count {
            let tradeData = tradeTicks[i]
            dataSeries.append(x: tradeData.tradeDate, y: tradeData.tradePrice.doubleValue, z: tradeData.tradeSize.doubleValue)
        }
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFF50C7E0, thickness: 2.0)
        rSeries.dataSeries = dataSeries
        rSeries.isDigitalLine = true
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.sweep(rSeries, duration: 2.0, easingFunction: SCICubicEase())
        }
    }
    
}
