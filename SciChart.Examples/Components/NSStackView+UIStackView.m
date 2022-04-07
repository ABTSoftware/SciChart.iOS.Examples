//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// NSStackView+UIStackView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "NSStackView+UIStackView.h"

#if TARGET_OS_OSX

@implementation NSStackView (UIStackView)

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof NSView *> *)views {
    return [NSStackView stackViewWithViews:views];
}

- (void)setAxis:(NSUserInterfaceLayoutOrientation)axis {
    self.orientation = axis;
}

- (NSUserInterfaceLayoutOrientation)axis {
    return self.orientation;
}

@end

#endif
