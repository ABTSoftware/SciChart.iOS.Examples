//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CreateLargeTradesStockChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "LargeTradesStockChartView.h"
#import "SCDDataManager.h"
#import "SCDLargeTradeGenerator.h"

@implementation LargeTradesStockChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    SCIOhlcDataSeries *historicalData = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    SCIXyzDataSeries *largeSellTradesData = [[SCIXyzDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double zType:SCIDataType_Double];
    SCIXyzDataSeries *largeBuyTradesData = [[SCIXyzDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double zType:SCIDataType_Double];
    
    SCDLargeTradeGenerator *largeTradeGenerator = [SCDLargeTradeGenerator new];
    
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    NSArray<SCDLargeTradeBar *> *largeSellTradesList = [largeTradeGenerator generateLargeTradesForPriceSeries:priceSeries];
    NSArray<SCDLargeTradeBar *> *largeBuyTradesList = [largeTradeGenerator generateLargeTradesForPriceSeries:priceSeries];
    
    NSInteger count = priceSeries.count;
    SCIDateValues *dateData = priceSeries.dateData;
    
    [historicalData appendValuesX:dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    [self p_SCD_appendLargeTrades:largeSellTradesList toDataSeries:largeSellTradesData];
    [self p_SCD_appendLargeTrades:largeBuyTradesList toDataSeries:largeBuyTradesData];
    
    SCIDataSeriesIndexDataProvider *indexDataProvider = [[SCIDataSeriesIndexDataProvider alloc] initWithDataSeriesValues:historicalData];
    SCIIndexDateAxis *xAxis = [SCIIndexDateAxis new];
    [xAxis setIndexDataProvider:indexDataProvider];
    xAxis.visibleRange = [[SCIDateRange alloc] initWithMin:[dateData getValueAt:count - 30] max:[dateData getValueAt:count - 1]];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    id<ISCIRenderableSeries> historicalPrices = [SCIFastCandlestickRenderableSeries new];
    historicalPrices.dataSeries = historicalData;
    
    SCIFastBubbleRenderableSeries *largeBuyTrades = [SCIFastBubbleRenderableSeries new];
    largeBuyTrades.dataSeries = largeBuyTradesData;
    largeBuyTrades.bubbleBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x774248F5];
    largeBuyTrades.autoZRange = NO;
    largeBuyTrades.strokeStyle = SCISolidPenStyle.TRANSPARENT;
    
    SCIFastBubbleRenderableSeries *largeSellTrades = [SCIFastBubbleRenderableSeries new];
    largeSellTrades.dataSeries = largeSellTradesData;
    largeSellTrades.bubbleBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x77F542AA];
    largeSellTrades.autoZRange = NO;
    largeSellTrades.strokeStyle = SCISolidPenStyle.TRANSPARENT;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries addAll:historicalPrices, largeBuyTrades, largeSellTrades, nil];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations waveSeries:historicalPrices duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations waveSeries:largeBuyTrades duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations waveSeries:largeSellTrades duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}
     
- (void)p_SCD_appendLargeTrades:(NSArray<SCDLargeTradeBar *> *)largeTrades toDataSeries:(id<ISCIXyzDataSeries>)dataSeries {
    for (NSInteger i = 0, count = largeTrades.count; i < count; i++) {
        SCDLargeTradeBar *largeTradeBar = largeTrades[i];
        NSDate *date = largeTradeBar.date;
        
        for (NSInteger j = 0, count = largeTradeBar.largeTrades.count; j < count; j++) {
            SCDLargeTrade *largeTrade = largeTradeBar.largeTrades[j];
            [dataSeries appendX:date y:@(largeTrade.price) z:@(largeTrade.volume)];
        }
    }
}

@end
