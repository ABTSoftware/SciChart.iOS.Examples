//
//  SCSThemeCustomChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 12/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSThemeCustomChartView: UIView {
    
    var dataSource : [SCSMultiPaneItem]!
    let surface = SCIChartSurface()
    let SCIChart_BerryBlueStyleKey = "SciChart_BerryBlue"
    
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
        applyCustomTheme()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        
        let axisStyle = SCIAxisStyle()
        axisStyle.drawMajorGridLines = false
        axisStyle.drawMinorGridLines = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMajorBands = false
        
        let xAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        xAxis.axisTitle = "Bottom Axis Title";
        surface.xAxes.add(xAxis)
        
        let yAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        yAxis.axisTitle = "Right Axis Title"
        surface.yAxes.add(yAxis)
        
        let yAxis2 = SCINumericAxis()
        yAxis2.axisAlignment = .left
        yAxis2.axisId = "yAxis2"
        yAxis2.axisTitle = "Left Axis Title"
        surface.yAxes.add(yAxis2)
    }
    
    fileprivate func addDataSeries() {
        
        dataSource = SCSDataManager.loadThemeData()
        
        let priceDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        priceDataSeries.seriesName = "Line Series"
        priceDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let priceRenderableSeries = SCIFastLineRenderableSeries()
        priceRenderableSeries.dataSeries = priceDataSeries
        surface.renderableSeries.add(priceRenderableSeries)
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float)
        ohlcDataSeries.seriesName = "Candle Series"
        ohlcDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let candlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
        candlestickRenderableSeries.dataSeries = ohlcDataSeries
        surface.renderableSeries.add(candlestickRenderableSeries)
        
        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        mountainDataSeries.seriesName = "Mountain Series"
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = mountainDataSeries
        surface.renderableSeries.add(mountainRenderableSeries)
        
        let columnDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        columnDataSeries.seriesName = "Column Series"
        columnDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.style.dataPointWidth = 0.3
        columnRenderableSeries.dataSeries = columnDataSeries
        surface.renderableSeries.add(columnRenderableSeries)
        
        let averageHigh = SCSMovingAverage(length: 20)
        var i = 0
        for item: SCSMultiPaneItem in dataSource {
            let date = SCIGeneric(i)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)
            ohlcDataSeries.appendX(date, open: open, high: high, low: low, close: close)
            priceDataSeries.appendX(date, y: SCIGeneric(averageHigh.push(item.close).current))
            mountainDataSeries.appendX(date, y: SCIGeneric(item.close - 1000))
            columnDataSeries.appendX(date, y: SCIGeneric(item.close - 3500))
            i += 1
        }
        
        
    }
    
    func applyCustomTheme() {
        SCIThemeManager.addTheme(byThemeKey: SCIChart_BerryBlueStyleKey)
        SCIThemeManager.applyTheme(toThemeable: surface, withThemeKey: SCIChart_BerryBlueStyleKey)
    }
}
