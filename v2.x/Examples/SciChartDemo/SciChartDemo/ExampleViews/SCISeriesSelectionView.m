//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SCISeriesSelectionView.h"
#import <SciChart/SciChart.h>

@implementation SeriesSelectionView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) initializeSurfaceRenderableSeries{
    int dataCount = 20;
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [lineDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFd7ffd6]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    
    SCIFastLineRenderableSeries * lineRenderableSeries = [SCIFastLineRenderableSeries new];
    [lineRenderableSeries.style setPointMarker: ellipsePointMarker];
    [lineRenderableSeries.style setDrawPointMarkers: NO];
    [lineRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:1]];
    
    lineRenderableSeries.selectedStyle = lineRenderableSeries.style;
    [lineRenderableSeries.selectedStyle setLinePen: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:1.5]];
    [lineRenderableSeries.selectedStyle setPointMarker: ellipsePointMarker];
    [lineRenderableSeries.selectedStyle setDrawPointMarkers: YES];
    [lineRenderableSeries.hitTestProvider setHitTestMode:SCIHitTest_Interpolate];
    
    [lineRenderableSeries setXAxisId: @"xAxis"];
    [lineRenderableSeries setYAxisId: @"yAxis"];
    [lineRenderableSeries setDataSeries:lineDataSeries];
    
    [surface.renderableSeries add:lineRenderableSeries];
    
    
    SCIXyDataSeries * scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [scatterDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    SCIXyScatterRenderableSeries * scatterRenderableSeries = [SCIXyScatterRenderableSeries new];
    scatterRenderableSeries.selectedStyle = scatterRenderableSeries.style;
    
    SCIEllipsePointMarker * pointMarker = [[SCIEllipsePointMarker alloc] init];
    pointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode: 0xFF00D0A0];
    pointMarker.strokeStyle = nil;
    pointMarker.height = 5;
    pointMarker.width = 5;
    scatterRenderableSeries.style.pointMarker = pointMarker;
    
    SCIEllipsePointMarker * selectedPointMarker = [SCIEllipsePointMarker new];
    selectedPointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode: 0xFF00D0A0];
    selectedPointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode: 0xFF404040 withThickness: 0.7];
    selectedPointMarker.height = 7;
    selectedPointMarker.width = 7;
    scatterRenderableSeries.selectedStyle.pointMarker = selectedPointMarker;
    
    scatterRenderableSeries.xAxisId = @"xAxis";
    scatterRenderableSeries.yAxisId = @"yAxis";
    [scatterRenderableSeries setDataSeries:scatterDataSeries];
    [surface.renderableSeries add:scatterRenderableSeries];
    
    [surface invalidateElement];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
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
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    [xDragModifier setModifierName:@"XAxis DragModifier"];
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    [yDragModifier setModifierName:@"YAxis DragModifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    [rollover setModifierName:@"Rollover Modifier"];
    
    SCISeriesSelectionModifier * selectionModifier = [[SCISeriesSelectionModifier alloc] init];
    selectionModifier.selectionMode = SCISelectionModifierSelectionMode_MultiSelectDeselectOnMiss;
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, selectionModifier]];
    surface.chartModifier = gm;
}

@end
