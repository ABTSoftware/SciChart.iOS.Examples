//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
        xAxis.growBy = SCIDoubleRange(min:SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.2), max: SCIGeneric(0.2))
        
        let originalData = SCIXyDataSeries(xType: .float, yType: .float)
        let doubleSeries = DataManager.getSinewaveWithAmplitude(1.0, phase: 0.0, pointCount: 28, freq: 7)
        originalData.appendRangeX(doubleSeries!.xValues, y: doubleSeries!.yValues, count: doubleSeries!.size)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.width = 7;
        ellipsePointMarker.height = 7;
        ellipsePointMarker.strokeStyle = SCISolidPenStyle.init(colorCode: 0xFF006400, withThickness: 1.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle.init(colorCode: 0xFFFFFFFF)
        
        let splineRenderSeries = SplineLineRenderableSeries()
        splineRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4282B4, withThickness: 1.0)
        splineRenderSeries.dataSeries = originalData
        splineRenderSeries.pointMarker = ellipsePointMarker
        splineRenderSeries.upSampleFactor = 10

        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4282B4, withThickness: 1.0)
        lineRenderSeries.dataSeries = originalData
        lineRenderSeries.pointMarker = ellipsePointMarker
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = .relative;
        textAnnotation.x1 = SCIGeneric(0.5);
        textAnnotation.y1 = SCIGeneric(0.01);
        textAnnotation.horizontalAnchorPoint = .center;
        textAnnotation.verticalAnchorPoint = .top;
        textAnnotation.style.textStyle.fontSize = 24;
        textAnnotation.text = "Custom Spline Chart";
        textAnnotation.style.textColor = UIColor.white
        textAnnotation.style.backgroundColor = UIColor.clear

        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(splineRenderSeries)
            self.surface.renderableSeries.add(lineRenderSeries)
            self.surface.annotations.add(textAnnotation)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
            
            splineRenderSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            lineRenderSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
