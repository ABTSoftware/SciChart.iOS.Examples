//
//  RandomWalkGenerator.h
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 26.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomWalkGenerator : NSObject {
    unsigned int _seed;
}

-(NSMutableArray*) GetRandomWalkSeries:(int) count min:(double)min max:(double)max includePrior:(Boolean)includePrior;
-(double) next: (double)min :(double)max :(Boolean)includePrior;

@end
