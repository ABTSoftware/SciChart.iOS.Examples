//
//  SCSPalettedChartView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 08/22/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class MinMaxPaletteProvider: SCIPaletteProvider {
    
    var _styleMin : SCILineSeriesStyle
    var _styleMax : SCILineSeriesStyle
    var _minIndex : Int32
    var _maxIndex : Int32
    
    override init() {
        _styleMin = SCILineSeriesStyle()
        _styleMin.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        _styleMin.drawPointMarkers = true
        let minMarker = SCIEllipsePointMarker()
        minMarker.fillStyle = SCISolidBrushStyle(color: UIColor.cyan)
        _styleMin.pointMarker = minMarker
        
        _styleMax = SCILineSeriesStyle()
        _styleMax.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        _styleMax.drawPointMarkers = true
        let maxMarker = SCIEllipsePointMarker()
        maxMarker.fillStyle = SCISolidBrushStyle(color: UIColor.red)
        _styleMax.pointMarker = maxMarker
        
        _minIndex = 0
        _maxIndex = 0
    }
    
    override func updateData(_ data: SCIRenderPassDataProtocol!) {
        var minIndex : Int32 = 0;
        var minValue : Double = DBL_MAX;
        var maxIndex : Int32 = 0;
        var maxValue : Double = -DBL_MAX;
        let points : SCIPointSeriesProtocol = data.pointSeries();
        let count = points.count();
        for i in 0..<count {
            let value: Double = SCIGenericDouble( points.yValues().value( at: i ) );
            if (value < minValue) {
                minValue = value;
                minIndex = SCIGenericInt( points.indices().value( at: i ) );
            }
            if (value > maxValue) {
                maxValue = value;
                maxIndex = SCIGenericInt( points.indices().value( at: i ) );
            }
        }
        _minIndex = minIndex;
        _maxIndex = maxIndex;
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        if (index == _minIndex) {
            return _styleMin;
        } else if (index == _maxIndex) {
            return _styleMax;
        } else {
            return nil;
        }
    }
}

class ZeroLinePaletteProvider: SCIPaletteProvider {
    var _style : SCILineSeriesStyle
    var _zeroLine : Double
    var _yCoordCalc : SCICoordinateCalculatorProtocol!
    
    override init() {
        _style = SCILineSeriesStyle()
        _style.drawPointMarkers = false
        _style.linePen = SCISolidPenStyle(color: UIColor.blue, withThickness: 0.7)
        
        _zeroLine = 10
        
        _yCoordCalc = nil
    }
    
    override func updateData(_ data: SCIRenderPassDataProtocol!) {
         _yCoordCalc = data.yCoordinateCalculator()
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        let value : Double = _yCoordCalc.getDataValue(from: y)
        if (value < _zeroLine) {
            return _style
        } else  {
            return nil
        }
    }
}

class SCSPalettedChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    // MARK: Private Functions

    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addSeries() {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(dataSeries)
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putFourierDataInto(fourierDataSeries)
        
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        fourierDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        renderSeries.style.pointMarker = ellipsePointMarker
        renderSeries.style.drawPointMarkers = true
        renderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        chartSurface.renderableSeries.add(renderSeries)
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.dataSeries = fourierDataSeries
        fourierRenderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFFff8a4c, withThickness: 0.7)
        chartSurface.renderableSeries.add(fourierRenderSeries)
        
        renderSeries.paletteProvider = MinMaxPaletteProvider()
        fourierRenderSeries.paletteProvider = ZeroLinePaletteProvider()
        
        chartSurface.invalidateElement()
    }
    
}
