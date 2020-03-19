//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSpectogramItems.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSpectogramItems.h"

@implementation SCDSpectogramItems

@synthesize values = _values;

- (instancetype)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _values = [[SCIFloatValues alloc] initWithCapacity:capacity];
        
        for (NSInteger i = 0; i < capacity; i++) {
            [_values add:0];
        }
    }
    return self;
}

- (void)replaceWithNewItems:(SCIFloatValues *)newItems {
    float *newItemsArray = newItems.itemsArray;
    float *itemsArray = _values.itemsArray;
    long remainingCount = _values.count - newItems.count;
    
    memcpy(itemsArray, itemsArray + newItems.count, sizeof(float) * remainingCount);
    memcpy(itemsArray + remainingCount, newItemsArray, sizeof(float) * newItems.count);
}

- (SCIFloatValues *)values {
    return _values;
}

@end
