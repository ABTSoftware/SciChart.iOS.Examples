//
//  StackedColumnVerticalChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 10/27/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedColumnVerticalChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedColumnVerticalChartView

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
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"xAxis";
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"dd/MM/yyyy"];
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
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
    
    [self attachStackedColumnRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedColumnRenderableSeries {
    
    SCIStackedVerticalColumnGroupSeries *stackedGroup = [SCIStackedVerticalColumnGroupSeries new];
    [stackedGroup addSeries:[self p_getRenderableSeriesWithIndex:0 andFillColor:0xff226fb7 andBorderColor:0xff22579d]];
    [stackedGroup addSeries:[self p_getRenderableSeriesWithIndex:1 andFillColor:0xffff9a2e andBorderColor:0xffbe642d]];
    stackedGroup.xAxisId = @"xAxis";
    stackedGroup.yAxisId = @"yAxis";

    SCIStackedVerticalColumnGroupSeries *stackedGroup_2 = [SCIStackedVerticalColumnGroupSeries new];
    [stackedGroup_2 addSeries:[self p_getRenderableSeriesWithIndex:2 andFillColor:0xffdc443f andBorderColor:0xffa33631]];
    [stackedGroup_2 addSeries:[self p_getRenderableSeriesWithIndex:3 andFillColor:0xffaad34f andBorderColor:0xff73953d]];
    [stackedGroup_2 addSeries:[self p_getRenderableSeriesWithIndex:4 andFillColor:0xff8562b4 andBorderColor:0xff64458a]];
    stackedGroup_2.xAxisId = @"xAxis";
    stackedGroup_2.yAxisId = @"yAxis";

    SCIStackedHorizontalColumnGroupSeries *horizontalStacked = [SCIStackedHorizontalColumnGroupSeries new];
    [horizontalStacked addSeries:stackedGroup];
    [horizontalStacked addSeries:stackedGroup_2];
    horizontalStacked.xAxisId = @"xAxis";
    horizontalStacked.yAxisId = @"yAxis";
    
    [self.surface.renderableSeries add:horizontalStacked];
    
}

- (SCIStackedColumnRenderableSeries*)p_getRenderableSeriesWithIndex:(int)index andFillColor:(uint)fillColor andBorderColor:(uint)borderColor {
    
    
    SCIStackedColumnRenderableSeries *renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:borderColor withThickness:2];
    renderableSeries.dataSeries = [DataManager stackedVerticalColumnSeries][index];
    renderableSeries.xAxisId = @"xAxis";
    renderableSeries.yAxisId = @"yAxis";
    
    return renderableSeries;
    
}

@end
