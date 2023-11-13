//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DateAxisLineChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DateAxisChartView.h"
#import "SCDDataManager.h"
#import "SCDTradeData.h"
#import "CustomDateAxisLabelProvider.h"

@implementation DateAxisChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCIDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.labelProvider = [[CustomDateAxisLabelProvider alloc] init];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyzDataSeries *dataSeries = [[SCIXyzDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double zType:SCIDataType_Double];
    NSArray *tradeTicks = [SCDDataManager getTradeTicks];
    for (NSUInteger i = 0, count = tradeTicks.count; i < count; i++) {
        SCDTradeData *tradeData = (SCDTradeData *)tradeTicks[i];
        [dataSeries appendX:tradeData.tradeDate y:tradeData.tradePrice z:tradeData.tradeSize];
    }
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF50C7E0 thickness:2.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations sweepSeries:lineSeries duration:1.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
