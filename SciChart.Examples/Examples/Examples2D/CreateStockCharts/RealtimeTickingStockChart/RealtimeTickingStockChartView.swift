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
    
    let mainXAxis = SCICategoryDateAxis()
    let mainYAxis = SCINumericAxis()
    let rangeSelectorAnnotation = SCIRangeSelectorAnnotation();
    
    var isDragging: Bool = false;
    
    override func initExample() {
        initDataWithService(_marketDataService)
        createMainPriceChart()
        createOverviewChart()
        
        mainXAxis.visibleRangeChangeListener = { [weak self] (axis, oldRange, newRange, isAnimating) in
            guard let self = self else { return }
            
            if (!isDragging) {
                rangeSelectorAnnotation.set(x1: axis.visibleRange.minAsDouble);
                rangeSelectorAnnotation.set(x2: axis.visibleRange.maxAsDouble);
            }
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
        mainXAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.1)
        mainXAxis.drawMajorGridLines = false
        
        mainYAxis.autoRange = .always
        
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
            self.mainSurface.xAxes.add(self.mainXAxis)
            self.mainSurface.yAxes.add(self.mainYAxis)
            self.mainSurface.renderableSeries.add(ma50Series)
            self.mainSurface.renderableSeries.add(ohlcSeries)
            self.mainSurface.annotations.add(items: self._smaAxisMarker, self._ohlcAxisMarker)
            self.mainSurface.chartModifiers.add(items: SCIXAxisDragModifier(), SCIZoomPanModifier(), SCIPinchZoomModifier(), SCIZoomExtentsModifier(), legendModifier)
        }
    }
    
    fileprivate func createOverviewChart() {
        let xAxis = SCICategoryDateAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = _ohlcDataSeries
        mountainSeries.areaStyle = SCILinearGradientBrushStyle(__start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1), startColorCode: 0x883a668f, endColorCode: 0xff20384f)
        
        self.configureRangeSelectorAnnotation()
        
        SCIUpdateSuspender.usingWith(overviewSurface) {
            self.overviewSurface.xAxes.add(xAxis)
            self.overviewSurface.yAxes.add(yAxis)
            self.overviewSurface.renderableSeries.add(mountainSeries)
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
    
    fileprivate func configureRangeSelectorAnnotation() {
        
        rangeSelectorAnnotation.set(y1: 0)
        rangeSelectorAnnotation.set(y2: 1)
        rangeSelectorAnnotation.set(x1: mainXAxis.visibleRange.minAsDouble)
        rangeSelectorAnnotation.set(x2: mainXAxis.visibleRange.maxAsDouble)
        rangeSelectorAnnotation.xAxisId = mainXAxis.axisId;
        rangeSelectorAnnotation.yAxisId = mainYAxis.axisId;
        
        rangeSelectorAnnotation.coordinateMode = .relativeY;
        rangeSelectorAnnotation.dragDirections = .xDirection;
        
        rangeSelectorAnnotation.fillBrush = SCISolidBrushStyle(color: 0x33FFFFFF)
        
        let dragListener = SCIOverviewAnnotationDragListener();
        dragListener.dragDelegate = self;
        rangeSelectorAnnotation.annotationDragListener = dragListener;
        
        self.overviewSurface.annotations.add(items: rangeSelectorAnnotation)
    }
    
    func changeVisibleRange(annotation: ISCIAnnotation, isFromOnDrag: Bool) {
        let x1: Double = annotation.getX1()
        let x2: Double = annotation.getX2()
        
    #if os(iOS)
        UIView.animate(withDuration: 2.0, delay: 0, options: [.overrideInheritedCurve], animations: {
            self.mainXAxis.visibleRange = SCIDoubleRange(min: x1, max: x2)
        }, completion: { finished in
            if !isFromOnDrag {
                self.isDragging = false
            }
            self.rangeSelectorAnnotation.isSelected = true
        })
    #elseif os(macOS)
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 2.0
        NSAnimationContext.current.completionHandler = {
            if !isFromOnDrag {
                self.isDragging = false
            }
            self.rangeSelectorAnnotation.isSelected = true
        }

        self.mainXAxis.visibleRange = SCIDoubleRange(min: x1, max: x2)
        NSAnimationContext.endGrouping()
    #endif
    }
}

extension RealtimeTickingStockChartView: SCIOverviewAnnotationDragDelegate {
    func onDragStarted(_ annotation: any ISCIAnnotation) {
        isDragging = true
    }
    
    func onDrag(_ annotation: any ISCIAnnotation, byXDelta xDelta: CGFloat, yDelta: CGFloat) {
        changeVisibleRange(annotation: annotation, isFromOnDrag: true)
    }
    
    func onDragEnded(_ annotation: any ISCIAnnotation) {
        changeVisibleRange(annotation: annotation, isFromOnDrag: false)
    }
}
