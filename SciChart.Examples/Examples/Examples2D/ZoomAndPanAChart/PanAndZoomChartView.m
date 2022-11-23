//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"

@implementation PanAndZoomChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:3 max:6];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    SCDDoubleSeries *data1 = [SCDDataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.01 PointCount:1000 Freq:10];
    SCDDoubleSeries *data2 = [SCDDataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.024 PointCount:1000 Freq:10];
    SCDDoubleSeries *data3 = [SCDDataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.049 PointCount:1000 Freq:10];
    
    [ds1 appendValuesX:data1.xValues y:data1.yValues];
    [ds2 appendValuesX:data2.xValues y:data2.yValues];
    [ds3 appendValuesX:data3.xValues y:data3.yValues];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77b4efdb strokeColor:0xFF68bcae]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77efb4d3 strokeColor:0xFFae418d]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77b4bfed strokeColor:0xFF274b92]];
        [self.surface.chartModifiers addAll:[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], nil];
    }];
}

- (SCIFastMountainRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries brushColor:(unsigned int)brushColor strokeColor:(unsigned int)strokeColor {
    SCIFastMountainRenderableSeries *rSeries = [SCIFastMountainRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:strokeColor thickness:1.0];
    rSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:brushColor];
    rSeries.dataSeries = dataSeries;
    
    [SCIAnimations waveSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
