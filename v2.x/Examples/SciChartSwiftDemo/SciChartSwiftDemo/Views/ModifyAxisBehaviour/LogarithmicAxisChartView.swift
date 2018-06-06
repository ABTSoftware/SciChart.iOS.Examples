//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LogarithmicAxisChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LogarithmicAxisChartView: SingleChartLayout {

    override func initExample() {
        let xAxis = SCILogarithmicNumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.scientificNotation = .logarithmicBase
        xAxis.textFormatting = "#.#E+0"
        
        let yAxis = SCILogarithmicNumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxis.scientificNotation = .logarithmicBase
        yAxis.textFormatting = "#.#E+0"

        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Curve A"
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Curve B"
        let dataSeries3 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries3.seriesName = "Curve C"

        let doubleSeries1 = DataManager.getExponentialCurve(withExponent: 1.8, count: 100)
        let doubleSeries2 = DataManager.getExponentialCurve(withExponent: 2.25, count: 100)
        let doubleSeries3 = DataManager.getExponentialCurve(withExponent: 3.59, count: 100)
        
        dataSeries1.appendRangeX(doubleSeries1!.xValues, y: doubleSeries1!.yValues, count: doubleSeries1!.size)
        dataSeries2.appendRangeX(doubleSeries2!.xValues, y: doubleSeries2!.yValues, count: doubleSeries2!.size)
        dataSeries3.appendRangeX(doubleSeries3!.xValues, y: doubleSeries3!.yValues, count: doubleSeries3!.size)
        
        let line1Color: UInt32 = 0xFFFFFF00
        let line2Color: UInt32 = 0xFF279B27
        let line3Color: UInt32 = 0xFFFF1919
        
        let line1 = SCIFastLineRenderableSeries()
        line1.dataSeries = dataSeries1
        line1.strokeStyle = SCISolidPenStyle(colorCode: line1Color, withThickness: 1.5)
        line1.pointMarker = getPointMarker(size: 5, colorCode: line1Color)

        let line2 = SCIFastLineRenderableSeries()
        line2.dataSeries = dataSeries2
        line2.strokeStyle = SCISolidPenStyle(colorCode: line2Color, withThickness: 1.5)
        line2.style.pointMarker = getPointMarker(size: 5, colorCode: line2Color)
        
        let line3 = SCIFastLineRenderableSeries()
        line3.dataSeries = dataSeries3
        line3.strokeStyle = SCISolidPenStyle(colorCode: line3Color, withThickness: 1.5)
        line3.style.pointMarker = getPointMarker(size: 5, colorCode: line3Color)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(line1)
            self.surface.renderableSeries.add(line2)
            self.surface.renderableSeries.add(line3)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
            
            line1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line3.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }

    fileprivate func getPointMarker(size: Int, colorCode: UInt32) -> SCIEllipsePointMarker {
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.width = Float(size)
        pointMarker.height = Float(size)
        pointMarker.strokeStyle = nil
        pointMarker.fillStyle = SCISolidBrushStyle(colorCode: colorCode)
        
        return pointMarker
    }
}
