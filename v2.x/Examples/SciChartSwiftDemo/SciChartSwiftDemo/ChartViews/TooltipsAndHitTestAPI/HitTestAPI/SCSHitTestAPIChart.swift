//
//  SCSHitTestAPIChart.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 5/4/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSHitTestAPIChart: SCSBaseChartView{
    var touchPoint:CGPoint!
    var hitTestInfo:SCIHitTestInfo!
    var alertPopup:UIAlertView!
    
    override func completeConfiguration() {
        super.completeConfiguration()
        
        let singleFingerTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SCSHitTestAPIChart.handleSingleTap))
        
        self.chartSurface.view?.addGestureRecognizer(singleFingerTap)
        
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    override func addDefaultModifiers() {
        
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
        
        chartSurface.chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        
        let yAxisLeft = SCINumericAxis()
        yAxisLeft.axisAlignment = .left
        yAxisLeft.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxisLeft)
    }
    
    func addSeries(){
        let xData:[Double] = [0, 1,   2,   3,   4,   5,    6,   7,    8,   9];
        let yData:[Double] = [0, 0.1, 0.3, 0.5, 0.4, 0.35, 0.3, 0.25, 0.2, 0.1];
        
        let dataSeries0 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries0.seriesName = "Line Series"
        dataSeries0.appendRangeX(xData , y: yData)
        addLineRenderSeries(data: dataSeries0)
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries1.seriesName = "Mountain Series"
        var yData1: [Double] = []
        for i in 0..<yData.count {
            let value:Double = yData[i] * 0.7
            yData1.append(value)
            
        }
        dataSeries1.appendRangeX(xData , y: yData1)
        addMountainRenderSeries(data: dataSeries1)
        
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries2.seriesName = "Column Series"
        var yData2: [Double] = []
        for i in 0..<yData.count{
            let value:Double = yData[i] * 0.5
            yData2.append(value)
        }
        dataSeries2.appendRangeX(xData , y: yData2)
        addColumnRenderSeries(data: dataSeries2)
        
        let dataSeries3 = SCIOhlcDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
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
    
    func handleSingleTap(_ recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: recognizer.view!.superview)
        
        touchPoint = chartSurface.renderSurface?.point(inChartFrame: location)
        let resultString = NSMutableString.init(format: "Touch at: (%.0f, %.0f)",touchPoint.x, touchPoint.y)
        
        for i in 0..<chartSurface.renderableSeries.count(){
            let renderSeries:SCIRenderableSeriesBase = chartSurface.renderableSeries.item(at: UInt32(i)) as! SCIRenderableSeriesBase
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
        
        chartSurface.renderableSeries.add(lineRenderSeries)
    }
    
    private func addMountainRenderSeries(data:SCIXyDataSeries){
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.dataSeries = data;
        mountainRenderSeries.areaStyle = SCISolidBrushStyle(colorCode: 0xFFB0C4DE)
        mountainRenderSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 2)
        
        chartSurface.renderableSeries.add(mountainRenderSeries)
    }
    
    private func addColumnRenderSeries(data:SCIXyDataSeries){
        let columnRenderSeries = SCIFastColumnRenderableSeries()
        columnRenderSeries.dataSeries = data
        
        chartSurface.renderableSeries.add(columnRenderSeries)
    }
    
    private func addCandleRenderSeries(data:SCIOhlcDataSeries){
        let candleRenderSeries = SCIFastCandlestickRenderableSeries()
        candleRenderSeries.dataSeries = data;
        
        chartSurface.renderableSeries.add(candleRenderSeries)
    }
    
    
    private func timedAlert(){
        self.perform(#selector(SCSHitTestAPIChart.dismissAlert), with: alertPopup, afterDelay: 4)
    }
    
    func dismissAlert(_ alertView: UIAlertView){
        alertPopup.dismiss(withClickedButtonIndex: -1, animated: true)
    }
    
}
