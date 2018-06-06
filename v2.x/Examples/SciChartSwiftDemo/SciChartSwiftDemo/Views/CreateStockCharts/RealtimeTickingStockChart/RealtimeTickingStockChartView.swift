//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

let DefaultPointCount: Int32 = 150
let SmaSeriesColor: uint = 0xFFFFA500
let StrokeUpColor: uint = 0xFF00AA00
let StrokeDownColor: uint = 0xFFFF0000

class RealtimeTickingStockChartView: RealtimeTickingStockChartLayout {
    
    var _smaSeriesColor: uint = 0
    var _strokeUpColor: uint = 0
    var _strokeDownColor: uint = 0
    
    let _ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
    let _xyDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
    
    let _smaAxisMarker = SCIAxisMarkerAnnotation()
    let _ohlcAxisMarker = SCIAxisMarkerAnnotation()
    
    let _marketDataService = MarketDataService(start: NSDate(year: 2000, month: 8, day: 01, hour: 12, minute: 0, second: 0) as Date?, timeFrameMinutes: 5, tickTimerIntervals: 0.02)
    let _sma50 = MovingAverage(length: 50)
    var _lastPrice: PriceBar?
    
    var onNewPriceBlock: PriceUpdateCallback?
    
    override func commonInit() {
        weak var wSelf = self
        onNewPriceBlock = { price in wSelf?.onNewPrice(price!) }
        self.continueTickingTouched = { wSelf?.subscribePriceUpdate() }
        self.pauseTickingTouched = { wSelf?.clearSubscribtions() }
        self.seriesTypeTouched = { wSelf?.changeSeriesType() }
    }

    override func initExample() {
        initDataWithService(_marketDataService!)
        
        createMainPriceChart()
        let leftAreaAnnotation = SCIBoxAnnotation()
        let rightAreaAnnotation = SCIBoxAnnotation()
        
        createOverviewChartWith(leftAreaAnnotation, rightAreaAnnotation: rightAreaAnnotation)
        
        let axis = mainSurface.xAxes[0] as! SCIAxisBase
        axis.registerVisibleRangeChangedCallback { (newRange, oldRange, isAnimated, sender) in
            leftAreaAnnotation.x1 = self.overviewSurface.xAxes[0].visibleRange.min
            leftAreaAnnotation.x2 = self.mainSurface.xAxes[0].visibleRange.min
            
            rightAreaAnnotation.x1 = self.mainSurface.xAxes[0].visibleRange.max
            rightAreaAnnotation.x2 = self.overviewSurface.xAxes[0].visibleRange.max
        }
        
        _marketDataService?.subscribePriceUpdate(onNewPriceBlock)
    }
    
    fileprivate func initDataWithService(_ marketDataService: MarketDataService) {
        _ohlcDataSeries.seriesName = "Price Series"
        _xyDataSeries.seriesName = "50-Period SMA";

        let prices = marketDataService.getHistoricalData(DefaultPointCount)
        let size = prices!.size()
        
        _lastPrice = (prices?.lastObject())!
        
        _ohlcDataSeries.appendRangeX(DataManager.getGenericDataArray(prices!.dateData()),
                                     open: DataManager.getGenericDataArray(prices!.openData()),
                                     high: DataManager.getGenericDataArray(prices!.highData()),
                                     low: DataManager.getGenericDataArray(prices!.lowData()),
                                     close: DataManager.getGenericDataArray(prices!.closeData()),
                                     count: size)
        var movingAverageArray = [Double](repeating: 0, count: Int(size))
        let movingAveragePointer: UnsafeMutablePointer<Double> = UnsafeMutablePointer(mutating: movingAverageArray)
        for i in 0..<size {
            movingAverageArray[Int(i)] = (_sma50?.push(prices!.item(at: i).close).current())!
        }
        _xyDataSeries.appendRangeX(DataManager.getGenericDataArray(prices!.dateData()), y: DataManager.getGenericDataArray(movingAveragePointer), count: size)
    }
    
    fileprivate func createMainPriceChart() {
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.0), max: SCIGeneric(0.1))
        xAxis.style.drawMajorGridLines = false
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let ohlcSeries = SCIFastOhlcRenderableSeries()
        ohlcSeries.dataSeries = _ohlcDataSeries
        
        let ma50Series = SCIFastLineRenderableSeries()
        ma50Series.dataSeries = _xyDataSeries
        ma50Series.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF6600, withThickness: 1)
        
        _smaAxisMarker.position = SCIGeneric(0)
        _smaAxisMarker.style.backgroundColor = UIColor.fromARGBColorCode(SmaSeriesColor)
        
        _ohlcAxisMarker.position = SCIGeneric(0)
        _ohlcAxisMarker.style.backgroundColor = UIColor.fromARGBColorCode(StrokeUpColor)
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.direction = .xDirection
        
        let legendModifier = SCILegendModifier()
        legendModifier.orientation = .horizontal
        legendModifier.position = .bottom
        
        SCIUpdateSuspender.usingWithSuspendable(mainSurface) {
            self.mainSurface.xAxes.add(xAxis)
            self.mainSurface.yAxes.add(yAxis)
            self.mainSurface.renderableSeries.add(ma50Series)
            self.mainSurface.renderableSeries.add(ohlcSeries)
            self.mainSurface.annotations.add(self._smaAxisMarker)
            self.mainSurface.annotations.add(self._ohlcAxisMarker)
            
            self.mainSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIXAxisDragModifier(), zoomPanModifier, SCIZoomExtentsModifier(), legendModifier])
            SCIThemeManager.applyDefaultTheme(toThemeable: self.mainSurface)
        }
    }
    
    fileprivate func createOverviewChartWith(_ leftAreaAnnotation: SCIBoxAnnotation, rightAreaAnnotation: SCIBoxAnnotation) {
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxis.autoRange = .always
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = _ohlcDataSeries
        mountainSeries.areaStyle = SCILinearGradientBrushStyle(colorCodeStart: 0x883a668f, finish: 0xff20384f, direction: .vertical)
        
        leftAreaAnnotation.coordinateMode = .relativeY
        leftAreaAnnotation.y1 = SCIGeneric(0)
        leftAreaAnnotation.y2 = SCIGeneric(1)
        leftAreaAnnotation.style.fillBrush = SCISolidBrushStyle(colorCode: 0x33FFFFFF)
        
        rightAreaAnnotation.coordinateMode = .relativeY
        rightAreaAnnotation.y1 = SCIGeneric(0)
        rightAreaAnnotation.y2 = SCIGeneric(1)
        rightAreaAnnotation.style.fillBrush = SCISolidBrushStyle(colorCode: 0x33FFFFFF)
        
        SCIUpdateSuspender.usingWithSuspendable(overviewSurface) {
            self.overviewSurface.xAxes.add(xAxis)
            self.overviewSurface.yAxes.add(yAxis)
            self.overviewSurface.renderableSeries.add(mountainSeries)
            self.overviewSurface.annotations.add(leftAreaAnnotation)
            self.overviewSurface.annotations.add(rightAreaAnnotation)
            
            SCIThemeManager.applyDefaultTheme(toThemeable: self.overviewSurface)
        }
    }
    
    fileprivate func onNewPrice(_ price: PriceBar) {
        let smaLastValue: Double
        if (_lastPrice!.date == price.date) {
            _ohlcDataSeries.update(at: _ohlcDataSeries.count() - 1, open: SCIGeneric(price.open), high: SCIGeneric(price.high), low: SCIGeneric(price.low), close: SCIGeneric(price.close))
            
            smaLastValue = (_sma50?.update(price.close)?.current())!
            _xyDataSeries.update(at: _xyDataSeries.count() - 1, y: SCIGeneric(smaLastValue))
        } else {
            _ohlcDataSeries.appendX(SCIGeneric(price.date), open: SCIGeneric(price.open), high: SCIGeneric(price.high), low: SCIGeneric(price.low), close: SCIGeneric(price.close))

            smaLastValue = (_sma50?.push(price.close)?.current())!
            _xyDataSeries.appendX(SCIGeneric(price.date), y: SCIGeneric(smaLastValue))
            
            let visibleRange = mainSurface.xAxes[0].visibleRange!
            if (visibleRange.maxAsDouble() > Double(_ohlcDataSeries.count())) {
                visibleRange.setMinTo(SCIGeneric(visibleRange.minAsDouble() + 1), maxTo: SCIGeneric(visibleRange.maxAsDouble() + 1))
            }
        }
        
        _ohlcAxisMarker.style.backgroundColor = price.close >= price.open ? UIColor.fromARGBColorCode(StrokeUpColor) : UIColor.fromARGBColorCode(StrokeDownColor)
        _ohlcAxisMarker.position = SCIGeneric(price.close);
        _smaAxisMarker.position = SCIGeneric(smaLastValue);
        
        _lastPrice = price;
    }
    
    fileprivate func subscribePriceUpdate() {
        _marketDataService?.subscribePriceUpdate(onNewPriceBlock)
    }
    
    fileprivate func clearSubscribtions() {
        _marketDataService?.clearSubscriptions()
    }
    
    fileprivate func changeSeriesType() {
        let alertController = UIAlertController(title: "Series type", message: "Select series type for the top scichart surface", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "CandlestickRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.changeSeries(SCIFastCandlestickRenderableSeries())
        }))
        alertController.addAction(UIAlertAction(title: "OhlcRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.changeSeries(SCIFastOhlcRenderableSeries())
        }))
        alertController.addAction(UIAlertAction(title: "MountainRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.changeSeries(SCIFastMountainRenderableSeries())
        }))
        
        var topVC = UIApplication.shared.delegate?.window??.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        topVC?.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func changeSeries(_ rSeries: SCIRenderableSeriesBase) {
        rSeries.dataSeries = _ohlcDataSeries
        
        SCIUpdateSuspender.usingWithSuspendable(mainSurface) {
            self.mainSurface.renderableSeries.remove(at: 1)
            self.mainSurface.renderableSeries.add(rSeries)
            SCIThemeManager.applyDefaultTheme(toThemeable: rSeries)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow);
        if newWindow == nil {
            _marketDataService?.clearSubscriptions()
        }
    }
}
