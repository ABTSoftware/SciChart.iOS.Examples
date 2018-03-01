//
//  RandomWalkGenerator.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 26.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "RandomWalkGenerator.h"
#import "RandomUtil.h"

@implementation RandomWalkGenerator{
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

- (RandomWalkGenerator *)setBias:(double)bias {
    _bias = bias;
    return self;
}

- (DoubleSeries *)getRandomWalkSeries:(int)count {
    DoubleSeries * result = [[DoubleSeries alloc] initWithCapacity:count];
    
    // Generate a slightly positive biased random walk
    // y[i] = y[i-1] + random,
    // where random is in the range -0.5, +0.5
    for(int i = 0; i < count; i++) {
        double next = _last + (randf(0.0, 1.0) - 0.5 + _bias);
        _last = next;
        [result addX:_index++ Y:next];
    }
    
    return result;
}

- (double)next {
    _last = _last + randf(0.0, 1.0) - 0.5 + _bias;
    
    return _last;
}

@end
