//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDLargeTradeGenerator.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDLargeTradeGenerator.h"
#import "SCDRandomUtil.h"

@implementation SCDLargeTradeGenerator {
    int _maxLargeTradesPerCandle;
    double _minLargeTradeVolume;
    double _maxLargeTradeVolume;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxLargeTradesPerCandle = 4;
        _minLargeTradeVolume = 20;
        _maxLargeTradeVolume = 80;
    }
    return self;
}

- (NSArray<SCDLargeTradeBar *> *)generateLargeTradesForPriceSeries:(SCDPriceSeries *)priceSeries {
    NSMutableArray<SCDLargeTradeBar *> *result = [NSMutableArray<SCDLargeTradeBar *> new];
    for (NSInteger i = 0, count = priceSeries.count; i < count; i++) {
        SCDPriceBar *priceBar = [priceSeries itemAt:i];
        
        NSArray<SCDLargeTrade *> *largeTrades = [self p_SCD_generateRandomLargeTradesForPrice:priceBar];
        
        SCDLargeTradeBar *largeTradeBar = [[SCDLargeTradeBar alloc] initWithDate:priceBar.date andLargeTrades:largeTrades];
        [result addObject:largeTradeBar];
    }
    
    return result;
}

- (NSArray<SCDLargeTrade *> *)p_SCD_generateRandomLargeTradesForPrice:(SCDPriceBar *)priceBar {
    NSMutableArray<SCDLargeTrade *> *result = [NSMutableArray<SCDLargeTrade *> new];
    for (int i = 0, count = randi(0, _maxLargeTradesPerCandle); i < count; i++) {
        [result addObject:[self p_SCD_generateRandomLargeTradeForPrice:priceBar]];
    }
    
    return result;
}

- (SCDLargeTrade *)p_SCD_generateRandomLargeTradeForPrice:(SCDPriceBar *)priceBar {
    double price = randf(priceBar.low.doubleValue, priceBar.high.doubleValue);
    double volume = randf(_minLargeTradeVolume, _maxLargeTradeVolume);
    
    return [[SCDLargeTrade alloc] initWithPrice:price andVolume:volume];
}

@end
