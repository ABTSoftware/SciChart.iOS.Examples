//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMacdPoints.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMacdPoints.h"

@implementation SCDMacdPoints

- (instancetype)init {
    self = [super init];
    if (self) {
        _macdValues = [SCIDoubleValues new];
        _signalValues = [SCIDoubleValues new];
        _divergenceValues = [SCIDoubleValues new];
    }
    return self;
}

- (void)addMacd:(double)macd signal:(double)signal divergence:(double)divergence {
    [_macdValues add:macd];
    [_signalValues add:signal];
    [_divergenceValues add:divergence];
}

@end
