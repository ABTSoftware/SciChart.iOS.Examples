//
//  StackedColumnFullFillChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 11/9/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedColumnFullFillChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedColumnFullFillChartView


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
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
}

-(void) initializeSurfaceData {
    [self prepare];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    [axis setAutoRange:SCIAutoRange_Once];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.01) Max:SCIGeneric(0.01)]];
    [surface.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"xAxis";
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"dd/MM/yyyy"];
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.01) Max:SCIGeneric(0.01)]];
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
    
    SCILegendModifier *legend = [[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop
                                                                                 andOrientation:SCIOrientationVertical];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, legend]];
    surface.chartModifiers = gm;
    
    [self attachStackedColumnRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedColumnRenderableSeries {
    
    SCIStackedColumnRenderableSeries *porkRenderableSeries = [SCIStackedColumnRenderableSeries new];
    porkRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xff226fb7];
    porkRenderableSeries.strokeStyle = nil;
    porkRenderableSeries.dataSeries = [DataManager porkDataSeries];
    [porkRenderableSeries.dataSeries setSeriesName:@"Pork"];
    porkRenderableSeries.xAxisId = @"xAxis";
    porkRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *cucumberRenderableSeries = [SCIStackedColumnRenderableSeries new];
    cucumberRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xffaad34f];
    cucumberRenderableSeries.strokeStyle = nil;
    cucumberRenderableSeries.dataSeries = [DataManager cucumberDataSeries];
    [cucumberRenderableSeries.dataSeries setSeriesName:@"Cucumber"];
    cucumberRenderableSeries.xAxisId = @"xAxis";
    cucumberRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *tomatoesRenderableSeries = [SCIStackedColumnRenderableSeries new];
    tomatoesRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xffdc443f];
    tomatoesRenderableSeries.strokeStyle = nil;
    tomatoesRenderableSeries.dataSeries = [DataManager tomatoesDataSeries];
    [tomatoesRenderableSeries.dataSeries setSeriesName:@"Tomatoes"];
    tomatoesRenderableSeries.xAxisId = @"xAxis";
    tomatoesRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *pepperRenderableSeries = [SCIStackedColumnRenderableSeries new];
    pepperRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xff8562b4];
    pepperRenderableSeries.strokeStyle = nil;
    pepperRenderableSeries.dataSeries = [DataManager pepperDataSeries];
    [pepperRenderableSeries.dataSeries setSeriesName:@"Pepper"];
    pepperRenderableSeries.xAxisId = @"xAxis";
    pepperRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *vealRenderableSeries = [SCIStackedColumnRenderableSeries new];
    vealRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xffff9a2e];
    vealRenderableSeries.strokeStyle = nil;
    vealRenderableSeries.dataSeries = [DataManager vealDataSeries];
    [vealRenderableSeries.dataSeries setSeriesName:@"Veal"];
    vealRenderableSeries.xAxisId = @"xAxis";
    vealRenderableSeries.yAxisId = @"yAxis";
    
    SCIVerticallyStackedColumnsCollection *stackedGroup = [SCIVerticallyStackedColumnsCollection new];
    stackedGroup.isOneHundredPercentSeries = YES;
    [stackedGroup add:tomatoesRenderableSeries];
    [stackedGroup add:pepperRenderableSeries];
    [stackedGroup add:vealRenderableSeries];
    [stackedGroup add:porkRenderableSeries];
    [stackedGroup add:cucumberRenderableSeries];
    [stackedGroup setXAxisId: @"xAxis"];
    [stackedGroup setYAxisId: @"yAxis"];
    
    [self.surface.renderableSeries add:stackedGroup];

}

@end

