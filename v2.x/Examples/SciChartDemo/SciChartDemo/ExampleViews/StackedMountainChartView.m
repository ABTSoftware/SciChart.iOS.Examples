//
//  StackedMountainChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 2/28/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "StackedMountainChartView.h"
#import <SciChart/SciChart.h>

@implementation StackedMountainChartView


@synthesize surface;

-(void) attachStackedMountainRenderableSeries {
    SCIXyDataSeries * mountainDataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Float];
    SCIXyDataSeries * mountainDataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Float];
    
    double yValues1[] = { 4.0,  7,    5.2,  9.4,  3.8,  5.1, 7.5,  12.4, 14.6, 8.1, 11.7, 14.4, 16.0, 3.7, 5.1, 6.4, 3.5, 2.5, 12.4, 16.4, 7.1, 8.0, 9.0 };
    double yValues2[] = { 15.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4,  4.6,  0.1, 1.7, 14.4, 6.0, 13.7, 10.1, 8.4, 8.5, 12.5, 1.4, 0.4, 10.1, 5.0, 1.0 };
    
    for(int i=0; i<((sizeof(yValues1)/sizeof(double))); i++){
        [mountainDataSeries1 appendX:SCIGeneric(i) Y:SCIGeneric(yValues1[i])];}
    for(int i=0; i<((sizeof(yValues2)/sizeof(double))); i++){
        [mountainDataSeries2 appendX:SCIGeneric(i) Y:SCIGeneric(yValues2[i])];
    }
    
    SCIStackedMountainRenderableSeries * topMountainRenderableSeries = [[SCIStackedMountainRenderableSeries alloc] init];
    [topMountainRenderableSeries.style setAreaStyle: [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xDDDBE0E1 finish:0x88B6C1C3 direction:SCILinearGradientDirection_Vertical]];
    [topMountainRenderableSeries.style setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:1.0]];
    [topMountainRenderableSeries setDataSeries:mountainDataSeries1];
    
    SCIStackedMountainRenderableSeries * bottomMountainRenderableSeries = [SCIStackedMountainRenderableSeries new];
    [bottomMountainRenderableSeries.style setAreaStyle: [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xDDACBCCA finish:0x88439AAF direction:SCILinearGradientDirection_Vertical]];
    [bottomMountainRenderableSeries.style setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:1.0]];
    [bottomMountainRenderableSeries setDataSeries:mountainDataSeries2];
    
    SCIVerticallyStackedMountainsCollection *stackedGroup = [SCIVerticallyStackedMountainsCollection new];
    [stackedGroup add:topMountainRenderableSeries];
    [stackedGroup add:bottomMountainRenderableSeries];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [stackedGroup addAnimation:animation];
    
    [surface.renderableSeries add:stackedGroup];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    return self;
}

-(void) initializeSurfaceData {
    
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifiers = gm;
    
    [self attachStackedMountainRenderableSeries];
    
    [surface invalidateElement];
}

@end
