//
//  RandomUtil.m
//  SciChartDemo
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "RandomUtil.h"
#define ARC4RANDOM_MAX 0x100000000

@implementation RandomUtil

+(double)nextDouble {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

@end
