//
//  BrownianMotionGenerator.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/26/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoubleSeries.h"

@interface BrownianMotionGenerator : NSObject

+ (DoubleSeries *)getRandomDataWithMin:(double)min max:(double)max count:(int)count;

+ (double)getRandomPointsWithMin:(double)min max:(double)max;

@end
