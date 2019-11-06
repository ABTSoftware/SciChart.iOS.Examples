//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRandomUtil.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>

@interface SCDRandomUtil : NSObject

+ (double)nextDouble;

+ (double)nextFloat;

@end

static inline double randf(double min, double max) {
    return [SCDRandomUtil nextDouble] * (max - min) + min;
}

static inline int32_t randi(int32_t min, int32_t max) {
    return rand() % (max - min) + min;
}
