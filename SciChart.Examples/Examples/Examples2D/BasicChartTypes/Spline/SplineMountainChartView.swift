//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineMountainChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SplineMountainChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xBottomAxis = SCINumericAxis()
        xBottomAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: 0, max: 0.2)
        
        let dataSeries = SCIXyDataSeries(xType: .int, yType: .int)
        let yValues = [50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60]
        for i in 0 ..< yValues.count {
            dataSeries.append(x: i, y: yValues[i])
        }

        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: 0xFFFFFFFF)
        ellipsePointMarker.size = CGSize(width: 7, height: 7)
        
        let rSeries = SCISplineMountainRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = ellipsePointMarker
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xAAefcdb4, thickness: 1.0, strokeDashArray: nil, antiAliasing: true)
        rSeries.areaStyle = SCILinearGradientBrushStyle(startColor: 0xAAbf7436, endColor: 0x88090E11)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xBottomAxis)
            self.surface.yAxes.add(yRightAxis)
            self.surface.renderableSeries.add(items: rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())

            SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
