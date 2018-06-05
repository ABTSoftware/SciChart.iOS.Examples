//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PanAndZoomChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "PanAndZoomChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation PanAndZoomChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(3) Max:SCIGeneric(6)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    DoubleSeries * data1 = [DataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.01 PointCount:1000 Freq:10];
    DoubleSeries * data2 = [DataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.024 PointCount:1000 Freq:10];
    DoubleSeries * data3 = [DataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.049 PointCount:1000 Freq:10];
    
    [ds1 appendRangeX:data1.xValues Y:data1.yValues Count:data1.size];
    [ds2 appendRangeX:data2.xValues Y:data2.yValues Count:data2.size];
    [ds3 appendRangeX:data3.xValues Y:data3.yValues Count:data3.size];
    
    SCIFastMountainRenderableSeries * rs1 = [self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77279B27 strokeColor:0xFF177B17];
    SCIFastMountainRenderableSeries * rs2 = [self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77FF1919 strokeColor:0xFFDD0909];
    SCIFastMountainRenderableSeries * rs3 = [self getRenderableSeriesWithDataSeries:ds1 brushColor:0x771964FF strokeColor:0xFF0944CF];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        [self.surface.renderableSeries add:rs3];
        
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
}

- (SCIFastMountainRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries brushColor:(uint)brushColor strokeColor:(uint)strokeColor {
    SCIFastMountainRenderableSeries * rSeries = [SCIFastMountainRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:strokeColor withThickness:1.0];
    rSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:brushColor];
    rSeries.dataSeries = dataSeries;
    [rSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseOut]];
    
    return rSeries;
}

@end
