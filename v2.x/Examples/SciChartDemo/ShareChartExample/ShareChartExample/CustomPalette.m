//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomPalette.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomPalette.h"

@implementation CustomPalette {
    SCILineSeriesStyle * _lineSeriesStyle;
    SCIColumnSeriesStyle * _columnSeriesStyle;
    SCIOhlcSeriesStyle * _ohlcSeriesStyle;
    SCICandlestickSeriesStyle * _candleStickSeriesStyle;
    SCIMountainSeriesStyle * _mountainSeriesStyle;
    SCIScatterSeriesStyle * _scatterSeriesStyle;
    
    int _startIndex;
    int _endIndex;
    
    RenderableSeriesType _seriesType;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        _startIndex = 152;
        _endIndex = 158;
        
        SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
        [ellipsePointMarker setWidth:7];
        [ellipsePointMarker setHeight:7];
        [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc]initWithColor:[UIColor redColor]]];
        [ellipsePointMarker setStrokeStyle:[[SCISolidPenStyle alloc] initWithColor:[UIColor redColor] withThickness:1.0]];
        
        _lineSeriesStyle = [SCILineSeriesStyle new];
        [_lineSeriesStyle setPointMarker:ellipsePointMarker];
        [_lineSeriesStyle setStrokeStyle:[[SCISolidPenStyle alloc] initWithColor:[UIColor redColor] withThickness:1.0]];
        
        _mountainSeriesStyle = [SCIMountainSeriesStyle new];
        [_mountainSeriesStyle setAreaStyle:[[SCISolidBrushStyle alloc]initWithColor:[UIColor redColor]]];
        [_mountainSeriesStyle setStrokeStyle: [[SCISolidPenStyle alloc] initWithColor:[UIColor redColor] withThickness:1.0]];
        
        _scatterSeriesStyle = [SCIScatterSeriesStyle new];
        SCISquarePointMarker * squarePointMarker = [SCISquarePointMarker new];
        [squarePointMarker setWidth:7];
        [squarePointMarker setHeight:7];
        [squarePointMarker setFillStyle:[[SCISolidBrushStyle alloc]initWithColor:[UIColor greenColor]]];
        [_scatterSeriesStyle setPointMarker: squarePointMarker];
        
        _ohlcSeriesStyle = [SCIOhlcSeriesStyle new];
        [_ohlcSeriesStyle setStrokeUpStyle:[[SCISolidPenStyle alloc]initWithColorCode:0xFF6495ED withThickness:1.0]];
        [_ohlcSeriesStyle setStrokeDownStyle:[[SCISolidPenStyle alloc]initWithColorCode:0xFF6495ED withThickness:1.0]];
        
        _candleStickSeriesStyle = [SCICandlestickSeriesStyle new];
        [_candleStickSeriesStyle setFillUpBrushStyle: [[SCISolidBrushStyle alloc]initWithColor:[UIColor greenColor]]];
        [_candleStickSeriesStyle setFillDownBrushStyle: [[SCISolidBrushStyle alloc]initWithColor:[UIColor greenColor]]];
        
        _columnSeriesStyle = [SCIColumnSeriesStyle new];
        [_columnSeriesStyle setStrokeStyle:nil];
        [_columnSeriesStyle setFillBrushStyle:[[SCISolidBrushStyle alloc]initWithColor:[UIColor purpleColor]]];
    }
    return self;
}

-(void)updateData:(id<SCIRenderPassDataProtocol>)data {
    if ([data.renderableSeries isKindOfClass:[SCIFastLineRenderableSeries class]]) _seriesType = line;
    if ([data.renderableSeries isKindOfClass:[SCIFastOhlcRenderableSeries class]]) _seriesType = ohlc;
    if ([data.renderableSeries isKindOfClass:[SCIXyScatterRenderableSeries class]]) _seriesType = scatter;
    if ([data.renderableSeries isKindOfClass:[SCIFastMountainRenderableSeries class]]) _seriesType = mountain;
    if ([data.renderableSeries isKindOfClass:[SCIFastColumnRenderableSeries class]]) _seriesType = column;
    if ([data.renderableSeries isKindOfClass:[SCIFastCandlestickRenderableSeries class]]) _seriesType = candles;
}

-(id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    BOOL isInRange = index >= _startIndex && index <=_endIndex;
    
    if (isInRange){
        switch (_seriesType) {
            case line:
                return _lineSeriesStyle;
                break;
            case column:
                return _columnSeriesStyle;
                break;
            case ohlc:
                return _ohlcSeriesStyle;
                break;
            case candles:
                return _candleStickSeriesStyle;
                break;
            case mountain:
                return _mountainSeriesStyle;
                break;
            case scatter:
                return _scatterSeriesStyle;
                break;
        }
    }
    return nil;
}

@end

