//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BrownianMotionGenerator.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import "DoubleSeries.h"

@interface BrownianMotionGenerator : NSObject

+ (DoubleSeries *)getRandomDataWithMin:(double)min max:(double)max count:(int)count;

+ (double)getRandomPointsWithMin:(double)min max:(double)max;

@end
