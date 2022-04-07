//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarView.h"

@implementation SCDToolbarView {
    UIStackView *_stackView;
}

- (instancetype)initWithItems:(NSArray<id<ISCDToolbarItem>> *)toolbarItems {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _stackView = [UIStackView new];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentCenter;
        
        for (NSUInteger i = 0, count = toolbarItems.count; i < count; i++) {
            [_stackView addArrangedSubview:[toolbarItems[i] createView]];
            if (i < count - 1) {
                [_stackView addArrangedSubview:self.p_SCD_separator];
            }
        }
        
        [self p_SCD_placeViews];
    }
    return self;
}

- (UIView *)p_SCD_separator {
    UIView *separator = [UIView new];
    separator.backgroundColor = UIColor.whiteColor;
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [separator addConstraints:@[
        [separator.heightAnchor constraintEqualToConstant:2],
        [separator.widthAnchor constraintEqualToConstant:35]
    ]];
    
    return separator;
}

- (void)p_SCD_placeViews {
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor colorNamed:@"color.primary.green"];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [backgroundView addSubview:_stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [_stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:backgroundView.leadingAnchor],
        [_stackView.trailingAnchor constraintLessThanOrEqualToAnchor:backgroundView.trailingAnchor],
        [_stackView.topAnchor constraintEqualToAnchor:backgroundView.topAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:backgroundView.bottomAnchor],
    ]];
    
    [self addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

@end
