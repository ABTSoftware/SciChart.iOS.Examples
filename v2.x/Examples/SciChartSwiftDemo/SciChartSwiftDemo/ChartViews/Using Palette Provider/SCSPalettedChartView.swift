//
//  SCSPalettedChartView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 08/22/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSPalettedChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addDefaultModifiers()
        addSeries()
        buildBoxAnnotation()
        
        chartSurface.invalidateElement()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(150), max: SCIGeneric(164))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        let priceDataSeries:SCIOhlcDataSeries = SCIOhlcDataSeries.init(xType: .dateTime, yType: .float, seriesType: .defaultType)
        SCSDataManager.getPriceIndu(dataSeries: priceDataSeries, fileName: "INDU_Daily")
        
        let offset:Float = -1000
        
        let xdata:SCIArrayController = SCIArrayController.init(type: .float)
        for i in 0..<priceDataSeries.count() {
            xdata.append(SCIGeneric(i))
        }
        
        let mountainDataSeries = SCIXyDataSeries.init(xType: .float, yType: .float, seriesType: .defaultType)
        var ac = offsetData(dataSeries: priceDataSeries.lowColumn as! (SCIArrayController), offset: offset*2)
        mountainDataSeries.appendRangeX(SCIGeneric(xdata.floatData()), y:SCIGeneric(ac.floatData()), count:priceDataSeries.count());
        
        let lineDataSeries = SCIXyDataSeries.init(xType: .float, yType: .float, seriesType: .defaultType)
        ac = offsetData(dataSeries: priceDataSeries.closeColumn as! (SCIArrayController), offset: -offset)
        lineDataSeries.appendRangeX(SCIGeneric(xdata.floatData()), y:SCIGeneric(ac.floatData()), count:priceDataSeries.count());
        
        let columnDataSeries = SCIXyDataSeries.init(xType: .float, yType: .float, seriesType: .defaultType)
        ac = offsetData(dataSeries: priceDataSeries.closeColumn as! (SCIArrayController), offset: offset*3)
        columnDataSeries.appendRangeX(SCIGeneric(xdata.floatData()), y:SCIGeneric(ac.floatData()), count:priceDataSeries.count());
        
        let scatterDataSeries = SCIXyDataSeries.init(xType: .float, yType: .float, seriesType: .defaultType)
        ac = offsetData(dataSeries: priceDataSeries.openColumn as! (SCIArrayController), offset: offset*2.5)
        scatterDataSeries.appendRangeX(SCIGeneric(xdata.floatData()), y:SCIGeneric(ac.floatData()), count:priceDataSeries.count());
        
        let candleDataSeries = SCIOhlcDataSeries.init(xType: .float, yType: .float, seriesType: .defaultType)
        let ac1 = offsetData(dataSeries: priceDataSeries.lowColumn as! (SCIArrayController), offset: offset)
        let ac2 = offsetData(dataSeries: priceDataSeries.lowColumn as! (SCIArrayController), offset: offset)
        let ac3 = offsetData(dataSeries: priceDataSeries.lowColumn as! (SCIArrayController), offset: offset)
        let ac4 = offsetData(dataSeries: priceDataSeries.lowColumn as! (SCIArrayController), offset: offset)
        candleDataSeries.appendRangeX(SCIGeneric(xdata.floatData()), open: SCIGeneric(ac1.floatData()), high: SCIGeneric(ac2.floatData()), low: SCIGeneric(ac3.floatData()), close: SCIGeneric(ac4.floatData()), count: priceDataSeries.count())
        
        let ohlcDataSeries = SCIOhlcDataSeries.init(xType: .float, yType: .float, seriesType: .defaultType)
        ohlcDataSeries.appendRangeX(SCIGeneric(xdata.floatData()), open: SCIGeneric(priceDataSeries.openColumn.floatData()), high: SCIGeneric(priceDataSeries.highColumn.floatData()), low: SCIGeneric(priceDataSeries.lowColumn.floatData()), close: SCIGeneric(priceDataSeries.closeColumn.floatData()), count: priceDataSeries.count())
        
        let mountainRS = SCIFastMountainRenderableSeries()
        mountainRS.dataSeries=mountainDataSeries
        mountainRS.style.areaBrush = SCISolidBrushStyle.init(colorCode: 0x9787CEEB)
        mountainRS.style.borderPen = SCISolidPenStyle.init(colorCode: 0xFFFF00FF, withThickness: 1.0)
        mountainRS.zeroLineY = 6000
        mountainRS.paletteProvider = SCSCustomPaletteProvider()
        chartSurface.renderableSeries.add(mountainRS)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle.init(color: UIColor.red)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle.init(color: UIColor.orange, withThickness: 2.0)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let lineRS = SCIFastLineRenderableSeries()
        lineRS.dataSeries = lineDataSeries
        lineRS.style.linePen = SCISolidPenStyle.init(colorCode: 0xFF0000FF, withThickness: 1.0)
        lineRS.style.drawPointMarkers = true
        lineRS.style.pointMarker = ellipsePointMarker
        lineRS.paletteProvider = SCSCustomPaletteProvider()
        chartSurface.renderableSeries.add(lineRS)
        
        let ohlcRS = SCIFastOhlcRenderableSeries()
        ohlcRS.dataSeries = ohlcDataSeries
        ohlcRS.paletteProvider = SCSCustomPaletteProvider()
        chartSurface.renderableSeries.add(ohlcRS)
        
        let candlesRS = SCIFastCandlestickRenderableSeries()
        candlesRS.dataSeries = candleDataSeries
        candlesRS.paletteProvider = SCSCustomPaletteProvider()
        chartSurface.renderableSeries.add(candlesRS)
        
        let columnRS = SCIFastColumnRenderableSeries()
        columnRS.dataSeries = columnDataSeries
        columnRS.style.drawBorders = false
        columnRS.zeroLineY = 6000
        columnRS.style.dataPointWidth = 0.8
        columnRS.style.fillBrush = SCISolidBrushStyle.init(color: UIColor.blue)
        columnRS.paletteProvider = SCSCustomPaletteProvider()
        chartSurface.renderableSeries.add(columnRS)
        
        let squarePointMarker = SCISquarePointMarker()
        squarePointMarker.fillStyle = SCISolidBrushStyle.init(color: UIColor.red)
        squarePointMarker.strokeStyle = SCISolidPenStyle.init(color: UIColor.orange, withThickness: 2.0)
        squarePointMarker.height = 7
        squarePointMarker.width = 7
        
        let scatterRS = SCIXyScatterRenderableSeries()
        scatterRS.dataSeries = scatterDataSeries
        scatterRS.style.pointMarker = squarePointMarker
        scatterRS.paletteProvider = SCSCustomPaletteProvider()
        chartSurface.renderableSeries.add(scatterRS)
    }
    
    private func offsetData(dataSeries:(SCIArrayController), offset:(Float)) -> SCIArrayController{
        let result = SCIArrayController.init(type:.float)
        for i in 0..<dataSeries.count() {
            var y:Float = SCIGenericFloat(dataSeries.value(at: i))
            y += offset;
            result?.append(SCIGeneric(y))
        }
        return result!;
    }
    
    private func buildBoxAnnotation(){
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.coordinateMode = .relativeY;
        boxAnnotation.x1 = SCIGeneric(152);
        boxAnnotation.y1 = SCIGeneric(1.0);
        boxAnnotation.x2 = SCIGeneric(158);
        boxAnnotation.y2 = SCIGeneric(0.0);
        boxAnnotation.style.fillBrush = SCILinearGradientBrushStyle.init(colorStart: UIColor.fromARGBColorCode(0x550000FF), finish: UIColor.fromARGBColorCode(0x55FFFF00), direction: .vertical)
        boxAnnotation.style.borderPen = SCISolidPenStyle.init(color: UIColor.fromARGBColorCode(0xFF279B27), withThickness: 1.0)
        
        chartSurface.annotation = boxAnnotation
    }
}
