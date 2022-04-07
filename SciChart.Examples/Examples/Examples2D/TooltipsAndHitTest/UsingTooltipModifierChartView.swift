//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingTooltipModifierChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingTooltipModifierChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Lissajous Curve"
        dataSeries1.acceptsUnsortedData = true
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Sinewave"
        
        let SCDDoubleSeries1 = SCDDataManager.getLissajousCurve(withAlpha: 0.8, beta: 0.2, delta: 0.43, count: 500)
        let SCDDoubleSeries2 = SCDDataManager.getSinewaveWithAmplitude(1.5, phase: 1.0, pointCount: 500)
        
        let scaledValues = SCDDataManager.scale(SCDDataManager.offset(SCDDoubleSeries1.xValues, offset: 1), scale: 5)
        dataSeries1.append(x: scaledValues, y: SCDDoubleSeries1.yValues)
        dataSeries2.append(x: SCDDoubleSeries2.xValues, y: SCDDoubleSeries2.yValues)
        
        let pointMarker1 = SCIEllipsePointMarker()
        pointMarker1.strokeStyle = SCIPenStyle.transparent
        pointMarker1.fillStyle = SCISolidBrushStyle(color: 0xFF4682B4)
        pointMarker1.size = CGSize(width: 5, height: 5)
        
        let line1 = SCIFastLineRenderableSeries()
        line1.dataSeries = dataSeries1
        line1.strokeStyle = SCISolidPenStyle(color: 0xFF4682B4, thickness: 0.5)
        line1.pointMarker = pointMarker1
        
        let pointMarker2 = SCIEllipsePointMarker()
        pointMarker2.strokeStyle = SCIPenStyle.transparent
        pointMarker2.fillStyle = SCISolidBrushStyle(color: 0xFFFF3333)
        pointMarker2.size = CGSize(width: 5, height: 5)
        
        let line2 = SCIFastLineRenderableSeries()
        line2.dataSeries = dataSeries2
        line2.strokeStyle = SCISolidPenStyle(color: 0xFFFF3333, thickness: 0.5)
        line2.pointMarker = pointMarker2
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: line1, line2)
            self.surface.chartModifiers.add(SCITooltipModifier())
            
            SCIAnimations.fade(line1, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.fade(line2, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
