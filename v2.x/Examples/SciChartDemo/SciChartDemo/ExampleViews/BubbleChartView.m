//
//  BubbleChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 18.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "BubbleChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation BubbleChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) createBubbleRenderableSeries {
    SCIXyzDataSeries *xyzDataSeries = [[SCIXyzDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float ZType:SCIDataType_Float];
    [DataManager getTradeTicks:xyzDataSeries fileName:@"TradeTicks"];
    
    SCIBubbleRenderableSeries *bubbleRenderableSeries = [[SCIBubbleRenderableSeries alloc] init];
    bubbleRenderableSeries.style.bubbleBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x50CCCCCC];
    bubbleRenderableSeries.style.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFCCCCCC withThickness:1.0];
    bubbleRenderableSeries.style.detalization = 44;
    bubbleRenderableSeries.zScaleFactor = 1.0;
    bubbleRenderableSeries.autoZRange = false;
    [bubbleRenderableSeries setDataSeries:xyzDataSeries];
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [[SCIFastLineRenderableSeries alloc]init];
    [lineRenderableSeries setDataSeries:xyzDataSeries];
    [lineRenderableSeries setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:0xffff3333 withThickness:2.0]];
    
    [surface.renderableSeries add:lineRenderableSeries];
    [surface.renderableSeries add:bubbleRenderableSeries];
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
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)]];
    [surface.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCITooltipModifier * tooltip = [[SCITooltipModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, tooltip]];
    surface.chartModifiers = gm;
    
    [self createBubbleRenderableSeries];
    [surface invalidateElement];
}

@end
