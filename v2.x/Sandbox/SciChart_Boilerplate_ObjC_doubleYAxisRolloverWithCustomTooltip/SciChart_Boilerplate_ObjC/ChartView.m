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
    SCINumericAxis * axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis1";
    [axis.style.labelStyle setColor:[UIColor redColor]];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
    [format setPositiveFormat:@"# ' PSI'"];
    [format setNegativeFormat:@"-# ' PSI'"];
    [axis setNumberFormatter:format];
    [_surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis2";
    [axis setAxisAlignment:SCIAxisAlignment_Left];
    [axis.style.labelStyle setColor:[UIColor greenColor]];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface.yAxes add:axis];
    
    SCIDateTimeAxis * xAxis = [[SCIDateTimeAxis alloc] init];
    xAxis.axisId = @"xAxis";
    xAxis.subDayTextFormatting = @"yyyy-MM-dd HH:mm:ss";;
    xAxis.subYearTextFormatting = @"yyyy-MM-dd HH:mm:ss";
    xAxis.decadesTextFormatting = @"yyyy-MM-dd HH:mm:ss";
    [xAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface.xAxes add:xAxis];
}

-(void) addModifiers {
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier1 = [SCIYAxisDragModifier new];
    yDragModifier1.axisId = @"yAxis1";
    yDragModifier1.dragMode = SCIAxisDragMode_Pan;
    
    SCIYAxisDragModifier * yDragModifier2 = [SCIYAxisDragModifier new];
    yDragModifier2.axisId = @"yAxis2";
    yDragModifier2.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    CustomRollover * rollover = [CustomRollover new];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier1, yDragModifier2, pzm, zem, rollover]];
    _surface.chartModifiers = gm;
}

-(void) addRenderableSeries{
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float];
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float];
    int dataCount = 20;
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y1 = arc4random_uniform(20);
        [dataSeries1 appendX:SCIGeneric(x) Y:SCIGeneric(y1)];
        double y2 = arc4random_uniform(20);
        [dataSeries2 appendX:SCIGeneric(x) Y:SCIGeneric(y2)];
    }
    
    SCIFastLineRenderableSeries * renderableSeries1 = [SCIFastLineRenderableSeries new];
    [renderableSeries1.style setStrokeStyle:[[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 withThickness:1]];
    [renderableSeries1 setXAxisId: @"xAxis"];
    [renderableSeries1 setYAxisId: @"yAxis1"];
    [renderableSeries1 setDataSeries:dataSeries1];
    [_surface.renderableSeries add:renderableSeries1];
    
    SCIFastLineRenderableSeries * renderableSeries2 = [SCIFastLineRenderableSeries new];
    [renderableSeries2.style setStrokeStyle:[[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 withThickness:1]];
    [renderableSeries2 setXAxisId: @"xAxis"];
    [renderableSeries2 setYAxisId: @"yAxis2"];
    [renderableSeries2 setDataSeries:dataSeries2];
    [_surface.renderableSeries add:renderableSeries2];
    
    [_surface invalidateElement];
}

@end
