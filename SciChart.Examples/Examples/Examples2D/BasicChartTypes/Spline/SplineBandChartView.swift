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

class SplineBandChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
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
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: 0xFFFFFFFF)
        ellipsePointMarker.size = CGSize(width: 7, height: 7)
        
        let rSeries = SCISplineBandRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = ellipsePointMarker
        rSeries.fillBrushStyle = SCISolidBrushStyle(color: 0x3350C7E0)
        rSeries.fillY1BrushStyle = SCISolidBrushStyle(color: 0x33F48420)
        rSeries.strokeStyle =  SCISolidPenStyle(color: 0xFF50C7E0, thickness: 2.0)
        rSeries.strokeY1Style = SCISolidPenStyle(color: 0xFFF48420, thickness: 2.0)
        
        let easingFunction = SCIElasticEase()
        easingFunction.oscillations = 1
        easingFunction.springiness = 5        
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())

            SCIAnimations.scale(rSeries, duration: 1.0, andEasingFunction: easingFunction)
        }
    }
}
