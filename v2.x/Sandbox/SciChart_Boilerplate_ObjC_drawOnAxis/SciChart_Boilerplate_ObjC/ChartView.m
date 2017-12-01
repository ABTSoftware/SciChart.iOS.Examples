//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ChartView.h"
#import <SciChart/SciChart.h>
#import "DrawOnAxisModifier.h"

@implementation ChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        _sciChartSurface = view;
        
        [_sciChartSurface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_sciChartSurface];
        NSDictionary *layout = @{@"SciChart":_sciChartSurface};
        
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
        _sciChartSurface = view;
        
        [_sciChartSurface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_sciChartSurface];
        NSDictionary *layout = @{@"SciChart":_sciChartSurface};
        
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
    [_sciChartSurface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_sciChartSurface.xAxes add:axis];
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
    
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    DrawOnAxisModifier * axisLineModifier = [DrawOnAxisModifier new];
    axisLineModifier.axesId = @[@"xAxis", @"yAxis"];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm, axisLineModifier]];
    
    _sciChartSurface.chartModifiers = gm;
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
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7] ];
    [priceRenderableSeries setXAxisId: @"xAxis"];
    [priceRenderableSeries setYAxisId: @"yAxis"];
    [priceRenderableSeries setDataSeries:dataSeries];
    [_sciChartSurface.renderableSeries add:priceRenderableSeries];
    
    [_sciChartSurface invalidateElement];
}

@end
