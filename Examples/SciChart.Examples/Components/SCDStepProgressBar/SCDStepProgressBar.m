//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDStepProgressBar.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDStepProgressBar.h"

@implementation SCDStepProgressBar {
    NSInteger _progress;
    SCDProgressBarStyle *_style;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_commonInit];
    }
    return self;
}

- (void)p_SCD_commonInit {
    _progress = 0;
}

- (void)p_SCD_setupSteps {
    self.spacing = _style.spacing;
    self.axis = _style.isVertical ? SCILayoutConstraintAxisVertical : SCILayoutConstraintAxisHorizontal;
    
    for (int i = 0; i < _style.max; i++) {
        SCIView *step = [SCIView new];
        step.platformBackgroundColor = _style.progressBackgroundColor;

        [self addArrangedSubview:step];
        step.translatesAutoresizingMaskIntoConstraints = NO;
        if (self.axis == SCILayoutConstraintAxisVertical) {
            [step.heightAnchor constraintEqualToConstant:_style.barSize].active = YES;
        } else {
            [step.widthAnchor constraintEqualToConstant:_style.barSize].active = YES;
        }
    }
}

- (void)setStyle:(SCDProgressBarStyle *)style {
    _style = style;
    [self p_SCD_setupSteps];
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress - 1;
    for (SCIView *view in self.arrangedSubviews) {
        view.platformBackgroundColor = _style.progressBackgroundColor;
    }
    
    NSArray<SCIView *> *views = _style.isVertical ? [self.arrangedSubviews reverseObjectEnumerator].allObjects : self.arrangedSubviews;
    for (NSInteger i = 0, count = _progress; i < count; i++) {
        views[i].platformBackgroundColor = _style.progressColor;
    }
}

@end
