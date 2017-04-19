//
//  BrownianMotionGenerator.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/26/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "BrownianMotionGenerator.h"
#import "RandomUtil.h"

@implementation BrownianMotionGenerator{
    NSMutableArray * xyData;
    double xmin, xmax;
}

-(NSMutableArray*) getXyData:(int) count :(double)min :(double)max{
    xmin = min;
    xmax = max;
    
    if (!xyData)
        [self initXyData:count :min :max];
    
    return xyData;
}

-(void) initXyData:(int) count :(double)min :(double)max{
    xyData = [[NSMutableArray alloc]init];
    
    NSMutableArray * xValues = [[NSMutableArray alloc]initWithCapacity:count];
    NSMutableArray * yValues = [[NSMutableArray alloc]initWithCapacity:count];
    
    // Generate a slightly positive biased random walk
    // y[i] = y[i-1] + random,
    // where random is in the range min, max
    for (int i = 0; i < count; i++) {
        [xValues addObject: @(i)];
        [yValues addObject: @([self randf:min max:max])];
    }
    
    [xyData addObject:xValues];
    [xyData addObject:yValues];
}

-(double) MapX:(double) v1 :(double) v2{
    return xmin + (xmax - xmin) * v1;
}

-(double) GetRandomPoints{
    double v1 = [self randf:0.0 max:1.0], v2 = [self randf:0.0 max:1.0];
    
    return [self MapX:v1 : v2];
}

-(double) randf:(double) min max:(double) max {
    return [RandomUtil nextDouble] * (max - min) + min;
}

@end
