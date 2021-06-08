//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsePaletteProviderView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AnnotationDragListener: ISCIAnnotationDragListener {
    func onDragStarted(_ annotation: ISCIAnnotation) {
        updateAnnotation(annotation: annotation)
    }
    func onDrag(_ annotation: ISCIAnnotation, byXDelta xDelta: CGFloat, yDelta: CGFloat) {
        updateAnnotation(annotation: annotation)
    }
    func onDragEnded(_ annotation: ISCIAnnotation) {
        updateAnnotation(annotation: annotation)
    }
    func updateAnnotation(annotation: ISCIAnnotation) {
        annotation.set(y1: 0)
        annotation.set(y2: 1)
    }
}

class UsePaletteProviderView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min: 150.0, max: 165.0)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        yAxis.autoRange = .always
        yAxis.labelProvider = SCDThousandsLabelProvider()
        
        let priceData = SCDDataManager.getPriceDataIndu()
        let offset = -1000.0
        
        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let columnDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        let scatterDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        mountainDataSeries.append(x: priceData.indexesAsDouble, y: priceData.lowData)
        lineDataSeries.append(x: priceData.indexesAsDouble, y: SCDDataManager.offset(priceData.closeData, offset: -offset))
        columnDataSeries.append(x: priceData.indexesAsDouble, y: SCDDataManager.offset(priceData.closeData, offset: offset * 3))
        ohlcDataSeries.append(x: priceData.indexesAsDouble, open:priceData.openData, high:priceData.highData, low:priceData.lowData, close:priceData.closeData)
        candlestickDataSeries.append(x: priceData.indexesAsDouble,
                                     open: SCDDataManager.offset(priceData.openData, offset: offset),
                                     high: SCDDataManager.offset(priceData.highData, offset: offset),
                                     low: SCDDataManager.offset(priceData.lowData, offset: offset),
                                     close: SCDDataManager.offset(priceData.closeData, offset: offset))
        scatterDataSeries.append(x: priceData.indexesAsDouble, y: SCDDataManager.offset(priceData.closeData, offset: offset * 2.5))

        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.set(x1: 152.0)
        boxAnnotation.set(y1: 1.0)
        boxAnnotation.set(x2: 158.0)
        boxAnnotation.set(y2: 0.0)
        boxAnnotation.coordinateMode = .relativeY
        boxAnnotation.isEditable = true
        boxAnnotation.fillBrush = SCILinearGradientBrushStyle(start: CGPoint(x: 0.5, y: 0.0), end: CGPoint(x: 0.5, y: 1.0), startColorCode: 0x550000FF, endColorCode: 0x55FFFF00)
        boxAnnotation.borderPen = SCISolidPenStyle(colorCode: 0xFF279B27, thickness: 1)
        boxAnnotation.annotationDragListener = AnnotationDragListener()
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = mountainDataSeries
        mountainSeries.areaStyle = SCISolidBrushStyle(colorCode: 0x9787CEEB)
        mountainSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF00FF, thickness: 1.0)
        mountainSeries.zeroLineY = 6000
        mountainSeries.paletteProvider = XyCustomPaletteProvider(color: SCIColor.red, annotation: boxAnnotation)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: SCIColor.red)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(color: SCIColor.orange, thickness: 2.0)
        ellipsePointMarker.size = CGSize(width: 10, height: 10)
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0000FF, thickness: 1.0)
        lineSeries.pointMarker = ellipsePointMarker
        lineSeries.paletteProvider = XyCustomPaletteProvider(color: SCIColor.red, annotation: boxAnnotation)
        
        let ohlcSeries = SCIFastOhlcRenderableSeries()
        ohlcSeries.dataSeries = ohlcDataSeries
        ohlcSeries.paletteProvider = OhlcCustomPaletteProvider(color: SCIColor.blue, annotation: boxAnnotation)
        
        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = candlestickDataSeries
        candlestickSeries.paletteProvider = OhlcCustomPaletteProvider(color: SCIColor.green, annotation: boxAnnotation)
        
        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = columnDataSeries
        columnSeries.strokeStyle = SCISolidPenStyle(color: SCIColor.blue, thickness: 1)
        columnSeries.zeroLineY = 6000
        columnSeries.fillBrushStyle = SCISolidBrushStyle(color: SCIColor.blue)
        columnSeries.paletteProvider = XyCustomPaletteProvider(color: SCIColor.purple, annotation: boxAnnotation)
        
        let squarePointMarker = SCISquarePointMarker()
        squarePointMarker.fillStyle = SCISolidBrushStyle(color: SCIColor.red)
        squarePointMarker.strokeStyle = SCISolidPenStyle(color: SCIColor.orange, thickness: 2.0)
        squarePointMarker.size = CGSize(width: 7, height: 7)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = scatterDataSeries
        scatterSeries.pointMarker = squarePointMarker
        scatterSeries.paletteProvider = XyCustomPaletteProvider(color: SCIColor.green, annotation: boxAnnotation)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: mountainSeries, lineSeries, ohlcSeries, candlestickSeries, columnSeries, scatterSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            self.surface.annotations.add(boxAnnotation)
            
            SCIAnimations.scale(mountainSeries, withZeroLine: 6000, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(lineSeries, withZeroLine: 12500, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(ohlcSeries, withZeroLine: 11750, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(candlestickSeries, withZeroLine: 10750, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(columnSeries, withZeroLine: 6000, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(scatterSeries, withZeroLine: 9000, duration: 3.0, andEasingFunction: SCIElasticEase())
        }
    }
}
