//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDCustomRotateChartModifier.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDCustomRotateChartModifier.h"

@implementation SCDCustomRotateChartModifier

- (void)rotateChart {
    if (!self.isAttached) return;
    
    const id<ISCIChartSurface> parentSurface = self.parentSurface;
    id<ISCIUpdateSuspender> updateSuspender = [parentSurface suspendUpdates];
    @try {
        [self p_SCD_rotateAxes:parentSurface.xAxes];
        [self p_SCD_rotateAxes:parentSurface.yAxes];
    } @finally {
        updateSuspender = nil;
    }
}

- (void)p_SCD_rotateAxes:(SCIAxisCollection *)axes {
    for (NSInteger i = 0, count = axes.count; i < count; i++) {
        const id<ISCIAxis> axis = axes[i];
        
        switch (axis.axisAlignment) {
            case SCIAxisAlignment_Left:
                axis.axisAlignment = SCIAxisAlignment_Top;
                break;
            case SCIAxisAlignment_Top:
                axis.axisAlignment = SCIAxisAlignment_Right;
                break;
            case SCIAxisAlignment_Right:
                axis.axisAlignment = SCIAxisAlignment_Bottom;
                break;
            case SCIAxisAlignment_Bottom:
                axis.axisAlignment = SCIAxisAlignment_Left;
                break;
            default:
                // default: isXAxis ? Bottom : Right
                axis.axisAlignment = axis.isXAxis ? SCIAxisAlignment_Left : SCIAxisAlignment_Bottom;
        }
    }
}

@end
