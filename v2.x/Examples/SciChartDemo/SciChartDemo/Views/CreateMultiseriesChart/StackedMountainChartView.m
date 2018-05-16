//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedMountainChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "StackedMountainChartView.h"

@implementation StackedMountainChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];

    double yValues1[] = { 4.0,  7,    5.2,  9.4,  3.8,  5.1, 7.5,  12.4, 14.6, 8.1, 11.7, 14.4, 16.0, 3.7, 5.1, 6.4, 3.5, 2.5, 12.4, 16.4, 7.1, 8.0, 9.0 };
    double yValues2[] = { 15.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4,  4.6,  0.1, 1.7, 14.4, 6.0, 13.7, 10.1, 8.4, 8.5, 12.5, 1.4, 0.4, 10.1, 5.0, 1.0 };
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    for (int i = 0; i < ((sizeof(yValues1)/sizeof(double))); i++) {
        [ds1 appendX:SCIGeneric(i) Y:SCIGeneric(yValues1[i])];
        [ds2 appendX:SCIGeneric(i) Y:SCIGeneric(yValues2[i])];
    }
    
    SCIStackedMountainRenderableSeries * rSeries1 = [SCIStackedMountainRenderableSeries new];
    rSeries1.dataSeries = ds1;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:1.0];
    rSeries1.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xDDDBE0E1 finish:0x88B6C1C3 direction:SCILinearGradientDirection_Vertical];
    
    SCIStackedMountainRenderableSeries * rSeries2 = [SCIStackedMountainRenderableSeries new];
    rSeries2.dataSeries = ds2;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:1.0];
    rSeries2.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xDDACBCCA finish:0x88439AAF direction:SCILinearGradientDirection_Vertical];
    
    SCIVerticallyStackedMountainsCollection * seriesCollection = [SCIVerticallyStackedMountainsCollection new];
    [seriesCollection add:rSeries1];
    [seriesCollection add:rSeries2];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:seriesCollection];
        [self.surface.chartModifiers add:[SCITooltipModifier new]];
        
        [seriesCollection addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
