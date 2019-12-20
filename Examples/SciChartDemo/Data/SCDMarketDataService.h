//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMarketDataService.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPriceBar.h"
#import "SCDPriceSeries.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^PriceUpdateCallback) (SCDPriceBar *priceBar);

@interface SCDMarketDataService : NSObject

- (instancetype)initWithStartDate:(NSDate *)startDate TimeFrameMinutes:(NSTimeInterval)timeFrameMinutes TickTimerIntervals:(NSTimeInterval)tickTimerIntervals;

- (void)subscribePriceUpdate:(PriceUpdateCallback)callback;

- (SCDPriceSeries *)getHistoricalData:(NSInteger)numberBars;

- (void)clearSubscriptions;

- (SCDPriceBar *)getNextBar;

@end

NS_ASSUME_NONNULL_END
