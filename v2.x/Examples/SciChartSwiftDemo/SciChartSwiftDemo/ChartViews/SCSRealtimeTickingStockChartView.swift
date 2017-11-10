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
    
    var surface1 = SCIChartSurface()
    var surface2 = SCIChartSurface()
    
    var szpm: SCIMultiSurfaceModifier!
    var szem: SCIMultiSurfaceModifier!
    var spzm: SCIMultiSurfaceModifier!
    
    var ohlcDataSeries: SCIOhlcDataSeries!
    var avgDataSeries: SCIXyDataSeries!
    var mountainDataSeries: SCIXyDataSeries!
    
    var xAxis: SCIDateTimeAxis!
    
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
    
    let lastMarker: SCIAxisMarkerAnnotation = SCIAxisMarkerAnnotation()
    let averageMarker: SCIAxisMarkerAnnotation = SCIAxisMarkerAnnotation()
    
    var strokeUpColor:UIColor!
    var strokeDownColor:UIColor!
    var smaSeriesColor:UIColor!
    let strokeThinkess:Float = 1.5
    
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
            wSelf!.surface1.renderableSeries.clear()
            wSelf!.updateToCandlestickRenderableSeries()
            wSelf!.updateRenderableSeriesType()
        })
        alertView.addAction(action)
        action = UIAlertAction(title: "OhlcRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf!.surface1.renderableSeries.clear()
            wSelf!.updateToOhlcRenderableSeries()
            wSelf!.updateRenderableSeriesType()
        })
        alertView.addAction(action)
        action = UIAlertAction(title: "MountainRenderableSeries", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf!.surface1.renderableSeries.clear()
            wSelf!.updateToMountainRenderableSeries()
            wSelf!.updateRenderableSeriesType()
        })
        alertView.addAction(action)
        
        configureChartSurfaceViewsLayout()
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
        
        ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        ohlcDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        for i in 0..<prices.count {
            let item : SCSMultiPaneItem = prices[i]
            ohlcDataSeries.appendX(SCIGeneric(item.dateTime), open: SCIGeneric(item.open), high: SCIGeneric(item.high), low: SCIGeneric(item.low), close: SCIGeneric(item.close))
        }
        
        avgDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float)
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
//        surface1 = SCIChartSurface()
        surface1.backgroundColor = UIColor.fromARGBColorCode(0xFF1c1c1e)
        surface1.renderableSeriesAreaFill = SCISolidBrushStyle(colorCode: 0xFF1c1c1e)
        
        //  Initializing bottom scichart surface
//        surface2 = SCIChartSurface()
        surface2.backgroundColor = UIColor.fromARGBColorCode(0xFF1c1c1e)
        surface2.renderableSeriesAreaFill = SCISolidBrushStyle(colorCode: 0xFF1c1c1e)
        
        //  Initializing box annotation
        box = SCIBoxAnnotation()
        box.xAxisId = "X2"
        box.yAxisId = "Y2"
        box.coordinateMode = .relativeY
        box.style.fillBrush = SCISolidBrushStyle(colorCode: 0x200070FF)
        surface2.annotations = SCIAnnotationCollection.init(childAnnotations: [box])
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
        (renderableSeries as! SCIFastOhlcRenderableSeries).strokeUpStyle = SCISolidPenStyle(color: strokeUpColor, withThickness: strokeThinkess)
        (renderableSeries as! SCIFastOhlcRenderableSeries).strokeDownStyle = SCISolidPenStyle(color: strokeDownColor, withThickness: strokeThinkess)
    }
    
    func updateToCandlestickRenderableSeries() {
        renderableSeries = SCIFastCandlestickRenderableSeries()
        renderableSeries.xAxisId = "X1"
        renderableSeries.yAxisId = "Y1"
        renderableSeries.dataSeries = ohlcDataSeries
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.strokeUpStyle = SCISolidPenStyle(color: strokeUpColor, withThickness: strokeThinkess)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.strokeDownStyle = SCISolidPenStyle(color: strokeDownColor, withThickness: strokeThinkess)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.fillUpBrushStyle = SCISolidBrushStyle(color: strokeUpColor)
        (renderableSeries as! SCIFastCandlestickRenderableSeries).style.fillDownBrushStyle = SCISolidBrushStyle(color: strokeDownColor)
    }
    
    func updateToMountainRenderableSeries() {
        renderableSeries = SCIFastMountainRenderableSeries()
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0x883a668f, finish: 0xff20384f, direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xffc6e6ff, withThickness: strokeThinkess)
        (renderableSeries as! SCIFastMountainRenderableSeries).areaStyle = brush
        (renderableSeries as! SCIFastMountainRenderableSeries).style.strokeStyle = pen
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
        surface1.renderableSeries.add(renderableSeries)
        surface1.renderableSeries.add(avgRenderableSeries)
        surface1.invalidateElement()
    }
    
    
    // MARK: Private Functions
    
    func configureChartSurfaceViewsLayout() {
        
        //  Initializing top scichart view
        surface1.translatesAutoresizingMaskIntoConstraints = false
        addSubview(surface1)
        
        //  Initializing bottom scichart view
        surface2.translatesAutoresizingMaskIntoConstraints = false
        addSubview(surface2)
        
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
        addSubview(panel)
              
        let layoutDictionary: [String : UIView] = ["SciChart1" : surface1, "SciChart2" : surface2, "Panel" : panel]
        
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
    
    func getOhlcRenderableSeries(_ isRevered: Bool, upBodyBrush upBodyColor: SCISolidBrushStyle, downBodyBrush downBodyColor: SCISolidBrushStyle, count: Int) -> SCIFastOhlcRenderableSeries {
        renderableSeries = SCIFastOhlcRenderableSeries()
        renderableSeries.xAxisId = "X1"
        renderableSeries.yAxisId = "Y1"
        renderableSeries.dataSeries = ohlcDataSeries
        (renderableSeries as! SCIFastOhlcRenderableSeries).strokeUpStyle = SCISolidPenStyle(color: strokeUpColor, withThickness: strokeThinkess)
        (renderableSeries as! SCIFastOhlcRenderableSeries).strokeDownStyle = SCISolidPenStyle(color: strokeDownColor, withThickness: strokeThinkess)
        return (renderableSeries as! SCIFastOhlcRenderableSeries)
    }
    
    fileprivate func getMountainRenderSeries(withBrush brush:SCILinearGradientBrushStyle, and pen: SCISolidPenStyle) -> SCIFastMountainRenderableSeries {
        
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        for i in 0..<seriesCount {
            mountainDataSeries.appendX(SCIGeneric(i), y: ohlcDataSeries.highValues().value(at: i))
        }
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.areaStyle = brush
        mountainRenderSeries.style.strokeStyle = pen
        mountainRenderSeries.xAxisId = "X2"
        mountainRenderSeries.yAxisId = "Y2"
        mountainRenderSeries.dataSeries = mountainDataSeries
        
        return mountainRenderSeries
        
    }
    
    func getAverageLine() -> SCIFastLineRenderableSeries {
        avgRenderableSeries = SCIFastLineRenderableSeries()
        (avgRenderableSeries as! SCIFastLineRenderableSeries).strokeStyle = SCISolidPenStyle(color: smaSeriesColor, withThickness: strokeThinkess)
        (avgRenderableSeries as! SCIFastLineRenderableSeries).xAxisId = "X1"
        (avgRenderableSeries as! SCIFastLineRenderableSeries).yAxisId = "Y1"
        (avgRenderableSeries as! SCIFastLineRenderableSeries).dataSeries = avgDataSeries
        return (avgRenderableSeries as! SCIFastLineRenderableSeries)
    }
    
    func getMountainRenderableSeries(_ areaBrush: SCIBrushStyle, borderPen: SCIPenStyle) -> SCIFastMountainRenderableSeries {
        mountainDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float)
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        for i in 0..<ohlcDataSeries.xValues().count() {
            mountainDataSeries.appendX(ohlcDataSeries.xValues().value(at: i), y: ohlcDataSeries.highValues().value(at: i))
        }
        
        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.areaStyle = areaBrush
        mountainRenderableSeries.style.strokeStyle = borderPen
        mountainRenderableSeries.xAxisId = "X2"
        mountainRenderableSeries.yAxisId = "Y2"
        mountainRenderableSeries.dataSeries = mountainDataSeries
        return mountainRenderableSeries
    }
    
    func drawBoxAnnotation() {
        box.isEditable = false
        box.x1 = xAxis!.visibleRange.min
        box.x2 = xAxis!.visibleRange.max
        box.y1 = SCIGeneric(0)
        box.y2 = SCIGeneric(1)
    }
    
    @objc func updateData(_ timer: Timer) {
        let price = marketDataService.getNextBar()
        
        if lastPrice != nil && lastPrice.dateTime == price.dateTime {
            // TODO: compare dates in proper way
            ohlcDataSeries.update(at: ohlcDataSeries.count() - 1, open: SCIGeneric(price.open), high: SCIGeneric(price.high), low: SCIGeneric(price.low), close: SCIGeneric(price.close))
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
                let step: Double = lastItem - priorItem
                
                xAxis!.visibleRange = SCIDateRange(min: SCIGeneric(visibleRangeMin + step), max: SCIGeneric(visibleRangeMax + step))
            }
        }
        
        self.lastMarker.position = SCIGeneric(price.close)
        self.lastMarker.style.backgroundColor = price.close > price.open ? strokeUpColor : strokeDownColor;
        
        self.averageMarker.position = SCIGeneric(msa.current)
        self.lastPrice = price
        
        drawBoxAnnotation()
        surface1.invalidateElement()
        surface2.invalidateElement()
    }
    
    func initializeTopSurfaceData() {
        
        strokeUpColor = UIColor.fromARGBColorCode(0xFF00AA00);
        strokeDownColor = UIColor.fromARGBColorCode(0xFFFF0000);
        smaSeriesColor = UIColor.fromARGBColorCode(0xFFFFA500);
        
        let priorItem: Double = (SCIGenericDate(ohlcDataSeries.xValues().value(at: ohlcDataSeries.xValues().count() - 2))).timeIntervalSince1970
        let lastItem: Double = SCIGenericDate(ohlcDataSeries.xValues().value(at: ohlcDataSeries.xValues().count() - 1)).timeIntervalSince1970
        
        xAxis = SCIDateTimeAxis()
        xAxis.axisId = "X1"
        xAxis.visibleRange = SCIDateRange(min: ohlcDataSeries.xValues().value(at: 0), max: SCIGeneric(lastItem + 4*(lastItem - priorItem)))
        xAxis.textFormatting = "dd/MM/yyyy"
        surface1.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.axisId = "Y1"
        yAxis.cursorTextFormatting = "%.02f"
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxis.autoRange = .always
        surface1.yAxes.add(yAxis)
        
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
        (zommPanModifier as! SCIZoomPanModifier).direction = .xDirection
        let gm = SCIChartModifierCollection(childModifiers: [x1Pinch, x1Drag, y1Drag, spzm, szem, szpm])
        self.surface1.chartModifiers = gm
        
        surface1.renderableSeries.add(getOhlcRenderableSeries(false, upBodyBrush: SCISolidBrushStyle(colorCode: 0xFFff9c0f), downBodyBrush: SCISolidBrushStyle(colorCode: 0xFFffff66), count: Int(seriesCount)))
        surface1.renderableSeries.add(getAverageLine())
        
        self.addAxisMarkerAnnotation(axisMarker: lastMarker, surface: surface1, yID: "Y1", color: strokeUpColor);
        self.addAxisMarkerAnnotation(axisMarker: averageMarker, surface: surface1, yID: "Y1", color: smaSeriesColor);
        
    }
    
    func addAxisMarkerAnnotation(axisMarker:SCIAxisMarkerAnnotation, surface:SCIChartSurface, yID:String, color:UIColor){
        axisMarker.yAxisId = yID
        axisMarker.style.margin = 5
        
        let textFormatting = SCITextFormattingStyle()
        textFormatting.color = UIColor.white;
        textFormatting.fontSize = 10;
        axisMarker.style.textStyle = textFormatting
        axisMarker.coordinateMode = .absolute
        axisMarker.style.backgroundColor = color
        surface.annotations.add(axisMarker)
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
        
        //Initializing modifiers group here and attaching to the surface
        let zoomPanModifier = szpm.modifier(forSurface: surface2)
        (zoomPanModifier as! SCIZoomPanModifier).direction = .xDirection
        let pinchZoomModifier = spzm.modifier(forSurface: surface2)
        (pinchZoomModifier as! SCIPinchZoomModifier).direction = .xDirection
        
        let gm = SCIChartModifierCollection(childModifiers: [szpm, spzm])
        self.surface2.chartModifiers = gm
        
        //Attaching Renderable Series
        surface2.renderableSeries.add(getMountainRenderableSeries(SCILinearGradientBrushStyle(colorCodeStart: 0x883a668f, finish: 0xff20384f, direction: .vertical), borderPen: SCISolidPenStyle(colorCode: 0xff3a668f, withThickness: 0.5)))

    }
}
