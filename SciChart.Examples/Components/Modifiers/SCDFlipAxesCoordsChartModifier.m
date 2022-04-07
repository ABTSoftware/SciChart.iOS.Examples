//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDFlipAxesCoordsChartModifier.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDFlipAxesCoordsChartModifier.h"

@implementation SCDFlipAxesCoordsChartModifier

- (void)flipXAxes {
    if (!self.isAttached) return;
    
    [self p_SCD_flipAxesCoordinates:self.parentSurface.xAxes];
}

- (void)flipYAxes {
    if (!self.isAttached) return;
    
    [self p_SCD_flipAxesCoordinates:self.parentSurface.yAxes];
}

- (void)p_SCD_flipAxesCoordinates:(SCIAxisCollection *)axes {
    for (NSInteger i = 0, count = axes.count; i < count; i++) {
        id<ISCIAxisCore> axis = axes[i];
        axis.flipCoordinates = !axis.flipCoordinates;
    }
}

@end
