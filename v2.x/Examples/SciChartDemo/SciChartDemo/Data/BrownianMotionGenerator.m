//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BrownianMotionGenerator.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "BrownianMotionGenerator.h"
#import "RandomUtil.h"

@implementation BrownianMotionGenerator

+ (DoubleSeries *)getRandomDataWithMin:(double)min max:(double)max count:(int)count {
    DoubleSeries * result = [[DoubleSeries alloc] initWithCapacity:count];
    
    for(int i = 0; i < count; i++) {
        [result addX:i Y:randf(min, max)];
    }
    
    return result;
}

+ (double)getRandomPointsWithMin:(double)min max:(double)max {
    double v1 = randf(0.0, 1.0);
    
    return min + (max - min) * v1;
}

@end
