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
        // surface background. If you set color for chart background than it is color only for axes area
        surface.backgroundColor = .orange
        // chart area (viewport) background fill color
        surface.renderableSeriesAreaFill = SCISolidBrushStyle(colorCode: 0xFFFFB6C1)
        // chart area border color and thickness
        surface.renderableSeriesAreaBorder = SCISolidPenStyle(colorCode: 0xFF4682b4, withThickness: 2)
    }
    
    func setupAxes () {
        
        // Brushes and styles for the XAxis, vertical gridlines, vertical tick marks, vertical axis bands and xaxis labels
        let xAxisGridBandBrush = SCISolidBrushStyle(colorCode: 0x55ff6655)
        let xAxisMajorGridLineBrush = SCISolidPenStyle(color: .green, withThickness: 1)
        let xAxisMinorGridLineBrush = SCISolidPenStyle(color: .yellow, withThickness: 0.5, andStrokeDash: [10, 3, 10, 3])
        let xAxisMajorTickBrush = SCISolidPenStyle(color: .green, withThickness: 1)
        let xAxisMinorTickBrush = SCISolidPenStyle(color: .yellow, withThickness: 0.5, andStrokeDash: [10, 3, 10, 3])
        let xAxisLabelColor = UIColor.purple
        let xAxisFontName = "Helvetica"
        let xAxisFontSize : Float=14.0
        let xAxisDrawLabels : Bool=true
        let xAxisDrawMajorTicks : Bool=true
        let xAxisDrawMinorTicks : Bool=true
        let xAxisDrawMajorGridlines : Bool=true
        let xAxisDrawMinorGridlines : Bool=true
        
        // Create the XAxis
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(150), max: SCIGeneric(180))
        
        // Apply styles to the XAxis (see above)
        xAxis.style.gridBandBrush = xAxisGridBandBrush;
        xAxis.style.majorGridLineBrush = xAxisMajorGridLineBrush
        xAxis.style.minorGridLineBrush = xAxisMinorGridLineBrush
        xAxis.style.labelStyle.color = xAxisLabelColor
        xAxis.style.labelStyle.fontName = xAxisFontName
        xAxis.style.labelStyle.fontSize = xAxisFontSize
        xAxis.style.drawMajorTicks = xAxisDrawMajorTicks
        xAxis.style.drawMinorTicks = xAxisDrawMinorTicks
        xAxis.style.drawMajorGridLines = xAxisDrawMajorGridlines
        xAxis.style.drawMinorGridLines = xAxisDrawMinorGridlines
        xAxis.style.drawLabels = xAxisDrawLabels
        xAxis.style.majorTickSize = 5
        xAxis.style.majorTickBrush = xAxisMajorTickBrush
        xAxis.style.minorTickSize = 2
        xAxis.style.minorTickBrush = xAxisMinorTickBrush
        
        // Brushes and styles for the Right YAxis, horizontal gridlines, horizontal tick marks, horizontal axis bands and right yaxis labels
        let yRightAxisMajorTickBrush = SCISolidPenStyle(color: .purple, withThickness: 1)
        let yRightAxisMinorTickBrush = SCISolidPenStyle(color: .red, withThickness: 0.5)
        let yRightAxisMajorBandBrush = SCISolidBrushStyle(colorCode: 0x55ff6655)
        let yRightAxisMajorGridLineBrush = SCISolidPenStyle(color: .green, withThickness: 1)
        let yRightAxisMinorGridLineBrush = SCISolidPenStyle(color: .yellow, withThickness: 0.5, andStrokeDash: [10, 3, 10, 3])
        let yRightAxisLabelFormatter = ThousandsLabelProvider() // see LabelProvider API documentation for more info
        let yRightAxisLabelColor = UIColor.green
        let yRightAxisFontSize : Float=12.0
        let yRightAxisDrawLabels : Bool=true
        let yRightAxisDrawMajorTicks : Bool=true
        let yRightAxisDrawMinorTicks : Bool=true
        let yRightAxisDrawMajorGridlines : Bool=true
        let yRightAxisDrawMinorGridlines : Bool=true
        
        // Create the Right YAxis
        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        
        // Apply styles to the Right YAxis (see above)
        yRightAxis.style.gridBandBrush = yRightAxisMajorBandBrush
        yRightAxis.style.majorGridLineBrush = yRightAxisMajorGridLineBrush
        yRightAxis.style.minorGridLineBrush = yRightAxisMinorGridLineBrush
        yRightAxis.labelProvider = yRightAxisLabelFormatter
        yRightAxis.style.labelStyle.color = yRightAxisLabelColor
        yRightAxis.style.labelStyle.fontSize = yRightAxisFontSize
        yRightAxis.style.majorTickSize = 3
        yRightAxis.style.majorTickBrush = yRightAxisMajorTickBrush
        yRightAxis.style.minorTickSize = 2
        yRightAxis.style.minorTickBrush = yRightAxisMinorTickBrush
        yRightAxis.style.drawMajorTicks = yRightAxisDrawMajorTicks
        yRightAxis.style.drawMinorTicks = yRightAxisDrawMinorTicks
        yRightAxis.style.drawMajorGridLines = yRightAxisDrawMajorGridlines
        yRightAxis.style.drawMinorGridLines = yRightAxisDrawMinorGridlines
        yRightAxis.style.drawLabels = yRightAxisDrawLabels

        // Brushes and styles for the Left YAxis, horizontal gridlines, horizontal tick marks, horizontal axis bands and left yaxis labels
        let yLeftAxisMajorTickBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        let yLeftAxisMinorTickBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)
        let yLeftAxisLabelFormatter = BillionsLabelProvider() // See LabelProvider API documentation
        let yLeftAxisLabelColor = UIColor.darkGray
        let yLeftAxisFontSize : Float=12.0
        let yLeftAxisDrawMajorBands : Bool=false
        let yLeftAxisDrawLabels : Bool=true
        let yLeftAxisDrawMajorTicks : Bool=true
        let yLeftAxisDrawMinorTicks : Bool=true
        let yLeftAxisDrawMajorGridlines : Bool=false
        let yLeftAxisDrawMinorGridlines : Bool=false

        
        // Create the left YAxis
        let yLeftAxis = SCINumericAxis()
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(3))
        yLeftAxis.axisAlignment = .left;
        yLeftAxis.autoRange = .always;
        yLeftAxis.axisId = "SecondaryAxisId";
        
        // Apply styles to the left YAxis (see above)
        yLeftAxis.style.drawMajorBands = yLeftAxisDrawMajorBands
        yLeftAxis.style.drawMajorGridLines = yLeftAxisDrawMajorGridlines
        yLeftAxis.style.drawMinorGridLines = yLeftAxisDrawMinorGridlines
        yLeftAxis.style.drawMajorTicks = yLeftAxisDrawMajorTicks
        yLeftAxis.style.drawMinorTicks = yLeftAxisDrawMinorTicks
        yLeftAxis.style.drawLabels = yLeftAxisDrawLabels
        yLeftAxis.labelProvider = yLeftAxisLabelFormatter
        yLeftAxis.style.labelStyle.color = yLeftAxisLabelColor
        yLeftAxis.style.labelStyle.fontSize = yLeftAxisFontSize
        yLeftAxis.style.majorTickSize = 3
        yLeftAxis.style.majorTickBrush = yLeftAxisMajorTickBrush
        yLeftAxis.style.minorTickSize = 2
        yLeftAxis.style.minorTickBrush = yLeftAxisMinorTickBrush
        
        // Add the axes to the chart
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
        
        mountainRenderableSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        lineRenderableSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        columnRenderableSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        candlestickRenderableSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        surface.renderableSeries.add(mountainRenderableSeries)
        surface.renderableSeries.add(lineRenderableSeries)
        surface.renderableSeries.add(columnRenderableSeries)
        surface.renderableSeries.add(candlestickRenderableSeries)
    }
}
