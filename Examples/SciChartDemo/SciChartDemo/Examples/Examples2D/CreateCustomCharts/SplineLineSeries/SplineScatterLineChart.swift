//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineScatterLineChart.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SplineScatterLineChart: SingleChartLayout {

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min:0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.2, max: 0.2)
        
        let originalData = SCIXyDataSeries(xType: .double, yType: .double)
        let SCDDoubleSeries = SCDDataManager.getSinewaveWithAmplitude(1.0, phase: 0.0, pointCount: 28, freq: 7)
        originalData.append(x: SCDDoubleSeries.xValues, y: SCDDoubleSeries.yValues)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.size = CGSize(width: 7, height: 7)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle.init(colorCode: 0xFF006400, thickness: 1.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle.init(colorCode: 0xFFFFFFFF)
        
        let rSeries = SplineLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF006400, thickness: 2.0)
        rSeries.dataSeries = originalData
        rSeries.pointMarker = ellipsePointMarker
        rSeries.upSampleFactor = 10

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4282B4, thickness: 1.0)
        lineSeries.dataSeries = originalData
        lineSeries.pointMarker = ellipsePointMarker
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.set(x1: 0.5)
        textAnnotation.set(y1: 0.01)
        textAnnotation.coordinateMode = .relative
        textAnnotation.horizontalAnchorPoint = .center
        textAnnotation.verticalAnchorPoint = .top
        textAnnotation.text = "Custom Spline Chart"

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: rSeries, lineSeries)
            self.surface.annotations.add(textAnnotation)
            // RubberBand
            self.surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCIPinchZoomModifier())
            
            SCIAnimations.scale(rSeries, duration: 2.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(lineSeries, duration: 2.0, andEasingFunction: SCIElasticEase())
        }
    }
}
