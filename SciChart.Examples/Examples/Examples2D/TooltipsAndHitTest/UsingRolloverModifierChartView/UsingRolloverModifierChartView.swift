//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingRolloverModifierChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingRolloverModifierChartView: SCDUsingRolloverModifierChartViewControllerBase {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        
        let ds1 = SCIXyDataSeries(xType: .int, yType: .double)
        ds1.seriesName = "Sinewave A"
        let ds2 = SCIXyDataSeries(xType: .int, yType: .double)
        ds2.seriesName = "Sinewave B"
        let ds3 = SCIXyDataSeries(xType: .int, yType: .double)
        ds3.seriesName = "Sinewave C"

        let count = 100
        let k = 2 * .pi / 30.0
        for i in 0 ..< count {
            let phi = k * Double(i)
            ds1.append(x: i, y: (1.0 + Double(i) / Double(count)) * sin(phi))
            ds2.append(x: i, y: (0.5 + Double(i) / Double(count)) * sin(phi))
            ds3.append(x: i, y: Double(i) / Double(count) * sin(phi))
        }
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: 0xFFD7FFD6)
        ellipsePointMarker.size = CGSize(width: 7, height: 7)
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = ds1
        rSeries1.pointMarker = ellipsePointMarker
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFFA1B9D7, thickness: 1)

        let rSeries2 = SCIFastLineRenderableSeries()
        rSeries2.dataSeries = ds2
        rSeries2.pointMarker = ellipsePointMarker
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFF0B5400, thickness: 1)
        
        let rSeries3 = SCIFastLineRenderableSeries()
        rSeries3.dataSeries = ds3
        rSeries3.strokeStyle = SCISolidPenStyle(color: 0xFF386EA6, thickness: 1)
        
        rolloverModifier = SCIRolloverModifier()
        rolloverModifier.sourceMode = sourceMode
        rolloverModifier.showTooltip = showTooltip
        rolloverModifier.showAxisLabel = showAxisLabel
        rolloverModifier.drawVerticalLine = drawVerticalLine

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: rSeries1, rSeries2, rSeries3)
            self.surface.chartModifiers.add(self.rolloverModifier)
            
            SCIAnimations.sweep(rSeries1, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(rSeries2, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(rSeries3, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
