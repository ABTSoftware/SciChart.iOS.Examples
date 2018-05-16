//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ECGChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ECGChartView.h"
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

- (void)initExample {
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
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        
        [SCIThemeManager applyDefaultThemeToThemeable:self.surface];
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
