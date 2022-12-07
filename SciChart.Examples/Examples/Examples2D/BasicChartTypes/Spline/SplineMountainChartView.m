//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineMountainChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SplineMountainChartView.h"

@implementation SplineMountainChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0 max:0.2];
    
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Int];
    int yValues[] = {50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60};
    for (unsigned long i = 0; i < sizeof(yValues)/sizeof(yValues[0]); i++) {
        [dataSeries appendX:@(i) y:@(yValues[i])];
    }
    
    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF50C7E0 thickness:2.0 strokeDashArray:NULL antiAliasing:YES];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7750C7E0];
    ellipsePointMarker.size = CGSizeMake(9, 9);
    
    SCISplineMountainRenderableSeries *rSeries = [SCISplineMountainRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.pointMarker = ellipsePointMarker;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF50C7E0 thickness:3.0 strokeDashArray:NULL antiAliasing:YES];
    rSeries.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointMake(0, 1) end:CGPointZero startColorCode:0xFF83D2F5 endColorCode:0x0083D2F5];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations waveSeries:rSeries duration:1.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
