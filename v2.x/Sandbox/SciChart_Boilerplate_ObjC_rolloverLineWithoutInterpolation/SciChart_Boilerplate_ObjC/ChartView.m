//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ChartView.h"
#import <SciChart/SciChart.h>
#import "CustomRollover.h"

@implementation ChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        _surface = view;
        
        [_surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_surface];
        NSDictionary *layout = @{@"SciChart":_surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithCoder:aDecoder];
        _surface = view;
        
        [_surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_surface];
        NSDictionary *layout = @{@"SciChart":_surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    return self;
}

-(void) initializeSurfaceData {
    [self addAxes];
    [self addModifiers];
    [self addRenderableSeries];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    CustomRollover * rollover = [CustomRollover new];
    rollover.style.hitTestMode = SCIHitTest_Vertical;
    rollover.hitTestRadius = 50;
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    _surface.chartModifiers = gm;
}

-(void) addRenderableSeries{
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    int dataCount = 20;
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [dataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    [lineSeries setXAxisId: @"xAxis"];
    [lineSeries setYAxisId: @"yAxis"];
    [lineSeries setDataSeries:dataSeries];
    [_surface.renderableSeries add:lineSeries];
    
    [_surface invalidateElement];
}

@end
