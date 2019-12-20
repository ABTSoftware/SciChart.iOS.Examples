//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRandomPricesDataSource.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDRandomPricesDataSource.h"
#import "SCDRandomUtil.h"

@implementation SCDRandomPriceDataSource {
    NSTimeInterval _openMarketTime;
    NSTimeInterval _closeMarketTime;
    
    NSTimeInterval _candleIntervalMinutes;
    BOOL _simulateDateGap;
    int _updatesPerPrice;
    
    SCDPriceBar *_initialPriceBar;
    SCDPriceBar *_lastPriceBar;
    
    double _currentTime;
    int _currentUpdateCount;
    
    // TODO REMOVE if redundant in the rest of the examples.
    int _randomSeed;
}

- (instancetype)initWithCandleIntervalMinutes:(NSTimeInterval)candleIntervalMinutes
                              SimulateDateGap:(BOOL)simulateDateGap
                              UpdatesPerPrice:(int)updatesPerPrice
                                   RandomSeed:(int)randomSeed
                                StartingPrice:(double)startingPrice
                                    StartDate:(NSDate *)startDate {
    self = [super init];
    
    if (self) {
        _openMarketTime = 360; //new TimeSpan(0, 08, 0, 0)
        _closeMarketTime = 720; //new TimeSpan(0, 16, 30, 0)
        
        _candleIntervalMinutes = candleIntervalMinutes;
        _simulateDateGap = simulateDateGap;
        _updatesPerPrice = updatesPerPrice;
        
        _initialPriceBar = [[SCDPriceBar alloc] initWithDate:startDate open:@0 high:@0 low:@0 close:@(startingPrice) volume:@0];
        _lastPriceBar = [[SCDPriceBar alloc] initWithDate:_initialPriceBar.date open:_initialPriceBar.close high:_initialPriceBar.close low:_initialPriceBar.close close:_initialPriceBar.close volume:0];
        
        _randomSeed = randomSeed;
    }
    
    return self;
}

- (SCDPriceBar *)getNextData {
    return [self getNextRandomPriceBar];
}

- (SCDPriceBar *)getNextRandomPriceBar {
    double close = _lastPriceBar.close.doubleValue;
    double num = (randf(0.0, 1.0) - 0.9) * _initialPriceBar.close.doubleValue / 30.0;
    double num2 = randf(0.0, 1.0);
    double num3 = _initialPriceBar.close.doubleValue + _initialPriceBar.close.doubleValue / 2.0 * sin(7.27220521664304E-06 * _currentTime) + _initialPriceBar.close.doubleValue / 16.0 * cos(7.27220521664304E-05 * _currentTime) + _initialPriceBar.close.doubleValue / 32.0 * sin(7.27220521664304E-05 * (10.0 + num2) * _currentTime) + _initialPriceBar.close.doubleValue / 64.0 * cos(7.27220521664304E-05 * (20.0 + num2) * _currentTime) + num;
    double num4 = fmax(close, num3);
    double num5 = randf(0.0, 1.0) * _initialPriceBar.close.doubleValue / 100.0;
    double high = num4 + num5;
    double num6 = fmin(close, num3);
    double num7 = randf(0.0, 1.0) * _initialPriceBar.close.doubleValue / 100.0;
    double low = num6 - num7;
    long volume = (long) (randf(0.0, 1.0) * 30000 + 20000);
    NSDate *openTime = _simulateDateGap ? [self emulateDateGap:_lastPriceBar.date] : _lastPriceBar.date;
    NSDate *closeTime = [openTime dateByAddingTimeInterval:_candleIntervalMinutes];
    
    SCDPriceBar *candle = [[SCDPriceBar alloc] initWithDate:closeTime open:@(close) high:@(high) low:@(low) close:@(num3) volume:@(volume)];
    _lastPriceBar = [[SCDPriceBar alloc] initWithDate:candle.date open:candle.open high:candle.high low:candle.low close:candle.close volume:candle.volume];
    
    _currentTime += _candleIntervalMinutes * 60;
    return candle;
}

- (NSDate *)emulateDateGap:(NSDate *)candleOpenTime {
    NSDate *result = candleOpenTime;

    if (candleOpenTime.timeIntervalSince1970 > _closeMarketTime) {
        NSDate *dateTime = candleOpenTime;
        dateTime = [dateTime dateByAddingTimeInterval:500];
        result = [dateTime dateByAddingTimeInterval:_openMarketTime];
    }
    
    while (result.timeIntervalSince1970 < 500) {
        result = [result dateByAddingTimeInterval:500];
    }
    
    return result;
}

- (SCDPriceBar *)getUpdatedData {
    double num = _lastPriceBar.close.doubleValue + (randf(0.0, 1.0) - 0.48) * (_lastPriceBar.close.doubleValue / 100.0);
    double high = num > _lastPriceBar.high.doubleValue ? num : _lastPriceBar.high.doubleValue;
    double low = num < _lastPriceBar.low.doubleValue ? num : _lastPriceBar.low.doubleValue;
    long volumeInc = (randf(0.0, 1.0) * 30000 + 20000) * 0.05;
    
    _lastPriceBar = [[SCDPriceBar alloc] initWithDate:_lastPriceBar.date open:_lastPriceBar.open high:@(high) low:@(low) close:@(num) volume:@(_lastPriceBar.volume.doubleValue + volumeInc)];
    
    return _lastPriceBar;
}

- (SCDPriceBar *)tick {
    if (_currentUpdateCount < _updatesPerPrice) {
        _currentUpdateCount++;
        return [self getUpdatedData];
    } else {
        _currentUpdateCount = 0;
        return [self getNextData];
    }
}

@end
