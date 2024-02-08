//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VolumeProfileStockChartFragment.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************


class VolumeProfileStockChartFragment: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    private let VOLUME_XAXIS = "VolumeXAxis";
    private let PRICES_XAXIS = "PricesXAxis";
    private let VOLUME_YAXIS = "VolumeYAxis";
    private let PRICES_YAXIS = "PricesYAxis";
    
    override func initExample() {
        let SCDPriceSeries = SCDDataManager.getPriceDataEurUsd()
        
        initPrice(model: SCDPriceSeries)
        initVolume(model: SCDPriceSeries)
    }
    
    private func initPrice(model: SCDPriceSeries) {
        
        let xAxis = SCICategoryDateAxis()
        xAxis.visibleRange = SCIDoubleRange()
        xAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.05)
        xAxis.axisId = PRICES_XAXIS
        
        let yAxis = SCINumericAxis()
        yAxis.textFormatting = "$0.0000"
        yAxis.axisId = PRICES_YAXIS
        yAxis.autoRange = .always
        yAxis.minorsPerMajor = 4
        yAxis.maxAutoTicks = 8
        
        let growBy = 0.05
        yAxis.growBy = SCIDoubleRange(min: growBy, max: growBy)
        
        // Add the main OHLC chart
        let stockPrices = SCIOhlcDataSeries(xType: .date, yType: .double)
        stockPrices.seriesName = "EUR/USD"
        stockPrices.append(x: model.dateData, open: model.openData, high: model.highData, low: model.lowData, close: model.closeData)
        
        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = stockPrices
        candlestickSeries.yAxisId = PRICES_YAXIS
        candlestickSeries.xAxisId = PRICES_XAXIS
        
        let xAxisDragModifier = SCIXAxisDragModifier()
        xAxisDragModifier.dragMode = .pan
        xAxisDragModifier.clipModeX = .stretchAtExtents
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.direction = .xDirection
        
        let legendModifier = SCILegendModifier()
        legendModifier.showCheckBoxes = false
        
        var annotations = SCIAxisMarkerAnnotation()
        annotations = addAxisMarkerAnnotationWith(PRICES_YAXIS, xAxisId: PRICES_XAXIS, format: "$%.4f", value: stockPrices.yValues.value(at: stockPrices.count - 1), color: SCIColor.fromARGBColorCode(0xFF67BDAF))
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(candlestickSeries)
            self.surface.annotations.add(annotations)
            self.surface.chartModifiers.add(items: xAxisDragModifier, pinchZoomModifier, SCIZoomPanModifier(), SCIZoomExtentsModifier(), legendModifier)
        }
    }
    
    private func initVolume(model: SCDPriceSeries) {
        
        let xAxis = SCICategoryDateAxis()
        xAxis.visibleRange = SCIDoubleRange()
        xAxis.growBy = SCIDoubleRange(min: 0.0, max: 0.05)
        xAxis.isVisible = false
        xAxis.axisId = VOLUME_XAXIS
        xAxis.axisAlignment = .left
        
        let yAxis = SCINumericAxis()
        yAxis.textFormatting = "$0.0000"
        yAxis.axisId = VOLUME_YAXIS
        yAxis.isVisible = false
        yAxis.axisAlignment = .top
        yAxis.autoRange = .always
        yAxis.minorsPerMajor = 4
        yAxis.maxAutoTicks = 8
        let growBy = 0.05
        yAxis.growBy = SCIDoubleRange(min: growBy, max: growBy)
        
        let volumePrices = SCIXyDataSeries(xType: .date, yType: .long)
        volumePrices.seriesName = "Volume"
        volumePrices.append(x: model.dateData, y: model.volumeData)

        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = volumePrices
        columnSeries.yAxisId = VOLUME_YAXIS
        columnSeries.xAxisId = VOLUME_XAXIS
        columnSeries.fillBrushStyle = SCISolidBrushStyle(color: 0x30FFFFFF)
        columnSeries.strokeStyle = SCISolidPenStyle(color: 0x30FFFFFF, thickness: 1)

        let xAxisDragModifier = SCIXAxisDragModifier()
        xAxisDragModifier.dragMode = .pan
        xAxisDragModifier.clipModeX = .stretchAtExtents

        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.direction = .xDirection

        let legendModifier = SCILegendModifier()
        legendModifier.showCheckBoxes = false

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(columnSeries)
            self.surface.chartModifiers.add(items: xAxisDragModifier, pinchZoomModifier, SCIZoomPanModifier(), SCIZoomExtentsModifier(), legendModifier)
        }
    }
    
    func addAxisMarkerAnnotationWith(_ yAxisId: String, xAxisId: String, format: String, value: ISCIComparable, color: SCIColor?) -> SCIAxisMarkerAnnotation {
        let axisMarkerAnnotation = SCIAxisMarkerAnnotation()
        axisMarkerAnnotation.yAxisId = yAxisId
        axisMarkerAnnotation.xAxisId = xAxisId
        axisMarkerAnnotation.set(y1: value.toDouble())
        axisMarkerAnnotation.coordinateMode = .absolute
        
        if let uiColor = color {
            axisMarkerAnnotation.backgroundBrush = SCISolidBrushStyle(color: uiColor)
        }
        
        axisMarkerAnnotation.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
        axisMarkerAnnotation.formattedValue = String(format: format, value.toDouble())

        return axisMarkerAnnotation
    }
}
