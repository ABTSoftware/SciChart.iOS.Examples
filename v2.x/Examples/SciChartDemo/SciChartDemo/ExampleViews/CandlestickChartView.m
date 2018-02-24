//
//  CandlestickViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "CandlestickChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation CandlestickChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void) initializeSurfaceData {
    PriceSeries * priceSeries = [DataManager getPriceDataIndu];
    int size = priceSeries.size;
    
    id<SCIAxis2DProtocol> xAxis = [SCICategoryDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(size - 30) Max:SCIGeneric(size)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIOhlcDataSeries * dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    [dataSeries appendRangeX:SCIGeneric(priceSeries.dateData) Open:SCIGeneric(priceSeries.openData) High:SCIGeneric(priceSeries.highData) Low:SCIGeneric(priceSeries.lowData) Close:SCIGeneric(priceSeries.closeData) Count:priceSeries.size];
    
    SCIFastCandlestickRenderableSeries * rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeUpStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF00AA00 withThickness:1];
    rSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x9000AA00];
    rSeries.strokeDownStyle  = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF0000 withThickness:1];
    rSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x90FF0000];
    
    SCIWaveRenderableSeriesAnimation * animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
}

@end
