//
//  SCSCandlestickChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSCandlestickChartView: UIView {
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(colorCode: 0x9000AA00)
        let downBrush = SCISolidBrushStyle(colorCode: 0x90FF0000)
        let upWickPen = SCISolidPenStyle(colorCode: 0xFF00AA00, withThickness: 0.7)
        let downWickPen = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 0.7)
        
        surface.renderableSeries.add(getCandleRenderSeries(false, upBodyBrush: upBrush, upWickPen: upWickPen, downBodyBrush: downBrush, downWickPen: downWickPen, count: 30))
        
        
    }
    
    fileprivate func getCandleRenderSeries(_ isReverse: Bool,
                                       upBodyBrush: SCISolidBrushStyle,
                                       upWickPen: SCISolidPenStyle,
                                       downBodyBrush: SCISolidBrushStyle,
                                       downWickPen: SCISolidPenStyle,
                                       count: Int) -> SCIFastCandlestickRenderableSeries {
        
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float)
        
        SCSDataManager.loadPriceData(into: ohlcDataSeries,
                                     fileName: "FinanceData",
                                     isReversed: isReverse,
                                     count: count)
        
        let candleRendereSeries = SCIFastCandlestickRenderableSeries()
        candleRendereSeries.dataSeries = ohlcDataSeries
        candleRendereSeries.fillUpBrushStyle = upBodyBrush
        candleRendereSeries.fillDownBrushStyle = downBodyBrush
        candleRendereSeries.strokeUpStyle = upWickPen
        candleRendereSeries.strokeDownStyle = downWickPen
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        candleRendereSeries.addAnimation(animation)
        
        return candleRendereSeries
    }
    
}
