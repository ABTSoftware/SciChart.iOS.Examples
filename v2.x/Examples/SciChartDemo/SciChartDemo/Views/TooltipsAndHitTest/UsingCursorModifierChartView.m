//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import <SciChart/SciChart.h>
#import "DataManager.h"

static const int PointsCount = 500;

@implementation UsingCursorModifierChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(3) Max:SCIGeneric(6)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)];
    yAxis.autoRange = SCIAutoRange_Always;

    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Green Series";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Red Series";
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds3.seriesName = @"Gray Series";
    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds4.seriesName = @"Gold Series";
    
    DoubleSeries * data1 = [DataManager getNoisySinewaveWithAmplitude:300 Phase:1.0 PointCount:PointsCount NoiseAmplitude:0.25];
    DoubleSeries * data2 = [DataManager getSinewaveWithAmplitude:100 Phase:2 PointCount:PointsCount];
    DoubleSeries * data3 = [DataManager getSinewaveWithAmplitude:200 Phase:1.5 PointCount:PointsCount];
    DoubleSeries * data4 = [DataManager getSinewaveWithAmplitude:50 Phase:0.1 PointCount:PointsCount];
    
    [ds1 appendRangeX:data1.xValues Y:data1.yValues Count:data1.size];
    [ds2 appendRangeX:data2.xValues Y:data2.yValues Count:data2.size];
    [ds3 appendRangeX:data3.xValues Y:data3.yValues Count:data3.size];
    [ds4 appendRangeX:data4.xValues Y:data4.yValues Count:data4.size];
    
    SCIFastLineRenderableSeries * rs1 = [[SCIFastLineRenderableSeries alloc] init];
    rs1.dataSeries = ds1;
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF177B17 withThickness:2.0];
    
    SCIFastLineRenderableSeries * rs2 = [[SCIFastLineRenderableSeries alloc] init];
    rs2.dataSeries = ds2;
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDD0909 withThickness:2.0];
    
    SCIFastLineRenderableSeries * rs3 = [[SCIFastLineRenderableSeries alloc] init];
    rs3.dataSeries = ds3;
    rs3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF808080 withThickness:2.0];
    
    SCIFastLineRenderableSeries * rs4 = [[SCIFastLineRenderableSeries alloc] init];
    rs4.dataSeries = ds4;
    rs4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFD700 withThickness:2.0];
    rs4.isVisible = NO;
    
    SCICursorModifier * cursorModifier = [SCICursorModifier new];
    cursorModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        [self.surface.renderableSeries add:rs3];
        [self.surface.renderableSeries add:rs4];
        [self.surface.chartModifiers add:cursorModifier];
        
        [rs1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [rs2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [rs3 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [rs4 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
