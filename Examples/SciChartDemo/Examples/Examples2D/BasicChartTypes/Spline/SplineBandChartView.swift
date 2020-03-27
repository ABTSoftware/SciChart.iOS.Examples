//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineBandChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SplineBandChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        
        let data = SCDDataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.005, pointCount: 1000, freq: 13)
        let moreData = SCDDataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.005, pointCount: 1000, freq: 12)
        
        let dataSeries = SCIXyyDataSeries(xType: .double, yType: .double)
        for i in 0 ..< 10 {
            let index = i * 100
            dataSeries.append(x: data.xValues.getValueAt(index), y: data.yValues.getValueAt(index), y1: moreData.yValues.getValueAt(index))
        }
        
        let rSeries = SCISplineBandRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = EllipsePointMarker(size: 7, strokeStyle: SCISolidPenStyle(colorCode: 0xFF006400, thickness: 1.0), fillStyle: SCISolidBrushStyle(colorCode: 0xFFFFFFFF))
        rSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: 0x33279B27)
        rSeries.fillY1BrushStyle = SCISolidBrushStyle(colorCode: 0x33FF1919)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF1919, thickness: 1.0, strokeDashArray: nil, antiAliasing: true)
        rSeries.strokeY1Style = SCISolidPenStyle(colorCode: 0xFF279B27, thickness: 1.0, strokeDashArray: nil, antiAliasing: true)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: rSeries)
            self.surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())

            SCIAnimations.scale(rSeries, duration: 3.0, andEasingFunction: SCIElasticEase())
        }
    }
}
