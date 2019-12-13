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
    
    SCIFastLineRenderableSeries *rs1 = [SCIFastLineRenderableSeries new];
    rs1.dataSeries = ds1;
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF177B17 thickness:2.0];
    
    SCIFastLineRenderableSeries *rs2 = [SCIFastLineRenderableSeries new];
    rs2.dataSeries = ds2;
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDD0909 thickness:2.0];
    
    SCIFastLineRenderableSeries *rs3 = [SCIFastLineRenderableSeries new];
    rs3.dataSeries = ds3;
    rs3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF808080 thickness:2.0];
    
    SCIFastLineRenderableSeries *rs4 = [SCIFastLineRenderableSeries new];
    rs4.dataSeries = ds4;
    rs4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFD700 thickness:2.0];
    rs4.isVisible = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        [self.surface.renderableSeries add:rs3];
        [self.surface.renderableSeries add:rs4];
        [self.surface.chartModifiers add:[SCICursorModifier new]];
        
        [SCIAnimations sweepSeries:rs1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rs2 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rs3 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rs4 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
