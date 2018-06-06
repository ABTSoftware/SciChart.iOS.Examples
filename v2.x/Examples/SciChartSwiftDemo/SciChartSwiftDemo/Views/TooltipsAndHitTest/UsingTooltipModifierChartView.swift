//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class UsingTooltipModifierChartView: SingleChartLayout {

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Lissajous Curve"
        dataSeries1.acceptUnsortedData = true
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Sinewave"
        
        let doubleSeries1 = DataManager.getLissajousCurve(withAlpha: 0.8, beta: 0.2, delta: 0.43, count: 500)
        let doubleSeries2 = DataManager.getSinewaveWithAmplitude(1.5, phase: 1.0, pointCount: 500)
        
        DataManager.scaleValues(doubleSeries1!.getXArray())
        dataSeries1.appendRangeX(doubleSeries1!.xValues, y: doubleSeries1!.yValues, count: doubleSeries1!.size)
        dataSeries2.appendRangeX(doubleSeries2!.xValues, y: doubleSeries2!.yValues, count: doubleSeries2!.size)
        
        let pointMarker1 = SCIEllipsePointMarker()
        pointMarker1.strokeStyle = nil
        pointMarker1.fillStyle = SCISolidBrushStyle(color: UIColor(red: 70.0 / 255.0, green: 130.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0))
        pointMarker1.height = 5
        pointMarker1.width = 5
        
        let line1 = SCIFastLineRenderableSeries()
        line1.dataSeries = dataSeries1
        line1.strokeStyle = SCISolidPenStyle(color: UIColor(red: 70.0 / 255.0, green: 130.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0), withThickness: 0.5)
        line1.pointMarker = pointMarker1
        
        let pointMarker2 = SCIEllipsePointMarker()
        pointMarker2.strokeStyle = nil
        pointMarker2.fillStyle = SCISolidBrushStyle(color: UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0))
        pointMarker2.height = 5
        pointMarker2.width = 5
        
        let line2 = SCIFastLineRenderableSeries()
        line2.dataSeries = dataSeries2
        line2.strokeStyle = SCISolidPenStyle(color: UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0), withThickness: 0.5)
        line2.pointMarker = pointMarker2
        
        let toolTipModifier = SCITooltipModifier()
        toolTipModifier.style.colorMode = .seriesColorToDataView
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(line1)
            self.surface.renderableSeries.add(line2)
            self.surface.chartModifiers.add(toolTipModifier)
            
            line1.addAnimation(SCIFadeRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line1.addAnimation(SCIFadeRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
