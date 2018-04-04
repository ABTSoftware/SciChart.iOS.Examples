#import <Foundation/Foundation.h>
#import "PriceBar.h"
#import "PriceSeries.h"

typedef void (^PriceUpdateCallback) (PriceBar * priceBar);

@interface MarketDataService : NSObject

- (instancetype)initWithStartDate:(NSDate *)startDate TimeFrameMinutes:(int)timeFrameMinutes TickTimerIntervals:(NSTimeInterval)tickTimerIntervals;

- (void)subscribePriceUpdate:(PriceUpdateCallback)callback;

- (PriceSeries *)getHistoricalData:(int)numberBars;

- (void)clearSubscriptions;

- (PriceBar *)getNextBar;

@end
