//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DashedLineChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DashedLineChartView.h"

@implementation DashedLineChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    int dataCount = 20;
    SCIXyDataSeries *priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double y = arc4random_uniform(20);
        
        [priceDataSeries appendX:@(time) y:@(y)];
    }
    
    dataCount = 1000;
    SCIXyDataSeries *fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double y = 2 * sin(time) + 10;
        
        [fourierDataSeries appendX:@(time) y:@(y)];
    };
    
    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFd6ffd7];
    ellipsePointMarker.size = CGSizeMake(5, 5);
    
    SCIFastLineRenderableSeries *priceSeries = [SCIFastLineRenderableSeries new];
    priceSeries.pointMarker = ellipsePointMarker;
    priceSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[SCIColor fromARGBColorCode:0xFF68bcae] thickness:1.f strokeDashArray:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    priceSeries.dataSeries = priceDataSeries;
    
    SCIFastLineRenderableSeries *fourierSeries = [SCIFastLineRenderableSeries new];
    fourierSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[SCIColor fromARGBColorCode:0xFF68bcae] thickness:1.f strokeDashArray:@[@(50.f), @(14.f), @(50.f), @(14.f), @(50.f), @(14.f), @(50.f), @(14.f)]];
    fourierSeries.dataSeries = fourierDataSeries;

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:priceSeries];
        [self.surface.renderableSeries add:fourierSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations sweepSeries:priceSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:fourierSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
