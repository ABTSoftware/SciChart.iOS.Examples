//
//  ColumnChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 27.01.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ColumnChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ColumnChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(SCIFastColumnRenderableSeries *) getColumnRenderableSeries:(SCIBrushStyle*) fillBrush
                                                   borderPen: (SCIPenStyle*) borderPen
                                                       order:(int) order{
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    //Getting Fourier dataSeries
    [DataManager loadDataFromFile:columnDataSeries
                         fileName:@"ColumnData"
                       startIndex:order
                        increment:3 reverse:NO];
    
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    
    columnDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    columnRenderableSeries.style.fillBrush = fillBrush;
    columnRenderableSeries.style.borderPen = borderPen;
    columnRenderableSeries.style.dataPointWidth = 0.3;
    
    columnRenderableSeries.xAxisId = @"xAxis";
    columnRenderableSeries.yAxisId = @"yAxis";
    
    [columnRenderableSeries setDataSeries:columnDataSeries];
    
    return columnRenderableSeries;
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
    [surface free];
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:20];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFFFFFFF];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
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
    [surface.yAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"xAxis";
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"dd/MM/yyyy"];
    [axis setCursorTextFormatting:@"dd-MM-yyyy"];
    [axis setStyle: axisStyle];
    [surface.xAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
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
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
  
    SCIBrushStyle *brush1 = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFa9d34f
                                                                        finish:0xFF93b944
                                                                     direction:SCILinearGradientDirection_Vertical];
    SCIPenStyle *pen1 = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
    id<SCIRenderableSeriesProtocol> chart1 = [self getColumnRenderableSeries:brush1 borderPen:pen1 order:0];
    
    SCIBrushStyle *brush2 = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFfc9930
                                                                        finish:0xFFd17f28
                                                                     direction:SCILinearGradientDirection_Vertical];
    SCIPenStyle *pen2 = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
    id<SCIRenderableSeriesProtocol> chart2 = [self getColumnRenderableSeries:brush2 borderPen:pen2 order:1];
    
    SCIBrushStyle *brush3 = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFd63b3f
                                                                        finish:0xFFbc3337
                                                                     direction:SCILinearGradientDirection_Vertical];
    SCIPenStyle *pen3 = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
    id<SCIRenderableSeriesProtocol> chart3 = [self getColumnRenderableSeries:brush3 borderPen:pen3 order:2];
    
    [surface.renderableSeries add:chart1];
    [surface.renderableSeries add:chart2];
    [surface.renderableSeries add:chart3];
    
    [surface invalidateElement];
}

@end
