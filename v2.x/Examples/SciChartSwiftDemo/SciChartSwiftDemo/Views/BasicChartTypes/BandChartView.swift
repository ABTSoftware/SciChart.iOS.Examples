//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BandChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class BandChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let data = DataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        let moreData = DataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.05, pointCount: 1000, freq: 12)
        
        let dataSeries = SCIXyyDataSeries(xType: .double, yType: .double)
        dataSeries.appendRangeX(data!.xValues, y1: data!.yValues, y2: moreData!.yValues, count: data!.size)
        
        let rSeries = SCIFastBandRenderableSeries()
        rSeries.dataSeries = dataSeries;
        rSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: 0x33279B27)
        rSeries.fillY1BrushStyle = SCISolidBrushStyle(colorCode: 0x33FF1919)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        rSeries.strokeY1Style = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1.0)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
