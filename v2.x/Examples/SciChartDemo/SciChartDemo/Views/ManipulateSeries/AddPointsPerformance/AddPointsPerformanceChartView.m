//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddPointsPerformanceChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AddPointsPerformanceChartView.h"
#import "RandomUtil.h"
#import "RandomWalkGenerator.h"

@implementation AddPointsPerformanceChartView

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    self.append10K = ^{ [wSelf appendPoints:10000]; };
    self.append100K = ^{ [wSelf appendPoints:100000]; };
    self.append1Mln = ^{ [wSelf appendPoints:1000000]; };
    self.clear = ^{ [wSelf clearSeries]; };
}

- (void)initExample {
    [self.surface.xAxes add:[SCINumericAxis new]];
    [self.surface.yAxes add:[SCINumericAxis new]];
    self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
}

- (void)appendPoints:(int)count {
    DoubleSeries * doubleSeries = [[[RandomWalkGenerator new] setBias:randf(0.0, 1.0) / 100] getRandomWalkSeries:count];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:[UIColor colorWithRed:randf(0, 1) green:randf(0, 1) blue:randf(0, 1) alpha:1.0].colorARGBCode withThickness:1];
    
    [self.surface.renderableSeries add:rSeries];
    [self.surface animateZoomExtents:0.5];
}

- (void)clearSeries {
    [self.surface.renderableSeries clear];
}

@end
