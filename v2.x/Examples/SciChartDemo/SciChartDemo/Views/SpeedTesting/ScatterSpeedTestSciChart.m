//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSpeedTestSciChart.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ScatterSpeedTestSciChart.h"
#import "BrownianMotionGenerator.h"
#import "RandomUtil.h"

static int const PointsCount = 20000;

@implementation ScatterSpeedTestSciChart{
    NSTimer * _timer;
    SCIXyDataSeries * _scatterDataSeries;
}

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    
    DoubleSeries * doubleSeries = [BrownianMotionGenerator getRandomDataWithMin:-50 max:50 count:PointsCount];
    _scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _scatterDataSeries.acceptUnsortedData = YES;
    [_scatterDataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];

    SCICoreGraphicsPointMarker * marker = [SCICoreGraphicsPointMarker new];
    marker.width = 6;
    marker.height = 6;
    
    SCIXyScatterRenderableSeries * rSeries = [SCIXyScatterRenderableSeries new];
    rSeries.dataSeries = _scatterDataSeries;
    rSeries.pointMarker = marker;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)updateData:(NSTimer *)timer {
    for (int i = 0; i < _scatterDataSeries.count; i++){
        SCIGenericType x = [[_scatterDataSeries xValues] valueAt:i];
        SCIGenericType y = [[_scatterDataSeries yValues] valueAt:i];
        
        [_scatterDataSeries updateAt:i X:SCIGeneric(SCIGenericDouble(x) + randf(-1.0, 1.0)) Y:SCIGeneric(SCIGenericDouble(y) + randf(-0.5, 0.5))];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
