//
//  BrownianMotionGenerator.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/26/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
