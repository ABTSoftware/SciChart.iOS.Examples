//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDVitalSignsComponentView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDVitalSignsComponentView.h"

#if TARGET_OS_OSX

#elif TARGET_OS_IOS

#import <UIKit/NSLayoutAnchor.h>

#endif

@implementation SCDVitalSignsComponentView {
    SCIView *_topLeftView;
    SCIView *_topRightView;
    SCIView *_bottomLeftView;
    SCIView *_bottomRightView;
}

- (instancetype)initWithTopLeftView:(SCIView *)topLeftView topRightView:(SCIView *)topRightView bottomLeftView:(SCIView *)bottomLeftView bottomRightView:(SCIView *)bottomRightView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _topLeftView = topLeftView;
        _topRightView = topRightView;
        _bottomLeftView = bottomLeftView;
        _bottomRightView = bottomRightView;
        
        [self p_SCD_setupViews];
    }
    return self;
}

- (void)p_SCD_setupViews {
    for (SCIView *view in @[_topLeftView, _topRightView, _bottomLeftView, _bottomRightView]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
    }
    
    [self addConstraints:@[
        [_topLeftView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8],
        [_topLeftView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8],

        [_topRightView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8],
        [_topRightView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8],

        [_bottomLeftView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8],
        [_bottomLeftView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8],

        [_bottomRightView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8],
        [_bottomRightView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0],
    ]];
}

@end
