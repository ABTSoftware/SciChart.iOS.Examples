//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// InteractionWithAnnotations.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class InteractionWithAnnotations: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let xAxis = SCICategoryDateAxis()
        let yAxis = SCINumericAxis()
        yAxis.visibleRange = SCIDoubleRange(min: 30, max: 37)
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        
        let marketDataService = SCDMarketDataService(start: Date(), timeFrameMinutes: 5, tickTimerIntervals: 0.005)
        let data = marketDataService.getHistoricalData(200)
        
        dataSeries.append(x: data.dateData, open: data.openData, high: data.highData, low: data.lowData, close: data.closeData)
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.opacity = 0.4
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(rSeries)
        surface.chartModifiers.add(SCIZoomPanModifier())
        
        let textAnnotation1 = SCITextAnnotation()
        textAnnotation1.set(x1: 10)
        textAnnotation1.set(y1: 30.5)
        textAnnotation1.isEditable = true
        textAnnotation1.verticalAnchorPoint = .bottom
        textAnnotation1.text = "Buy"
        textAnnotation1.fontStyle = SCIFontStyle(fontSize: 20, andTextColor: .white)
        
        let textAnnotation2 = SCITextAnnotation()
        textAnnotation2.set(x1: 50)
        textAnnotation2.set(y1: 34)
        textAnnotation2.isEditable = true
        textAnnotation2.text = "Sell"
        textAnnotation2.fontStyle = SCIFontStyle(fontSize: 20, andTextColor: .white)
        
        let rotatedTextAnnotation = SCITextAnnotation()
        rotatedTextAnnotation.set(x1: 80)
        rotatedTextAnnotation.set(y1: 36)
        rotatedTextAnnotation.isEditable = true
        rotatedTextAnnotation.rotationAngle = -30
        rotatedTextAnnotation.text = "Rotated text"
        rotatedTextAnnotation.fontStyle = SCIFontStyle(fontSize: 20, andTextColor: .white)
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.set(x1: 50)
        boxAnnotation.set(y1: 35.5)
        boxAnnotation.set(x2: 120)
        boxAnnotation.set(y2: 32)
        boxAnnotation.isEditable = true
        boxAnnotation.fillBrush = SCISolidBrushStyle(color: 0x33FF6600)
        boxAnnotation.borderPen = SCISolidPenStyle(color: 0x77FF6600, thickness: 1.0)
        
        let lineAnnotation1 = SCILineAnnotation()
        lineAnnotation1.set(x1: 30)
        lineAnnotation1.set(y1: 30.5)
        lineAnnotation1.set(x2: 60)
        lineAnnotation1.set(y2: 35.5)
        lineAnnotation1.isEditable = true
        lineAnnotation1.stroke = SCISolidPenStyle(color: 0xAAFF6600, thickness: 2)
        
        let lineAnnotation2 = SCILineAnnotation()
        lineAnnotation2.set(x1: 120)
        lineAnnotation2.set(y1: 30.5)
        lineAnnotation2.set(x2: 175)
        lineAnnotation2.set(y2: 36)
        lineAnnotation2.isEditable = true
        lineAnnotation2.stroke = SCISolidPenStyle(color: 0xAAFF6600, thickness: 2)
        
        let lineArrowAnnotation = SCILineArrowAnnotation()
        lineArrowAnnotation.set(x1: 120)
        lineArrowAnnotation.set(y1: 35)
        lineArrowAnnotation.set(x2: 80)
        lineArrowAnnotation.set(y2: 31.4)
        lineArrowAnnotation.headLength = 8
        lineArrowAnnotation.headWidth = 16
        lineArrowAnnotation.isEditable = true
        
        let axisMarker1 = SCIAxisMarkerAnnotation()
        axisMarker1.set(y1: 32.7)
        axisMarker1.isEditable = true
        
        let axisMarker2 = SCIAxisMarkerAnnotation()
        axisMarker2.set(x1: 100)
        axisMarker2.isEditable = true
        axisMarker2.formattedValue = "Horizontal"
        axisMarker2.annotationSurface = .xAxis
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.set(x1: 150)
        horizontalLine1.set(y1: 32.2)
        horizontalLine1.isEditable = true
        horizontalLine1.horizontalAlignment = .right
        horizontalLine1.stroke = SCISolidPenStyle(color: 0xFFc43360, thickness: 2)
        horizontalLine1.annotationLabels.add(createLabelWith(text: nil, labelPlacement: .axis))
        
        let horizontalLine2 = SCIHorizontalLineAnnotation()
        horizontalLine2.set(x1: 130)
        horizontalLine2.set(x2: 160)
        horizontalLine2.set(y1: 33.9)
        horizontalLine2.isEditable = true
        horizontalLine2.horizontalAlignment = .centerHorizontal
        horizontalLine2.stroke = SCISolidPenStyle(color: 0x55274b92, thickness: 2)
        horizontalLine2.annotationLabels.add(createLabelWith(text: "Top", labelPlacement: .top))
        horizontalLine2.annotationLabels.add(createLabelWith(text: "Left", labelPlacement: .left))
        horizontalLine2.annotationLabels.add(createLabelWith(text: "Right", labelPlacement: .right))
        
        let verticalLine1 = SCIVerticalLineAnnotation()
        verticalLine1.set(x1: 20)
        verticalLine1.set(y1: 35)
        verticalLine1.set(y2: 33)
        verticalLine1.isEditable = true
        verticalLine1.verticalAlignment = .centerVertical
        verticalLine1.stroke = SCISolidPenStyle(color: 0xFF68bcae, thickness: 2)
        
        let verticalLine2 = SCIVerticalLineAnnotation()
        verticalLine2.set(x1: 40)
        verticalLine2.set(y1: 34)
        verticalLine2.isEditable = true
        verticalLine2.verticalAlignment = .top
        verticalLine2.stroke = SCISolidPenStyle(color: 0xFF68bcae, thickness: 2)
        verticalLine2.annotationLabels.add(createLabelWith(text: nil, labelPlacement: .top))
        
        let textAnnotation3 = SCITextAnnotation()
        textAnnotation3.set(x1: 0.5)
        textAnnotation3.set(y1: 0.5)
        textAnnotation3.coordinateMode = .relative
        textAnnotation3.horizontalAnchorPoint = .center
        textAnnotation3.text = "EUR/USD"
        textAnnotation3.fontStyle = SCIFontStyle(fontSize: 72, andTextColorCode: 0x77FFFFFF)
        
        surface.annotations = SCIAnnotationCollection(collection: [textAnnotation3, textAnnotation1, textAnnotation2, rotatedTextAnnotation, boxAnnotation, lineAnnotation1, lineAnnotation2, lineArrowAnnotation, axisMarker1, axisMarker2, horizontalLine1, horizontalLine2, verticalLine1, verticalLine2])
    }
    
    fileprivate func createLabelWith(text: String?, labelPlacement: SCILabelPlacement) -> SCIAnnotationLabel {
        let annotationLabel = SCIAnnotationLabel()
        if (text != nil) {
            annotationLabel.text = text!
        }
        annotationLabel.labelPlacement = labelPlacement
        
        return annotationLabel
    }
}
