//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RandomWalkGenerator.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RandomWalkGenerator.h"
#import "RandomUtil.h"

@implementation RandomWalkGenerator{
    double _last;
//    int _i;
}
const double Bias = 0;//0.001;

-(NSMutableArray*) GetRandomWalkSeries:(int) count min:(double)min max:(double)max includePrior:(Boolean)includePrior{
    NSMutableArray * doubleSeries = [[NSMutableArray alloc]initWithCapacity:count];
    NSMutableArray * xData = [[NSMutableArray alloc]initWithCapacity:count];
    NSMutableArray * yData = [[NSMutableArray alloc]initWithCapacity:count];
    
    [doubleSeries addObject:xData];
    [doubleSeries addObject:yData];
    
    _last = 0;
    _seed = 0;
    
    // Generate a slightly positive biased random walk
    // y[i] = y[i-1] + random,
    // where random is in the range min, max
    for (int i = 0; i < count; i++){
        [xData addObject: @(i)];
        [yData addObject:@([self next:min :max :includePrior])];
    }
    
    return doubleSeries;
}

-(double) next:(double)min :(double)max :(Boolean)includePrior{
    double next;
    if(includePrior)
       next = _last + ([self randf:min max:max] + Bias);
    else
        next = ([self randf:min max:max] + Bias);
    _last = next;
    return next;
}

-(double) randf:(double) min max:(double) max {
    return [RandomUtil nextDouble] * (max - min) + min;
}

@end
