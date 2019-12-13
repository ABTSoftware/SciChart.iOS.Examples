//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDoubleSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDoubleSeries.h"

@implementation SCDDoubleSeries

- (instancetype)init {
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _xValues = [[SCIDoubleValues alloc] initWithCapacity:capacity];
        _yValues = [[SCIDoubleValues alloc] initWithCapacity:capacity];
    }
    return self;
}

- (void)addX:(double)x y:(double)y {
    [_xValues add:x];
    [_yValues add:y];
}

@end
