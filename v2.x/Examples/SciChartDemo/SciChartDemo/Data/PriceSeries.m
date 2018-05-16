//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PriceSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "PriceSeries.h"

@implementation PriceSeries {
    NSMutableArray * _items;
    
    double * _dateArray;
    double * _openArray;
    double * _highArray;
    double * _lowArray;
    double * _closeArray;
    long * _volumeArray;
    double * _indexesArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray new];
    }
    return self;
}

-(void)dealloc {
    free(_dateArray);
    free(_openArray);
    free(_highArray);
    free(_lowArray);
    free(_closeArray);
    free(_volumeArray);
    free(_indexesArray);

    _dateArray = nil;
    _openArray = nil;
    _highArray = nil;
    _lowArray = nil;
    _closeArray = nil;
    _volumeArray = nil;
    _indexesArray = nil;
}

- (double *)dateData {
    free(_dateArray);
    _dateArray = malloc(sizeof(double) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        PriceBar * bar = (PriceBar *)[_items objectAtIndex:i];
        _dateArray[i] = [[bar date] timeIntervalSince1970];
    }
    return _dateArray;
}

- (double *)openData {
    free(_openArray);
    _openArray = malloc(sizeof(double) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        PriceBar * bar = (PriceBar *)[_items objectAtIndex:i];
        _openArray[i] = [bar open];
    }
    return _openArray;
}

- (double *)highData {
    free(_highArray);
    _highArray = malloc(sizeof(double) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        PriceBar * bar = (PriceBar *)[_items objectAtIndex:i];
        _highArray[i] = [bar high];
    }
    return _highArray;
}

- (double *)lowData {
    free(_lowArray);
    _lowArray = malloc(sizeof(double) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        PriceBar * bar = (PriceBar *)[_items objectAtIndex:i];
        _lowArray[i] = [bar low];
    }
    return _lowArray;
}

- (double *)closeData {
    free(_closeArray);
    _closeArray = malloc(sizeof(double) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        PriceBar * bar = (PriceBar *)[_items objectAtIndex:i];
        _closeArray[i] = [bar close];
    }
    return _closeArray;
}

- (long *)volumeData {
    free(_volumeArray);
    _volumeArray = malloc(sizeof(long) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        PriceBar * bar = (PriceBar *)[_items objectAtIndex:i];
        _volumeArray[i] = [bar volume];
    }
    return _volumeArray;
}

- (double *)indexesAsDouble {
    free(_indexesArray);
    _indexesArray = malloc(sizeof(double) * [self size]);
    
    for (int i = 0; i < [_items count]; i++) {
        _indexesArray[i] = (double)i;
    }
    return _indexesArray;
}

- (void)add:(PriceBar *)item {
    if (![_items containsObject:item]) {
        [_items addObject:item];
    }
}

- (PriceBar *)itemAt:(int)index {
    return [_items objectAtIndex:index];
}

- (PriceBar *)lastObject {
    return [_items lastObject];
}

- (int)size {
    return (int)[_items count];
}

@end
