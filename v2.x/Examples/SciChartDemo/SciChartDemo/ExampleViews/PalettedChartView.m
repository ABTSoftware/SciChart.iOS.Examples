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

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        
        NSDictionary * layout = @{@"SciChart":self.surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(150.0) Max:SCIGeneric(165.0)];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    PriceSeries * priceData = [DataManager getPriceDataIndu];
    double offset = -1000;
    double offsetOpenData[priceData.size];
    double offsetHighData[priceData.size];
    double offsetLowData[priceData.size];
    double offsetCloseData[priceData.size];

    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIOhlcDataSeries * candleStickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    [mountainDataSeries appendRangeX:SCIGeneric(priceData.indexesAsDouble) Y:SCIGeneric(priceData.lowData) Count:priceData.size];
    [lineDataSeries appendRangeX:SCIGeneric(priceData.indexesAsDouble) Y:SCIGeneric([DataManager offsetArray:priceData.closeData destArray:offsetCloseData count:priceData.size offset:-offset]) Count:priceData.size];
    [columnDataSeries appendRangeX:SCIGeneric(priceData.indexesAsDouble) Y:SCIGeneric([DataManager offsetArray:priceData.closeData destArray:offsetCloseData count:priceData.size offset:offset * 3]) Count:priceData.size];
    [ohlcDataSeries appendRangeX:SCIGeneric(priceData.indexesAsDouble)
                            Open:SCIGeneric(priceData.openData)
                            High:SCIGeneric(priceData.highData)
                             Low:SCIGeneric(priceData.lowData)
                           Close:SCIGeneric(priceData.closeData)
                           Count:priceData.size];
    [candleStickDataSeries appendRangeX:SCIGeneric(priceData.indexesAsDouble)
                                   Open:SCIGeneric([DataManager offsetArray:priceData.openData destArray:offsetOpenData count:priceData.size offset:offset])
                                   High:SCIGeneric([DataManager offsetArray:priceData.highData destArray:offsetHighData count:priceData.size offset:offset])
                                    Low:SCIGeneric([DataManager offsetArray:priceData.lowData destArray:offsetLowData count:priceData.size offset:offset])
                                  Close:SCIGeneric([DataManager offsetArray:priceData.closeData destArray:offsetCloseData count:priceData.size offset:offset])
                                  Count:priceData.size];
    [scatterDataSeries appendRangeX:SCIGeneric(priceData.indexesAsDouble) Y:SCIGeneric([DataManager offsetArray:priceData.closeData destArray:offsetCloseData count:priceData.size offset:offset * 2.5]) Count:priceData.size];

    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x9787CEEB];
    mountainSeries.strokeStyle  = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF00FF withThickness:1.0];
    mountainSeries.zeroLineY = 6000;
    mountainSeries.paletteProvider = [CustomPalette new];

    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor: [UIColor redColor]];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColor: [UIColor orangeColor] withThickness:2.0];
    ellipsePointMarker.height = 10;
    ellipsePointMarker.width = 10;

    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF0000FF withThickness:1.0];
    lineSeries.pointMarker = ellipsePointMarker;
    lineSeries.paletteProvider = [CustomPalette new];

    SCIFastOhlcRenderableSeries * ohlcSeries = [SCIFastOhlcRenderableSeries new];
    ohlcSeries.dataSeries = ohlcDataSeries;
    ohlcSeries.paletteProvider = [CustomPalette new];

    SCIFastCandlestickRenderableSeries * candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = candleStickDataSeries;
    candlestickSeries.paletteProvider = [CustomPalette new];

    SCIFastColumnRenderableSeries * columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = columnDataSeries;
    columnSeries.strokeStyle = nil;
    columnSeries.zeroLineY = 6000;
    columnSeries.dataPointWidth = 0.8;
    columnSeries.fillBrushStyle = [[SCISolidBrushStyle alloc]initWithColor:[UIColor blueColor]];
    columnSeries.paletteProvider = [CustomPalette new];

    SCISquarePointMarker * squarePointMarker = [[SCISquarePointMarker alloc]init];
    squarePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor: [UIColor redColor]];
    squarePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColor: [UIColor orangeColor] withThickness:2.0];
    squarePointMarker.height = 7;
    squarePointMarker.width = 7;

    SCIXyScatterRenderableSeries * scatterSeries = [SCIXyScatterRenderableSeries new];
    scatterSeries.dataSeries = scatterDataSeries;
    scatterSeries.pointMarker = squarePointMarker;
    scatterSeries.paletteProvider = [CustomPalette new];

    [self addAnimationToSeries:mountainSeries];
    [self addAnimationToSeries:lineSeries];
    [self addAnimationToSeries:ohlcSeries];
    [self addAnimationToSeries:candlestickSeries];
    [self addAnimationToSeries:columnSeries];
    [self addAnimationToSeries:scatterSeries];

    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIBoxAnnotation * boxAnnotation = [SCIBoxAnnotation new];
    boxAnnotation.coordinateMode = SCIAnnotationCoordinate_RelativeY;
    boxAnnotation.x1 = SCIGeneric(152);
    boxAnnotation.y1 = SCIGeneric(1.0);
    boxAnnotation.x2 = SCIGeneric(158);
    boxAnnotation.y2 = SCIGeneric(0.0);
    boxAnnotation.style.fillBrush = [[SCILinearGradientBrushStyle alloc]initWithColorStart:[UIColor fromARGBColorCode:0x550000FF] finish:[UIColor fromARGBColorCode:0x55FFFF00] direction:(SCILinearGradientDirection_Vertical)];
    boxAnnotation.style.borderPen = [[SCISolidPenStyle alloc]initWithColor: [UIColor fromARGBColorCode:0xFF279B27] withThickness:1.0];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:mountainSeries];
        [surface.renderableSeries add:lineSeries];
        [surface.renderableSeries add:ohlcSeries];
        [surface.renderableSeries add:candlestickSeries];
        [surface.renderableSeries add:columnSeries];
        [surface.renderableSeries add:scatterSeries];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCITooltipModifier new]]];
        [surface.annotations add:boxAnnotation];
    }];
}

- (void)addAnimationToSeries:(id<SCIRenderableSeriesProtocol>)series {
    SCIScaleRenderableSeriesAnimation * animation = [[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic];
    [animation startAfterDelay:0.3];
    [series addAnimation:animation];
}

@end
