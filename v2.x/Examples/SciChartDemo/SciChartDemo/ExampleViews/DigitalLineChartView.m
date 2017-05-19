//
//  DigitalLineChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//
#import <SciChart/SciChart.h>
#import "DigitalLineChartView.h"
#import "DataManager.h"

@implementation DigitalLineChartView{
    NSMutableArray * _series;
    uint _color1, _color2;
}


@synthesize surface;

-(void) initializeSurfaceRenderableSeries {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager getFourierSeries:dataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    
    SCIFastLineRenderableSeries * digitalSeries = [SCIFastLineRenderableSeries new];
    [digitalSeries setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:1.0]];
    [digitalSeries setDataSeries:dataSeries];
    [[digitalSeries style] setIsDigitalLine:YES];
    [surface.renderableSeries add:digitalSeries];
    
    [surface invalidateElement];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
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
    
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.5) Max:SCIGeneric(0.5)]];
    [axis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(2.3) Max:SCIGeneric(3.3)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(1.0) Max:SCIGeneric(1.25)]];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifiers = gm;
}

@end
