//
//  SCSMultiPaneStockChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 7/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart
import Darwin

enum DataSeriesName : Int {
    case candleData = 1
    case volumeData
    case rsiData
    case mcadColumnData
    case mcadBandData
    case highData
    case lowData
}

class SCSMultiPaneStockChartView: UIView {
    
    let sciChartView1 = SCIChartSurface()
    let sciChartView2 = SCIChartSurface()
    let sciChartView3 = SCIChartSurface()
    let sciChartView4 = SCIChartSurface()
    let szem = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
    
    var dataSource : [SCSMultiPaneItem]
    var dataSeries = [DataSeriesName : SCIDataSeriesProtocol]()
    let rangeSync = SCIAxisRangeSynchronization()
    let axisAreaSync = SCIAxisAreaSizeSynchronization()
    
    override init(frame: CGRect) {
        dataSource = SCSDataManager.loadPaneStockData()
        super.init(frame: frame)
        configureChartSurface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dataSource = SCSDataManager.loadPaneStockData()
        super.init(coder: aDecoder)
        configureChartSurface()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureChartSurface()
    }
    
    // MARK: Private Functions
    
    fileprivate func configureChartSurface() {
        
        generateDataSeries()
        
        axisAreaSync.syncMode = .right
        
        sciChartView1.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sciChartView1)
        
        sciChartView2.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sciChartView2)
        
        sciChartView3.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sciChartView3)
        
        sciChartView4.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sciChartView4)
        
        let layoutDictionary = ["SciChart1" : sciChartView1,
                                "SciChart2" : sciChartView2,
                                "SciChart3" : sciChartView3,
                                "SciChart4" : sciChartView4]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: layoutDictionary))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart2]-(0)-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: layoutDictionary))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart3]-(0)-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: layoutDictionary))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart4]-(0)-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: layoutDictionary))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[SciChart1]-(0)-[SciChart2(SciChart3)]-(0)-[SciChart3(SciChart2)]-(0)-[SciChart4(SciChart3)]-(0)-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: layoutDictionary))
        
        addConstraint(NSLayoutConstraint(item: sciChartView1,
                                         attribute: .height, relatedBy: .equal, toItem: self,
                                         attribute: .height,
                                         multiplier: 0.5,
                                         constant: 0))
        
        
        addAxisToTopChart()
        addAxisForChartView(sciChartView2)
        addAxisForChartView(sciChartView3)
        addAxisForChartView(sciChartView4)
        
        addModifiersForSurface(sciChartView1)
        addModifiersForSurface(sciChartView2)
        addModifiersForSurface(sciChartView3)
        addModifiersForSurface(sciChartView4)
        
        generateCandleStick(surface: sciChartView1)
        generateLineSeries(surface: sciChartView1)
        generateLineSeries1(surface: sciChartView1)
        
        generateColumnSeries(surface: sciChartView2)
        generateBandSeries(surface: sciChartView2)
        
        generateLineSeries2(surface: sciChartView3)
        
        generateColumnSeries1(surface: sciChartView4)
    }
    
    fileprivate func addAxisToTopChart() {
        sciChartView1.xAxes.add(SCICategoryDateTimeAxis())
        sciChartView1.xAxes.item(at: 0).axisId = "xID"
        
        sciChartView1.yAxes.add(SCINumericAxis())
        sciChartView1.yAxes.item(at: 0).autoRange = .always
        sciChartView1.yAxes.item(at: 0).textFormatting = "$%.4f"
        sciChartView1.yAxes.item(at: 0).axisId = "yID"
        
        rangeSync.attachAxis(sciChartView1.xAxes.item(at: 0))
    }
    
    func addAxisMarkerAnnotation(surface:SCIChartSurface, yID:String, color:uint, valueFormat:String, value:SCIGenericType){
        let axisMarker = SCIAxisMarkerAnnotation()
        axisMarker.yAxisId = "yID";
        axisMarker.style.margin = 5;
        
        let textFormatting = SCITextFormattingStyle();
        textFormatting.color = UIColor.white;
        textFormatting.fontSize = 10;
        axisMarker.style.textStyle = textFormatting;
        axisMarker.formattedValue = String.init(format: valueFormat, SCIGenericDouble(value));
        axisMarker.coordinateMode = .absolute
        axisMarker.style.backgroundColor = UIColor.fromARGBColorCode(color);
        axisMarker.position = value;
        
        surface.annotations.add(axisMarker);
    }
    
    fileprivate func addAxisForChartView(_ charView: SCIChartSurface) {
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.isVisible = false;
        xAxis.axisId = "xID"
        rangeSync.attachAxis(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.axisId = "yID"
        yAxis.style.labelStyle.fontSize = 12
        yAxis.style.labelStyle.colorCode = 0xFFb6b3af
        
        if charView == sciChartView2 {
            yAxis.textFormatting = "%.2f"
        }
        else if charView == sciChartView3 {
            yAxis.textFormatting = "%.1f"
        }
        else if charView == sciChartView4 {
            yAxis.numberFormatter = NumberFormatter()
            yAxis.numberFormatter.maximumIntegerDigits = 3
            yAxis.numberFormatter.numberStyle = .scientific
            yAxis.numberFormatter.exponentSymbol = "E+"
        }
        
        charView.xAxes.add(xAxis)
        charView.yAxes.add(yAxis)
    }
    
    fileprivate func addModifiersForSurface(_ chartSurfaceView: SCIChartSurface) {
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        xAxisDragmodifier.axisId = "xID"
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        let panZoomModifier = SCICursorModifier()
//            SCIZoomPanModifier()
        
        let legendModifier = SCILegendModifier()
        let itemStyle = SCILegendCellStyle()
        itemStyle.seriesNameFont = UIFont(name:"Helvetica",size:8)
        itemStyle.seriesNameTextColor = UIColor.white
        legendModifier.showCheckBoxes = false
        legendModifier.styleOfItemCell = itemStyle
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, pinchZoomModifier, szem, panZoomModifier, legendModifier])
        
        chartSurfaceView.chartModifiers = groupModifier
        
        axisAreaSync.attachSurface(chartSurfaceView)
    }
    
    fileprivate func generateLineSeries(surface: SCIChartSurface) {
        let renderableSeries = SCIFastLineRenderableSeries()
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF33DD33, withThickness: 1.0)
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        let data:SCIXyDataSeries = dataSeries[.highData] as! SCIXyDataSeries
        
        renderableSeries.dataSeries = data
        surface.renderableSeries.add(renderableSeries)
        
        addAxisMarkerAnnotation(surface: surface, yID:"yID", color: 0xFF33DD33, valueFormat: "$%.2f", value: data.yValues().value(at: data.count()-1))
    }
    
    fileprivate func generateLineSeries1(surface: SCIChartSurface) {
        let renderableSeries = SCIFastLineRenderableSeries()
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF3333, withThickness: 1.0)
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        let data:SCIXyDataSeries = dataSeries[.lowData] as! SCIXyDataSeries
        
        renderableSeries.dataSeries = data
        surface.renderableSeries.add(renderableSeries)
        
        addAxisMarkerAnnotation(surface: surface, yID:"yID", color: 0xFFFF3333, valueFormat: "$%.2f", value: data.yValues().value(at: data.count()-1))
    }
    
    fileprivate func generateCandleStick(surface: SCIChartSurface) {
        let renderableSeries = SCIFastCandlestickRenderableSeries()
        renderableSeries.dataSeries = dataSeries[.candleData]
        renderableSeries.style.strokeUpStyle = SCISolidPenStyle(colorCode: 0xff52cc54, withThickness: 1.0)
        renderableSeries.style.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0xa052cc54)
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        renderableSeries.style.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0xd0e26565)
        renderableSeries.style.strokeDownStyle = SCISolidPenStyle(colorCode: 0xffe26565, withThickness: 1.0)
        surface.renderableSeries.add(renderableSeries)
    }
    
    fileprivate func generateLineSeries2(surface: SCIChartSurface) {
        let renderableSeries = SCIFastLineRenderableSeries()
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        let data:SCIXyDataSeries = dataSeries[.rsiData] as! SCIXyDataSeries
        
        renderableSeries.dataSeries = data
        surface.renderableSeries.add(renderableSeries)
        
        addAxisMarkerAnnotation(surface: surface, yID:"yID", color: 0xa052cc54, valueFormat: "%.2f", value: data.yValues().value(at: data.count()-1))
    }
    
    fileprivate func generateColumnSeries(surface: SCIChartSurface) {
        let renderableSeries = SCIFastColumnRenderableSeries()
        renderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.white, withThickness: 1.0)
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(color: UIColor.white)
        renderableSeries.style.dataPointWidth = 0.3
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        let data:SCIXyDataSeries = dataSeries[.mcadColumnData] as! SCIXyDataSeries
        
        renderableSeries.dataSeries = data
        surface.renderableSeries.add(renderableSeries)
        
        addAxisMarkerAnnotation(surface: surface, yID:"yID", color: 0xa052cc54, valueFormat: "%.2f", value: data.yValues().value(at: data.count()-1))
    }
    
    fileprivate func generateBandSeries(surface: SCIChartSurface) {
        let renderableSeries = SCIFastBandRenderableSeries()
        
        renderableSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xffe26565, withThickness: 1.0)
        renderableSeries.style.strokeY1Style = SCISolidPenStyle(colorCode: 0xff52cc54, withThickness: 1.0)
        
        renderableSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.clear)
        renderableSeries.style.fillY1BrushStyle = SCISolidBrushStyle(color: UIColor.clear)
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        let data:SCIXyyDataSeries = dataSeries[.mcadBandData] as! SCIXyyDataSeries
        
        renderableSeries.dataSeries = data
        surface.renderableSeries.add(renderableSeries)
        
        addAxisMarkerAnnotation(surface: surface, yID:"yID", color: 0xa052cc54, valueFormat: "%.2f", value: data.y1Values().value(at: data.count()-1))
    }
    
    fileprivate func generateColumnSeries1(surface: SCIChartSurface) {
        let renderableSeries = SCIFastColumnRenderableSeries()
        renderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.white, withThickness: 1.0)
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(color: UIColor.white)
        renderableSeries.style.dataPointWidth = 0.3
        let data:SCIXyDataSeries = dataSeries[.volumeData] as! SCIXyDataSeries
        renderableSeries.yAxisId = "yID"
        renderableSeries.xAxisId = "xID"
        renderableSeries.dataSeries = data
        surface.renderableSeries.add(renderableSeries)
        
        addAxisMarkerAnnotation(surface: surface, yID:"yID", color: 0xa052cc54, valueFormat: "%.2g", value: data.yValues().value(at: data.count()-1))
    }
    
    fileprivate func generateDataSeries() {
        
        let priceDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        priceDataSeries.seriesName = "EUR/USD"
        let columnDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        columnDataSeries.seriesName = "Volume"
        let rsiDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        rsiDataSeries.seriesName = "RSI"
        let columnMcadDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        columnMcadDataSeries.seriesName = "Histogram"
        let bandMcadDataSeries = SCIXyyDataSeries(xType: .dateTime, yType: .double)
        bandMcadDataSeries.seriesName = "MACD"
        let highDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        highDataSeries.seriesName = "High"
        let lowDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        lowDataSeries.seriesName = "Low"
        
        let averageGainRsi = SCSMovingAverage(length: 14)
        let averageLossRsi = SCSMovingAverage(length: 14)
        let averageSLow = SCSMovingAverage(length: 12)
        let averageFast = SCSMovingAverage(length: 26)
        let averageSignal = SCSMovingAverage(length: 9)
        let averageLow = SCSMovingAverage(length: 50)
        let averageHigh = SCSMovingAverage(length: 200)
        var previous = self.dataSource.first
        
        for item: SCSMultiPaneItem in self.dataSource {
            let date = SCIGeneric(item.dateTime)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)
            let volume = SCIGeneric(item.volume)
            priceDataSeries.appendX(date,
                                    open: open,
                                    high: high,
                                    low: low,
                                    close: close)
            columnDataSeries.appendX(date, y: volume)
            let rsiValue = self.rsiForAverageGain(averageGainRsi, andAveLoss: averageLossRsi, previous: previous!, currentItem: item)
            let rsi = SCIGeneric(rsiValue)
            rsiDataSeries.appendX(date, y: rsi)
            let mcadPoint = self.mcadPointForSlow(averageSLow, forFast: averageFast, forSignal: averageSignal, andCloseValue: item.close)
            
            if mcadPoint.divergence.isNaN {
                mcadPoint.divergence = 0.00000000000000;
            }
            columnMcadDataSeries.appendX(date, y: SCIGeneric(mcadPoint.divergence))
            
            bandMcadDataSeries.appendX(date, y1: SCIGeneric(mcadPoint.mcad), y2: SCIGeneric(mcadPoint.signal))
            highDataSeries.appendX(date, y: SCIGeneric(averageHigh.push(item.close).current))
            lowDataSeries.appendX(date, y: SCIGeneric(averageLow.push(item.close).current))
            previous = item
        }
        
        dataSeries[.candleData] = priceDataSeries
        dataSeries[.volumeData] = columnDataSeries
        dataSeries[.rsiData] = rsiDataSeries
        dataSeries[.mcadColumnData] = columnMcadDataSeries
        dataSeries[.mcadBandData] = bandMcadDataSeries
        dataSeries[.highData] = highDataSeries
        dataSeries[.lowData] = lowDataSeries
    }
    
    fileprivate func rsiForAverageGain(_ averageGain: SCSMovingAverage, andAveLoss averageLoss: SCSMovingAverage, previous: SCSMultiPaneItem, currentItem item: SCSMultiPaneItem) -> Double {
        let gain = item.close > previous.close ? item.close - previous.close : 0.0
        let loss = previous.close > item.close ? previous.close - item.close : 0.0
        _ = averageGain.push(gain)
        _ = averageLoss.push(loss)
        let relativeStrength = averageGain.current.isNaN || averageLoss.current.isNaN ? Double.nan : averageGain.current / averageLoss.current
        return relativeStrength.isNaN ? Double.nan : 100.0 - (100.0 / (1.0 + relativeStrength))
    }
    
    fileprivate func mcadPointForSlow(_ slow: SCSMovingAverage, forFast fast: SCSMovingAverage, forSignal signal: SCSMovingAverage, andCloseValue close: Double) -> SCSMcadPointItem {
        _ = slow.push(close)
        _ = fast.push(close)
        let macd = slow.current - fast.current
        let signalLine = macd.isNaN ? Double.nan : signal.push(macd).current
        let divergence = macd.isNaN || signalLine.isNaN ? Double.nan : macd - signalLine
        let point = SCSMcadPointItem()
        point.mcad = macd
        point.signal = signalLine
        point.divergence = divergence
        return point
    }
    
    
}
