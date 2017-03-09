//
//  ECGChartView.m
//  SciChartDemo
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ECGChartView.h"
#import <SciChart/SciChart.h>
#include <math.h>
#include "DataManager.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation ECGChartView{
    SCIXyDataSeries * dataSeries;
    SCIXyDataSeries * _sourceData;
    
    NSTimer *timer;
    double test10LastValue;
    int test10XCounter;
    BOOL _isBeat;
    BOOL _lastBeat;
    int _heartRate;
    NSDate *_lastBeatTime;
    int _currentIndex;
    int _totalIndex;
}

@synthesize sciChartSurfaceView;
@synthesize surface;

-(SCIFastLineRenderableSeries*) getECGRenderableSeries{
    dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_Fifo];
    [dataSeries setFifoCapacity:1500];
    
    dataSeries.seriesName = @"ECG";
    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * ecgRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    
    [ecgRenderableSeries.style setLinePen:[[SCISolidPenStyle alloc] initWithColorCode:0xFFb3e8f6 withThickness:0.5]];
    [ecgRenderableSeries setXAxisId: @"xAxis"];
    [ecgRenderableSeries setYAxisId: @"yAxis"];
    [ecgRenderableSeries setDataSeries:dataSeries];
    
    return ecgRenderableSeries;
}

-(void)updateECGData:(NSTimer *)timer{
    for (int i = 0; i < 10; i++)
    [self AppendPoint:400];
    _isBeat = [[dataSeries yValues] valueAt:[dataSeries count]-3].doubleData > 0.5 ||
    [[dataSeries yValues] valueAt:[dataSeries count]-5].doubleData > 0.5||
    [[dataSeries yValues] valueAt:[dataSeries count]-8].doubleData > 0.5;
    
    if (_isBeat && !_lastBeat)
    {
        _heartRate = (int)(60.0 / [_lastBeatTime timeIntervalSinceNow]);
        _lastBeatTime = [NSDate date];
    }
}

-(void) AppendPoint:(double) sampleRate{
    if (_currentIndex >= [_sourceData count]) {
        _currentIndex = 0;
    }
    
    // Get the next voltage and time, and append to the chart
    double voltage = [[_sourceData yValues] valueAt:_currentIndex].floatData*1000;
    double time = _totalIndex / sampleRate;
    [dataSeries appendX:SCIGeneric(time) Y:SCIGeneric(voltage)];
    [surface invalidateElement];
    _lastBeat = _isBeat;
    _currentIndex++;
    _totalIndex++;
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
        
        _currentIndex=0;
        _totalIndex =0;
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    _sourceData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [DataManager loadDataFromFile:_sourceData fileName:@"WaveformData"];
    _lastBeatTime = [NSDate date];
    
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
    
    float updateTime = 1.0f / 30.0f;
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    [axis setAutoRange:SCIAutoRange_Always];
    [axis setAnimatedChangeDuration: updateTime*2 ];
    [axis setAnimateVisibleRangeChanges: YES];
    [axis setAxisId: @"yAxis"];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setAutoRange:SCIAutoRange_Always];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    axis.animatedChangeDuration = updateTime*2;
    axis.animateVisibleRangeChanges = YES;
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
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    [zpm setModifierName:@"PanZoom Modifier"];    
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm]];
    surface.chartModifier = gm;
    
    [surface.renderableSeries add: [self getECGRenderableSeries]];
    
    [surface invalidateElement];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                 target:self
                                               selector:@selector(updateECGData:)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

@end
