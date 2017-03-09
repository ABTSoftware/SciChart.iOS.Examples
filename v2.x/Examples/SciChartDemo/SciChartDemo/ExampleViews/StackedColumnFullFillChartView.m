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
    
    SCILegendCollectionModifier *legend = [[SCILegendCollectionModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop
                                                                                 andOrientation:SCILegendOrientationVertical];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, legend]];
    surface.chartModifier = gm;
    
    [self attachStackedColumnRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedColumnRenderableSeries {
    
    SCIStackedColumnRenderableSeries *porkRenderableSeries = [SCIStackedColumnRenderableSeries new];
    porkRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xff226fb7];
    porkRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xff22579d withThickness:2];
    porkRenderableSeries.dataSeries = [DataManager porkDataSeries];
    [porkRenderableSeries.dataSeries setSeriesName:@"Pork"];
    porkRenderableSeries.xAxisId = @"xAxis";
    porkRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *cucumberRenderableSeries = [SCIStackedColumnRenderableSeries new];
    cucumberRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xffaad34f];
    cucumberRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xff73953d withThickness:2];
    cucumberRenderableSeries.dataSeries = [DataManager cucumberDataSeries];
    [cucumberRenderableSeries.dataSeries setSeriesName:@"Cucumber"];
    cucumberRenderableSeries.xAxisId = @"xAxis";
    cucumberRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *tomatoesRenderableSeries = [SCIStackedColumnRenderableSeries new];
    tomatoesRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xffdc443f];
    tomatoesRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xffa33631 withThickness:2];
    tomatoesRenderableSeries.dataSeries = [DataManager tomatoesDataSeries];
    [tomatoesRenderableSeries.dataSeries setSeriesName:@"Tomatoes"];
    tomatoesRenderableSeries.xAxisId = @"xAxis";
    tomatoesRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *pepperRenderableSeries = [SCIStackedColumnRenderableSeries new];
    pepperRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xff8562b4];
    pepperRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xff64458a withThickness:2];
    pepperRenderableSeries.dataSeries = [DataManager pepperDataSeries];
    [pepperRenderableSeries.dataSeries setSeriesName:@"Pepper"];
    pepperRenderableSeries.xAxisId = @"xAxis";
    pepperRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedColumnRenderableSeries *vealRenderableSeries = [SCIStackedColumnRenderableSeries new];
    vealRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0xffff9a2e];
    vealRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xffbe642d withThickness:2];
    vealRenderableSeries.dataSeries = [DataManager vealDataSeries];
    [vealRenderableSeries.dataSeries setSeriesName:@"Veal"];
    vealRenderableSeries.xAxisId = @"xAxis";
    vealRenderableSeries.yAxisId = @"yAxis";
    
    SCIStackedVerticalColumnGroupSeries *stackedGroup = [SCIStackedVerticalColumnGroupSeries new];
    stackedGroup.isOneHundredPercentSeries = YES;
    [stackedGroup addSeries:tomatoesRenderableSeries];
    [stackedGroup addSeries:pepperRenderableSeries];
    [stackedGroup addSeries:vealRenderableSeries];
    [stackedGroup addSeries:porkRenderableSeries];
    [stackedGroup addSeries:cucumberRenderableSeries];
    [stackedGroup setXAxisId: @"xAxis"];
    [stackedGroup setYAxisId: @"yAxis"];
    
    [self.surface.renderableSeries add:stackedGroup];

}

@end

