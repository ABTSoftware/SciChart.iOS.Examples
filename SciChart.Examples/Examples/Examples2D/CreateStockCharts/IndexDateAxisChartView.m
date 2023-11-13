//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// IndexDateAxisChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "IndexDateAxisChartView.h"
#import "SCDDataManager.h"

@implementation IndexDateAxisChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    
    SCIOhlcDataSeries *historicalData = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndex];
    NSInteger count = priceSeries.count;
    SCIDateValues *dateData = priceSeries.dateData;
    SCIDataSeriesIndexDataProvider *indexDataProvider = [[SCIDataSeriesIndexDataProvider alloc] initWithDataSeriesValues:historicalData];
    
    SCIIndexDateAxis *xAxis = [SCIIndexDateAxis new];
    [xAxis setIndexDataProvider:indexDataProvider];
    xAxis.visibleRange = [[SCIDateRange alloc] initWithMin:[dateData getValueAt:count - 30] max:[dateData getValueAt:count - 1]];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
        [historicalData appendValuesX:dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastCandlestickRenderableSeries *historicalPrices = [SCIFastCandlestickRenderableSeries new];
    historicalPrices.dataSeries = historicalData;
    historicalPrices.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF67BDAF thickness:1];
    historicalPrices.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7767BDAF];
    historicalPrices.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:1];
    historicalPrices.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x77DC7969];
    
    double y[] = {124.17, 157.38, 143.90, 156.30, 147.70, 162.14};

    NSArray *arrr = @[ @"2023.01.03",
                       @"2023.02.03",
                       @"2023.03.02",
                       @"2023.03.06",
                       @"2023.03.13",
                       @"2023.03.22"];
    NSMutableArray *arrDates = [[NSMutableArray alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy.MM.dd"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    for (NSUInteger i = 0; i<arrr.count; i++) {
        [arrDates addObject:[df dateFromString:arrr[i]]];
    }
    SCIDateValues *xValues = [SCIDateValues new];
    for (NSUInteger i = 0; i<arrDates.count; i++) {
        [xValues add:arrDates[i]];
    }
    
    SCIDoubleValues *yValues = [SCIDoubleValues new];
    for (NSUInteger i = 0; i < arrDates.count; i++) {
        [yValues add:y[i]];
    }
    
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    [lineDataSeries appendValuesX:xValues y:yValues];
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:3.0];
    
    SCIXyDataSeries *movingAverageSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    [movingAverageSeries appendValuesX:dateData y:[SCDDataManager computeMovingAverageOf:priceSeries.lowData length:14]];
    
    SCIFastLineRenderableSeries *averageSeries = [SCIFastLineRenderableSeries new];
    averageSeries.dataSeries = movingAverageSeries;
    averageSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:2.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries addAll:historicalPrices,lineSeries, averageSeries, nil];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        [SCIAnimations fadeSeries:historicalPrices duration:1.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations scaleSeries:lineDataSeries withZeroLine:6000 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:averageSeries withZeroLine:6000 duration:3.0 andEasingFunction:[SCIElasticEase new]];
    }];
}

@end
