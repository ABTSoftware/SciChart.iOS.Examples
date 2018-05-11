//
//  NxMSeriesSpeedTestSciChart.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/13/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "NxMSeriesSpeedTestSciChart.h"
#import "RandomWalkGenerator.h"

static int const SeriesCount = 100;
static int const PointsCount = 100;

@implementation NxMSeriesSpeedTestSciChart{
    NSTimer * _timer;
    
    SCINumericAxis * _yAxis;

    int _updateNumber;
    double _rangeMin;
    double _rangeMax;
}

- (void)initExample {
    _rangeMin = _rangeMax = NAN;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    _yAxis = [SCINumericAxis new];

    RandomWalkGenerator * randomWalk = [RandomWalkGenerator new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:_yAxis];
        
        uint color = 0xFFff8a4c;
        for (int i = 0; i < SeriesCount; i++) {
            [randomWalk reset];
            DoubleSeries * doubleSeries = [randomWalk getRandomWalkSeries:PointsCount];
            SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
            [dataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:PointsCount];
            
            color = (color + 0x10f00F) | 0xFF000000;
            
            SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
            rSeries.dataSeries = dataSeries;
            rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:0.5];
            
            [self.surface.renderableSeries add:rSeries];
        }
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)updateData:(NSTimer *)timer {
    if (isnan(_rangeMin)) {
        _rangeMin = SCIGenericDouble(_yAxis.visibleRange.min);
        _rangeMax = SCIGenericDouble(_yAxis.visibleRange.max);
    }
    
    double scaleFactor = fabs(sin(_updateNumber * 0.1)) + 0.5;
    _yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:(SCIGeneric(_rangeMin * scaleFactor)) Max:(SCIGeneric(_rangeMax * scaleFactor))];
    _updateNumber++;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
