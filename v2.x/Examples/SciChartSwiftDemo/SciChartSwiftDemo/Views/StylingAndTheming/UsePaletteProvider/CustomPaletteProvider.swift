//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomPaletteProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import SciChart

enum RenderableSeriesType {
    case line
    case column
    case ohlc
    case mountain
    case candles
    case scatter
    case none
}

class CustomPaletteProvider: SCIPaletteProvider {
    
    private let lineSeriesStyle = SCILineSeriesStyle()
    private let columnSeriesStyle = SCIColumnSeriesStyle()
    private let ohlcSeriesStyle = SCIOhlcSeriesStyle()
    private let candleStickSeriesStyle = SCICandlestickSeriesStyle()
    private let mountainSeriesStyle = SCIMountainSeriesStyle()
    private let scatterSeriesStyle = SCIScatterSeriesStyle()
    
    private let startIndex: Int32 = 152
    private let endIndex: Int32 = 158
    
    private var seriesType: RenderableSeriesType = .none
    
    override init() {
        super.init()
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.width = 7
        ellipsePointMarker.height = 7
        ellipsePointMarker.fillStyle = SCISolidBrushStyle.init(color: UIColor.red)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle.init(color: UIColor.red, withThickness: 1.0)
        
        lineSeriesStyle.pointMarker = ellipsePointMarker
        lineSeriesStyle.strokeStyle = SCISolidPenStyle.init(color: UIColor.red, withThickness: 1.0)
        
        mountainSeriesStyle.areaStyle = SCISolidBrushStyle.init(color: UIColor.red)
        mountainSeriesStyle.strokeStyle = SCISolidPenStyle.init(color: UIColor.red, withThickness: 1.0)
        
        let squarePointMarker = SCISquarePointMarker()
        squarePointMarker.width = 7
        squarePointMarker.height = 7
        squarePointMarker.fillStyle = SCISolidBrushStyle.init(color:UIColor.green)
        scatterSeriesStyle.pointMarker = squarePointMarker
        
        ohlcSeriesStyle.strokeUpStyle = SCISolidPenStyle.init(colorCode:0xFF6495ED, withThickness:1.0)
        ohlcSeriesStyle.strokeDownStyle = SCISolidPenStyle.init(colorCode:0xFF6495ED, withThickness:1.0)
        
        candleStickSeriesStyle.fillUpBrushStyle = SCISolidBrushStyle.init(color:UIColor.green)
        candleStickSeriesStyle.fillDownBrushStyle = SCISolidBrushStyle.init(color:UIColor.green)
        
        columnSeriesStyle.fillBrushStyle = SCISolidBrushStyle.init(color:UIColor.purple)
    }
    
    override func updateData(_ data: SCIRenderPassDataProtocol!) {
        if data.renderableSeries() is SCIFastLineRenderableSeries{
            seriesType = .line
        }
        if data.renderableSeries() is SCIFastColumnRenderableSeries{
            seriesType = .column
        }
        if data.renderableSeries() is SCIXyScatterRenderableSeries{
            seriesType = .scatter
        }
        if data.renderableSeries() is SCIFastCandlestickRenderableSeries{
            seriesType = .candles
        }
        if data.renderableSeries() is SCIFastMountainRenderableSeries{
            seriesType = .mountain
        }
        if data.renderableSeries() is SCIFastOhlcRenderableSeries{
            seriesType = .ohlc
        }
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        let isInRange: Bool = (index >= startIndex) && (index <= endIndex)
        
        if (isInRange){
            switch seriesType {
            case .line:
                return lineSeriesStyle;
            case .column:
                return columnSeriesStyle;
            case .ohlc:
                return ohlcSeriesStyle;
            case .candles:
                return candleStickSeriesStyle;
            case .mountain:
                return mountainSeriesStyle;
            case .scatter:
                return scatterSeriesStyle;
            case .none:
                return nil
            }
        }
        return nil;
    }
}
