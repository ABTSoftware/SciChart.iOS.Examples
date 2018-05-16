//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import <SciChart/SciChart.h>

@implementation DashedLineChartView

-(void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    int dataCount = 20;
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double y = arc4random_uniform(20);
        
        [priceDataSeries appendX:SCIGeneric(time) Y:SCIGeneric(y)];
    }
    
    dataCount = 1000;
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double y = 2 * sin(time) + 10;
        
        [fourierDataSeries appendX:SCIGeneric(time) Y:SCIGeneric(y)];
    };
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFd6ffd7];
    ellipsePointMarker.height = 5;
    ellipsePointMarker.width = 5;
    
    SCIFastLineRenderableSeries * priceSeries = [SCIFastLineRenderableSeries new];
    priceSeries.pointMarker = ellipsePointMarker;
    priceSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFF99EE99] withThickness:1.f andStrokeDash:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    priceSeries.dataSeries = priceDataSeries;
    
    SCIFastLineRenderableSeries * fourierSeries = [SCIFastLineRenderableSeries new];
    fourierSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFF4c8aff] withThickness:1.f andStrokeDash:@[@(50.f), @(14.f), @(50.f), @(14.f), @(50.f), @(14.f), @(50.f), @(14.f)]];
    fourierSeries.dataSeries = fourierDataSeries;

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:priceSeries];
        [self.surface.renderableSeries add:fourierSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [priceSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [fourierSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
