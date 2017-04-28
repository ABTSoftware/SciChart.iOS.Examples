//
//  PalettedChartView.m
//  SciChartDemo
//
//  Created by Admin on 21.08.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "PalettedChartView.h"
#import "DataManager.h"
#import <SciChart/SciChart.h>
#import "CustomPalette.h"

@implementation PalettedChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _sciChartSurfaceView = [[SCIChartSurfaceView alloc]init];
        
        [_sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartSurfaceView];
        
        NSDictionary *layout = @{@"SciChart":_sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    _surface = [[SCIChartSurface alloc] initWithView: _sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> axisY = [[SCINumericAxis alloc] init];
    axisY.axisId = @"yAxis";
    [_surface.yAxes add:axisY];
    
    id<SCIAxis2DProtocol> axisX = [[SCINumericAxis alloc] init];
    axisX.axisId = @"xAxis";
    [axisX setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(150.0) Max:SCIGeneric(165.0)]];
    [_surface.xAxes add:axisX];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    [zpm setModifierName:@"ZoomPan Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm]];
    _surface.chartModifier = gm;
    
    [self initializeSurfaceRenderableSeries];
    [self addBoxAnnotation];
    
    [_surface invalidateElement];
}

-(void) initializeSurfaceRenderableSeries {
    SCIOhlcDataSeries * priceDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [DataManager getPriceIndu:@"INDU_Daily" data:priceDataSeries];
    
    float offset = -1000;
    
    SCIArrayController * xdata = [[SCIArrayController alloc]initWithType:SCIDataType_Float];
    for (int i = 0; i<[priceDataSeries count]; i++) {
        [xdata append:SCIGeneric(i)];
    }
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIArrayController * ac = [self offset:[priceDataSeries lowColumn] offset:offset*2];
    [mountainDataSeries appendRangeX:SCIGeneric([xdata floatData])
                                   Y:SCIGeneric([ac floatData])
                               Count:[priceDataSeries count]];
    
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    ac = [self offset:[priceDataSeries closeColumn]  offset: -offset];
    [lineDataSeries appendRangeX:SCIGeneric([xdata floatData])
                                   Y:SCIGeneric([ac floatData])
                               Count:[priceDataSeries count]];
    
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    ac = [self offset:[priceDataSeries closeColumn] offset: offset*3];
    [columnDataSeries appendRangeX:SCIGeneric([xdata floatData])
                                   Y:SCIGeneric([ac floatData])
                               Count:[priceDataSeries count]];
    
    SCIXyDataSeries * scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    ac = [self offset:[priceDataSeries openColumn] offset: offset*2.5];
    [scatterDataSeries appendRangeX:SCIGeneric([xdata floatData])
                                   Y:SCIGeneric([ac floatData])
                               Count:[priceDataSeries count]];
    
    SCIOhlcDataSeries * candleDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIArrayController * ac1 = [self offset:[priceDataSeries openColumn] offset: offset];
    SCIArrayController * ac2 = [self offset:[priceDataSeries highColumn] offset: offset];
    SCIArrayController * ac3 = [self offset:[priceDataSeries lowColumn] offset: offset];
    SCIArrayController * ac4 = [self offset:[priceDataSeries closeColumn] offset: offset];
    [candleDataSeries appendRangeX:SCIGeneric([xdata floatData])
                              Open:SCIGeneric([ac1 floatData])
                              High:SCIGeneric([ac2 floatData])
                               Low:SCIGeneric([ac3 floatData])
                             Close:SCIGeneric([ac4 floatData])
                             Count:[priceDataSeries count]];
    
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [ohlcDataSeries appendRangeX:SCIGeneric([xdata floatData])
                              Open:SCIGeneric([[priceDataSeries openColumn] floatData])
                              High:SCIGeneric([[priceDataSeries highColumn] floatData])
                               Low:SCIGeneric([[priceDataSeries lowColumn] floatData])
                             Close:SCIGeneric([[priceDataSeries closeColumn] floatData])
                             Count:[priceDataSeries count]];
    
    SCIFastMountainRenderableSeries * mountainRS = [SCIFastMountainRenderableSeries new];
    [mountainRS setXAxisId: @"xAxis"];
    [mountainRS setYAxisId: @"yAxis"];
    [mountainRS setDataSeries:mountainDataSeries];
    [mountainRS.style setAreaBrush:[[SCISolidBrushStyle alloc]initWithColorCode:0x9787CEEB]];
    [mountainRS.style setBorderPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF00FF withThickness:1.0]];
    [mountainRS setZeroLineY:6000];
    [mountainRS setPaletteProvider: [CustomPalette new]];
    [_surface.renderableSeries add:mountainRS];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColor: [UIColor redColor]]];
    [ellipsePointMarker setStrokeStyle:[[SCISolidPenStyle alloc]initWithColor: [UIColor orangeColor] withThickness:2.0]];
    [ellipsePointMarker setHeight:10];
    [ellipsePointMarker setWidth:10];
    
    SCIFastLineRenderableSeries * lineRS = [SCIFastLineRenderableSeries new];
    [lineRS setXAxisId: @"xAxis"];
    [lineRS setYAxisId: @"yAxis"];
    [lineRS setDataSeries:lineDataSeries];
    [lineRS.style setLinePen:[[SCISolidPenStyle alloc]initWithColorCode:0xFF0000FF withThickness:1.0]];
    [lineRS.style setDrawPointMarkers:YES];
    [lineRS.style setPointMarker:ellipsePointMarker];
    [lineRS setPaletteProvider: [CustomPalette new]];
    [_surface.renderableSeries add:lineRS];
    
    SCIFastOhlcRenderableSeries * ohlcRS = [SCIFastOhlcRenderableSeries new];
    [ohlcRS setXAxisId: @"xAxis"];
    [ohlcRS setYAxisId: @"yAxis"];
    [ohlcRS setDataSeries:ohlcDataSeries];
    [ohlcRS setPaletteProvider: [CustomPalette new]];
    [_surface.renderableSeries add:ohlcRS];
    
    SCIFastCandlestickRenderableSeries * candlesRS = [SCIFastCandlestickRenderableSeries new];
    [candlesRS setXAxisId: @"xAxis"];
    [candlesRS setYAxisId: @"yAxis"];
    [candlesRS setDataSeries:candleDataSeries];
    [candlesRS setPaletteProvider: [CustomPalette new]];
    [_surface.renderableSeries add:candlesRS];
    
    SCIFastColumnRenderableSeries * columnRS = [SCIFastColumnRenderableSeries new];
    [columnRS setXAxisId: @"xAxis"];
    [columnRS setYAxisId: @"yAxis"];
    [columnRS setDataSeries:columnDataSeries];
    [columnRS.style setDrawBorders:NO];
    [columnRS setZeroLineY:6000];
    [columnRS.style setDataPointWidth:0.8];
    [columnRS.style setFillBrush:[[SCISolidBrushStyle alloc]initWithColor:[UIColor blueColor]]];
    [columnRS setPaletteProvider: [CustomPalette new]];
    [_surface.renderableSeries add:columnRS];
    
    SCISquarePointMarker * squarePointMarker = [[SCISquarePointMarker alloc]init];
    [squarePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColor: [UIColor redColor]]];
    [squarePointMarker setStrokeStyle:[[SCISolidPenStyle alloc]initWithColor: [UIColor orangeColor] withThickness:2.0]];
    [squarePointMarker setHeight:7];
    [squarePointMarker setWidth:7];
    
    SCIXyScatterRenderableSeries * scatterRS = [SCIXyScatterRenderableSeries new];
    [scatterRS setXAxisId: @"xAxis"];
    [scatterRS setYAxisId: @"yAxis"];
    [scatterRS setDataSeries:scatterDataSeries];
    [scatterRS.style setPointMarker:squarePointMarker];
    [scatterRS setPaletteProvider: [CustomPalette new]];
    [_surface.renderableSeries add:scatterRS];
}

-(SCIArrayController*) offset:(SCIArrayController*)dataSeries offset:(float)offset{
    SCIArrayController * result = [[SCIArrayController alloc] initWithType:SCIDataType_Float];
    for (int i =0; i<[dataSeries count]; i++) {
        float y = SCIGenericFloat([dataSeries valueAt:i]);
        y += offset;
        [result append:SCIGeneric(y)];
    }
    return result;
}

-(void)addBoxAnnotation{
    SCIBoxAnnotation * boxAnnotation = [[SCIBoxAnnotation alloc] init];
    boxAnnotation.coordinateMode = SCIAnnotationCoordinate_RelativeY;
    [boxAnnotation setXAxisId: @"xAxis"];
    [boxAnnotation setYAxisId: @"yAxis"];
    boxAnnotation.x1 = SCIGeneric(152);
    boxAnnotation.y1 = SCIGeneric(1.0);
    boxAnnotation.x2 = SCIGeneric(158);
    boxAnnotation.y2 = SCIGeneric(0.0);
    boxAnnotation.style.fillBrush = [[SCILinearGradientBrushStyle alloc]initWithColorStart:[UIColor fromARGBColorCode:0x550000FF] finish:[UIColor fromARGBColorCode:0x55FFFF00] direction:(SCILinearGradientDirection_Vertical)];
    boxAnnotation.style.borderPen = [[SCISolidPenStyle alloc]initWithColor: [UIColor fromARGBColorCode:0xFF279B27] withThickness:1.0];
    
    [_surface setAnnotation:boxAnnotation];
}

@end
