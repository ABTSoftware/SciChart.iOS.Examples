//
//  SCSRealtimeTickingStockChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 7/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSRealtimeTickingStockChartView: UIView {
    
    var sciChartView1 :SCIChartSurfaceView!
    var sciChartView2: SCIChartSurfaceView!
    var surface1: SCIChartSurface!
    var surface2: SCIChartSurface!
    
    var szpm: SCIMultiSurfaceModifier!
    var szem: SCIMultiSurfaceModifier!
    var spzm: SCIMultiSurfaceModifier!
    
    var ohlcDataSeries: SCIOhlcDataSeries!
    var avgDataSeries: SCIXyDataSeries!
    var mountainDataSeries: SCIXyDataSeries!
    
    var xAxis: SCIAxis2DProtocol!
    
    var renderableSeries: SCIRenderableSeriesBase!
    var avgRenderableSeries: SCIRenderableSeriesBase!
    var marketDataService: SCSMarketDataService!
    var msa: SCSMovingAverage!
    var lastPrice: SCSMultiPaneItem!
    var box: SCIBoxAnnotation!
    
    var timer: Timer?
    var counter:Int32 = 0
    var seriesCount:Int32 = 0
    var countUpdater:Int32 = 0
    
    var lastMarker: SCIAxisMarkerAnnotation!
    var lastUpColor: UIColor!
    var lastDownColor: UIColor!
    var averageMarker: SCIAxisMarkerAnnotation!
    var drawZoomRectangle = false
    
    var alertView: UIAlertController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    private func completeConfiguration() {
        weak var wSelf = self
        alertView = UIAlertController(title: "Series type", message: "Select series type for the top scichart surface", preferredStyle: .actionSheet)
        var action = UIAlertAction(title: "CandlestickRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf!.surface1.renderableSeries.remove(wSelf!.renderableSeries)
            wSelf!.updateToCandlestickRenderableSeries()
            wSelf!.updateRenderableSeriesType()
        })
        alertView.addAction(action)
        action = UIAlertAction(title: "OhlcRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf!.surface1.renderableSeries.remove(wSelf!.renderableSeries)
            wSelf!.updateToOhlcRenderableSeries()
            wSelf!.updateRenderableSeriesType()
        })
        alertView.addAction(action)
        action = UIAlertAction(title: "MountainRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf!.surface1.renderableSeries.remove(wSelf!.renderableSeries)
            wSelf!.updateToMountainRenderableSeries()
            wSelf!.updateRenderableSeriesType()
        })
        alertView.addAction(action)
        
        configureChartSurfaceViews()
        configureChartSurfaces()
        configureSeriesData()
        initializeTopSurfaceData()
        initializeBottomSurfaceData()
        continueTicking()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow);
        
        if newWindow == nil{
            if timer != nil{
                timer!.invalidate()
                timer = nil
            }
        }
        else{
            if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target: self,
                                                           selector: #selector(SCSRealtimeTickingStockChartView.updateData),
                                                           userInfo: nil,
                                                           repeats: true)}
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func configureSeriesData(){
        counter = 0
        seriesCount = 60
        countUpdater = seriesCount
        
        msa = SCSMovingAverage(length: 50)
        let initialDate = Date(timeIntervalSinceNow: 500)
        
        marketDataService = SCSMarketDataService(start: initialDate, timeFrameMinutes: 500, tickTimerIntervals: 0)
        let prices = marketDataService.getHistoricalData(Int(seriesCount))
        
        ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double, seriesType: .defaultType)
        ohlcDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        for i in 0..<prices.count {
            let item : SCSMultiPaneItem = prices[i]
            ohlcDataSeries.appendX(SCIGeneric(item.dateTime), open: SCIGeneric(item.open), high: SCIGeneric(item.high), low: SCIGeneric(item.low), close: SCIGeneric(item.close))
        }
        
        avgDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        avgDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        for i in 0..<prices.count {
            let item = prices[i]
            avgDataSeries.appendX(SCIGeneric(item.dateTime), y: SCIGeneric(msa.push((item.close)).current))
            lastPrice = item
        }
        
    }
    
    func configureChartSurfaces() {
        //  Initializing SciChart Modifiers
        szpm = SCIMultiSurfaceModifier(modifierType: SCIZoomPanModifier.self)
        szem = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
        spzm = SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self)
        
        //  Initializing top scichart surface
        surface1 = SCIChartSurface(view: sciChartView1)
        surface1.style.backgroundBrush = SCISolidBrushStyle(colorCode: 0xFF1c1c1e)
        surface1.style.seriesBackgroundBrush = SCISolidBrushStyle(colorCode: 0xFF1c1c1e)
        
        //  Initializing bottom scichart surface
        surface2 = SCIChartSurface(view: sciChartView2)
        surface2.style.backgroundBrush = SCISolidBrushStyle(colorCode: 0xFF1c1c1e)
        surface2.style.seriesBackgroundBrush = SCISolidBrushStyle(colorCode: 0xFF1c1c1e)
        
        //  Initializing box annotation
        box = SCIBoxAnnotation()
        box.xAxisId = "X2"
        box.yAxisId = "Y2"
        box.coordinateMode = .relativeY
        box.style.fillBrush = SCISolidBrushStyle(colorCode: 0x200070FF)
        surface2.annotation = box
    }
    
    func continueTicking(){
        if(timer == nil){
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target: self,
                                                           selector: #selector(SCSRealtimeTickingStockChartView.updateData),
                                                           userInfo: nil,
                                                           repeats: true)}
    }
    
    func pauseTicking(){
        if timer == nil{
            return
        }
        timer!.invalidate()
        timer = nil
    }
    
    func updateToOhlcRenderableSeries() {
        renderableSeries = SCIFastOhlcRenderableSeries()
        renderableSeries.xAxisId = "X1"
        renderableSeries.yAxisId = "Y1"
        renderableSeries.dataSeries = ohlcDataSeries
        (renderableSeries as! SCIFastOhlcRenderableSeries).style.upWickPen = SCISolidPenStyle(colorCode: 0xFFa64044, withThickness: 1.0)
        (renderableSeries as! SCIFastOhlcRenderableSeries).style.downWickPen = SCISolidPenStyle(colorCode: 0xFF3da13b, withThickness: 1.0)
    }
    
    func updateToCandlestickRenderableSeries() {
        renderableSeries = SCIFastCandlestickRenderableSeries()
        renderableSeries.xAxisId = "X1"
        renderableSeries.yAxisId = "Y1"
        renderableSeries.dataSeries = ohlcDataSeries
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.drawBorders = false
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.strokeUpStyle = SCISolidPenStyle(colorCode: 0xFFa64044, withThickness: 1.0)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.strokeDownStyle = SCISolidPenStyle(colorCode: 0xFF3da13b, withThickness: 1.0)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0xFFa64044)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0xFF3da13b)
    }
    
    func updateToMountainRenderableSeries() {
        renderableSeries = SCIFastMountainRenderableSeries()
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0x883a668f, finish: 0xff20384f, direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xffc6e6ff, withThickness: 0.5)
        (renderableSeries as! SCIFastMountainRenderableSeries).style.areaBrush = brush
        (renderableSeries as! SCIFastMountainRenderableSeries).style.borderPen = pen
        renderableSeries.xAxisId = "X1"
        renderableSeries.yAxisId = "Y1"
        renderableSeries.dataSeries = ohlcDataSeries
    }
    
    func changeSeriesType(_ sender: UIButton) {
        alertView.popoverPresentationController?.sourceRect = sender.bounds
        alertView.popoverPresentationController?.sourceView = sender
        let currentTopVC = currentTopViewController()
        currentTopVC.present(alertView, animated: true, completion: nil)
    }
    
    func currentTopViewController() -> UIViewController {
        var topVC = UIApplication.shared.delegate!.window!!.rootViewController!
        while topVC.isBeingPresented {
            topVC = topVC.presentedViewController!
        }
        return topVC
    }
    
    func updateRenderableSeriesType() {
        surface1.renderableSeries.remove(avgRenderableSeries)
        surface1.renderableSeries.add(renderableSeries)
        surface1.renderableSeries.add(avgRenderableSeries)
        surface1.invalidateElement()
    }
    
    
    // MARK: Private Functions
    
    func configureChartSurfaceViews() {
        
        //  Initializing top scichart view
        sciChartView1 = SCIChartSurfaceView()
        sciChartView1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView1)
        
        //  Initializing bottom scichart view
        sciChartView2 =  SCIChartSurfaceView()
        sciChartView2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView2)
        
        weak var wSelf = self
        let panel = (Bundle.main.loadNibNamed("SCSRealTimeTickingStocksControlPanel", owner: self, options: nil)!.first! as! SCSRealTimeTickingStocksControlPanelView)
        panel.translatesAutoresizingMaskIntoConstraints = false
        //Subscribing to the control view events
        panel.continueTickingTouched = {(sender: UIButton) -> Void in
            wSelf!.continueTicking()
        }
        panel.pauseTickingTouched = {(sender: UIButton) -> Void in
            wSelf!.pauseTicking()
        }
        panel.seriesTypeTouched = {(sender: UIButton) -> Void in
            wSelf!.changeSeriesType(sender)
        }
        self.addSubview(panel)
        
        sciChartView1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView1)
        
        sciChartView2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView2)
        
        let layoutDictionary: [String : UIView] = ["SciChart1" : sciChartView1, "SciChart2" : sciChartView2, "Panel" : panel]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart2]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[Panel]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[Panel(40)]-(0)-[SciChart1]-(5)-[SciChart2(100)]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
    }
    
    func getOhlcRenderableSeries(_ isRevered: Bool, upBodyBrush upBodyColor: SCISolidBrushStyle, downBodyBrush downBodyColor: SCISolidBrushStyle, count: Int) -> SCIFastCandlestickRenderableSeries {
        renderableSeries = SCIFastCandlestickRenderableSeries()
        renderableSeries.xAxisId = "X1"
        renderableSeries.yAxisId = "Y1"
        renderableSeries.dataSeries = ohlcDataSeries
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.strokeUpStyle = SCISolidPenStyle(colorCode: 0xFFa64044, withThickness: 0.7)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.strokeDownStyle = SCISolidPenStyle(colorCode: 0xFF3da13b, withThickness: 0.7)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0xFFa64044)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0xFF3da13b)
        return (renderableSeries as! SCIFastCandlestickRenderableSeries)
    }
    
    fileprivate func getMountainRenderSeries(withBrush brush:SCILinearGradientBrushStyle, and pen: SCISolidPenStyle) -> SCIFastMountainRenderableSeries {
        
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        for i in 0..<seriesCount {
            mountainDataSeries.appendX(SCIGeneric(i), y: ohlcDataSeries.highValues().value(at: i))
        }
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.style.areaBrush = brush
        mountainRenderSeries.style.borderPen = pen
        mountainRenderSeries.xAxisId = "X2"
        mountainRenderSeries.yAxisId = "Y2"
        mountainRenderSeries.dataSeries = mountainDataSeries
        
        return mountainRenderSeries
        
    }
    
    func getAverageLine() -> SCIFastLineRenderableSeries {
        avgRenderableSeries = SCIFastLineRenderableSeries()
        (avgRenderableSeries as! SCIFastLineRenderableSeries).style.linePen = SCISolidPenStyle(colorCode: 0xFFffa500, withThickness: 1.0)
        (avgRenderableSeries as! SCIFastLineRenderableSeries).xAxisId = "X1"
        (avgRenderableSeries as! SCIFastLineRenderableSeries).yAxisId = "Y1"
        (avgRenderableSeries as! SCIFastLineRenderableSeries).dataSeries = avgDataSeries
        return (avgRenderableSeries as! SCIFastLineRenderableSeries)
    }
    
    func getMountainRenderableSeries(_ areaBrush: SCIBrushStyle, borderPen: SCIPenStyle) -> SCIFastMountainRenderableSeries {
        mountainDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        for i in 0..<ohlcDataSeries.xValues().count() {
            mountainDataSeries.appendX(ohlcDataSeries.xValues().value(at: i), y: ohlcDataSeries.highValues().value(at: i))
        }
        
        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.style.areaBrush = areaBrush
        mountainRenderableSeries.style.borderPen = borderPen
        mountainRenderableSeries.xAxisId = "X2"
        mountainRenderableSeries.yAxisId = "Y2"
        mountainRenderableSeries.dataSeries = mountainDataSeries
        return mountainRenderableSeries
    }
    
    func drawBoxAnnotation() {
        box.isEnabled = false
        box.x1 = xAxis!.visibleRange.min
        box.x2 = xAxis!.visibleRange.max
        box.y1 = SCIGeneric(0)
        box.y2 = SCIGeneric(1)
    }
    
    func updateData(_ timer: Timer) {
        let price = marketDataService.getNextBar()
        
        if lastPrice != nil && lastPrice.dateTime == price.dateTime {
            // TODO: compare dates in proper way
            ohlcDataSeries.update(at: ohlcDataSeries.count() - 1, x: SCIGeneric(price.dateTime), open: SCIGeneric(price.open), high: SCIGeneric(price.high), low: SCIGeneric(price.low), close: SCIGeneric(price.close))
            msa.update((price.close))
            avgDataSeries.update(at: Int32(ohlcDataSeries.xValues().count()) - 1, x: SCIGeneric(price.dateTime), y: SCIGeneric(msa.current))
            mountainDataSeries.update(at: Int32(mountainDataSeries.xValues().count()) - 1, x: SCIGeneric(price.dateTime), y: SCIGeneric(price.high))
        }
        else{
            ohlcDataSeries.appendX(SCIGeneric(price.dateTime), open: SCIGeneric(price.open), high: SCIGeneric(price.high), low: SCIGeneric(price.low), close: SCIGeneric(price.close))
            avgDataSeries.appendX(SCIGeneric(price.dateTime), y: SCIGeneric(msa.push((price.close)).current))
            mountainDataSeries.appendX(SCIGeneric(price.dateTime), y: SCIGeneric(price.high))
            let visibleRangeMax: Double = SCIGenericDate(xAxis!.visibleRange.max).timeIntervalSince1970
            let lastItem: Double = SCIGenericDate(ohlcDataSeries.xValues().value(at: ohlcDataSeries.xValues().count() - 1)).timeIntervalSince1970
            if visibleRangeMax >= lastItem {
                let priorItem: Double = SCIGenericDate(ohlcDataSeries.xValues().value( at: ohlcDataSeries.xValues().count() - 2)).timeIntervalSince1970
                let visibleRangeMin: Double = SCIGenericDate(xAxis!.visibleRange.min).timeIntervalSince1970
                let leftItem: Double = SCIGenericDate(ohlcDataSeries.xValues().value(at: 0)).timeIntervalSince1970
                var min: Double
                if visibleRangeMin >= leftItem {
                    min = visibleRangeMin + (lastItem - priorItem)
                }
                else {
                    min = visibleRangeMin + (lastItem - priorItem)
                }
                xAxis!.visibleRange = SCIDateRange(min: SCIGeneric(min), max: SCIGeneric(lastItem + (visibleRangeMax - priorItem)))
            }
        }
        
        self.lastMarker.position = SCIGeneric(price.close)
        if price.close > price.open {
            self.lastMarker.style.backgroundColor = lastUpColor
        }
        else {
            self.lastMarker.style.backgroundColor = lastDownColor
        }
        self.averageMarker.position = SCIGeneric(msa.current)
        self.lastPrice = price
        surface1.invalidateElement()
        drawBoxAnnotation()
        surface2.invalidateElement()
        
        
    }
    
    func initializeTopSurfaceData() {
        let majorPen = SCISolidPenStyle(colorCode: 0xFF323539, withThickness: 0.5)
        let gridBandPen = SCISolidBrushStyle(colorCode: 0xE1202123)
        let minorPen = SCISolidPenStyle(colorCode: 0xFF232426, withThickness: 0.5)
        let textFormatting = SCITextFormattingStyle()
        textFormatting.fontSize = 16
        textFormatting.fontName = "Helvetica"
        textFormatting.colorCode = 0xFFb6b3af
        
        //Initializing axes and attaching them to the surface
        let axisStyle = SCIAxisStyle()
        axisStyle.majorTickBrush = majorPen
        axisStyle.gridBandBrush = gridBandPen
        axisStyle.majorGridLineBrush = majorPen
        axisStyle.minorTickBrush = minorPen
        axisStyle.minorGridLineBrush = minorPen
        axisStyle.labelStyle = textFormatting
        axisStyle.drawMinorGridLines = true
        axisStyle.drawMajorBands = true
        let axis = SCINumericAxis()
        axis.style = axisStyle
        axis.axisId = "Y1"
        axis.cursorTextFormatting = "%.02f"
        axis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        axis.autoRange = .always
        surface1.yAxes.add(axis)
        
        xAxis = SCIDateTimeAxis()
        xAxis.axisId = "X1"
        let priorItem: Double = (SCIGenericDate(ohlcDataSeries.xValues().value(at: ohlcDataSeries.xValues().count() - 2))).timeIntervalSince1970
        let lastItem: Double = SCIGenericDate(ohlcDataSeries.xValues().value(at: ohlcDataSeries.xValues().count() - 1)).timeIntervalSince1970
        xAxis.visibleRange = SCIDateRange(min: ohlcDataSeries.xValues().value(at: 0), max: SCIGeneric(lastItem + (lastItem - priorItem)))
        (xAxis as! SCIDateTimeAxis).textFormatting = "dd/MM/yyyy"
        xAxis.style = axisStyle
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.0), max: SCIGeneric(0.1))
        surface1.xAxes.add(xAxis)
        
        //Creating SciChart modifiers
        let x1Pinch = SCIAxisPinchZoomModifier()
        x1Pinch.axisId = "X1"
        x1Pinch.modifierName = "X1 Axis Pinch Modifier"
        let x1Drag = SCIXAxisDragModifier()
        x1Drag.axisId = "X1"
        x1Drag.dragMode = .scale
        x1Drag.clipModeX = .none
        x1Drag.modifierName = "X1 Axis Drag Modifier"
        let y1Pinch = SCIAxisPinchZoomModifier()
        y1Pinch.axisId = "Y1"
        y1Pinch.modifierName = "Y1 Axis Pinch Modifier"
        let y1Drag = SCIYAxisDragModifier()
        y1Drag.axisId = "Y1"
        y1Drag.dragMode = .pan
        y1Drag.modifierName = "Y1 Axis Drag Modifier"
        let pzm = SCIPinchZoomModifier()
        pzm.modifierName = "PinchZoom Modifier"
        let zem = SCIZoomExtentsModifier()
        zem.modifierName = "ZoomExtents Modifier"
        let zpm = SCIZoomPanModifier()
        zpm.modifierName = "PanZoom Modifier"
        
        //Initializing modifiers group and attaching it to the scichart surface
        let zommPanModifier = szpm.modifier(forSurface: surface1)
        (zommPanModifier as! SCIZoomPanModifier).xyDirection = .xDirection
        let gm = SCIModifierGroup(childModifiers: [x1Pinch, y1Pinch, x1Drag, y1Drag, spzm, szem, szpm])
        self.surface1.chartModifier = gm
        
        surface1.renderableSeries.add(getOhlcRenderableSeries(false, upBodyBrush: SCISolidBrushStyle(colorCode: 0xFFff9c0f), downBodyBrush: SCISolidBrushStyle(colorCode: 0xFFffff66), count: Int(seriesCount)))
        surface1.renderableSeries.add(getAverageLine())
        
        self.lastUpColor = UIColor.fromABGRColorCode(0xFFa64044)
        self.lastDownColor = UIColor.fromABGRColorCode(0xFF3da13b)
        self.lastMarker = SCIAxisMarkerAnnotation()
        self.lastMarker.yAxisId = "Y1"
        self.lastMarker.coordinateMode = .absolute
        self.lastMarker.style.backgroundColor = lastUpColor
        
        self.averageMarker = SCIAxisMarkerAnnotation()
        self.averageMarker.yAxisId = "Y1"
        self.averageMarker.coordinateMode = .absolute
        self.averageMarker.style.backgroundColor = UIColor.fromABGRColorCode(0xFFffa500)
        self.surface1.annotation = SCIAnnotationCollection(childAnnotations: [averageMarker, lastMarker])
        surface1.invalidateElement()
    }
    
    func initializeBottomSurfaceData() {
        //Creating axes and attaching them to the scichart surface
        var axis = SCIDateTimeAxis()
        axis.axisId = "Y2"
        axis.style.drawMajorGridLines = false
        axis.isVisible = false
        axis.autoRange = .always
        axis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface2.yAxes.add(axis)
        axis = SCIDateTimeAxis()
        axis.axisId = "X2"
        axis.autoRange = .always
        axis.textFormatting = "dd/MM/yyyy"
        axis.style.drawMajorGridLines = false
        axis.isVisible = false
        axis.growBy = SCIDoubleRange(min: SCIGeneric(0.0), max: SCIGeneric(0.1))
        surface2.xAxes.add(axis)
        
        //Creating modifiers and attaching them to the scichart surface
        let x2Pinch = SCIAxisPinchZoomModifier()
        x2Pinch.axisId = "X2"
        x2Pinch.modifierName = "Y2 Axis Pinch Modifier"
        
        let x2Drag = SCIXAxisDragModifier()
        x2Drag.axisId = "X2"
        x2Drag.dragMode = .scale
        x2Drag.clipModeX = .none
        x2Drag.modifierName = "Y2 Axis Drag Modifier"
        let y2Pinch = SCIAxisPinchZoomModifier()
        y2Pinch.axisId = "Y2"
        y2Pinch.modifierName = "X2 Axis Pinch Modifier"
        let y2Drag = SCIYAxisDragModifier()
        y2Drag.axisId = "Y2"
        y2Drag.dragMode = .pan
        y2Drag.modifierName = "X2 Axis Drag Modifier"
        let pzm = SCIPinchZoomModifier()
        pzm.modifierName = "PinchZoom Modifier"
        let zem = SCIZoomExtentsModifier()
        zem.modifierName = "ZoomExtents Modifier"
        let zpm = SCIZoomPanModifier()
        zpm.modifierName = "PanZoom Modifier"
        
        //Initializing modifiers group here and attaching to the surface
        let zoomPanModifier = szpm.modifier(forSurface: surface2)
        (zoomPanModifier as! SCIZoomPanModifier).xyDirection = .xDirection
        let pinchZoomModifier = spzm.modifier(forSurface: surface2)
        (pinchZoomModifier as! SCIPinchZoomModifier).xyDirection = .xDirection
        let gm = SCIModifierGroup(childModifiers: [szpm, spzm])
        self.surface2.chartModifier = gm
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0x883a668f, finish: 0xff20384f, direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xff3a668f, withThickness: 0.5)
        //Attaching Renderable Series
        surface2.renderableSeries.add(getMountainRenderableSeries(brush, borderPen: pen))
        surface2.invalidateElement()
    }
}





