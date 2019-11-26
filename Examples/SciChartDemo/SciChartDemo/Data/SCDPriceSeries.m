//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPriceSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPriceSeries.h"

@implementation SCDPriceSeries {
    NSMutableArray<SCDPriceBar *> * _items;
}

- (instancetype)init {
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _items = [NSMutableArray arrayWithCapacity:capacity];
    }
    return self;
}

- (SCIDateValues *)dateData {
    SCIDateValues *result = [SCIDateValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:_items[i].date];
    }
    
    return result;
}

- (SCIDoubleValues *)openData {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:_items[i].open.doubleValue];
    }
    
    return result;
}

- (SCIDoubleValues *)highData {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:_items[i].high.doubleValue];
    }
    
    return result;
}

- (SCIDoubleValues *)lowData {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:_items[i].low.doubleValue];
    }
    
    return result;
}

- (SCIDoubleValues *)closeData {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:_items[i].close.doubleValue];
    }
    
    return result;
}

- (SCILongValues *)volumeData {
    SCILongValues *result = [SCILongValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:_items[i].volume.longLongValue];
    }
    
    return result;
}

- (SCIDoubleValues *)indexesAsDouble {
    SCIDoubleValues *result = [SCIDoubleValues new];
    for (NSUInteger i = 0, count = _items.count; i < count; i++) {
        [result add:i];
    }
    
    return result;
}

- (void)add:(SCDPriceBar *)item {
    if (![_items containsObject:item]) {
        [_items addObject:item];
    }
}

- (SCDPriceBar *)itemAt:(NSInteger)index {
    return [_items objectAtIndex:index];
}

- (SCDPriceBar *)lastObject {
    return [_items lastObject];
}

- (NSInteger)count {
    return _items.count;
}

@end
