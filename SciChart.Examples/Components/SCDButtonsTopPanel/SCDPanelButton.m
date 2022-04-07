//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPanelButton.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPanelButton.h"

@implementation SCDPanelButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_commonInit];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize oldSize = [super intrinsicContentSize];
    return (CGSize){
        .width = oldSize.width + _padding * 2,
        .height = oldSize.height
#if TARGET_OS_OSX
            + _padding
#endif
    };
}

- (void)p_SCD_commonInit {
    _padding = 6;
    [self setTitleColor:[SCIColor fromARGBColorCode:0xFFEAEAEA]];
    self.platformBackgroundColor = [SCIColor fromARGBColorCode:0xFF3D3F41];
}

@end
