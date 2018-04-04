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

static double const TimeInterval = 0.02;

@implementation ECGChartView {
    SCIXyDataSeries * _series0;
    SCIXyDataSeries * _series1;
    NSArray * _sourceData;
    
    NSTimer * _timer;
    int _currentIndex;
    int _totalIndex;
    
    TraceAOrB _whichTrace;
}

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    _sourceData = [DataManager loadWaveformData];
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Never;
    xAxis.axisTitle = @"Time (seconds)";
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(10)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Never;
    yAxis.axisTitle = @"Voltage (mV)";
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-0.5) Max:SCIGeneric(1.5)];
    
    _series0 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _series0.fifoCapacity = 3850;
    _series1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _series1.fifoCapacity = 3850;
    
    SCIFastLineRenderableSeries * rSeries1 = [SCIFastLineRenderableSeries new];
    rSeries1.dataSeries = _series0;
    SCIFastLineRenderableSeries * rSeries2 = [SCIFastLineRenderableSeries new];
    rSeries2.dataSeries = _series1;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries1];
        [surface.renderableSeries add:rSeries2];
        
        [SCIThemeManager applyDefaultThemeToThemeable:surface];
    }];
}

- (void)appendData:(NSTimer *)timer {
    for (int i = 0; i < 10; i++) {
        [self appendPoint:400];
    }
}

- (void)appendPoint:(double)sampleRate {
    if (_currentIndex >= _sourceData.count) {
        _currentIndex = 0;
    }
    
    // Get the next voltage and time, and append to the chart
    double voltage = [(NSNumber *)[_sourceData objectAtIndex:_currentIndex] doubleValue];
    double time = fmod((_totalIndex / sampleRate), 10.0);
    
    if (_whichTrace == TraceA) {
        [_series0 appendX:SCIGeneric(time) Y:SCIGeneric(voltage)];
        [_series1 appendX:SCIGeneric(time) Y:SCIGeneric(NAN)];
    } else {
        [_series0 appendX:SCIGeneric(time) Y:SCIGeneric(NAN)];
        [_series1 appendX:SCIGeneric(time) Y:SCIGeneric(voltage)];
    }
    
    _currentIndex++;
    _totalIndex++;
    
    if (_totalIndex % 4000 == 0) {
        _whichTrace = _whichTrace == TraceA ? TraceB : TraceA;
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(appendData:) userInfo:nil repeats:YES];
    } else {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
