//
//  SCSHitTestAPIChart.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 5/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSHitTestAPIChart: UIView, UIGestureRecognizerDelegate {
    var touchPoint:CGPoint!
    var hitTestInfo:SCIHitTestInfo!
    var alertPopup:UIAlertView!
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    func completeConfiguration() {
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(SCSHitTestAPIChart.handleSingleTap))
        singleFingerTap.delegate = self
        surface.addGestureRecognizer(singleFingerTap)
        
        addSurface()
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.clipModeX = .none;
        
        let selectionModifier = SCISeriesSelectionModifier();
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier, selectionModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        surface.xAxes.add(SCINumericAxis())
        
        let yAxisLeft = SCINumericAxis()
        yAxisLeft.axisAlignment = .left
        yAxisLeft.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxisLeft)
    }
    
    func addSeries(){
        let xData:[Double] = [0, 1,   2,   3,   4,   5,    6,   7,    8,   9];
        let yData:[Double] = [0, 0.1, 0.3, 0.5, 0.4, 0.35, 0.3, 0.25, 0.2, 0.1];
        
        let dataSeries0 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries0.seriesName = "Line Series"
        dataSeries0.appendRangeX(xData , y: yData)
        addLineRenderSeries(data: dataSeries0)
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Mountain Series"
        var yData1: [Double] = []
        for i in 0..<yData.count {
            let value:Double = yData[i] * 0.7
            yData1.append(value)
            
        }
        dataSeries1.appendRangeX(xData , y: yData1)
        addMountainRenderSeries(data: dataSeries1)
        
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Column Series"
        var yData2: [Double] = []
        for i in 0..<yData.count{
            let value:Double = yData[i] * 0.5
            yData2.append(value)
        }
        dataSeries2.appendRangeX(xData , y: yData2)
        addColumnRenderSeries(data: dataSeries2)
        
        let dataSeries3 = SCIOhlcDataSeries(xType: .double, yType: .double)
        dataSeries3.seriesName = "Candlestick Series"
        
        var open: [Double] = []
        for i in 0..<yData.count {
            let value:Double = yData[i] + 0.5
            open.append(value)
        }
        var high: [Double] = []
        for i in 0..<yData.count {
            let value:Double = yData[i] + 1.0
            high.append(value)
        }
        var low: [Double] = []
        for i in 0..<yData.count {
            let value:Double = yData[i] + 0.3
            low.append(value)
        }
        var close: [Double] = []
        for i in 0..<yData.count {
            let value:Double = yData[i] + 0.7
            close.append(value)
        }
        dataSeries3.appendRangeX(xData, open: open, high: high, low: low, close: close)
        addCandleRenderSeries(data: dataSeries3)
    }
    
    @objc func handleSingleTap(_ recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: recognizer.view!.superview)
        
        touchPoint = surface.renderSurface?.point(inChartFrame: location)
        let resultString = NSMutableString.init(format: "Touch at: (%.0f, %.0f)",touchPoint.x, touchPoint.y)
        
        for i in 0..<surface.renderableSeries.count() {
            let renderSeries:SCIRenderableSeriesBase = surface.renderableSeries.item(at: UInt32(i)) as! SCIRenderableSeriesBase
            hitTestInfo = renderSeries.hitTestProvider().hitTestAt(x: Double(touchPoint.x), y: Double(touchPoint.y), radius: 30, onData: renderSeries.currentRenderPassData)
            resultString.append(NSString.init(format: "\n%@ - %@", renderSeries.dataSeries.seriesName!, hitTestInfo.match.boolValue ? "YES" : "NO") as String)
        }
        
        alertPopup = UIAlertView(title: "HitTestInfo", message: resultString as String, delegate: self, cancelButtonTitle: nil)
        alertPopup.show()
        timedAlert()
    }
    
    private func addLineRenderSeries(data:SCIXyDataSeries){
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.dataSeries = data;
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.width = 30;
        ellipsePointMarker.height = 30;
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF4682B4)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(colorCode: 0xFFE6E6FA, withThickness: 2)
        
        lineRenderSeries.style.pointMarker = ellipsePointMarker
        
        surface.renderableSeries.add(lineRenderSeries)
    }
    
    private func addMountainRenderSeries(data:SCIXyDataSeries){
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.dataSeries = data;
        mountainRenderSeries.areaStyle = SCISolidBrushStyle(colorCode: 0xFFB0C4DE)
        mountainRenderSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 2)
        
        surface.renderableSeries.add(mountainRenderSeries)
    }
    
    private func addColumnRenderSeries(data:SCIXyDataSeries){
        let columnRenderSeries = SCIFastColumnRenderableSeries()
        columnRenderSeries.dataSeries = data
        
        surface.renderableSeries.add(columnRenderSeries)
    }
    
    private func addCandleRenderSeries(data:SCIOhlcDataSeries){
        let candleRenderSeries = SCIFastCandlestickRenderableSeries()
        candleRenderSeries.dataSeries = data;
        
        surface.renderableSeries.add(candleRenderSeries)
    }
    
    
    private func timedAlert(){
        self.perform(#selector(SCSHitTestAPIChart.dismissAlert), with: alertPopup, afterDelay: 4)
    }
    
    @objc func dismissAlert(_ alertView: UIAlertView){
        alertPopup.dismiss(withClickedButtonIndex: -1, animated: true)
    }
    
}
