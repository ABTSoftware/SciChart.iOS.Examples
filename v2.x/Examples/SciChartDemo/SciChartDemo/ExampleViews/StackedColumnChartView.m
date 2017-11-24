//
//  StackedColumnChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 10/27/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedColumnChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedColumnChartView

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

-(void) initializeSurfaceData {
    
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setAutoRange:SCIAutoRange_Once];
    axis.axisId = @"yAxis";
    [surface.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"xAxis";
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"yyyy"];
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
    
    [self attachStackedColumnRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedColumnRenderableSeries {
    
    SCIVerticallyStackedColumnsCollection *stackedGroup = [SCIVerticallyStackedColumnsCollection new];
    [stackedGroup add:[self p_getRenderableSeriesWithIndex:0 andFillColor:0xff226fb7 ]];
    [stackedGroup add:[self p_getRenderableSeriesWithIndex:1 andFillColor:0xffff9a2e ]];
    stackedGroup.xAxisId = @"xAxis";
    stackedGroup.yAxisId = @"yAxis";

    SCIVerticallyStackedColumnsCollection *stackedGroup_2 = [SCIVerticallyStackedColumnsCollection new];
    [stackedGroup_2 add:[self p_getRenderableSeriesWithIndex:2 andFillColor:0xffdc443f]];
    [stackedGroup_2 add:[self p_getRenderableSeriesWithIndex:3 andFillColor:0xffaad34f]];
    [stackedGroup_2 add:[self p_getRenderableSeriesWithIndex:4 andFillColor:0xff8562b4]];
    stackedGroup_2.xAxisId = @"xAxis";
    stackedGroup_2.yAxisId = @"yAxis";

    SCIHorizontallyStackedColumnsCollection *horizontalStacked = [SCIHorizontallyStackedColumnsCollection new];
    [horizontalStacked add:stackedGroup];
    [horizontalStacked add:stackedGroup_2];
    horizontalStacked.xAxisId = @"xAxis";
    horizontalStacked.yAxisId = @"yAxis";
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurveEaseOut];
    [animation startAfterDelay:0.3];
    [horizontalStacked addAnimation:animation];
    
    [self.surface.renderableSeries add:horizontalStacked];
    
}

- (SCIStackedColumnRenderableSeries*)p_getRenderableSeriesWithIndex:(int)index andFillColor:(uint)fillColor {
    
    SCIStackedColumnRenderableSeries *renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.strokeStyle = nil;
    renderableSeries.dataSeries = [DataManager stackedVerticalColumnSeries][index];
    renderableSeries.xAxisId = @"xAxis";
    renderableSeries.yAxisId = @"yAxis";
    
    return renderableSeries;
    
}

@end
