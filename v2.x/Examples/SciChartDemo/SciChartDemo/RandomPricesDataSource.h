#import <Foundation/Foundation.h>
#import "PriceBar.h"

@interface RandomPriceDataSource : NSObject

- (instancetype)initWithCandleIntervalMinutes:(int)candleIntervalMinutes
                              SimulateDateGap:(BOOL)simulateDateGap
                              UpdatesPerPrice:(int)updatesPerPrice
                                   RandomSeed:(int)randomSeed
                                StartingPrice:(double)startingPrice
                                    StartDate:(NSDate *)startDate;

- (PriceBar *)getNextData;
- (PriceBar *)getNextRandomPriceBar;
- (NSDate *)emulateDateGap:(NSDate *)candleOpenTime;
- (PriceBar *)getUpdatedData;
- (PriceBar *)tick;

@end
