//
//  ScatterSeriesViewController.m
//  SciChartDemo
//
//  Created by Admin on 27.01.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ScatterSeriesChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ScatterSeriesChartView


@synthesize surface;

-(id<SCIRenderableSeriesProtocol>) getScatterRenderableSeriesWithDetalization:(int)pointMarkerDetalization
                                                                Color:(unsigned int) color
                                                             Negative:(BOOL) negative
{
    SCIXyDataSeries * scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float];
    
    //Getting Fourier dataSeries
    for (int i = 0; i < 200; i++) {
        double x = i;
        double time =  (i < 100) ? arc4random_uniform(x+10) : arc4random_uniform(200-x+10);
        double y = time*time*time;
        if (negative) {
            [scatterDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(-y)];
        } else {
            [scatterDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
        }
    }
    
    SCIXyScatterRenderableSeries * xyScatterRenderableSeries = [[SCIXyScatterRenderableSeries alloc] init];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [xyScatterRenderableSeries addAnimation:animation];
    
    scatterDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    scatterDataSeries.seriesName = (pointMarkerDetalization == 6)
    ? ( (negative)
       ? @"Negative Hex"
       : @"Positive Hex" )
    : ( (negative)
       ? @"Negative"
       : @"Positive" );
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:color];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF withThickness:0.1];
    ellipsePointMarker.detalization = pointMarkerDetalization;
    ellipsePointMarker.height = 6;
    ellipsePointMarker.width = 6;
    
    xyScatterRenderableSeries.style.pointMarker = ellipsePointMarker;
    xyScatterRenderableSeries.xAxisId = @"xAxis";
    xyScatterRenderableSeries.yAxisId = @"yAxis";
    xyScatterRenderableSeries.dataSeries = scatterDataSeries;
    
    return xyScatterRenderableSeries;
}

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
    
    SCISolidPenStyle *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Arial"];
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
    [surface.yAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [surface.xAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCICursorModifier * cursor = [[SCICursorModifier alloc] init];
    cursor.style.hitTestMode = SCIHitTest_Point;
    cursor.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    [cursor.style setTooltipSize:CGSizeMake(200, NAN)];
    
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [cursor setModifierName:@"Cursor Modifier"];
    [yDragModifier setModifierName:@"Y Axis Drag Modifier"];
    [xDragModifier setModifierName:@"X Axis Drag Modifier"];

    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, cursor]];
    surface.chartModifiers = gm;
    
    id<SCIRenderableSeriesProtocol> chart1 = [self getScatterRenderableSeriesWithDetalization:3 Color:0xFFffeb01 Negative:NO];
    id<SCIRenderableSeriesProtocol> chart2 = [self getScatterRenderableSeriesWithDetalization:6 Color:0xFFffa300 Negative:NO];
    id<SCIRenderableSeriesProtocol> chart3 = [self getScatterRenderableSeriesWithDetalization:3 Color:0xFFff6501 Negative:YES];
    id<SCIRenderableSeriesProtocol> chart4 = [self getScatterRenderableSeriesWithDetalization:6 Color:0xFFffa300 Negative:YES];
    
    [surface.renderableSeries add:chart1];
    [surface.renderableSeries add:chart2];
    [surface.renderableSeries add:chart3];
    [surface.renderableSeries add:chart4];
    
    [surface invalidateElement];
}

@end
