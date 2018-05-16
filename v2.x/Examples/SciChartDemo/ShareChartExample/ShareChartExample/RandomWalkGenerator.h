//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RandomWalkGenerator.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>

@interface RandomWalkGenerator : NSObject {
    unsigned int _seed;
}

-(NSMutableArray*) GetRandomWalkSeries:(int) count min:(double)min max:(double)max includePrior:(Boolean)includePrior;
-(double) next: (double)min :(double)max :(Boolean)includePrior;

@end
