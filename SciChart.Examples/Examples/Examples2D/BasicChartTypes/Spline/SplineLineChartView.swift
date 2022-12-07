//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineLineChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SplineLineChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        
        let dataSeries = SCIXyDataSeries(xType: .int, yType: .int)
        let yValues = [50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60]
        for i in 0 ..< yValues.count {
            dataSeries.append(x: i, y: yValues[i])
        }

        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(color: 0xFF50C7E0, thickness: 2.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: 0x33FFFFFF)
        ellipsePointMarker.size = CGSize(width: 11, height: 11)

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(color: 0xFFF48420, thickness: 2.0, strokeDashArray: nil, antiAliasing: true)
        
        let splineLineSeries = SCISplineLineRenderableSeries()
        splineLineSeries.dataSeries = dataSeries
        splineLineSeries.pointMarker = ellipsePointMarker
        splineLineSeries.strokeStyle = SCISolidPenStyle(color: 0xFF50C7E0, thickness: 3.0, strokeDashArray: nil, antiAliasing: true)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: lineSeries, splineLineSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())

            SCIAnimations.sweep(lineSeries, duration: 1.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(splineLineSeries, duration: 1.0, easingFunction: SCICubicEase())
        }
    }
}
