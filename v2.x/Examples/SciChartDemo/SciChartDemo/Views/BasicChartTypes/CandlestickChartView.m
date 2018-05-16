//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CandlestickChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CandlestickChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation CandlestickChartView

- (void)initExample {
    PriceSeries * priceSeries = [DataManager getPriceDataIndu];
    int size = priceSeries.size;
    
    id<SCIAxis2DProtocol> xAxis = [SCICategoryDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(size - 30) Max:SCIGeneric(size)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIOhlcDataSeries * dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    [dataSeries appendRangeX:SCIGeneric(priceSeries.dateData) Open:SCIGeneric(priceSeries.openData) High:SCIGeneric(priceSeries.highData) Low:SCIGeneric(priceSeries.lowData) Close:SCIGeneric(priceSeries.closeData) Count:priceSeries.size];
    
    SCIFastCandlestickRenderableSeries * rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeUpStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF00AA00 withThickness:1];
    rSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x9000AA00];
    rSeries.strokeDownStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF0000 withThickness:1];
    rSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x90FF0000];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [rSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
