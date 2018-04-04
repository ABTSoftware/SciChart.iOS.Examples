//
//  LinePerformanceView.m
//  SciChartDemo
//
//  Created by Admin on 28.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "AddPointsPerformanceChartView.h"
#import "RandomUtil.h"
#import "RandomWalkGenerator.h"

@implementation AddPointsPerformanceChartView

- (void)initExample {
    __weak typeof(self) wSelf = self;
    self.append10K = ^{ [wSelf appendPoints:10000]; };
    self.append100K = ^{ [wSelf appendPoints:100000]; };
    self.append1Mln = ^{ [wSelf appendPoints:1000000]; };
    self.clear = ^{ [wSelf clearSeries]; };
    
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
