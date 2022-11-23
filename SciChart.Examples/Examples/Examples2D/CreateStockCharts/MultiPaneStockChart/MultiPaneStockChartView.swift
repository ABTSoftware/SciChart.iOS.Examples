//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MultiPaneStockChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

let VOLUME = "Volume";
let PRICES = "Prices";
let RSI = "RSI";
let MACD = "MACD";

// MARK: - Charts Initialization

class MultiPaneStockChartView: SCDMultiPaneStockChartViewController {
    let verticalGroup = SCIChartVerticalGroup()
    let sharedXRange = SCIDoubleRange()
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let SCDPriceSeries = SCDDataManager.getPriceDataEurUsd()

        let pricePaneModel = PricePaneModel(prices: SCDPriceSeries)
        let macdPaneModel = MacdPaneModel(prices: SCDPriceSeries)
        let rsiPaneModel = RsiPaneModel(prices: SCDPriceSeries)
        let volumePaneModel = VolumePaneModel(prices: SCDPriceSeries)

        initSurface(priceSurface, model: pricePaneModel, isMainPane: true)
        initSurface(macdSurface, model: macdPaneModel, isMainPane: false)
        initSurface(rsiSurface, model: rsiPaneModel, isMainPane: false)
        initSurface(volumeSurface, model: volumePaneModel, isMainPane: false)
    }

    fileprivate func initSurface(_ surface: SCIChartSurface, model: BasePaneModel, isMainPane: Bool) {
        let xAxis = SCICategoryDateAxis()
        xAxis.isVisible = isMainPane
        xAxis.visibleRange = sharedXRange
        xAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.05)

        let xAxisDragModifier = SCIXAxisDragModifier()
        xAxisDragModifier.dragMode = .pan
        xAxisDragModifier.clipModeX = .stretchAtExtents

        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.direction = .xDirection

        let legendModifier = SCILegendModifier()
        legendModifier.showCheckBoxes = false

        SCIUpdateSuspender.usingWith(surface) {
            surface.xAxes.add(xAxis)
            surface.yAxes.add(model.yAxis)
            surface.renderableSeries = model.renderableSeries
            surface.annotations = model.annotations
            surface.chartModifiers.add(items: xAxisDragModifier, pinchZoomModifier, SCIZoomPanModifier(), SCIZoomExtentsModifier(), legendModifier)
            
            self.verticalGroup.addSurface(toGroup: surface)
        }
    }
}

// MARK: - Base Chart Pane

class BasePaneModel {
    fileprivate let renderableSeries = SCIRenderableSeriesCollection()
    fileprivate let annotations = SCIAnnotationCollection()
    fileprivate let yAxis = SCINumericAxis()
    fileprivate let title: String

    init(title: String, yAxisTextFormatting: String?, isFirstPane: Bool) {
        self.title = title
        yAxis.axisId = title
        if (yAxisTextFormatting != nil) {
            yAxis.textFormatting = yAxisTextFormatting
        }
        yAxis.autoRange = .always
        yAxis.minorsPerMajor = isFirstPane ? 4 : 2
        yAxis.maxAutoTicks = isFirstPane ? 8 : 4

        let growBy = isFirstPane ? 0.05 : 0.0
        yAxis.growBy = SCIDoubleRange(min: growBy, max: growBy)
    }

    func addRenderableSeries(_ renderableSeries: SCIRenderableSeriesBase) {
        self.renderableSeries.add(renderableSeries)
    }

    func addAxisMarkerAnnotationWith(_ yAxisId: String, format: String, value: ISCIComparable, color: SCIColor?) {
        let axisMarkerAnnotation = SCIAxisMarkerAnnotation()
        axisMarkerAnnotation.yAxisId = yAxisId
        axisMarkerAnnotation.set(y1: value.toDouble())
        axisMarkerAnnotation.coordinateMode = .absolute
        
        if let uiColor = color {
            axisMarkerAnnotation.backgroundBrush = SCISolidBrushStyle(color: uiColor)
        }
        axisMarkerAnnotation.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
        axisMarkerAnnotation.formattedValue = String(format: format, value.toDouble())

        annotations.add(axisMarkerAnnotation)
    }
}

// MARK: - Price Pane

class PricePaneModel: BasePaneModel {
    init(prices: SCDPriceSeries) {
        super.init(title: PRICES, yAxisTextFormatting: "$0.0000", isFirstPane: true)

        // Add the main OHLC chart
        let stockPrices = SCIOhlcDataSeries(xType: .date, yType: .double)
        stockPrices.seriesName = "EUR/USD"
        stockPrices.append(x: prices.dateData, open: prices.openData, high: prices.highData, low: prices.lowData, close: prices.closeData)
        
        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = stockPrices
        candlestickSeries.yAxisId = PRICES
        addRenderableSeries(candlestickSeries)

        let maLow = SCIXyDataSeries(xType: .date, yType: .double)
        maLow.seriesName = "Low Line"
        maLow.append(x: prices.dateData, y: SCDMovingAverage.movingAverage(prices.closeData, period: 50))
        
        let lineSeriesLow = SCIFastLineRenderableSeries()
        lineSeriesLow.dataSeries = maLow
        lineSeriesLow.yAxisId = PRICES
        lineSeriesLow.strokeStyle = SCISolidPenStyle(color: 0xFFe97064, thickness: 1)
        addRenderableSeries(lineSeriesLow)

        let maHigh = SCIXyDataSeries(xType: .date, yType: .double)
        maHigh.seriesName = "High Line"
        maHigh.append(x: prices.dateData, y: SCDMovingAverage.movingAverage(prices.closeData, period: 200))
        
        let lineSeriesHigh = SCIFastLineRenderableSeries()
        lineSeriesHigh.dataSeries = maHigh
        lineSeriesHigh.yAxisId = PRICES
        lineSeriesHigh.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1)
        addRenderableSeries(lineSeriesHigh)

        addAxisMarkerAnnotationWith(PRICES, format: "$%.4f", value: stockPrices.yValues.value(at: stockPrices.count - 1), color: lineSeriesLow.strokeStyle.color)
        addAxisMarkerAnnotationWith(PRICES, format: "$%.4f", value: stockPrices.yValues.value(at: maLow.count - 1), color: lineSeriesLow.strokeStyle.color)
        addAxisMarkerAnnotationWith(PRICES, format: "$%.4f", value: stockPrices.yValues.value(at: maHigh.count - 1), color: lineSeriesHigh.strokeStyle.color)
    }
}

// MARK: - Volume Pane

class VolumePaneModel: BasePaneModel {
    init(prices: SCDPriceSeries) {
        super.init(title: VOLUME, yAxisTextFormatting: "###E+0", isFirstPane: false)

        let volumePrices = SCIXyDataSeries(xType: .date, yType: .long)
        volumePrices.seriesName = "Volume"
        volumePrices.append(x: prices.dateData, y: prices.volumeData)

        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = volumePrices
        columnSeries.yAxisId = VOLUME
        addRenderableSeries(columnSeries)

        addAxisMarkerAnnotationWith(VOLUME, format: "$%.g", value: volumePrices.yValues.value(at: volumePrices.count - 1), color: nil)
    }
}

// MARK: - RSI Pane

class RsiPaneModel: BasePaneModel {
    init(prices: SCDPriceSeries) {
        super.init(title: RSI, yAxisTextFormatting: "0.0", isFirstPane: false)

        let rsiDataSeries = SCIXyDataSeries(xType: .date, yType: .double)
        rsiDataSeries.seriesName = "RSI"
        rsiDataSeries.append(x: prices.dateData, y: SCDMovingAverage.rsi(prices, period: 14))

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = rsiDataSeries
        lineSeries.yAxisId = RSI
        lineSeries.strokeStyle = SCISolidPenStyle(color: 0xFFC6E6FF, thickness: 1)
        addRenderableSeries(lineSeries)

        addAxisMarkerAnnotationWith(RSI, format: "%.2f", value: rsiDataSeries.yValues.value(at: rsiDataSeries.count - 1), color: nil)
    }
}

// MARK: - MACD Pane

class MacdPaneModel: BasePaneModel {
    init(prices: SCDPriceSeries) {
        super.init(title: MACD, yAxisTextFormatting: "0.00", isFirstPane: false)

        let macdPoints = SCDMovingAverage.macd(prices.closeData, slow: 12, fast: 25, signal: 9)

        let histogramDataSeries = SCIXyDataSeries(xType: .date, yType: .double)
        histogramDataSeries.seriesName = "Histogram"
        histogramDataSeries.append(x: prices.dateData, y: macdPoints.divergenceValues)

        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = histogramDataSeries
        columnSeries.yAxisId = MACD
        addRenderableSeries(columnSeries)

        let macdDataSeries = SCIXyyDataSeries(xType: .date, yType: .double)
        macdDataSeries.seriesName = "MACD"
        macdDataSeries.append(x: prices.dateData, y: macdPoints.macdValues, y1: macdPoints.signalValues)

        let bandSeries = SCIFastBandRenderableSeries()
        bandSeries.dataSeries = macdDataSeries
        bandSeries.yAxisId = MACD
        addRenderableSeries(bandSeries)

        addAxisMarkerAnnotationWith(MACD, format: "%.2f", value: histogramDataSeries.yValues.value(at: histogramDataSeries.count - 1), color: nil)
        addAxisMarkerAnnotationWith(MACD, format: "%.2f", value: macdDataSeries.yValues.value(at: macdDataSeries.count - 1), color: nil)
    }
}
