//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class InteractionWithAnnotations: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCICategoryDateTimeAxis()
        let yAxis = SCINumericAxis()
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(30), max: SCIGeneric(37))
        
        let dataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .float)
        
        let marketDataService = MarketDataService(start: Date(), timeFrameMinutes: 5, tickTimerIntervals: 0.005)
        let data = marketDataService!.getHistoricalData(200)
        
        dataSeries.appendRangeX(SCIGeneric(data!.dateData()), open: SCIGeneric(data!.openData()), high: SCIGeneric(data!.highData()), low: SCIGeneric(data!.lowData()), close: SCIGeneric(data!.closeData()), count: data!.size())
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(rSeries)
        surface.chartModifiers.add(SCIZoomPanModifier())
        
        let textAnnotation1 = SCITextAnnotation()
        textAnnotation1.isEditable = true
        textAnnotation1.text = "Buy"
        textAnnotation1.x1 = SCIGeneric(10)
        textAnnotation1.y1 = SCIGeneric(30.5)
        textAnnotation1.verticalAnchorPoint = .bottom
        textAnnotation1.style.textStyle.fontSize = 20
        textAnnotation1.style.textColor = UIColor.white
        
        let textAnnotation2 = SCITextAnnotation()
        textAnnotation2.isEditable = true
        textAnnotation2.text = "Sell"
        textAnnotation2.x1 = SCIGeneric(50)
        textAnnotation2.y1 = SCIGeneric(34)
        textAnnotation2.verticalAnchorPoint = .bottom
        textAnnotation2.style.textStyle.fontSize = 20
        textAnnotation2.style.textColor = UIColor.white
        
        let rotatedTextAnnotation = SCITextAnnotation()
        rotatedTextAnnotation.isEditable = true
        rotatedTextAnnotation.text = "Rotated text"
        rotatedTextAnnotation.x1 = SCIGeneric(80)
        rotatedTextAnnotation.y1 = SCIGeneric(36)
        rotatedTextAnnotation.verticalAnchorPoint = .bottom
        rotatedTextAnnotation.style.textStyle.fontSize = 20
        rotatedTextAnnotation.style.textColor = UIColor.white
        rotatedTextAnnotation.style.viewSetup = {view in
            view!.isUserInteractionEnabled = true
            view!.layer.transform = CATransform3DMakeRotation (30 * .pi / 180, 0, 0, 1)
            view!.frame = CGRect(x: view!.frame.origin.x, y: view!.frame.origin.y, width: 50, height: 100)
        }
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.x1 = SCIGeneric(50)
        boxAnnotation.y1 = SCIGeneric(35.5)
        boxAnnotation.x2 = SCIGeneric(120)
        boxAnnotation.y2 = SCIGeneric(32)
        boxAnnotation.style.fillBrush = SCISolidBrushStyle(colorCode: 0x33FF6600)
        boxAnnotation.style.borderPen = SCISolidPenStyle(colorCode: 0x77FF6600, withThickness: 1.0)
        boxAnnotation.isEditable = true
        
        let lineAnnotation1 = SCILineAnnotation()
        lineAnnotation1.x1 = SCIGeneric(30)
        lineAnnotation1.y1 = SCIGeneric(30.5)
        lineAnnotation1.x2 = SCIGeneric(60)
        lineAnnotation1.y2 = SCIGeneric(35.5)
        lineAnnotation1.isEditable = true
        lineAnnotation1.style.linePen = SCISolidPenStyle(colorCode: 0xAAFF6600, withThickness: 2)
        
        let lineAnnotation2 = SCILineAnnotation()
        lineAnnotation2.x1 = SCIGeneric(120)
        lineAnnotation2.y1 = SCIGeneric(30.5)
        lineAnnotation2.x2 = SCIGeneric(175)
        lineAnnotation2.y2 = SCIGeneric(36)
        lineAnnotation2.isEditable = true
        lineAnnotation2.style.linePen = SCISolidPenStyle(colorCode: 0xAAFF6600, withThickness: 2)
        
        let axisMarker1 = SCIAxisMarkerAnnotation()
        axisMarker1.position = SCIGeneric(32.7)
        axisMarker1.isEditable = true
        axisMarker1.style.annotationSurface = .yAxis;
        
        let axisMarker2 = SCIAxisMarkerAnnotation()
        axisMarker2.position = SCIGeneric(100)
        axisMarker2.isEditable = true
        axisMarker2.formattedValue = "Horizontal"
        axisMarker2.style.annotationSurface = .xAxis
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.x1 = SCIGeneric(150)
        horizontalLine1.y1 = SCIGeneric(32.2)
        horizontalLine1.isEditable = true
        horizontalLine1.horizontalAlignment = .right
        horizontalLine1.style.linePen = SCISolidPenStyle(color: UIColor.red, withThickness: 2)
        horizontalLine1.add(createLabelWith(text: "", labelPlacement: .axis, color: UIColor.white, backColor: UIColor.red))
        
        let horizontalLine2 = SCIHorizontalLineAnnotation()
        horizontalLine2.x1 = SCIGeneric(130)
        horizontalLine2.x2 = SCIGeneric(160)
        horizontalLine2.y1 = SCIGeneric(33.9)
        horizontalLine2.isEditable = true
        horizontalLine2.horizontalAlignment = .center
        horizontalLine2.style.linePen = SCISolidPenStyle(color: UIColor.blue, withThickness: 2)
        horizontalLine2.add(createLabelWith(text: "Top", labelPlacement: .top, color: UIColor.blue, backColor: UIColor.clear))
        horizontalLine2.add(createLabelWith(text: "Left", labelPlacement: .left, color: UIColor.blue, backColor: UIColor.clear))
        horizontalLine2.add(createLabelWith(text: "Right", labelPlacement: .right, color: UIColor.blue, backColor: UIColor.clear))
        
        let verticalLine1 = SCIVerticalLineAnnotation()
        verticalLine1.x1 = SCIGeneric(20)
        verticalLine1.y1 = SCIGeneric(35)
        verticalLine1.y2 = SCIGeneric(33)
        verticalLine1.isEditable = true
        verticalLine1.verticalAlignment = .center
        verticalLine1.style.linePen = SCISolidPenStyle(colorCode: 0xFF006400, withThickness: 2)
        
        let verticalLine2 = SCIVerticalLineAnnotation()
        verticalLine2.x1 = SCIGeneric(40)
        verticalLine2.y1 = SCIGeneric(34)
        verticalLine2.isEditable = true
        verticalLine2.verticalAlignment = .top
        verticalLine2.style.linePen = SCISolidPenStyle(colorCode: 0xFF006400, withThickness: 2)
        verticalLine2.add(createLabelWith(text: "", labelPlacement: .top, color: UIColor.green, backColor: UIColor.clear))
        
        let textAnnotation3 = SCITextAnnotation()
        textAnnotation3.coordinateMode = .relative
        textAnnotation3.horizontalAnchorPoint = .center
        textAnnotation3.text = "EUR/USD"
        textAnnotation3.x1 = SCIGeneric(0.5)
        textAnnotation3.y1 = SCIGeneric(0.5)
        textAnnotation3.style.textStyle.fontSize = 72
        textAnnotation3.style.textColor = UIColor.fromARGBColorCode(0x77FFFFFF)
        
        surface.annotations = SCIAnnotationCollection(childAnnotations: [textAnnotation3, textAnnotation1, textAnnotation2, rotatedTextAnnotation, boxAnnotation, lineAnnotation1, lineAnnotation2, axisMarker1, axisMarker2, horizontalLine1, horizontalLine2, verticalLine1, verticalLine2])
        
        SCIThemeManager.applyDefaultTheme(toThemeable: rSeries)
    }
    
    fileprivate func createLabelWith(text: String, labelPlacement: SCILabelPlacement, color: UIColor, backColor: UIColor) -> SCILineAnnotationLabel {
        let lineAnnotationLabel = SCILineAnnotationLabel()
        lineAnnotationLabel.text = text
        lineAnnotationLabel.style.backgroundColor = backColor
        lineAnnotationLabel.style.labelPlacement = labelPlacement
        lineAnnotationLabel.style.textStyle.color = color
        
        return lineAnnotationLabel
    }
}
