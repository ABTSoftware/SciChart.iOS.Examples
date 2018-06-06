//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ImpulseChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ImpulseChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let ds1points = DataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.05, pointCount: 50, freq: 5)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.appendRangeX(ds1points!.xValues, y: ds1points!.yValues, count: ds1points!.size)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF0066FF)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let rSeries = SCIFastImpulseRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0066FF, withThickness: 1.0)
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = ellipsePointMarker
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
