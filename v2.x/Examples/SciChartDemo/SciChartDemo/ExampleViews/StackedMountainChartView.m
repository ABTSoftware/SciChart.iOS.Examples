//
//  StackedMountainChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 2/28/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "StackedMountainChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedMountainChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) attachStackedMountainRenderableSeries {
    SCIXyDataSeries * mountainDataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    mountainDataSeries1.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    [DataManager loadDataFromFile:mountainDataSeries1
                         fileName:@"FinanceData"
                       startIndex:1
                        increment:1 reverse:YES];
    
    SCIStackedMountainRenderableSeries * topMountainRenderableSeries = [[SCIStackedMountainRenderableSeries alloc] init];
    SCIBrushStyle *brush1 = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0x88ffffff
                                                                            finish:0xDDE1E0DB
                                                                         direction:SCILinearGradientDirection_Vertical];
    SCIPenStyle *pen1 = [[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:0.5];
    [topMountainRenderableSeries.style setAreaBrush: brush1];
    [topMountainRenderableSeries.style setBorderPen: pen1];
    [topMountainRenderableSeries setXAxisId: @"xAxis"];
    [topMountainRenderableSeries setYAxisId: @"yAxis"];
    [topMountainRenderableSeries setDataSeries:mountainDataSeries1];
    
    
    SCIXyDataSeries * mountainDataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    mountainDataSeries2.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    [DataManager loadDataFromFile:mountainDataSeries2
                         fileName:@"FinanceData"
                       startIndex:1
                        increment:1 reverse:YES];
    
    SCIBrushStyle *brush2 = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0x88909Aaf
                                                                            finish:0x88439Aaf
                                                                         direction:SCILinearGradientDirection_Vertical];
    SCIPenStyle *pen2 = [[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:0.5];
    SCIStackedMountainRenderableSeries * bottomMountainRenderableSeries = [[SCIStackedMountainRenderableSeries alloc] init];
    [bottomMountainRenderableSeries.style setAreaBrush: brush2];
    [bottomMountainRenderableSeries.style setBorderPen: pen2];
    [bottomMountainRenderableSeries setXAxisId: @"xAxis"];
    [bottomMountainRenderableSeries setYAxisId: @"yAxis"];
    [bottomMountainRenderableSeries setDataSeries:mountainDataSeries2];
    
    SCIStackedGroupSeries *stackedGroup = [[SCIStackedGroupSeries alloc] init];
    [stackedGroup setXAxisId: @"xAxis"];
    [stackedGroup setYAxisId: @"yAxis"];
    [stackedGroup addSeries:bottomMountainRenderableSeries];
    [stackedGroup addSeries:topMountainRenderableSeries];
    [surface.renderableSeries add:stackedGroup];
}

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

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
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
    
    [self attachStackedMountainRenderableSeries];
    
    [surface invalidateElement];
}

@end
