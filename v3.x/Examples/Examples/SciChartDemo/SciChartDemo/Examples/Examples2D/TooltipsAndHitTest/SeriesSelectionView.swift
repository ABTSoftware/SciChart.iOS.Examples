//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SeriesSelectionView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIStyleBase

class SelectedSeriesStyle: SCIStyleBase<ISCIRenderableSeries> {

    let Stroke = "Stroke"
    let selectedStrokeStyle = SCISolidPenStyle(color: .white, thickness: 4)
    let PointMarker = "PointMarker"
    let selectedPointMarker: ISCIPointMarker
    
    init() {
        selectedPointMarker = SCIEllipsePointMarker()
        selectedPointMarker.size = CGSize(width: 10, height: 10)
        selectedPointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFFF00DC)
        selectedPointMarker.strokeStyle = SCISolidPenStyle(color: .white, thickness: 1)
        
        super.init(styleableType: SCIRenderableSeriesBase.self)
    }
    
    override func applyStyleInternal(to styleableObject: ISCIRenderableSeries!) {
        putProperty(Stroke, value: styleableObject.strokeStyle, intoObject: styleableObject)
        putProperty(PointMarker, value: styleableObject.pointMarker, intoObject: styleableObject)
        
        styleableObject.strokeStyle = selectedStrokeStyle
        styleableObject.pointMarker = selectedPointMarker
    }
    
    override func discardStyleInternal(from styleableObject: ISCIRenderableSeries!) {
        let penStyle = getValueFromProperty(Stroke, ofType: SCISolidPenStyle.self, fromObject: styleableObject)
        let pointMarker = getValueFromProperty(PointMarker, ofType: ISCIPointMarker.self, fromObject: styleableObject)
        
        styleableObject.strokeStyle = penStyle as? SCIPenStyle
        styleableObject.pointMarker = pointMarker as? ISCIPointMarker
    }
}

class SeriesSelectionView: SingleChartLayout {
    
    let SeriesPointCount: Int32 = 50
    let SeriesCount = 80

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let leftAxis = SCINumericAxis()
        leftAxis.axisId = "yLeftAxis"
        leftAxis.axisAlignment = .left
        
        let rightAxis = SCINumericAxis()
        rightAxis.axisId = "yRightAxis"
        rightAxis.axisAlignment = .right
    
        let seriesSelectionModifier = SCISeriesSelectionModifier()
        seriesSelectionModifier.selectedSeriesStyle = SelectedSeriesStyle()
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(items: leftAxis, rightAxis)
            self.surface.chartModifiers.add(seriesSelectionModifier)
            
            var initialColor = UIColor.blue
            for i in 0..<self.SeriesCount {
                let axisAlignment: SCIAxisAlignment = i % 2 == 0 ? .left: .right;
                
                let rSeries = SCIFastLineRenderableSeries()
                rSeries.dataSeries = self.generateDataSeriesWith(axisAlignment, index: i)
                rSeries.yAxisId = axisAlignment == .left ? "yLeftAxis" : "yRightAxis"
                rSeries.strokeStyle = SCISolidPenStyle(color: initialColor, thickness: 1)
                
                self.surface.renderableSeries.add(rSeries)
                
                var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
                initialColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                let newR = red == 1.0 ? 1.0 : red + 0.0125;
                let newB = blue == 0.0 ? 0.0 : blue - 0.0125;
                initialColor = UIColor(red: newR, green: green, blue: newB, alpha: alpha)
                
                SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
            }
        }
    }

    fileprivate func generateDataSeriesWith(_ axisAlignment: SCIAxisAlignment, index: Int) -> SCIXyDataSeries {
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        dataSeries.seriesName = String(format: "Series %i", index)
        
        let gradient = Double(axisAlignment == .right ? index: -index);
        let start = axisAlignment == .right ? 0.0 : 14000;
        
        let straightLine = SCDDataManager.getStraightLines(withGradient: gradient, yIntercept: start, pointCount: SeriesPointCount)
        dataSeries.append(x: straightLine.xValues, y: straightLine.yValues)
        
        return dataSeries
    }
}
