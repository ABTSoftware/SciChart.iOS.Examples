//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class UsePaletteProviderView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(150.0), max: SCIGeneric(165.0))
        let yAxis = SCINumericAxis()
        
        let priceData = DataManager.getPriceDataIndu()
        let size = priceData!.size()
        let offset = -1000.0
        
        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let columnDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        let scatterDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        mountainDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataArray(priceData!.lowData()), count: size)
        lineDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataArrayWithOffset(priceData!.closeData(), size: size, offset: -offset), count: size)
        columnDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataArrayWithOffset(priceData!.closeData(), size: size, offset: offset * 3), count: size)
        ohlcDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()),
                                    open: DataManager.getGenericDataArray(priceData!.openData()),
                                    high: DataManager.getGenericDataArray(priceData!.highData()),
                                    low: DataManager.getGenericDataArray(priceData!.lowData()),
                                    close: DataManager.getGenericDataArray(priceData!.closeData()),
                                    count: size)
        candlestickDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()),
                                           open: DataManager.getGenericDataArrayWithOffset(priceData!.openData(), size: size, offset: offset),
                                           high: DataManager.getGenericDataArrayWithOffset(priceData!.highData(), size: size, offset: offset),
                                           low: DataManager.getGenericDataArrayWithOffset(priceData!.lowData(), size: size, offset: offset),
                                           close: DataManager.getGenericDataArrayWithOffset(priceData!.closeData(), size: size, offset: offset),
                                           count: size)
        scatterDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataArrayWithOffset(priceData!.closeData(), size: size, offset: offset * 2.5), count: size)

        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = mountainDataSeries
        mountainSeries.areaStyle = SCISolidBrushStyle(colorCode: 0x9787CEEB)
        mountainSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF00FF, withThickness: 1.0)
        mountainSeries.zeroLineY = 6000
        mountainSeries.paletteProvider = CustomPaletteProvider()
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: UIColor.red)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(color: UIColor.orange, withThickness: 2.0)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0000FF, withThickness: 1.0)
        lineSeries.pointMarker = ellipsePointMarker
        lineSeries.paletteProvider = CustomPaletteProvider()
        
        let ohlcSeries = SCIFastOhlcRenderableSeries()
        ohlcSeries.dataSeries = ohlcDataSeries
        ohlcSeries.paletteProvider = CustomPaletteProvider()
        
        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = candlestickDataSeries
        candlestickSeries.paletteProvider = CustomPaletteProvider()
        
        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = columnDataSeries
        columnSeries.strokeStyle = nil
        columnSeries.zeroLineY = 6000
        columnSeries.style.dataPointWidth = 0.8
        columnSeries.fillBrushStyle = SCISolidBrushStyle(color: UIColor.blue)
        columnSeries.paletteProvider = CustomPaletteProvider()
        
        let squarePointMarker = SCISquarePointMarker()
        squarePointMarker.fillStyle = SCISolidBrushStyle(color: UIColor.red)
        squarePointMarker.strokeStyle = SCISolidPenStyle(color: UIColor.orange, withThickness: 2.0)
        squarePointMarker.height = 7
        squarePointMarker.width = 7
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = scatterDataSeries
        scatterSeries.pointMarker = squarePointMarker
        scatterSeries.paletteProvider = CustomPaletteProvider()
        
        let xDragModifier = SCIXAxisDragModifier()
        xDragModifier.clipModeX = .none
        
        let yDragModifier = SCIYAxisDragModifier()
        yDragModifier.dragMode = .pan
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.coordinateMode = .relativeY
        boxAnnotation.x1 = SCIGeneric(152)
        boxAnnotation.y1 = SCIGeneric(1.0)
        boxAnnotation.x2 = SCIGeneric(158)
        boxAnnotation.y2 = SCIGeneric(0.0)
        boxAnnotation.style.fillBrush = SCILinearGradientBrushStyle(colorCodeStart: 0x550000FF, finish: 0x55FFFF00, direction: .vertical)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(mountainSeries)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(ohlcSeries)
            self.surface.renderableSeries.add(candlestickSeries)
            self.surface.renderableSeries.add(columnSeries)
            self.surface.renderableSeries.add(scatterSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xDragModifier, yDragModifier, SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCITooltipModifier()])
            self.surface.annotations.add(boxAnnotation)
            
            mountainSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            lineSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            ohlcSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            candlestickSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            columnSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            scatterSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
        }
    }
}
