//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingCursorModifierChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingCursorModifierChartView.h"
#import "SCDDataManager.h"

static const int PointsCount = 500;

@implementation UsingCursorModifierChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:3 max:6];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.05 max:0.05];
    yAxis.autoRange = SCIAutoRange_Always;

    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds1.seriesName = @"Green Series";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds2.seriesName = @"Red Series";
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds3.seriesName = @"Gray Series";
    SCIXyDataSeries *ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds4.seriesName = @"Gold Series";
    
    SCDDoubleSeries *data1 = [SCDDataManager getNoisySinewaveWithAmplitude:300 Phase:1.0 PointCount:PointsCount NoiseAmplitude:0.25];
    SCDDoubleSeries *data2 = [SCDDataManager getSinewaveWithAmplitude:100 Phase:2 PointCount:PointsCount];
    SCDDoubleSeries *data3 = [SCDDataManager getSinewaveWithAmplitude:200 Phase:1.5 PointCount:PointsCount];
    SCDDoubleSeries *data4 = [SCDDataManager getSinewaveWithAmplitude:50 Phase:0.1 PointCount:PointsCount];
    
    [ds1 appendValuesX:data1.xValues y:data1.yValues];
    [ds2 appendValuesX:data2.xValues y:data2.yValues];
    [ds3 appendValuesX:data3.xValues y:data3.yValues];
    [ds4 appendValuesX:data4.xValues y:data4.yValues];
    
    SCIFastLineRenderableSeries *rSeries1 = [SCIFastLineRenderableSeries new];
    rSeries1.dataSeries = ds1;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:2.0];
    
    SCIFastLineRenderableSeries *rSeries2 = [SCIFastLineRenderableSeries new];
    rSeries2.dataSeries = ds2;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFc43360 thickness:2.0];
    
    SCIFastLineRenderableSeries *rSeries3 = [SCIFastLineRenderableSeries new];
    rSeries3.dataSeries = ds3;
    rSeries3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFd6dee8 thickness:2.0];
    
    SCIFastLineRenderableSeries *rSeries4 = [SCIFastLineRenderableSeries new];
    rSeries4.dataSeries = ds4;
    rSeries4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe8c667 thickness:2.0];
    rSeries4.isVisible = NO;
    
    self.cursorModifier = [SCICursorModifier new];
    self.cursorModifier.sourceMode = self.sourceMode;
    self.cursorModifier.showTooltip = self.showTooltip;
    self.cursorModifier.showAxisLabel = self.showAxisLabel;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries addAll:rSeries1, rSeries2, rSeries3, rSeries4, nil];
        [self.surface.chartModifiers add:self.cursorModifier];
        
        [SCIAnimations sweepSeries:rSeries1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rSeries2 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rSeries3 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rSeries4 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
