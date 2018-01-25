//
//  StackedBarChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 9/24/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedBarChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedBarChartView


@synthesize surface;

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

-(void) prepare {
    
}

-(void) initializeSurfaceData {
    [self prepare];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis";
    [axis setAxisAlignment:SCIAxisAlignment_Bottom];
    [axis setFlipCoordinates:YES];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setAxisAlignment:SCIAxisAlignment_Right];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    
    [rollover setModifierName:@"Rollover Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"Y Axis Drag Modifier"];
    [xDragModifier setModifierName:@"X Axis Drag Modifier"];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifiers = gm;
    
    [self attachStackedMountainRenderableSeries];
}

-(void) attachStackedMountainRenderableSeries {
    SCIVerticallyStackedColumnsCollection *stackedGroup = [SCIVerticallyStackedColumnsCollection new];
    [stackedGroup add:[self p_getRenderableSeries:0 andFillColorStart:0xff3D5568 andfinish:0xff567893]];
    [stackedGroup add:[self p_getRenderableSeries:1 andFillColorStart:0xff439aaf andfinish:0xffACBCCA]];
    [stackedGroup add:[self p_getRenderableSeries:2 andFillColorStart:0xffb6c1c3 andfinish:0xffdbe0e1]];
    [stackedGroup setXAxisId: @"xAxis"];
    [stackedGroup setYAxisId: @"yAxis"];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [stackedGroup addAnimation:animation];
    
    [self.surface.renderableSeries add:stackedGroup];
}

- (SCIStackedColumnRenderableSeries*)p_getRenderableSeries:(int)index
                                         andFillColorStart:(uint)fillColor
                                                 andfinish:(uint)finishColor {
    SCIStackedColumnRenderableSeries *renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:fillColor finish:finishColor direction:SCILinearGradientDirection_Horizontal];
    renderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor blackColor] withThickness:0.5];
    renderableSeries.dataSeries = [DataManager stackedBarChartSeries][index];
    renderableSeries.xAxisId = @"xAxis";
    renderableSeries.yAxisId = @"yAxis";
    
    return renderableSeries;
}


@end
