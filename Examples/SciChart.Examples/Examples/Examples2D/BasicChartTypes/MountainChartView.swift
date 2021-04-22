//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MountainChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class MountainChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCIDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let priceData = SCDDataManager.getPriceDataIndu()
        let dataSeries = SCIXyDataSeries(xType: .date, yType: .double)
        dataSeries.append(x: priceData.dateData, y: priceData.closeData)
        
        let rSeries = SCIFastMountainRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.zeroLineY = 10000
        rSeries.areaStyle = SCILinearGradientBrushStyle(start: CGPoint(x: 0.5, y: 0.0), end: CGPoint(x: 0.5, y: 1.0), startColorCode: 0x88090E11, endColorCode: 0xAAFF8D42)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xAAFFC9A8, thickness: 1.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
