//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BrushModifierAnnotationView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class BrushModifierAnnotationView: SCDBrushModifierChartViewController<SCIChartSurface>{
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let SCDPriceSeries = SCDDataManager.getPriceDataIndu()
        let size = Double(SCDPriceSeries.count)
        
        let xAxis = SCICategoryDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: size - 50, max: size)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        dataSeries.append(x: SCDPriceSeries.dateData, open: SCDPriceSeries.openData, high: SCDPriceSeries.highData, low: SCDPriceSeries.lowData, close: SCDPriceSeries.closeData)
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeUpStyle = SCISolidPenStyle(color: 0xFF67BDAF, thickness: 1.0)
        rSeries.fillUpBrushStyle = SCISolidBrushStyle(color: 0x7767BDAF)
        rSeries.strokeDownStyle = SCISolidPenStyle(color: 0xFFDC7969, thickness: 1.0)
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(color: 0x77DC7969)
        
        self.zoomPanModifier = SCIZoomPanModifier()
        self.zoomPanModifier.isEnabled = false
        
        let brush = SCIFreehandDrawingAnnotation()
        brush.appendPointWith(x: NSNumber(value: 224), y: NSNumber(value: 11000))
        brush.appendPointWith(x: NSNumber(value: 250), y: NSNumber(value: 12000))
        brush.appendPointWith(x: NSNumber(value: 220), y: NSNumber(value: 11400))
        brush.appendPointWith(x: NSNumber(value: 224), y: NSNumber(value: 11000))
        brush.stroke = SCISolidPenStyle(color: SCIColor.red, thickness: 3)
        brush.isEditable = true
        
        self.brushModifier = SCIFreehandDrawingModifier()
        self.brushModifier.receiveHandledEvents = true
        self.brushModifier.stroke = SCISolidPenStyle(color: strokeColor, thickness: self.thickness)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.annotations.add(brush)
            
            self.surface.chartModifiers.add(items:self.brushModifier, SCIPinchZoomModifier(), SCIZoomExtentsModifier(), self.zoomPanModifier)
        }

    }

}
