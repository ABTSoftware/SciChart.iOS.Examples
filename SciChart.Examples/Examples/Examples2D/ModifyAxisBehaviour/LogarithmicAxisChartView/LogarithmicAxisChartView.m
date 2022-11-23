//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LogarithmicAxisChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "LogarithmicAxisChartView.h"
#import "SCDDataManager.h"

@implementation LogarithmicAxisChartView

- (void)initExample {
    self.xAxis = [self generateLogarithmicAxis];
    self.yAxis = [self generateLogarithmicAxis];
    
    SCIXyDataSeries *dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries1.seriesName = @"Curve A";
    SCIXyDataSeries *dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries2.seriesName = @"Curve B";
    SCIXyDataSeries *dataSeries3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries3.seriesName = @"Curve C";
    
    SCDDoubleSeries *doubleSeries1 = [SCDDataManager getExponentialCurveWithExponent:1.8 count:100];
    SCDDoubleSeries *doubleSeries2 = [SCDDataManager getExponentialCurveWithExponent:2.25 count:100];
    SCDDoubleSeries *doubleSeries3 = [SCDDataManager getExponentialCurveWithExponent:3.59 count:100];
    
    [dataSeries1 appendValuesX:doubleSeries1.xValues y:doubleSeries1.yValues];
    [dataSeries2 appendValuesX:doubleSeries2.xValues y:doubleSeries2.yValues];
    [dataSeries3 appendValuesX:doubleSeries3.xValues y:doubleSeries3.yValues];

    unsigned int line1Color = 0xFFe8c667;
    unsigned int line2Color = 0xFF68bcae;
    unsigned int line3Color = 0xFFc43360;
    
    SCIFastLineRenderableSeries *line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = dataSeries1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line1Color thickness:1.5];
    line1.pointMarker = [self getPointMarkerWithSize:5 colorCode:line1Color];

    SCIFastLineRenderableSeries *line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = dataSeries2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line2Color thickness:1.5];
    line2.pointMarker = [self getPointMarkerWithSize:5 colorCode:line2Color];
    
    SCIFastLineRenderableSeries *line3 = [SCIFastLineRenderableSeries new];
    line3.dataSeries = dataSeries3;
    line3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line3Color thickness:1.5];
    line3.pointMarker = [self getPointMarkerWithSize:5 colorCode:line3Color];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:self.xAxis];
        [self.surface.yAxes add:self.yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.renderableSeries add:line3];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations sweepSeries:line1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line2 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line3 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

- (SCIEllipsePointMarker *)getPointMarkerWithSize:(int)size colorCode:(uint)colorCode {
    SCIEllipsePointMarker *pointMarker = [SCIEllipsePointMarker new];
    pointMarker.size = CGSizeMake(size, size);
    pointMarker.strokeStyle = SCIPenStyle.TRANSPARENT;
    pointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:colorCode];
    
    return pointMarker;
}

@end
