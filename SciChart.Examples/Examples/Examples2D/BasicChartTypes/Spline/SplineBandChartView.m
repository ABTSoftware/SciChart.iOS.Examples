//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineBandChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SplineBandChartView.h"
#import "SCDDataManager.h"

@implementation SplineBandChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    
    SCDDoubleSeries *data = [SCDDataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.005 PointCount:1000 Freq:13];
    SCDDoubleSeries *moreData = [SCDDataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.005 PointCount:1000 Freq:12];
    
    SCIXyyDataSeries *dataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    for (int i = 0; i < 10; i++) {
        int index = i * 100;
        double x = [data.xValues getValueAt:index];
        double y = [data.yValues getValueAt:index];
        double y1 = [moreData.yValues getValueAt:index];
        [dataSeries appendX:@(x) y:@(y) y1:@(y1)];
    }
    
    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1.0 strokeDashArray:NULL antiAliasing:YES];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFFFFF];
    ellipsePointMarker.size = CGSizeMake(7, 7);
    
    SCISplineBandRenderableSeries *rSeries = [SCISplineBandRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.pointMarker = ellipsePointMarker;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x3350C7E0];
    rSeries.fillY1BrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x33F48420];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF50C7E0 thickness:2.0];
    rSeries.strokeY1Style = [[SCISolidPenStyle alloc] initWithColorCode:0xFFF48420 thickness:2.0];
    
    SCIElasticEase* easingFunction = [SCIElasticEase new];
    easingFunction.springiness = 5;
    easingFunction.oscillations = 1;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];

        [SCIAnimations scaleSeries:rSeries duration:1.0 andEasingFunction:easingFunction];
    }];
}

@end
