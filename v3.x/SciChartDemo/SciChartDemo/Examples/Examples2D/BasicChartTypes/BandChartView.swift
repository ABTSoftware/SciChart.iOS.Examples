//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
        xAxis.visibleRange = SCIDoubleRange(min: 1.1, max: 2.7)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let data = SCDDataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        let moreData = SCDDataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.005, pointCount: 1000, freq: 12)
        
        let dataSeries = SCIXyyDataSeries(xType: .double, yType: .double)
        dataSeries.append(x: data.xValues, y: data.yValues, y1: moreData.yValues)
        
        let rSeries = SCIFastBandRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: 0x33279B27)
        rSeries.fillY1BrushStyle = SCISolidBrushStyle(colorCode: 0x33FF1919)
        rSeries.strokeStyle =  SCISolidPenStyle(colorCode: 0xFF279B27, thickness: 1.0)
        rSeries.strokeY1Style = SCISolidPenStyle(colorCode: 0xFFFF1919, thickness: 1.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())
            
            SCIAnimations.scale(rSeries, duration: 3.0, andEasingFunction: SCIElasticEase())
        }
    }
}
