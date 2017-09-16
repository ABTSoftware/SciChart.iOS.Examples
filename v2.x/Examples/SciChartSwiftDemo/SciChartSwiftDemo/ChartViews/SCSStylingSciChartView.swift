//
//  SCSStylingSciChartView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 13/09/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSStylingSciChartView: UIView {
    
    var dataSource : [SCSMultiPaneItem]!
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    func completeConfiguration() {
        addSurface()
        
        setupSurface()
        setupAxes()
        setupRenderableSeries()
        
        surface.chartModifiers = SCIChartModifierCollection.init(childModifiers: [SCICursorModifier(), SCIZoomExtentsModifier()])
    }
    
    func setupSurface () {
        // surface background. If you set colot for chart area than it is color only for axes area
        surface.backgroundColor = .white
        // chart area background fill color
        surface.renderableSeriesAreaFill = SCISolidBrushStyle(color: .lightGray)
        // chart area border color and thicknes
        surface.renderableSeriesAreaBorder = SCISolidPenStyle(color: .darkGray, withThickness: 1)
    }
    
    func setupAxes () {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(150), max: SCIGeneric(180))
        // setting axis band color. Band is filled area between major grid lines
        xAxis.style.gridBandBrush = SCISolidBrushStyle(colorCode: 0x70000000)
        // changing major grid line color and thicknes. major grid line is line at the label position
        xAxis.style.majorGridLineBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        // changing minor grid line color and thicknes. minor grid lines are located between major grid lines
        xAxis.style.minorGridLineBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)
        // axis label color
        xAxis.style.labelStyle.color = .darkGray
        // axis label font
        xAxis.style.labelStyle.fontName = "Helvetica"
        // axis label font size
        xAxis.style.labelStyle.fontSize = 14
        // drawing ticks is enabled by default. That lines are added just to show that such propertyes exist and what they do
        xAxis.style.drawMajorTicks = true
        xAxis.style.drawMinorTicks = true
        // drawing labels is enabled by default to. If set to false, there will be no labels on axis. Labels are placed at majot tick position
        xAxis.style.drawLabels = true
        // major ticks are marks on axis that are located at label
        // length of major tick in points
        xAxis.style.majorTickSize = 5
        // color and thicknes of major tick
        xAxis.style.majorTickBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        // minor ticks are marks on axis that fills space between major ticks
        // length of minor tick in points
        xAxis.style.minorTickSize = 2
        // color and thicknes of minor tick
        xAxis.style.minorTickBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)
        
        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        // setting axis band color. Band is filled area between major grid lines
        yRightAxis.style.gridBandBrush = SCISolidBrushStyle(colorCode: 0x70000000)
        // changing major grid line color and thicknes. major grid line is line at the label position
        yRightAxis.style.majorGridLineBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        // changing minor grid line color and thicknes. minor grid lines are located between major grid lines
        yRightAxis.style.minorGridLineBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)
        // set custom label provider for axis. Label provider defines text for labels
        yRightAxis.labelProvider = ThousandsLabelProvider()
        // axis label color
        yRightAxis.style.labelStyle.color = .darkGray
        // axis label font size
        yRightAxis.style.labelStyle.fontSize = 12
        // major ticks are marks on axis that are located at label
        // length of major tick in points
        yRightAxis.style.majorTickSize = 3
        // color and thicknes of major tick
        yRightAxis.style.majorTickBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        // minor ticks are marks on axis that fills space between major ticks
        // length of minor tick in points
        yRightAxis.style.minorTickSize = 2
        // color and thicknes of minor tick
        yRightAxis.style.minorTickBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)

        let yLeftAxis = SCINumericAxis()
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(3))
        yLeftAxis.axisAlignment = .left;
        yLeftAxis.autoRange = .always;
        yLeftAxis.axisId = "SecondaryAxisId";
        // we are disabling bands and grid on secondary Y axis
        yLeftAxis.style.drawMajorBands = false
        yLeftAxis.style.drawMajorGridLines = false
        yLeftAxis.style.drawMinorGridLines = false
        // set custom label provider for axis
        yLeftAxis.labelProvider = BillionsLabelProvider()
        // axis label color
        yLeftAxis.style.labelStyle.color = .darkGray
        // axis label font size
        yLeftAxis.style.labelStyle.fontSize = 12
        // major ticks are marks on axis that are located at label
        // length of major tick in points
        yLeftAxis.style.majorTickSize = 3
        // color and thicknes of major tick
        yLeftAxis.style.majorTickBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        // minor ticks are marks on axis that fills space between major ticks
        // length of minor tick in points
        yLeftAxis.style.minorTickSize = 2
        // color and thicknes of minor tick
        yLeftAxis.style.minorTickBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yRightAxis)
        surface.yAxes.add(yLeftAxis)
    }
    
    func setupRenderableSeries() {
        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        mountainDataSeries.seriesName = "Mountain Series"
        let lineDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        lineDataSeries.seriesName = "Line Series"
        let columnDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        columnDataSeries.seriesName = "Column Series"
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float)
        candlestickDataSeries.seriesName = "Candlestick Series"
        
        let averageHigh = SCSMovingAverage(length: 50)
        
        let dataSource = SCSDataManager.loadThemeData()
        for i in 0..<dataSource.count {
            let item = dataSource[i]
            
            let xValue = SCIGeneric(i)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)
            
            mountainDataSeries.appendX(xValue, y: SCIGeneric(item.close - 1000))
            lineDataSeries.appendX(xValue, y: SCIGeneric(averageHigh.push(item.close).current))
            columnDataSeries.appendX(xValue, y: SCIGeneric(item.volume))
            candlestickDataSeries.appendX(xValue, open: open, high: high, low: low, close: close)
        }
        
        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = mountainDataSeries
        mountainRenderableSeries.yAxisId = "PrimaryAxisId"
        // mountain series area fill
        mountainRenderableSeries.style.areaStyle = SCISolidBrushStyle(colorCode: 0xA000D0D0)
        // mountain series line (just on top of mountain). If set to nil, there will be no line
        mountainRenderableSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF00D0D0, withThickness: 2)
        // setting to true gives jagged mountains. set to false if you want regular mountain chart
        mountainRenderableSeries.isDigitalLine = true
        
        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.yAxisId = "PrimaryAxisId"
        // line series color and thickness
        lineRenderableSeries.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0000FF, withThickness: 3)
        // setting to true gives jagged line. set to false if you want regular line chart
        lineRenderableSeries.isDigitalLine = false
        // one of the options for point markers. That one uses core graphics drawing to render texture for point markers
        let pointMarker : SCICoreGraphicsPointMarker = SCICoreGraphicsPointMarker()
        pointMarker.height = 7
        pointMarker.width = 7
        // point marers at data points. set to nil if you don't need them
        lineRenderableSeries.style.pointMarker = pointMarker;
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.dataSeries = columnDataSeries
        columnRenderableSeries.yAxisId = "SecondaryAxisId"
        // column series fill color
        columnRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(colorCode: 0xE0D030D0)
        // column series outline color and width. It is set to nil to disable outline
        columnRenderableSeries.style.strokeStyle = nil
        
        let candlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
        candlestickRenderableSeries.dataSeries = candlestickDataSeries
        candlestickRenderableSeries.yAxisId = "PrimaryAxisId"
        // candlestick series has separate color for data where close is higher that open value (up) and oposite when close is lower than open (down)
        // candlestick stroke color and thicknes for "up" data
        candlestickRenderableSeries.style.strokeUpStyle = SCISolidPenStyle(colorCode: 0xFF00FF00, withThickness: 1)
        // candlestick fill color for "up" data
        candlestickRenderableSeries.style.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0x7000FF00)
        // candlestick stroke color and thicknes for "down" data
        candlestickRenderableSeries.style.strokeDownStyle = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 1)
        // candlestick fill color for "down" data
        candlestickRenderableSeries.style.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0xFFFF0000)
        
        surface.renderableSeries.add(mountainRenderableSeries)
        surface.renderableSeries.add(lineRenderableSeries)
        surface.renderableSeries.add(columnRenderableSeries)
        surface.renderableSeries.add(candlestickRenderableSeries)
    }
}
