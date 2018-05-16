//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FIFOSpeedTestSciChart.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "FIFOSpeedTestSciChart.h"
#import "RandomWalkGenerator.h"

static int const PointsCount = 1000;

@implementation FIFOSpeedTestSciChart {
    NSTimer * _timer;

    SCIXyDataSeries * _dataSeries;
    RandomWalkGenerator * _randomWalk;
    int _xCount;
}

-(void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;

    _randomWalk = [RandomWalkGenerator new];
    DoubleSeries * doubleSeries = [_randomWalk getRandomWalkSeries:PointsCount];
    
    _dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _dataSeries.fifoCapacity = PointsCount;
    [_dataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:PointsCount];
    _xCount += PointsCount;
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = _dataSeries;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)updateData:(NSTimer *)timer {
    [_dataSeries appendX:SCIGeneric(_xCount) Y:SCIGeneric([_randomWalk next])];
    _xCount++;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
