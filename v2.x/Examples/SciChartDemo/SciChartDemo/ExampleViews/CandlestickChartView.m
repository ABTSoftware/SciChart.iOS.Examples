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
                                                    upBodyBrush:(SCISolidBrushStyle*) upBodyColor
                                                  downBodyBrush:(SCISolidBrushStyle*) downBodyColor
                                                          count:(int) count{
    
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float
                                                                            YType:SCIDataType_Float
                                                                       SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager loadPriceData: ohlcDataSeries
                      fileName:@"FinanceData"
                    isReversed:isRevered
                         count:count];
    
    ohlcDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastCandlestickRenderableSeries * candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    
    candlestickRenderableSeries.xAxisId = @"xAxis";
    candlestickRenderableSeries.yAxisId = @"yAxis";
    [candlestickRenderableSeries setDataSeries: ohlcDataSeries];
    candlestickRenderableSeries.style.drawBorders = NO;
    
    candlestickRenderableSeries.style.strokeUpStyle = [[SCILinearGradientPenStyle alloc] initWithColorCodeStart:0xFFf9af16
                                                                                                    finish:0xFFf9af16
                                                                                                 direction:SCILinearGradientDirection_Vertical
                                                                                                     thickness:0.2];
    
    candlestickRenderableSeries.style.strokeDownStyle = [[SCILinearGradientPenStyle alloc] initWithColorCodeStart:0xFFf9af16
                                                                                                      finish:0xFFf9af16
                                                                                                   direction:SCILinearGradientDirection_Vertical
                                                                                                       thickness:0.7];
    
    candlestickRenderableSeries.dataAggregation = SCIGeneric(10);
    candlestickRenderableSeries.style.fillUpBrushStyle = upBodyColor;
    candlestickRenderableSeries.style.fillDownBrushStyle = downBodyColor;
    
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
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Arial"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [surface.yAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [surface.xAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    SCIXAxisDragModifier * xAxisDragModifier = [SCIXAxisDragModifier new];
    xAxisDragModifier.axisId = @"xAxis";
    xAxisDragModifier.dragMode = SCIAxisDragMode_Scale;
    xAxisDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yAxisDragModifier = [SCIYAxisDragModifier new];
    yAxisDragModifier.axisId = @"yAxis";
    yAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCITooltipModifier * tooltip = [[SCITooltipModifier alloc] init];
    //    tooltip.style.tooltipSize = CGSizeMake(100, NAN);
    
    [tooltip setModifierName:@"ToolTip Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yAxisDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xAxisDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * modifierGroup = [[SCIModifierGroup alloc] initWithChildModifiers:@[xAxisDragModifier, yAxisDragModifier, pzm, zem, tooltip]];
    
    surface.chartModifier = modifierGroup;
    
    
    id<SCIRenderableSeriesProtocol> chart = [self getPriceRenderableSeries:FALSE
                                                               upBodyBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFff9c0f]
                                                             downBodyBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFffff66]
                                                                     count:8000];
    [surface.renderableSeries add:chart];
    [surface invalidateElement];
}

@end
