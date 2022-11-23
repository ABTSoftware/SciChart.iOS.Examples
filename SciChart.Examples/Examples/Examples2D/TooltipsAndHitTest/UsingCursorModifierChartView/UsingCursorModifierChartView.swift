//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingCursorModifierChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingCursorModifierChartView: SCDUsingCursorModifierChartViewControllerBase {
    
    let PointsCount = 500
    
    override func initExample() {
        let xAxis = SCINumericAxis();
        xAxis.visibleRange = SCIDoubleRange(min: 3, max: 6)
        
        let yAxis = SCINumericAxis();
        yAxis.growBy = SCIDoubleRange(min: 0.05, max: 0.05)
        yAxis.autoRange = .always
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        ds1.seriesName = "Green Series";
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        ds2.seriesName = "Red Series";
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        ds3.seriesName = "Gray Series";
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double)
        ds4.seriesName = "Gold Series";
        
        let data1 = SCDDataManager.getNoisySinewave(withAmplitude: 300, phase: 1.0, pointCount: PointsCount, noiseAmplitude: 0.25)
        let data2 = SCDDataManager.getSinewaveWithAmplitude(100, phase: 2.0, pointCount: PointsCount)
        let data3 = SCDDataManager.getSinewaveWithAmplitude(200, phase: 1.5, pointCount: PointsCount)
        let data4 = SCDDataManager.getSinewaveWithAmplitude(50, phase: 0.1, pointCount: PointsCount)
        
        ds1.append(x: data1.xValues, y: data1.yValues)
        ds2.append(x: data2.xValues, y: data2.yValues)
        ds3.append(x: data3.xValues, y: data3.yValues)
        ds4.append(x: data4.xValues, y: data4.yValues)
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 2)
        
        let rSeries2 = SCIFastLineRenderableSeries()
        rSeries2.dataSeries = ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFFc43360, thickness: 2)
        
        let rSeries3 = SCIFastLineRenderableSeries()
        rSeries3.dataSeries = ds3
        rSeries3.strokeStyle = SCISolidPenStyle(color: 0xFFd6dee8, thickness: 2)
        
        let rSeries4 = SCIFastLineRenderableSeries()
        rSeries4.dataSeries = ds4
        rSeries4.strokeStyle = SCISolidPenStyle(color: 0xFFe8c667, thickness: 2)
        rSeries4.isVisible = false
        
        cursorModifier = SCICursorModifier()
        cursorModifier.sourceMode = sourceMode
        cursorModifier.showTooltip = showTooltip
        cursorModifier.showAxisLabel = showAxisLabel

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: rSeries1, rSeries2, rSeries3, rSeries4)
            self.surface.chartModifiers.add(self.cursorModifier)
            
            SCIAnimations.sweep(rSeries1, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(rSeries2, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(rSeries3, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(rSeries4, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
