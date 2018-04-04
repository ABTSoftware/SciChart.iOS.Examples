//
//  RandomWalkGenerator.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 26.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoubleSeries.h"

@interface RandomWalkGenerator : NSObject

- (instancetype)init;

- (void)reset;

- (RandomWalkGenerator *)setBias:(double)bias;
    
- (DoubleSeries *)getRandomWalkSeries:(int)count;

- (double)next;

@end
