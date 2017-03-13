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
    
    let sciChartView1 = SCSBaseChartView()
    let sciChartView2 = SCSBaseChartView()
    let sciChartView3 = SCSBaseChartView()
    let sciChartView4 = SCSBaseChartView()
    let szem = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
    
    var dataSource : [SCSMultiPaneItem]
    var dataSeries = [DataSeriesName : SCIDataSeriesProtocol]()
    let rangeSync = SCIAxisRangeSyncronization()
    let axisAreaSync = SCIAxisAreaSizeSyncronization()
    
    override init(frame: CGRect) {
        dataSource = SCSDataManager.loadPaneStockData()
        super.init(frame: frame)
        configureChartSuraface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dataSource = SCSDataManager.loadPaneStockData()
        super.init(coder: aDecoder)
        configureChartSuraface()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureChartSuraface()
    }
    
    // MARK: Private Functions
    
    fileprivate func configureChartSuraface() {
        
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
        
        sciChartView1.chartSurface.renderableSeries.add(generateLineSeries())
        sciChartView1.chartSurface.renderableSeries.add(generateLineSeries1())
        sciChartView1.chartSurface.renderableSeries.add(generateCandleStick())
        
        sciChartView2.chartSurface.renderableSeries.add(generateBandSeries())
        sciChartView2.chartSurface.renderableSeries.add(generateColumnSeries())
        
        sciChartView3.chartSurface.renderableSeries.add(generateLineSeries2())
        
        sciChartView4.chartSurface.renderableSeries.add(generateColumnSeries1())
        
        
        addTextAnnotation(" EUR/USD", forSurface: sciChartView1)
        addTextAnnotation(" MACD", forSurface: sciChartView2)
        addTextAnnotation(" RSI", forSurface: sciChartView3)
        addTextAnnotation(" Volume", forSurface: sciChartView4)
    }
    
    fileprivate func addAxisToTopChart() {
        sciChartView1.chartSurface.xAxes.add(SCICategoryDateTimeAxis())
        sciChartView1.chartSurface.yAxes.add(SCINumericAxis())
        sciChartView1.chartSurface.yAxes.item(at: 0).autoRange = .always
        sciChartView1.chartSurface.yAxes.item(at: 0).textFormatting = "$%.4f"
        sciChartView1.chartSurface.yAxes.item(at: 0).style.labelStyle.colorCode = 0xFFb6b3af
        sciChartView1.chartSurface.yAxes.item(at: 0).style.labelStyle.fontSize = 12
        sciChartView1.chartSurface.xAxes.item(at: 0).style.labelStyle.colorCode = 0xFFb6b3af
        sciChartView1.chartSurface.xAxes.item(at: 0).style.labelStyle.fontSize = 12
        rangeSync.attachAxis(sciChartView1.chartSurface.xAxes.item(at: 0))
    }
    
    fileprivate func addTextAnnotation(_ text: String, forSurface surfaceView: SCSBaseChartView) {
        
        let textFormatting = SCITextFormattingStyle()
        textFormatting.fontSize = 14
        textFormatting.fontName = "Arial"
        textFormatting.colorCode = 0xFFb6b3af
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = .relative
        textAnnotation.x1 = SCIGeneric(0.03)
        textAnnotation.y1 = SCIGeneric(0.2)
        textAnnotation.text = text
        textAnnotation.style.textStyle = textFormatting
        textAnnotation.style.textColor = UIColor.gray
        textAnnotation.style.backgroundColor = UIColor.init(red:22.0 / 255.0, green: 33.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
        
        let annotationGroup = SCIAnnotationCollection(childAnnotations: [textAnnotation])
        surfaceView.chartSurface.annotation = annotationGroup
    }
    
    fileprivate func addAxisForChartView(_ charView: SCSBaseChartView) {
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.isVisible = false;
        rangeSync.attachAxis(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
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
        
        charView.chartSurface.xAxes.add(xAxis)
        charView.chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addModifiersForSurface(_ chartSurfaceView: SCSBaseChartView) {
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        let panZoomModifier = SCIZoomPanModifier()
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, pinchZoomModifier, szem, panZoomModifier])
        
        chartSurfaceView.chartSurface.chartModifier = groupModifier
        
        axisAreaSync.attachSurface(chartSurfaceView.chartSurface)
    }
    
    fileprivate func generateLineSeries() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIFastLineRenderableSeries()
        renderebleSeries.style.linePen = SCISolidPenStyle(color: UIColor.green, withThickness: 0.5)
        renderebleSeries.dataSeries = dataSeries[.highData]
        return renderebleSeries;
    }
    
    fileprivate func generateLineSeries1() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIFastLineRenderableSeries()
        renderebleSeries.style.linePen = SCISolidPenStyle(color: UIColor.red, withThickness: 0.5)
        renderebleSeries.dataSeries = dataSeries[.lowData]
        return renderebleSeries;
    }
    
    fileprivate func generateCandleStick() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIFastCandlestickRenderableSeries()
        renderebleSeries.dataSeries = dataSeries[.candleData]
        renderebleSeries.style.strokeUpStyle = SCISolidPenStyle(color: UIColor.white, withThickness: 0.5)
        renderebleSeries.style.fillUpBrushStyle = SCISolidBrushStyle(color: UIColor.white)
        let downColor = UIColor(red: 56.0/255.0, green: 110.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        renderebleSeries.style.fillDownBrushStyle = SCISolidBrushStyle(color: downColor)
        renderebleSeries.style.strokeDownStyle = SCISolidPenStyle(color: downColor, withThickness: 0.5)
        return renderebleSeries;
    }
    
    fileprivate func generateLineSeries2() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIFastLineRenderableSeries()
        renderebleSeries.style.linePen = SCISolidPenStyle(color: UIColor(red: 168.0/255.0, green: 202.0/255.0, blue: 230.0/255.0, alpha: 1.0), withThickness: 0.5)
        renderebleSeries.dataSeries = dataSeries[.rsiData]
        return renderebleSeries;
    }
    
    fileprivate func generateColumnSeries() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIFastColumnRenderableSeries()
        renderebleSeries.style.borderPen = SCISolidPenStyle(color: UIColor.white, withThickness: 0.5)
        renderebleSeries.style.fillBrush = SCISolidBrushStyle(color: UIColor.white)
        renderebleSeries.style.dataPointWidth = 0.3
        renderebleSeries.dataSeries = dataSeries[.mcadColumnData]
        return renderebleSeries;
    }
    
    fileprivate func generateBandSeries() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIBandRenderableSeries()
        var color = UIColor(red: 69.0/255.0, green: 199.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        renderebleSeries.style.pen1 = SCISolidPenStyle(color: color, withThickness: 0.5)
        renderebleSeries.style.pen2 = SCISolidPenStyle(color: color, withThickness: 0.5)
        color = UIColor(red: 217.0/255.0, green: 77.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        renderebleSeries.style.brush1 = SCISolidBrushStyle(color: color)
        renderebleSeries.style.brush2 = SCISolidBrushStyle(color: color)
        renderebleSeries.style.drawPointMarkers = false
        renderebleSeries.dataSeries = dataSeries[.mcadBandData]
        return renderebleSeries;
    }
    
    fileprivate func generateColumnSeries1() -> SCIRenderableSeriesBase {
        let renderebleSeries = SCIFastColumnRenderableSeries()
        renderebleSeries.style.borderPen = SCISolidPenStyle(color: UIColor.white, withThickness: 0.5)
        renderebleSeries.style.fillBrush = SCISolidBrushStyle(color: UIColor.white)
        renderebleSeries.style.dataPointWidth = 0.3
        renderebleSeries.dataSeries = dataSeries[.volumeData]
        return renderebleSeries;
    }
    
    fileprivate func generateDataSeries() {
        
        let priceDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        priceDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let columnDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        columnDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let rsiDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        rsiDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let columnMcadDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        columnMcadDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let bandMcadDataSeries = SCIXyyDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        bandMcadDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let highDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        highDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let lowDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double, seriesType: .xCategory)
        lowDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
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
