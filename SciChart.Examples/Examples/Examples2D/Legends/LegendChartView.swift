//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LegendChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIStyleBase

class CustomSeriesStyle: SCIStyleBase<ISCIRenderableSeries> {
    let Stroke = "Stroke"
    init() {
        super.init(styleableType: SCIRenderableSeriesBase.self)
    }
    override func applyStyleInternal(to styleableObject: ISCIRenderableSeries) {
        let currentPenStyle = styleableObject.strokeStyle
        putProperty(Stroke, value: currentPenStyle, intoObject: styleableObject)
        
        styleableObject.strokeStyle = SCISolidPenStyle(color: currentPenStyle.color, thickness: 4)
    }
    
    override func discardStyleInternal(from styleableObject: ISCIRenderableSeries) {
        if let penStyle = getValueFromProperty(Stroke, ofType: SCISolidPenStyle.self, fromObject: styleableObject) as? SCIPenStyle {
            styleableObject.strokeStyle = penStyle
        }
    }
}

class LegendChartView: SCDLegendChartViewControllerBase {

    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Curve A"
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Curve B"
        let dataSeries3 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries3.seriesName = "Curve C"
        let dataSeries4 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries4.seriesName = "Curve D"
        
        let SCDDoubleSeries1 = SCDDataManager.getStraightLines(withGradient: 4000, yIntercept: 1.0, pointCount: 10)
        let SCDDoubleSeries2 = SCDDataManager.getStraightLines(withGradient: 3000, yIntercept: 1.0, pointCount: 10)
        let SCDDoubleSeries3 = SCDDataManager.getStraightLines(withGradient: 2000, yIntercept: 1.0, pointCount: 10)
        let SCDDoubleSeries4 = SCDDataManager.getStraightLines(withGradient: 1000, yIntercept: 1.0, pointCount: 10)
        
        dataSeries1.append(x: SCDDoubleSeries1.xValues, y: SCDDoubleSeries1.yValues)
        dataSeries2.append(x: SCDDoubleSeries2.xValues, y: SCDDoubleSeries2.yValues)
        dataSeries3.append(x: SCDDoubleSeries3.xValues, y: SCDDoubleSeries3.yValues)
        dataSeries4.append(x: SCDDoubleSeries4.xValues, y: SCDDoubleSeries4.yValues)
        
        let line1 = SCIFastLineRenderableSeries()
        line1.strokeStyle = SCISolidPenStyle(color: 0xFFe8c667, thickness: 1)
        line1.dataSeries = dataSeries1
        let line2 = SCIFastLineRenderableSeries()
        line2.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1)
        line2.dataSeries = dataSeries2
        let line3 = SCIFastLineRenderableSeries()
        line3.strokeStyle = SCISolidPenStyle(color: 0xFFae418d, thickness: 1)
        line3.dataSeries = dataSeries3
        let line4 = SCIFastLineRenderableSeries()
        line3.strokeStyle = SCISolidPenStyle(color: 0xFF274b92, thickness: 1)
        line4.dataSeries = dataSeries4
        line4.isVisible = false
        
        legendModifier = SCILegendModifier()
        legendModifier.position = [.left, .top]
        legendModifier.margins = SCIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let seriesSelectionModifier = SCISeriesSelectionModifier()
        seriesSelectionModifier.selectedSeriesStyle = CustomSeriesStyle()
        
        legendModifier.orientation = orientation;
        legendModifier.showLegend = showLegend;
        legendModifier.showCheckBoxes = showCheckBoxes;
        legendModifier.showSeriesMarkers = showSeriesMarkers;
        legendModifier.sourceMode = sourceMode;
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(line1)
            self.surface.renderableSeries.add(line2)
            self.surface.renderableSeries.add(line3)
            self.surface.renderableSeries.add(line4)
            self.surface.chartModifiers.add(self.legendModifier)
            self.surface.chartModifiers.add(seriesSelectionModifier)
            
            SCIAnimations.sweep(line1, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(line2, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(line3, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(line4, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
