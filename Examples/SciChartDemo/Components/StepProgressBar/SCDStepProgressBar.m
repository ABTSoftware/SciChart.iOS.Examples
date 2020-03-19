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

@interface SCDStepProgressBar()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation SCDStepProgressBar {
    NSInteger _progress;
    SCDProgressBarStyle *_style;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:@"SCDStepProgressBar" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    _progress = 0;
}

- (void)setupStackView {
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    self.stackView.spacing = _style.spacing;
    self.stackView.axis = _style.isVertical ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    
    for (int i = 0; i < _style.max; i++) {
        UIView *step = [UIView new];
        step.backgroundColor = _style.progressBackgroundColor;
        
        [self.stackView addArrangedSubview:step];
        step.translatesAutoresizingMaskIntoConstraints = NO;
        if (self.stackView.axis == UILayoutConstraintAxisVertical) {
            [step.heightAnchor constraintEqualToConstant:_style.barSize].active = YES;
        } else {
            [step.widthAnchor constraintEqualToConstant:_style.barSize].active = YES;
        }
    }
}

- (void)setStyle:(SCDProgressBarStyle *)style {
    _style = style;
    [self setupStackView];
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress - 1;
    for (UIView *view in self.stackView.arrangedSubviews) {
        view.backgroundColor = _style.progressBackgroundColor;
    }
    
    NSArray<UIView *> *views = _style.isVertical ? [[self.stackView.arrangedSubviews reverseObjectEnumerator] allObjects] : self.stackView.arrangedSubviews;
    
    for (NSInteger i = 0, count = _progress; i < count; i++) {
        views[i].backgroundColor = _style.progressColor;
    }
}

@end
