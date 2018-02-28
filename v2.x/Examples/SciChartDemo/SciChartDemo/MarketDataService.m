#import "MarketDataService.h"
#import "RandomPricesDataSource.h"

@implementation MarketDataService {
    BOOL _isRunning;
    NSTimer * _timer;
    NSTimeInterval _tickTimerIntervals;
    
    RandomPriceDataSource * _generator;
    
    PriceUpdateCallback _newData;
}

- (instancetype)initWithStartDate:(NSDate *)startDate TimeFrameMinutes:(int)timeFrameMinutes TickTimerIntervals:(NSTimeInterval)tickTimerIntervals {
    self = [super init];
    
    if (self) {
        _generator = [[RandomPriceDataSource alloc] initWithCandleIntervalMinutes:timeFrameMinutes SimulateDateGap:YES UpdatesPerPrice:25 RandomSeed:100 StartingPrice:30 StartDate:startDate];
        
        _tickTimerIntervals = tickTimerIntervals;
    }
    
    return self;
}

- (void)subscribePriceUpdate:(PriceUpdateCallback)callback {
    if (_isRunning) return;
    
    _newData = callback;
    
    _isRunning = true;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_tickTimerIntervals target:self selector:@selector(onTimerElapsed) userInfo:nil repeats:YES];
}

- (void)onTimerElapsed {
    if (!_isRunning) return;
    
    PriceBar * priceBar = [_generator tick];
    if (_newData != nil) {
        _newData(priceBar);
    }
}

- (PriceSeries *)getHistoricalData:(int)numberBars {
    PriceSeries * prices = [PriceSeries new];
    for (int i = 0; i < numberBars; i++) {
        [prices add:[_generator getNextData]];
    }
    
    return prices;
}

- (void)clearSubscriptions {
    if (!_isRunning) return;
    
    _isRunning = false;
    [_timer invalidate];
    
    _timer = nil;
    _newData = nil;
}

- (PriceBar *)getNextBar {
    return [_generator tick];
}

@end
