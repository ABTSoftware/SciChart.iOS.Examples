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
    for (NSUInteger i = 0, count = tradeTicks.count; i < count; i++) {
        SCDTradeData *tradeData = (SCDTradeData *)tradeTicks[i];
        [dataSeries appendX:tradeData.tradeDate y:tradeData.tradePrice z:tradeData.tradeSize];
    }
    
    self.rSeries = [SCIFastBubbleRenderableSeries new];
    self.rSeries.bubbleBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x30F48420];
    self.rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFF48420 thickness:3.0];
    self.rSeries.autoZRange = NO;
    self.rSeries.dataSeries = dataSeries;

    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF50C7E0 thickness:2.0];
    
    SCIElasticEase* easingFunction = [SCIElasticEase new];
    easingFunction.springiness = 5;
    easingFunction.oscillations = 1;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:self.rSeries];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCIRubberBandXyZoomModifier new], nil];

        [SCIAnimations scaleSeries:self.rSeries withZeroLine:10600 duration:1.0 andEasingFunction:easingFunction];
        [SCIAnimations scaleSeries:lineSeries withZeroLine:10600 duration:1.0 andEasingFunction:easingFunction];
    }];
}

@end
