//
//  RandomUtil.h
//  SciChartDemo
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomUtil : NSObject

+ (double)nextDouble;

@end

static inline double randf(double min, double max) {
    return [RandomUtil nextDouble] * (max - min) + min;
}

static inline int32_t randi(int32_t min, int32_t max) {
    return rand() % (max - min) + min;
}
