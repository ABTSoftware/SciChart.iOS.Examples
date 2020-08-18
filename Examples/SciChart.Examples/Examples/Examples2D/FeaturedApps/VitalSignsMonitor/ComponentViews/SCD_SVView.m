//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCD_SVView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCD_SVView.h"
#import "SCIStackView.h"

@implementation SCD_SVView

- (instancetype)initWithTopLeftView:(SCIView *)topLeftView topRightView:(SCIView *)topRightView bottomLeftView:(SCIView *)bottomLeftView bottomRightView:(SCIView *)bottomRightView {
    self = [super initWithTopLeftView:topLeftView topRightView:topRightView bottomLeftView:bottomLeftView bottomRightView:bottomRightView];
    if (self) {
        SCIStackView *stackView = (SCIStackView *)bottomLeftView;
        _svBar1 = [stackView arrangedSubviews].firstObject;
        _svBar2 = [stackView arrangedSubviews].lastObject;
        
        _bvValueLabel = (SCILabel *)bottomRightView;
    }
    return self;
}

@end
