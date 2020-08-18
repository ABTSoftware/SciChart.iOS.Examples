//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMarketDataService.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMarketDataService.h"
#import "SCDRandomPricesDataSource.h"

@implementation SCDMarketDataService {
    SCDRandomPriceDataSource *_generator;
    PriceUpdateCallback _newDataCallback;
    
    NSTimer *_timer;
    NSTimeInterval _tickTimerIntervals;
    BOOL _isRunning;
}

- (instancetype)initWithStartDate:(NSDate *)startDate TimeFrameMinutes:(NSTimeInterval)timeFrameMinutes TickTimerIntervals:(NSTimeInterval)tickTimerIntervals {
    self = [super init];
    if (self) {
        _generator = [[SCDRandomPriceDataSource alloc] initWithCandleIntervalMinutes:timeFrameMinutes SimulateDateGap:YES UpdatesPerPrice:25 RandomSeed:100 StartingPrice:30 StartDate:startDate];
        _tickTimerIntervals = tickTimerIntervals;
    }
    return self;
}

- (void)subscribePriceUpdate:(PriceUpdateCallback)callback {
    if (_isRunning) return;
    
    _newDataCallback = callback;
    _isRunning = true;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_tickTimerIntervals target:self selector:@selector(onTimerElapsed) userInfo:nil repeats:YES];
}

- (void)onTimerElapsed {
    if (!_isRunning) return;
    
    SCDPriceBar * priceBar = [_generator tick];
    if (_newDataCallback != nil) {
        _newDataCallback(priceBar);
    }
}

- (SCDPriceSeries *)getHistoricalData:(NSInteger)numberBars {
    SCDPriceSeries *prices = [SCDPriceSeries new];
    for (int i = 0; i < numberBars; i++) {
        [prices add:[_generator getNextData]];
    }
    
    return prices;
}

- (void)clearSubscriptions {
    if (!_isRunning) return;
    
    _isRunning = false;
    _newDataCallback = nil;
    
    [_timer invalidate];
    _timer = nil;
}

- (SCDPriceBar *)getNextBar {
    return [_generator tick];
}

@end
