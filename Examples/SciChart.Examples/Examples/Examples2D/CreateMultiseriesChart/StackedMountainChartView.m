//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    double yValues1[] = {4.0,  7,    5.2,  9.4,  3.8,  5.1, 7.5,  12.4, 14.6, 8.1, 11.7, 14.4, 16.0, 3.7, 5.1, 6.4, 3.5, 2.5, 12.4, 16.4, 7.1, 8.0, 9.0};
    double yValues2[] = {15.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4,  4.6,  0.1, 1.7, 14.4, 6.0, 13.7, 10.1, 8.4, 8.5, 12.5, 1.4, 0.4, 10.1, 5.0, 1.0};
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    for (unsigned long i = 0; i < ((sizeof(yValues1)/sizeof(double))); i++) {
        [ds1 appendX:@(i) y:@(yValues1[i])];
        [ds2 appendX:@(i) y:@(yValues2[i])];
    }
    
    SCIStackedMountainRenderableSeries *rSeries1 = [SCIStackedMountainRenderableSeries new];
    rSeries1.dataSeries = ds1;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF thickness:1.0];
    rSeries1.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0.0, 1.0) startColorCode:0xDDDBE0E1 endColorCode:0x88B6C1C3];
    
    SCIStackedMountainRenderableSeries *rSeries2 = [SCIStackedMountainRenderableSeries new];
    rSeries2.dataSeries = ds2;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF thickness:1.0];
    rSeries2.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0.0, 1.0) startColorCode:0xDDACBCCA endColorCode:0x88439AAF];
    
    SCIVerticallyStackedMountainsCollection *seriesCollection = [SCIVerticallyStackedMountainsCollection new];
    [seriesCollection add:rSeries1];
    [seriesCollection add:rSeries2];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:[SCINumericAxis new]];
        [self.surface.yAxes add:[SCINumericAxis new]];
        [self.surface.renderableSeries add:seriesCollection];
        [self.surface.chartModifiers add:[SCITooltipModifier new]];
        
        [SCIAnimations waveSeries:rSeries1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations waveSeries:rSeries2 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
