//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRandomWalkGenerator.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDRandomWalkGenerator.h"
#import "SCDRandomUtil.h"

@implementation SCDRandomWalkGenerator {
    double _last;
    int _index;
    double _bias;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _bias = 0.01;
    }
    return self;
}

- (void)reset {
    _index = 0;
    _last = 0;
}

- (SCDRandomWalkGenerator *)setBias:(double)bias {
    _bias = bias;
    return self;
}

- (SCDDoubleSeries *)getRandomWalkSeries:(NSInteger)count {
    SCDDoubleSeries *result = [[SCDDoubleSeries alloc] initWithCapacity:count];
    
    // Generate a slightly positive biased random walk
    // y[i] = y[i-1] + random,
    // where random is in the range -0.5, +0.5
    for (NSInteger i = 0; i < count; i++) {
        double next = _last + (randf(0.0, 1.0) - 0.5 + _bias);
        _last = next;
        [result addX:_index++ y:next];
    }
    
    return result;
}

- (double)next {
    _last = _last + randf(0.0, 1.0) - 0.5 + _bias;
    
    return _last;
}

@end
