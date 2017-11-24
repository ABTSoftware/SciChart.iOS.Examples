//
//  StackedColumnVerticalChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 10/27/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedColumnSideBySideChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedColumnSideBySideChartView


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
    [axis setAxisTitle:@"billions of People"];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCICategoryNumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
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
    
    SCILegendModifier * legendModifier = [SCILegendModifier new];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, legendModifier]];
    surface.chartModifiers = gm;
    
    [self attachStackedColumnRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedColumnRenderableSeries {
    
    SCIHorizontallyStackedColumnsCollection *horizontalStacked = [SCIHorizontallyStackedColumnsCollection new];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:0 andFillColor:0xff3399ff andBorderColor:0xff2d68bc seriesName: @"China"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:1 andFillColor:0xff014358 andBorderColor:0xff013547 seriesName: @"India"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:2 andFillColor:0xff1f8a71 andBorderColor:0xff1b5d46 seriesName: @"USA"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:3 andFillColor:0xffbdd63b andBorderColor:0xff7e952b seriesName: @"Indonesia"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:4 andFillColor:0xffffe00b andBorderColor:0xffaa8f0b seriesName: @"Brazil"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:5 andFillColor:0xfff27421 andBorderColor:0xffa95419 seriesName: @"Pakistan"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:6 andFillColor:0xffbb0000 andBorderColor:0xff840000 seriesName: @"Nigeria"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:7 andFillColor:0xff550033 andBorderColor:0xff370018 seriesName: @"Bangladesh"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:8 andFillColor:0xff339933 andBorderColor:0xff2d773d seriesName: @"Russia"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:9 andFillColor:0xff00ada9 andBorderColor:0xff006c6a seriesName: @"Japan"]];
    [horizontalStacked add:[self p_getRenderableSeriesWithIndex:10 andFillColor:0xff560068 andBorderColor:0xff3d0049 seriesName: @"Rest of The World"]];
    horizontalStacked.xAxisId = @"xAxis";
    horizontalStacked.yAxisId = @"yAxis";
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurveEaseOut];
    [animation startAfterDelay:0.3];
    [horizontalStacked addAnimation:animation];
    
    [self.surface.renderableSeries add:horizontalStacked];
    
}

- (SCIStackedColumnRenderableSeries*)p_getRenderableSeriesWithIndex:(int)index andFillColor:(uint)fillColor andBorderColor:(uint)borderColor seriesName:(NSString*)seriesName {
    SCIStackedColumnRenderableSeries *renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:borderColor withThickness:1];
    renderableSeries.dataSeries = [DataManager stackedSideBySideDataSeries][index];
    [renderableSeries.dataSeries setSeriesName:seriesName];
    renderableSeries.xAxisId = @"xAxis";
    renderableSeries.yAxisId = @"yAxis";
    return renderableSeries;
}

@end
