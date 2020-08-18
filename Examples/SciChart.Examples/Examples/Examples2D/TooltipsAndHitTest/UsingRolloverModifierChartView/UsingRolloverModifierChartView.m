//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingRolloverModifierChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingRolloverModifierChartView.h"

@implementation UsingRolloverModifierChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double];
    ds1.seriesName = @"Sinewave A";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double];
    ds2.seriesName = @"Sinewave B";
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double];
    ds3.seriesName = @"Sinewave C";
    
    double count = 100;
    double k = 2 * M_PI / 30.0;
    for (int i = 0; i < count; i++) {
        double phi = k * i;
        [ds1 appendX:@(i) y:@((1.0 + i / count) * sin(phi))];
        [ds2 appendX:@(i) y:@((0.5 + i / count) * sin(phi))];
        [ds3 appendX:@(i) y:@((i / count) * sin(phi))];
    }
    
    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFD7FFD6];
    ellipsePointMarker.size = CGSizeMake(7, 7);
 
    SCIFastLineRenderableSeries *rSeries1 = [SCIFastLineRenderableSeries new];
    rSeries1.dataSeries = ds1;
    rSeries1.pointMarker = ellipsePointMarker;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFA1B9D7 thickness:1];
    
    SCIFastLineRenderableSeries *rSeries2 = [SCIFastLineRenderableSeries new];
    rSeries2.dataSeries = ds2;
    rSeries2.pointMarker = ellipsePointMarker;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0B5400 thickness:1];
    
    SCIFastLineRenderableSeries *rSeries3 = [SCIFastLineRenderableSeries new];
    rSeries3.dataSeries = ds3;
    rSeries3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF386EA6 thickness:1];
    
    self.rolloverModifier = [SCIRolloverModifier new];
    self.rolloverModifier.sourceMode = self.sourceMode;
    self.rolloverModifier.showTooltip = self.showTooltip;
    self.rolloverModifier.showAxisLabel = self.showAxisLabel;
    self.rolloverModifier.drawVerticalLine = self.drawVerticalLine;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.renderableSeries add:rSeries3];
        [self.surface.chartModifiers add:self.rolloverModifier];
        
        [SCIAnimations sweepSeries:rSeries1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rSeries2 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rSeries3 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
