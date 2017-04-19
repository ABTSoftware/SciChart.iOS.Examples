//
//  BrownianMotionGenerator.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/26/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrownianMotionGenerator : NSObject

-(NSMutableArray*) getXyData:(int) count :(double)min :(double)max;
-(double) GetRandomPoints;

@end
