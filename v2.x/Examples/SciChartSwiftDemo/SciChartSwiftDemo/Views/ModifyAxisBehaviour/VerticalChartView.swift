//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VerticalChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class VerticalChartView: SingleChartLayout {
   
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.axisAlignment = .left
        xAxis.axisTitle = "X-Axis"
        
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .top
        yAxis.axisTitle = "Y-Axis"
        
        let dataSeries0 = SCIXyDataSeries(xType: .double, yType: .double)
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let doubleSeries = DoubleSeries(capacity: 20)
        DataManager.setRandomDoubleSeries(doubleSeries, count: 20)
        dataSeries0.appendRangeX(doubleSeries!.xValues, y: doubleSeries!.yValues, count: doubleSeries!.size)
        
        doubleSeries?.clear()
        
        DataManager.setRandomDoubleSeries(doubleSeries, count: 20)
        dataSeries1.appendRangeX(doubleSeries!.xValues, y: doubleSeries!.yValues, count: doubleSeries!.size)
        
        let lineSeries0 = SCIFastLineRenderableSeries()
        lineSeries0.dataSeries = dataSeries0
        lineSeries0.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 1.0)
        
        let lineSeries1 = SCIFastLineRenderableSeries()
        lineSeries1.dataSeries = dataSeries1
        lineSeries1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF00FF00, withThickness: 1.0)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries0)
            self.surface.renderableSeries.add(lineSeries1)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
            
            lineSeries0.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            lineSeries1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
