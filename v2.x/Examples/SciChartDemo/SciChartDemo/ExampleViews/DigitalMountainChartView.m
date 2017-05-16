//
//  DigitalMountainChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 3/14/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "DigitalMountainChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation DigitalMountainChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(SCIFastMountainRenderableSeries*) getMountainRenderableSeries:(SCIBrushStyle*) areaBrush
                                                      borderPen:(SCIPenStyle*) borderPen {
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    NSArray<NSDictionary *> *dataSource = [DataManager getPriceIndu:@"INDU_Daily"];
    for (NSDictionary *item in dataSource) {
        
        [mountainDataSeries appendX:SCIGeneric(item[@"X"]) Y:SCIGeneric([item[@"Y"] floatValue])];
        
    }
    
    SCIFastMountainRenderableSeries * mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.zeroLineY = 10000;
    mountainRenderableSeries.areaStyle = areaBrush;
    mountainRenderableSeries.strokeStyle = borderPen;
    mountainRenderableSeries.isDigitalLine = YES;
    [mountainRenderableSeries setDataSeries:mountainDataSeries];
    
    return mountainRenderableSeries;
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
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"dd/LL/yyyy"];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
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
    
    
    SCILinearGradientBrushStyle * brush = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xAAFF8D42
                                                                                               finish:0x88090E11
                                                                                            direction:SCILinearGradientDirection_Vertical];
    
    
    SCIPenStyle *pen = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFFC9A8 withThickness:1.0];
    id<SCIRenderableSeriesProtocol> series = [self getMountainRenderableSeries:brush borderPen:pen];
    [surface.renderableSeries add:series];
    
    [surface invalidateElement];
}

@end
