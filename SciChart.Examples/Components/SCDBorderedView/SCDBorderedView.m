//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDBorderedView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDBorderedView.h"
#import <SciChart/SCIColor.h>
#import <SciChart/UIColor+Util.h>

@implementation SCDBorderedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_customInit];
    }
    return self;
}

- (void)p_SCD_customInit {
#if TARGET_OS_OSX
    self.wantsLayer = YES;
#elif TARGET_OS_IOS
    self.clipsToBounds = YES;
#endif
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [[SCIColor fromARGBColorCode:0xFFD9D9C1] CGColor];
}

@end
