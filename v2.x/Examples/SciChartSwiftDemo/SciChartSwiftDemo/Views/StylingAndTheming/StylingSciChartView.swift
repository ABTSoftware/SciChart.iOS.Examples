//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StylingSciChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class StylingSciChartView: SingleChartLayout {
    
    override func initExample() {
        // surface background. If you set color for chart background than it is color only for axes area
        surface.backgroundColor = .orange
        // chart area (viewport) background fill color
        surface.renderableSeriesAreaFill = SCISolidBrushStyle(colorCode: 0xFFFFB6C1)
        // chart area border color and thickness
        surface.renderableSeriesAreaBorder = SCISolidPenStyle(colorCode: 0xFF4682b4, withThickness: 2)

        // Brushes and styles for the XAxis, vertical gridlines, vertical tick marks, vertical axis bands and xaxis labels
        let xAxisGridBandBrush = SCISolidBrushStyle(colorCode: 0x55ff6655)
        let xAxisMajorGridLineBrush = SCISolidPenStyle(color: .green, withThickness: 1)
        let xAxisMinorGridLineBrush = SCISolidPenStyle(color: .yellow, withThickness: 0.5, andStrokeDash: [10, 3, 10, 3])
        let xAxisMajorTickBrush = SCISolidPenStyle(color: .green, withThickness: 1)
        let xAxisMinorTickBrush = SCISolidPenStyle(color: .yellow, withThickness: 0.5, andStrokeDash: [10, 3, 10, 3])
        let xAxisLabelColor = UIColor.purple
        let xAxisFontName = "Helvetica"
        let xAxisFontSize: Float = 14.0
        let xAxisDrawLabels = true
        let xAxisDrawMajorTicks = true
        let xAxisDrawMinorTicks = true
        let xAxisDrawMajorGridlines = true
        let xAxisDrawMinorGridlines = true
        
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
        let yAxisMajorBandBrush = SCISolidBrushStyle(colorCode: 0x55ff6655)
        let yAxisMajorGridLineBrush = SCISolidPenStyle(color: .green, withThickness: 1)
        let yAxisMinorGridLineBrush = SCISolidPenStyle(color: .yellow, withThickness: 0.5, andStrokeDash: [10, 3, 10, 3])
        let yAxisMajorTickBrush = SCISolidPenStyle(color: .purple, withThickness: 1)
        let yAxisMinorTickBrush = SCISolidPenStyle(color: .red, withThickness: 0.5)
        let yAxisLabelColor = UIColor.green
        let yAxisFontName = "Helvetica"
        let yAxisFontSize: Float = 14.0
        let yAxisDrawLabels = true
        let yAxisDrawMajorTicks = true
        let yAxisDrawMinorTicks = true
        let yAxisDrawMajorGridlines = true
        let yAxisDrawMinorGridlines = true
        let yAxisLabelFormatter = ThousandsLabelProvider() // see LabelProvider API documentation for more info
        
        // Create the Right YAxis
        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        
        // Apply styles to the Right YAxis (see above)
        yRightAxis.style.gridBandBrush = yAxisMajorBandBrush
        yRightAxis.style.majorGridLineBrush = yAxisMajorGridLineBrush
        yRightAxis.style.minorGridLineBrush = yAxisMinorGridLineBrush
        yRightAxis.labelProvider = yAxisLabelFormatter
        yRightAxis.style.labelStyle.color = yAxisLabelColor
        yRightAxis.style.labelStyle.fontSize = yAxisFontSize
        yRightAxis.style.labelStyle.fontName = yAxisFontName
        yRightAxis.style.drawMajorTicks = yAxisDrawMajorTicks
        yRightAxis.style.drawMinorTicks = yAxisDrawMinorTicks
        yRightAxis.style.drawLabels = yAxisDrawLabels
        yRightAxis.style.drawMajorGridLines = yAxisDrawMajorGridlines
        yRightAxis.style.drawMinorGridLines = yAxisDrawMinorGridlines
        yRightAxis.style.majorTickSize = 3
        yRightAxis.style.majorTickBrush = yAxisMajorTickBrush
        yRightAxis.style.minorTickSize = 2
        yRightAxis.style.minorTickBrush = yAxisMinorTickBrush
        
        // Brushes and styles for the Left YAxis, horizontal gridlines, horizontal tick marks, horizontal axis bands and left yaxis labels
        let yLeftAxisMajorTickBrush = SCISolidPenStyle(color: .black, withThickness: 1)
        let yLeftAxisMinorTickBrush = SCISolidPenStyle(color: .black, withThickness: 0.5)
        let yLeftAxisLabelColor = UIColor.purple
        let yLeftAxisFontSize: Float = 12.0
        let yLeftAxisDrawLabels = true
        let yLeftAxisDrawMajorTicks = true
        let yLeftAxisDrawMinorTicks = true
        let yLeftAxisDrawMajorGridlines = false
        let yLeftAxisDrawMinorGridlines = false
        let yLeftAxisDrawMajorBands = false
        let yLeftAxisLabelFormatter = BillionsLabelProvider() // See LabelProvider API documentation
        
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
        
        // Create and populate data series
        let priceData = DataManager.getPriceDataIndu()
        let size = priceData!.size()
        
        let movingAverageArray = [Double](repeating: 0, count: Int(size))
        let movingAverageArrayPointer: UnsafeMutablePointer<Double> = UnsafeMutablePointer(mutating: movingAverageArray)
        
        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        mountainDataSeries.seriesName = "Mountain Series"
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        lineDataSeries.seriesName = "Line Series"
        let columnDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        columnDataSeries.seriesName = "Column Series"
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        candlestickDataSeries.seriesName = "Candlestick Series"
        
        mountainDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataArrayWithOffset(priceData!.closeData(), size: size, offset: -1000), count: size)
        let movingAverage = SCIGeneric(DataManager.computeMovingAverage(of: priceData!.closeData(), destArray: movingAverageArrayPointer, sourceArraySize: size, length: 50))
        lineDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: movingAverage, count: size)
        columnDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataLongArray(priceData!.volumeData()), count: size)
        candlestickDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()),
                                           open: DataManager.getGenericDataArray(priceData!.openData()),
                                           high: DataManager.getGenericDataArray(priceData!.highData()),
                                           low: DataManager.getGenericDataArray(priceData!.lowData()),
                                           close: DataManager.getGenericDataArray(priceData!.closeData()),
                                           count: size)
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = mountainDataSeries
        mountainSeries.yAxisId = "PrimaryAxisId"
        // mountain series area fill
        mountainSeries.areaStyle = SCISolidBrushStyle(colorCode: 0xA000D0D0)
        // mountain series line (just on top of mountain). If set to nil, there will be no line
        mountainSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF00D0D0, withThickness: 2)
        // setting to true gives jagged mountains. set to false if you want regular mountain chart
        mountainSeries.isDigitalLine = true
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.yAxisId = "PrimaryAxisId"
        // line series color and thickness
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0000FF, withThickness: 3)
        // setting to true gives jagged line. set to false if you want regular line chart
        lineSeries.isDigitalLine = false
        // one of the options for point markers. That one uses core graphics drawing to render texture for point markers
        let pointMarker = SCICoreGraphicsPointMarker()
        pointMarker.height = 7
        pointMarker.width = 7
        // point marers at data points. set to nil if you don't need them
        lineSeries.pointMarker = pointMarker
        
        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = columnDataSeries
        columnSeries.yAxisId = "SecondaryAxisId"
        // column series fill color
        columnSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: 0xE0D030D0)
        // column series outline color and width. It is set to nil to disable outline
        columnSeries.strokeStyle = nil

        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = candlestickDataSeries
        candlestickSeries.yAxisId = "PrimaryAxisId"
        // candlestick series has separate color for data where close is higher that open value (up) and oposite when close is lower than open (down)
        // candlestick stroke color and thicknes for "up" data
        candlestickSeries.strokeUpStyle = SCISolidPenStyle(colorCode: 0xFF00FF00, withThickness: 1)
        // candlestick fill color for "up" data
        candlestickSeries.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0x7000FF00)
        // candlestick stroke color and thicknes for "down" data
        candlestickSeries.strokeDownStyle = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 1)
        // candlestick fill color for "down" data
        candlestickSeries.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0xFFFF0000)

        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yRightAxis)
            self.surface.yAxes.add(yLeftAxis)
            self.surface.renderableSeries.add(mountainSeries)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(candlestickSeries)
            self.surface.renderableSeries.add(columnSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCICursorModifier(), SCIZoomExtentsModifier()])

            mountainSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            lineSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            columnSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            candlestickSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
        }
    }
}
