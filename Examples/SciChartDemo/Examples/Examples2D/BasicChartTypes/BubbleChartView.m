//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BubbleChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "BubbleChartView.h"
#import "SCDDataManager.h"
#import "SCDTradeData.h"

@implementation BubbleChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCIDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    SCIXyzDataSeries *dataSeries = [[SCIXyzDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double zType:SCIDataType_Double];
    NSArray *tradeTicks = [SCDDataManager getTradeTicks];
    for (int i = 0; i < tradeTicks.count; i++) {
        SCDTradeData *tradeData = (SCDTradeData *)tradeTicks[i];
        [dataSeries appendX:tradeData.tradeDate y:tradeData.tradePrice z:tradeData.tradeSize];
    }
    
    SCIFastBubbleRenderableSeries *rSeries = [SCIFastBubbleRenderableSeries new];
    rSeries.bubbleBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x50CCCCCC];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFCCCCCC thickness:1.0];
    rSeries.zScaleFactor = 1.0;
    rSeries.autoZRange = NO;
    rSeries.dataSeries = dataSeries;

    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xffff3333 thickness:2.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCIZoomExtentsModifier new]];

        [SCIAnimations scaleSeries:rSeries withZeroLine:10600 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:lineSeries withZeroLine:10600 duration:3.0 andEasingFunction:[SCIElasticEase new]];
    }];
}

@end
