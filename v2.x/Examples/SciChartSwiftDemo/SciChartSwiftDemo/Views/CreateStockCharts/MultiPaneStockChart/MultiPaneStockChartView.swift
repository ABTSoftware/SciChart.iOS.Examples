//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class MultiPaneStockChartView: MultiPaneStockChartLayout {
    
    let _rangeSync = SCIAxisRangeSynchronization()
    let _axisAreaSizeSync = SCIAxisAreaSizeSynchronization()
    
    override func commonInit() {
        _axisAreaSizeSync.syncMode = .right
    }

    override func initExample() {
        let priceSeries = DataManager.getPriceDataEurUsd()!
        
        let pricePaneModel = PricePaneModel(prices: priceSeries)
        let macdPaneModel = MacdPaneModel(prices: priceSeries)
        let rsiPaneModel = RsiPaneModel(prices: priceSeries)
        let volumePaneModel = VolumePaneModel(prices: priceSeries)
        
        initSurface(priceSurface, model: pricePaneModel, isMainPane: true)
        initSurface(macdSurface, model: macdPaneModel, isMainPane: false)
        initSurface(rsiSurface, model: rsiPaneModel, isMainPane: false)
        initSurface(volumeSurface, model: volumePaneModel, isMainPane: false)
    }
    
    fileprivate func initSurface(_ surface: SCIChartSurface, model: BasePaneModel, isMainPane: Bool) {
        // used to syncronize width of yAxes areas
        _axisAreaSizeSync.attachSurface(surface)
        
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.isVisible = isMainPane ? true : false
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.0), max: SCIGeneric(0.05))
        
        // Used to synchronize axis ranges
        _rangeSync.attachAxis(xAxis)
        
        let xAxisDragModifier = SCIXAxisDragModifier()
        xAxisDragModifier.dragMode = .pan
        xAxisDragModifier.clipModeX = .stretchAtExtents
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.direction = .xDirection
        
        let legendModifier = SCILegendModifier()
        legendModifier.showCheckBoxes = false

        SCIUpdateSuspender.usingWithSuspendable(surface) {
            surface.xAxes.add(xAxis)
            surface.yAxes.add(model.yAxis)
            surface.renderableSeries = model.renderableSeries
            surface.annotations = model.annotations
            surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xAxisDragModifier, pinchZoomModifier, SCIZoomPanModifier(), SCIZoomExtentsModifier(), legendModifier])
            
            if (!isMainPane) {
                surface.topAxisAreaForcedSize = 0.5
                surface.bottomAxisAreaForcedSize = 0.5
                SCIThemeManager.applyDefaultTheme(toThemeable: surface)
            }
        }
    }
}

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
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(growBy), max: SCIGeneric(growBy))
    }
    
    func addRenderableSeries(_ renderableSeries: SCIRenderableSeriesBase) {
        self.renderableSeries.add(renderableSeries)
    }
    
    func addAxisMarkerAnnotationWith(_ yAxisId: String, format: String, value: SCIGenericType, color: UIColor?) {
        let textFormatting = SCITextFormattingStyle()
        textFormatting.color = UIColor.white
        textFormatting.fontSize = 12
        
        let axisMarkerAnnotation = SCIAxisMarkerAnnotation()
        axisMarkerAnnotation.yAxisId = yAxisId
        axisMarkerAnnotation.position = value
        axisMarkerAnnotation.coordinateMode = .absolute
        if (color != nil) {
            axisMarkerAnnotation.style.backgroundColor = color
        }
        axisMarkerAnnotation.style.margin = 5
        axisMarkerAnnotation.style.textStyle = textFormatting
        axisMarkerAnnotation.formattedValue = String(format: format, SCIGenericDouble(value))
        
        annotations.add(axisMarkerAnnotation)
    }
}

class PricePaneModel: BasePaneModel {
    
    init(prices: PriceSeries) {
        super.init(title: PRICES, yAxisTextFormatting: "$0.0000", isFirstPane: true)
        
        let size = prices.size()
        
        let stockPrices = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        stockPrices.seriesName = "EUR/USD"
        stockPrices.appendRangeX(DataManager.getGenericDataArray(prices.dateData()),
                                 open: DataManager.getGenericDataArray(prices.openData()),
                                 high: DataManager.getGenericDataArray(prices.highData()),
                                 low: DataManager.getGenericDataArray(prices.lowData()),
                                 close: DataManager.getGenericDataArray(prices.closeData()),
                                 count: size)
        
        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = stockPrices
        candlestickSeries.yAxisId = PRICES
        addRenderableSeries(candlestickSeries)
        SCIThemeManager.applyDefaultTheme(toThemeable: candlestickSeries)
        
        let movingAverageArray = [Double](repeating: 0, count: Int(size))
        let movingAveragePointer: UnsafeMutablePointer<Double> = UnsafeMutablePointer(mutating: movingAverageArray)
        let maLow = SCIXyDataSeries(xType: .dateTime, yType: .double)
        maLow.seriesName = "Low Line"
        maLow.appendRangeX(DataManager.getGenericDataArray(prices.dateData()), y: DataManager.getGenericDataArray(MovingAverage.movingAverage(prices.closeData(), output: movingAveragePointer, count: Int32(size), period: 50)), count: size)
        
        let lineSeriesLow = SCIFastLineRenderableSeries()
        lineSeriesLow.dataSeries = maLow
        lineSeriesLow.yAxisId = PRICES
        lineSeriesLow.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF3333, withThickness: 1)
        addRenderableSeries(lineSeriesLow)
        
        let maHigh = SCIXyDataSeries(xType: .dateTime, yType: .double)
        maHigh.seriesName = "High Line"
        maHigh.appendRangeX(DataManager.getGenericDataArray(prices.dateData()), y: DataManager.getGenericDataArray(MovingAverage.movingAverage(prices.closeData(), output: movingAveragePointer, count: Int32(size), period: 200)), count: size)
        
        let lineSeriesHigh = SCIFastLineRenderableSeries()
        lineSeriesHigh.dataSeries = maHigh
        lineSeriesHigh.yAxisId = PRICES
        lineSeriesHigh.strokeStyle = SCISolidPenStyle(colorCode: 0xFF33DD33, withThickness: 1)
        addRenderableSeries(lineSeriesHigh)
        
        addAxisMarkerAnnotationWith(PRICES, format: "$%.4f", value: stockPrices.yColumn.value(at: stockPrices.count() - 1), color: lineSeriesLow.strokeStyle.color)
        addAxisMarkerAnnotationWith(PRICES, format: "$%.4f", value: stockPrices.yColumn.value(at: maLow.count() - 1), color: lineSeriesLow.strokeStyle.color)
        addAxisMarkerAnnotationWith(PRICES, format: "$%.4f", value: stockPrices.yColumn.value(at: maHigh.count() - 1), color: lineSeriesHigh.strokeStyle.color)
    }
}

class VolumePaneModel: BasePaneModel {
    
    init(prices: PriceSeries) {
        super.init(title: VOLUME, yAxisTextFormatting: "###E+0", isFirstPane: false)
        
        let size = prices.size()
        
        let volumePrices = SCIXyDataSeries(xType: .dateTime, yType: .double)
        volumePrices.seriesName = "Volume"
        volumePrices.appendRangeX(DataManager.getGenericDataArray(prices.dateData()), y: DataManager.getGenericDataLongArray(prices.volumeData()), count: size)
        
        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = volumePrices
        columnSeries.yAxisId = VOLUME
        addRenderableSeries(columnSeries)
        
        addAxisMarkerAnnotationWith(VOLUME, format: "$%.g", value: volumePrices.yColumn.value(at: volumePrices.count() - 1), color: nil)
    }
}

class RsiPaneModel: BasePaneModel {
    
    init(prices: PriceSeries) {
        super.init(title: RSI, yAxisTextFormatting: "0.0", isFirstPane: false)
        
        let size = prices.size()
        
        let rsiArray = [Double](repeating: 0, count: Int(size))
        let rsiPointer: UnsafeMutablePointer<Double> = UnsafeMutablePointer(mutating: rsiArray)
        let rsiDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        rsiDataSeries.seriesName = "RSI"
        rsiDataSeries.appendRangeX(DataManager.getGenericDataArray(prices.dateData()), y: DataManager.getGenericDataArray(MovingAverage.rsi(prices, output: rsiPointer, count: size, period: 14)), count: size)
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = rsiDataSeries
        lineSeries.yAxisId = RSI
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1)
        addRenderableSeries(lineSeries)
        
        addAxisMarkerAnnotationWith(RSI, format: "%.2f", value: rsiDataSeries.yColumn.value(at: rsiDataSeries.count() - 1), color: nil)
    }
}

class MacdPaneModel: BasePaneModel {
    
    init(prices: PriceSeries) {
        super.init(title: MACD, yAxisTextFormatting: "0.00", isFirstPane: false)
        
        let size = Int(prices.size())
        let macdPoints = MovingAverage.macd(prices.closeData(), count: Int32(size), slow: 12, fast: 25, signal: 9)
        
        let histogramDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        histogramDataSeries.seriesName = "Histogram"
        histogramDataSeries.appendRangeX(DataManager.getGenericDataArray(prices.dateData()), y: macdPoints!.divergenceValues, count: prices.size())
        
        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = histogramDataSeries
        columnSeries.yAxisId = MACD
        addRenderableSeries(columnSeries)
        
        let macdDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        macdDataSeries.seriesName = "MACD"
        macdDataSeries.appendRangeX(DataManager.getGenericDataArray(prices.dateData()), y: macdPoints!.macdValues, count: prices.size())
        
        let bandSeries = SCIFastLineRenderableSeries()
        bandSeries.dataSeries = macdDataSeries
        bandSeries.yAxisId = MACD
        addRenderableSeries(bandSeries)
        
        addAxisMarkerAnnotationWith(MACD, format: "%.2f", value: histogramDataSeries.yColumn.value(at: histogramDataSeries.count() - 1), color: nil)
        addAxisMarkerAnnotationWith(MACD, format: "%.2f", value: macdDataSeries.yColumn.value(at: macdDataSeries.count() - 1), color: nil)
    }
}
