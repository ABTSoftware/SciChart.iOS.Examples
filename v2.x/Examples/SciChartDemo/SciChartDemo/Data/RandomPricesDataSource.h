//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RandomPricesDataSource.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
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
