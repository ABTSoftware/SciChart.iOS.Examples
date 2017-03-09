//
//  MultipleSurfaceView.m
//  SciChartDemo
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "MultipleSurfaceChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface RangeSync : NSObject
@end


@interface MultipleSurfaceChartView () {
    SCIMultiSurfaceModifier * szpm;
    SCIMultiSurfaceModifier *szem;
    SCIMultiSurfaceModifier *spzm;
    
    SCIMultiSurfaceModifier * sXPinch;
    SCIMultiSurfaceModifier *sYPinch;
    SCIMultiSurfaceModifier *sXDrag;
    SCIMultiSurfaceModifier *sYDrag;
    
    SCIMultiSurfaceModifier *sRollover;
    
    SCIAxisRangeSyncronization * rSync;
    SCIAxisAreaSizeSyncronization * sSync;
}

@property (nonatomic, weak) SCIChartSurfaceView * sciChartView1;
@property (nonatomic, weak) SCIChartSurfaceView * sciChartView2;

@property (nonatomic, strong) SCIChartSurface * surface1;
@property (nonatomic, strong) SCIChartSurface * surface2;

@end

@implementation MultipleSurfaceChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        _sciChartView1 = view;
        [_sciChartView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView1];
        
        view = [[SCIChartSurfaceView alloc]init];
        _sciChartView2 = (SCIChartSurfaceView*)view;
        [_sciChartView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView2];
        NSDictionary *layout = @{@"SciChart1":_sciChartView1, @"SciChart2":_sciChartView2};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart1(SciChart2)]-(10)-[SciChart2(SciChart1)]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self createMultiSurface];
        [self createSharedModifiers];
        [self initializeSurface1Data];
        [self initializeSurface2Data];
    }
    
    return self;
}

-(void) createSharedModifiers {
    rSync = [SCIAxisRangeSyncronization new];
    sSync = [SCIAxisAreaSizeSyncronization new];
    sSync.syncMode = SCIAxisSizeSync_Right;
    
    szpm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomPanModifier class]];
    szem = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomExtentsModifier class]];
    spzm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIPinchZoomModifier class]];
    
    sXPinch = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIAxisPinchZoomModifier class]];
    sYPinch = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIAxisPinchZoomModifier class]];
    sXDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIXAxisDragModifier class]];
    sYDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIYAxisDragModifier class]];
    
    sRollover = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIRolloverModifier class]];
}

-(void) createMultiSurface {
    _surface1 = [[SCIChartSurface alloc] initWithView: _sciChartView1];
    [[_surface1 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface1 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];

    _surface2 = [[SCIChartSurface alloc] initWithView: _sciChartView2];
    [[_surface2 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface2 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    [sSync attachSurface:_surface1];
    [sSync attachSurface:_surface2];
}

-(void) initializeSurface1Data {
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    SCITextFormattingStyle *  textFormatting = [[SCITextFormattingStyle alloc] init];
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
    axis.axisId = @"Y1";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface1.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"X1";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface1.xAxes add:axis];
    [rSync attachAxis:axis];
    
//    SCIAxisPinchZoomModifier * x1Pinch = [SCIAxisPinchZoomModifier new];
    SCIAxisPinchZoomModifier * x1Pinch = [sXPinch modifierForSurface:_surface1];
    x1Pinch.axisId = @"X1";
//    SCIXAxisDragModifier * x1Drag = [SCIXAxisDragModifier new];
    SCIXAxisDragModifier * x1Drag = [sXDrag modifierForSurface:_surface1];
    x1Drag.axisId = @"X1";
    x1Drag.dragMode = SCIAxisDragMode_Scale;
    x1Drag.clipModeX = SCIZoomPanClipMode_None;
    
    SCIAxisPinchZoomModifier * y1Pinch = [sYPinch modifierForSurface:_surface1];//[SCIAxisPinchZoomModifier new];
    y1Pinch.axisId = @"Y1";
    SCIYAxisDragModifier * y1Drag = [sYDrag modifierForSurface:_surface1];//[SCIYAxisDragModifier new];
    y1Drag.axisId = @"Y1";
    y1Drag.dragMode = SCIAxisDragMode_Pan;
    
    SCIRolloverModifier * rollover = [sRollover modifierForSurface:_surface1];
    [rollover.style setRolloverPen:[[SCISolidPenStyle alloc] initWithColorCode:0xA099EE99 withThickness:1.5]];
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[sXPinch, sYPinch, sXDrag, sYDrag,
                                                                               pzm, szem, sRollover]];
    _surface1.chartModifier = gm;
    
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    int dataCount = 20;
    //Getting Fourier dataSeries
    for (int j = 0; j < dataCount; j++) {
        double time = 10 * j / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [priceDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setDrawBorder:YES];
    [ellipsePointMarker setFillBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFd7ffd6]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setPointMarker: ellipsePointMarker];
    [priceRenderableSeries.style setDrawPointMarkers: YES];
    [priceRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7]];
    
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:priceDataSeries];
    
    [_surface1.renderableSeries add:priceRenderableSeries];
    
    [_surface1 invalidateElement];
}

-(void) initializeSurface2Data {
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
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
    [axisStyle setLabelStyle:textFormatting];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"Y2";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface2.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"X2";
    [rSync attachAxis:axis];
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface2.xAxes add:axis];
    
    SCIAxisPinchZoomModifier * x2Pinch = [sXPinch modifierForSurface:_surface2];//[SCIAxisPinchZoomModifier new];
    x2Pinch.axisId = @"X2";
    SCIXAxisDragModifier * x2Drag = [sXDrag modifierForSurface:_surface2];//[SCIXAxisDragModifier new];
    x2Drag.axisId = @"X2";
    x2Drag.dragMode = SCIAxisDragMode_Scale;
    x2Drag.clipModeX = SCIZoomPanClipMode_None;
    
    SCIAxisPinchZoomModifier * y2Pinch = [sYPinch modifierForSurface:_surface2];//[SCIAxisPinchZoomModifier new];
    y2Pinch.axisId = @"Y2";
    SCIYAxisDragModifier * y2Drag = [sYDrag modifierForSurface:_surface2];//[SCIYAxisDragModifier new];
    y2Drag.axisId = @"Y2";
    y2Drag.dragMode = SCIAxisDragMode_Pan;
    
    SCIRolloverModifier * rollover = [sRollover modifierForSurface:_surface2];
    [rollover.style setRolloverPen:[[SCISolidPenStyle alloc] initWithColorCode:0xA0ff8a4c withThickness:1.5]];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[sXPinch, sYPinch, sXDrag, sYDrag,
                                                                               pzm, szem, sRollover]];
    _surface2.chartModifier = gm;
    
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    int dataCount = 1000;
    //Getting Fourier dataSeries
    for (int j = 0; j < dataCount; j++) {
        double time = 10 * j / (double)dataCount;
        double x = time;
        double y = 2 * sin(x)+10;
        [fourierDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    fourierDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
    fourierRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFff8a4c withThickness:0.7];
    
    fourierRenderableSeries.xAxisId = @"X2";
    fourierRenderableSeries.yAxisId = @"Y2";
    [fourierRenderableSeries setDataSeries:fourierDataSeries];
    
    [_surface2.renderableSeries add:fourierRenderableSeries];

    [_surface2 invalidateElement];
}

@end
