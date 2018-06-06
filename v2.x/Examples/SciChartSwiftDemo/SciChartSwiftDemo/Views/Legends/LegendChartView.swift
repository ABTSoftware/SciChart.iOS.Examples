//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LegendChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LegendChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Curve A"
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Curve B"
        let dataSeries3 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries3.seriesName = "Curve C"
        let dataSeries4 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries4.seriesName = "Curve D"
        
        let doubleSeries1 = DataManager.getStraightLines(withGradient: 4000, yIntercept: 1.0, pointCount: 10)
        let doubleSeries2 = DataManager.getStraightLines(withGradient: 3000, yIntercept: 1.0, pointCount: 10)
        let doubleSeries3 = DataManager.getStraightLines(withGradient: 2000, yIntercept: 1.0, pointCount: 10)
        let doubleSeries4 = DataManager.getStraightLines(withGradient: 1000, yIntercept: 1.0, pointCount: 10)
        
        dataSeries1.appendRangeX(doubleSeries1!.xValues, y: doubleSeries1!.yValues, count: doubleSeries1!.size)
        dataSeries2.appendRangeX(doubleSeries2!.xValues, y: doubleSeries2!.yValues, count: doubleSeries2!.size)
        dataSeries3.appendRangeX(doubleSeries3!.xValues, y: doubleSeries3!.yValues, count: doubleSeries3!.size)
        dataSeries4.appendRangeX(doubleSeries4!.xValues, y: doubleSeries4!.yValues, count: doubleSeries4!.size)
        
        let line1 = SCIFastLineRenderableSeries()
        line1.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFFFF00, withThickness: 1)
        line1.dataSeries = dataSeries1
        let line2 = SCIFastLineRenderableSeries()
        line2.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1)
        line2.dataSeries = dataSeries2
        let line3 = SCIFastLineRenderableSeries()
        line3.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1)
        line3.dataSeries = dataSeries3
        let line4 = SCIFastLineRenderableSeries()
        line3.strokeStyle = SCISolidPenStyle(colorCode: 0xFF1964FF, withThickness: 1)
        line4.dataSeries = dataSeries4
        line4.isVisible = false
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(line1)
            self.surface.renderableSeries.add(line2)
            self.surface.renderableSeries.add(line3)
            self.surface.renderableSeries.add(line4)
            self.surface.chartModifiers.add(SCILegendModifier())
            
            line1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line3.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line4.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
