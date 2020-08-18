//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSettingsViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSettingsViewController.h"
#import <SciChart/SCIView.h>
#import "SCIStackView.h"
#if TARGET_OS_IOS
#import <UIKit/NSLayoutAnchor.h>
#import <UIKit/UILabel.h>
#import <UIKit/UITapGestureRecognizer.h>
#import <SciChart/SCIColor.h>
#import <SciChart/SCIButton.h>
#endif

@implementation SCDSettingsViewController {
    NSArray<id<ISCDToolbarItem>> * _settingsItems;
    SCIView *_contentView;
}

- (instancetype)initWithSettingsItems:(NSArray<id<ISCDToolbarItem>> *)settingsItems {
    self = [super init];
    if (self) {
        _settingsItems = settingsItems;
    }
    return self;
}

- (void)loadView {
    SCIView *view = [SCIView new];
    self.view = view;
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisVertical;
#if TARGET_OS_OSX
    stackView.alignment = NSLayoutAttributeLeft;
#endif
    stackView.spacing = 15.0;
    
    for (id<ISCDToolbarItem> item in _settingsItems) {
        [stackView addArrangedSubview:[item createView]];
    }
    
#if TARGET_OS_OSX
    _contentView = self.view;
#elif TARGET_OS_IOS
    SCIView *iOSContentView = [SCIView new];
    iOSContentView.platformBackgroundColor = [SCIColor colorNamed:@"color.primary.green"];
    iOSContentView.layer.cornerRadius = 10;
    iOSContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iOSContentView];
    [NSLayoutConstraint activateConstraints:@[
        [iOSContentView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor],
        [iOSContentView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor],
        [iOSContentView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor],
        [iOSContentView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor],
        [iOSContentView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [iOSContentView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
    
    _contentView = iOSContentView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
#endif
    
    stackView.axis = SCILayoutConstraintAxisVertical;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

    [_contentView addSubview:stackView];
    CGFloat padding = 10.0;
    [NSLayoutConstraint activateConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor constant:padding],
        [stackView.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor constant:-padding],
        [stackView.topAnchor constraintEqualToAnchor:_contentView.topAnchor constant:padding],
        [stackView.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor constant:-padding],
    ]];
}

#if TARGET_OS_IOS
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_contentView];
    if (CGRectContainsPoint(_contentView.bounds, location)) return;
        
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#endif

@end
