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

@synthesize sciChartSurfaceView;
@synthesize surface;

-(SCIFastCandlestickRenderableSeries*) getPriceRenderableSeries:(bool) isRevered
                                                          count:(int) count{
    
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float
                                                                            YType:SCIDataType_Float
                                                                       SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager loadPriceData: ohlcDataSeries
                      fileName:@"FinanceData"
                    isReversed:isRevered
                         count:count];
    
    SCIFastCandlestickRenderableSeries * candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    [candlestickRenderableSeries setDataSeries: ohlcDataSeries];
    
    candlestickRenderableSeries.style.strokeUpStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF00AA00 withThickness:0.7];
    candlestickRenderableSeries.style.fillUpBrushStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x9000AA00];
    candlestickRenderableSeries.style.strokeDownStyle  = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF0000 withThickness:0.7];
    candlestickRenderableSeries.style.fillDownBrushStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x90FF0000];
    
    candlestickRenderableSeries.dataAggregation = SCIGeneric(10);
    
    return candlestickRenderableSeries;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    [surface free];
    
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [surface.yAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    axis = [[SCINumericAxis alloc] init];
    [surface.xAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    SCIXAxisDragModifier * xAxisDragModifier = [SCIXAxisDragModifier new];
    xAxisDragModifier.dragMode = SCIAxisDragMode_Scale;
    xAxisDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yAxisDragModifier = [SCIYAxisDragModifier new];
    yAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCITooltipModifier * tooltip = [[SCITooltipModifier alloc] init];
    
    SCIChartModifierCollection * modifierGroup = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xAxisDragModifier, yAxisDragModifier, pzm, zem, tooltip]];
    
    surface.chartModifiers = modifierGroup;
    
    
    id<SCIRenderableSeriesProtocol> chart = [self getPriceRenderableSeries:FALSE count:30];
    [surface.renderableSeries add:chart];
    [surface invalidateElement];
}

@end
