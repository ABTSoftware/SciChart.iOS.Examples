//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDProgressBarStyle.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDProgressBarStyle.h"

@implementation SCDProgressBarStyle

- (instancetype)initWithIsVertical:(BOOL)isVertical max:(NSInteger)max spacing:(NSInteger)spacing progressBackgroundColor:(SCIColor *)progressBackgroundColor progressColor:(SCIColor *)progressColor barSize:(NSInteger)barSize {
    self = [super init];
    if (self) {
        _isVertical = isVertical;
        _max = max;
        _spacing = spacing;
        _progressBackgroundColor = progressBackgroundColor;
        _progressColor = progressColor;
        _barSize = barSize;
    }
    return self;
}

@end
