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

@synthesize sciChartSurfaceView;
@synthesize surface;

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

-(void) prepare {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
}

-(void) initializeSurfaceData {
    [self prepare];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    [axis setAutoRange:SCIAutoRange_Once];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCICategoryNumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
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
    
//    SCILegendCollectionModifier *legend = [[SCILegendCollectionModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop
//                                                                                 andOrientation:SCILegendOrientationVertical];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
    
    [self attachStackedColumnRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedColumnRenderableSeries {
    
    SCIStackedHorizontalColumnGroupSeries *horizontalStacked = [SCIStackedHorizontalColumnGroupSeries new];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:0 andFillColor:0xff3399ff andBorderColor:0xff2d68bc]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:1 andFillColor:0xff014358 andBorderColor:0xff013547]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:2 andFillColor:0xff1f8a71 andBorderColor:0xff1b5d46]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:3 andFillColor:0xffbdd63b andBorderColor:0xff7e952b]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:4 andFillColor:0xffffe00b andBorderColor:0xffaa8f0b]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:5 andFillColor:0xfff27421 andBorderColor:0xffa95419]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:6 andFillColor:0xffbb0000 andBorderColor:0xff840000]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:7 andFillColor:0xff550033 andBorderColor:0xff370018]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:8 andFillColor:0xff339933 andBorderColor:0xff2d773d]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:9 andFillColor:0xff00ada9 andBorderColor:0xff006c6a]];
    [horizontalStacked addSeries:[self p_getRenderableSeriesWithIndex:10 andFillColor:0xff560068 andBorderColor:0xff3d0049]];
    horizontalStacked.xAxisId = @"xAxis";
    horizontalStacked.yAxisId = @"yAxis";
    
    [self.surface.renderableSeries add:horizontalStacked];
    
}

- (SCIStackedColumnRenderableSeries*)p_getRenderableSeriesWithIndex:(int)index andFillColor:(uint)fillColor andBorderColor:(uint)borderColor {
    SCIStackedColumnRenderableSeries *renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:borderColor withThickness:2];
    renderableSeries.dataSeries = [DataManager stackedSideBySideDataSeries][index];
    renderableSeries.xAxisId = @"xAxis";
    renderableSeries.yAxisId = @"yAxis";
    return renderableSeries;
}

@end
