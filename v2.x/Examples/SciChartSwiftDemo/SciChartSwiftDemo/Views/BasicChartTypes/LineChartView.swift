//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LineChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LineChartView: SingleChartLayout {
    
    override func initExample() {        
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let fourierSeries = DataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        dataSeries.appendRangeX(fourierSeries!.xValues, y: fourierSeries!.yValues, count: fourierSeries!.size)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        rSeries.dataSeries = dataSeries

        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
