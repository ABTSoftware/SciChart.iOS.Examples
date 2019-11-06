//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DigitalLineChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DigitalLineChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: 1, max: 1.25)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.visibleRange = SCIDoubleRange(min: 2.3, max: 3.3)
        
        let fourierSeries = SCDDataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.append(x: fourierSeries.xValues, y: fourierSeries.yValues)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF99EE99, thickness: 1.0)
        rSeries.dataSeries = dataSeries
        rSeries.isDigitalLine = true
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(ExampleViewBase.createDefaultModifiers())
            
            SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
