//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DashedLineChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DashedLineChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        var dataCount = 20
        let priceDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        for i in 0 ..< dataCount {
            let time = 10 * Double(i) / Double(dataCount)
            let y = Double(arc4random_uniform(20))
            
            priceDataSeries.append(x: time, y: y)
        }
        
        dataCount = 1000
        let fourierDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        for i in 0 ..< dataCount {
            let time = 10 * Double(i) / Double(dataCount)
            let y = 2 * sin(time) + 10
            
            fourierDataSeries.append(x: time, y: y)
        }
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: 0xFFd6ffd7)
        ellipsePointMarker.size = CGSize(width: 5, height: 5)
        
        let SCDPriceSeries = SCIFastLineRenderableSeries()
        SCDPriceSeries.pointMarker = ellipsePointMarker
        
        SCDPriceSeries.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0, strokeDashArray: [10.0, 3.0, 10.0, 3.0], antiAliasing: true)
        SCDPriceSeries.dataSeries = priceDataSeries
        
        let fourierSeries = SCIFastLineRenderableSeries()
        fourierSeries.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0, strokeDashArray: [50.0, 14.0, 50.0, 14.0, 50.0, 14.0, 50.0, 14.0], antiAliasing: true)
        fourierSeries.dataSeries = fourierDataSeries
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(SCDPriceSeries)
            self.surface.renderableSeries.add(fourierSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.sweep(SCDPriceSeries, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(fourierSeries, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
