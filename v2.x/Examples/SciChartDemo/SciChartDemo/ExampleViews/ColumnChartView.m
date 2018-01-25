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

@interface ColumnsTripleColorPalette : SCIPaletteProvider
@end

@implementation ColumnsTripleColorPalette {
    SCIColumnSeriesStyle * _style1;
    SCIColumnSeriesStyle * _style2;
    SCIColumnSeriesStyle * _style3;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _style1 = [[SCIColumnSeriesStyle alloc] init];
        _style1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style1.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFa9d34f
                                                                                 finish:0xFF93b944
                                                                              direction:SCILinearGradientDirection_Vertical];

        _style2 = [[SCIColumnSeriesStyle alloc] init];
        _style2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style2.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFfc9930
                                                                                 finish:0xFFd17f28
                                                                              direction:SCILinearGradientDirection_Vertical];
        
        _style3 = [[SCIColumnSeriesStyle alloc] init];
        _style3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style3.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFd63b3f
                                                                                 finish:0xFFbc3337
                                                                              direction:SCILinearGradientDirection_Vertical];
    }
    return self;
}

-(id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    int styleIndex = index % 3;
    if (styleIndex == 0) {
        return _style1;
    } else if (styleIndex == 1) {
        return _style2;
    } else {
        return _style3;
    }
}

@end

@implementation ColumnChartView


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

    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    
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
    axis.axisId = @"yAxis";
    [surface.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"xAxis";
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"dd/MM/yyyy"];
    [axis setCursorTextFormatting:@"dd-MM-yyyy"];
    [axis setStyle: axisStyle];
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
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifiers = gm;
  
   
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float];
    
    [DataManager loadDataFromFile:columnDataSeries
                         fileName:@"ColumnData"
                       startIndex:0
                        increment:1 reverse:NO];
    
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [columnRenderableSeries addAnimation:animation];
    
    columnRenderableSeries.xAxisId = @"xAxis";
    columnRenderableSeries.yAxisId = @"yAxis";
    
    [columnRenderableSeries setDataSeries:columnDataSeries];

    columnRenderableSeries.paletteProvider = [[ColumnsTripleColorPalette alloc] init];
    [surface.renderableSeries add:columnRenderableSeries];
    
    [surface invalidateElement];
}

@end
