//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPriceBar.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPriceBar.h"

@implementation SCDPriceBar

- (instancetype)initWithOpen:(NSNumber *)open high:(NSNumber *)high low:(NSNumber *)low close:(NSNumber *)close volume:(NSNumber *)volume {
    self = [super init];
    if (self) {
        _date = [NSDate new];
        _open = open;
        _high = high;
        _low = low;
        _close = close;
        _volume = volume;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date open:(NSNumber *)open high:(NSNumber *)high low:(NSNumber *)low close:(NSNumber *)close volume:(NSNumber *)volume {
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
