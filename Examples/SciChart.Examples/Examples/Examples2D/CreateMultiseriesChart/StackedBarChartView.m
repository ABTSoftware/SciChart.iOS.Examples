//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedBarChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "StackedBarChartView.h"
#import "SCDDataManager.h"

@implementation StackedBarChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;
    yAxis.flipCoordinates = YES;
    
    double yValues1[] = {0.0, 0.1, 0.2, 0.4, 0.8, 1.1, 1.5, 2.4, 4.6, 8.1, 11.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 5.4, 6.4, 7.1, 8.0, 9.0};
    double yValues2[] = {2.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 0.1, 1.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 0.4, 10.1, 0.0, 0.0};
    double yValues3[] = {20.0, 4.1, 4.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 5.1, 5.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 10.4, 8.1, 10.0, 15.0};
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds1.seriesName = @"Data 1";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds2.seriesName = @"Data 2";
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds3.seriesName = @"Data 3";
    
    int size = sizeof(yValues1) / sizeof(yValues1[0]);
    for (int i = 0; i < size; i++) {
        double xValue = (double)i;
        [ds1 appendX:@(xValue) y:@(yValues1[i])];
        [ds2 appendX:@(xValue) y:@(yValues2[i])];
        [ds3 appendX:@(xValue) y:@(yValues3[i])];
    }
    
    SCIVerticallyStackedColumnsCollection *columnCollection = [SCIVerticallyStackedColumnsCollection new];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds1 startColor:0xff567893 endColor:0xff3D5568]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds2 startColor:0xffACBCCA endColor:0xff439AAF]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds3 startColor:0xffDBE0E1 endColor:0xffB6C1C3]];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnCollection];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCICursorModifier new], nil];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries startColor:(uint)startColor endColor:(uint)endColor {
    SCIStackedColumnRenderableSeries *rSeries = [SCIStackedColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0.0, 1.0) startColorCode:startColor endColorCode:endColor];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.blackColor thickness:0.5];

    [SCIAnimations waveSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
