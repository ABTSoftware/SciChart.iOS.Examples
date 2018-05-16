//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PriceBar.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "PriceBar.h"

@implementation PriceBar

@synthesize date = _date;
@synthesize open = _open;
@synthesize high = _high;
@synthesize low = _low;
@synthesize close = _close;
@synthesize volume = _volume;

- (instancetype)initWithOpen:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume {
    self = [super init];
    if (self) {
        _date = [[NSDate alloc] init];
        _open = open;
        _high = high;
        _low = low;
        _close = close;
        _volume = volume;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date open:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume {
    self = [super init];
    if (self) {
        _date = date;
        _open = open;
        _high = high;
        _low = low;
        _close = close;
        _volume = volume;
    }
    return self;
}

@end
