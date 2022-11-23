//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeTickingStockChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

let DefaultPointCount = 150
let SmaSeriesColor: uint = 0xFFe97064
let StrokeUpColor: uint = 0xFF68bcae
let StrokeDownColor: uint = 0xFFae418d

class RealtimeTickingStockChartView: SCDRealtimeTickingStockChartViewControllerBase {
    let _ohlcDataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
    let _xyDataSeries = SCIXyDataSeries(xType: .date, yType: .double)
    
    let _smaAxisMarker = SCIAxisMarkerAnnotation()
    let _ohlcAxisMarker = SCIAxisMarkerAnnotation()
    
    let _marketDataService = SCDMarketDataService(start: NSDate(year: 2000, month: 8, day: 01, hour: 12, minute: 0, second: 0) as Date, timeFrameMinutes: 5, tickTimerIntervals: 0.02)
    let _sma50 = SCDMovingAverage(length: 50)
    var _lastPrice: SCDPriceBar?
    
    override func initExample() {
        initDataWithService(_marketDataService)
        createMainPriceChart()
        
        let leftAreaAnnotation = SCIBoxAnnotation()
        let rightAreaAnnotation = SCIBoxAnnotation()
        createOverviewChartWith(leftAreaAnnotation, rightAreaAnnotation: rightAreaAnnotation)
        
        let axis = mainSurface.xAxes[0]
        axis.visibleRangeChangeListener = { [weak self] (axis, oldRange, newRange, isAnimating) in
            guard let self = self else { return }
            
            leftAreaAnnotation.set(x1: self.overviewSurface.xAxes[0].visibleRange.minAsDouble)
            leftAreaAnnotation.set(x2: self.mainSurface.xAxes[0].visibleRange.minAsDouble)
            rightAreaAnnotation.set(x1: self.mainSurface.xAxes[0].visibleRange.minAsDouble)
            rightAreaAnnotation.set(x2: self.overviewSurface.xAxes[0].visibleRange.minAsDouble)
        }
    }
    
    fileprivate func initDataWithService(_ SCDMarketDataService: SCDMarketDataService) {
        _ohlcDataSeries.seriesName = "Price Series"
        _xyDataSeries.seriesName = "50-Period SMA";

        let prices = SCDMarketDataService.getHistoricalData(DefaultPointCount)
        _lastPrice = prices.lastObject()
        
        _ohlcDataSeries.append(x: prices.dateData, open: prices.openData, high: prices.highData, low: prices.lowData, close: prices.closeData)
        _xyDataSeries.append(x: prices.dateData, y: getSmaCurrentValues(prices: prices))
        
        subscribePriceUpdate()
    }
    
    fileprivate func getSmaCurrentValues(prices: SCDPriceSeries) -> SCIDoubleValues {
        let count = Int(prices.count)
        let result = SCIDoubleValues(capacity: count)
        for i in 0 ..< count {
            let close = prices.closeData.getValueAt(i)
            result.add(_sma50.push(close).current())
        }
        
        return result;
    }

    fileprivate func createMainPriceChart() {
        let xAxis = SCICategoryDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.1)
        xAxis.drawMajorGridLines = false
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let ohlcSeries = SCIFastOhlcRenderableSeries()
        ohlcSeries.dataSeries = _ohlcDataSeries
        
        let ma50Series = SCIFastLineRenderableSeries()
        ma50Series.dataSeries = _xyDataSeries
        ma50Series.strokeStyle = SCISolidPenStyle(color: 0xFFe97064, thickness: 1)
        
        _smaAxisMarker.set(y1: 0)
        _smaAxisMarker.borderPen = SCISolidPenStyle(color: SmaSeriesColor, thickness: 1)
        _smaAxisMarker.backgroundBrush = SCISolidBrushStyle(color: SmaSeriesColor)
        
        _ohlcAxisMarker.set(y1: 0)
        _ohlcAxisMarker.borderPen = SCISolidPenStyle(color: StrokeUpColor, thickness: 1)
        _ohlcAxisMarker.backgroundBrush = SCISolidBrushStyle(color: StrokeUpColor)
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.direction = .xDirection
        
        let legendModifier = SCILegendModifier()
        legendModifier.orientation = .horizontal
        legendModifier.position = [.centerHorizontal, .bottom]
        legendModifier.margins = SCIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        SCIUpdateSuspender.usingWith(mainSurface) {
            self.mainSurface.xAxes.add(xAxis)
            self.mainSurface.yAxes.add(yAxis)
            self.mainSurface.renderableSeries.add(ma50Series)
            self.mainSurface.renderableSeries.add(ohlcSeries)
            self.mainSurface.annotations.add(items: self._smaAxisMarker, self._ohlcAxisMarker)
            self.mainSurface.chartModifiers.add(items: SCIXAxisDragModifier(), zoomPanModifier, SCIZoomExtentsModifier(), legendModifier)
        }
    }
    
    fileprivate func createOverviewChartWith(_ leftAreaAnnotation: SCIBoxAnnotation, rightAreaAnnotation: SCIBoxAnnotation) {
        let xAxis = SCICategoryDateAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = _ohlcDataSeries
        mountainSeries.areaStyle = SCILinearGradientBrushStyle(__start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1), startColorCode: 0x883a668f, endColorCode: 0xff20384f)
        
        leftAreaAnnotation.coordinateMode = .relativeY
        leftAreaAnnotation.set(y1: 0)
        leftAreaAnnotation.set(y2: 1)
        leftAreaAnnotation.fillBrush = SCISolidBrushStyle(color: 0x33FFFFFF)
        
        rightAreaAnnotation.coordinateMode = .relativeY
        rightAreaAnnotation.set(y1: 0)
        rightAreaAnnotation.set(y2: 1)
        rightAreaAnnotation.fillBrush = SCISolidBrushStyle(color: 0x33FFFFFF)
        
        SCIUpdateSuspender.usingWith(overviewSurface) {
            self.overviewSurface.xAxes.add(xAxis)
            self.overviewSurface.yAxes.add(yAxis)
            self.overviewSurface.renderableSeries.add(mountainSeries)
            self.overviewSurface.annotations.add(items: leftAreaAnnotation, rightAreaAnnotation)
        }
    }
    
    fileprivate func onNewPrice(_ price: SCDPriceBar) {
        let smaLastValue: Double
        if (_lastPrice!.date == price.date) {
            _ohlcDataSeries.update(open: price.open.doubleValue, high: price.high.doubleValue, low: price.low.doubleValue, close: price.close.doubleValue, at: _ohlcDataSeries.count - 1)
            
            smaLastValue = _sma50.update(price.close.doubleValue).current()
            _xyDataSeries.update(y: smaLastValue, at: _xyDataSeries.count - 1)
        } else {
            _ohlcDataSeries.append(x: price.date, open: price.open.doubleValue, high: price.high.doubleValue, low: price.low.doubleValue, close: price.close.doubleValue)

            smaLastValue = _sma50.push(price.close.doubleValue).current()
            _xyDataSeries.append(x: price.date, y: smaLastValue)
            
            let visibleRange = mainSurface.xAxes[0].visibleRange
            if (visibleRange.maxAsDouble > Double(_ohlcDataSeries.count)) {
                visibleRange.setDoubleMinTo(visibleRange.minAsDouble + 1, maxTo: visibleRange.maxAsDouble + 1)
            }
        }
        
        let color = price.close.compare(price.open) == .orderedDescending ? StrokeUpColor : StrokeDownColor
        _ohlcAxisMarker.backgroundBrush = SCISolidBrushStyle(color: color)
        _ohlcAxisMarker.set(y1: price.close.doubleValue)
        _smaAxisMarker.set(y1: smaLastValue)
        
        _lastPrice = price;
    }
    
    override func subscribePriceUpdate() {
        _marketDataService.subscribePriceUpdate({ [weak self] (price) in self?.onNewPrice(price) })
    }
    
    override func clearSubscribtions() {
        _marketDataService.clearSubscriptions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _marketDataService.clearSubscriptions()
    }
}
