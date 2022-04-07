//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDLabeledSettingsItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDLabeledSettingsItem.h"
#import <SciChart/SCILabel.h>
#import <SciChart/SCIColor.h>
#if TARGET_OS_IOS
#import <UIKit/NSLayoutAnchor.h>
#import "SCDToolbarSliderItem.h"
#endif

@implementation SCDLabeledSettingsItem {
    NSString *_labelText;
    id<ISCDToolbarItem> _item;
    SCILayoutConstraintAxis _iOSAxis;
}

- (instancetype)initWithLabelText:(NSString *)labelText item:(id<ISCDToolbarItem>)item {
    return [self initWithLabelText:labelText item:item iOS_orientation:SCILayoutConstraintAxisHorizontal];
}

- (instancetype)initWithLabelText:(NSString *)labelText item:(id<ISCDToolbarItem>)item iOS_orientation:(SCILayoutConstraintAxis)iOSAxis {
    self = [super init];
    if (self) {
        _labelText = labelText;
        _item = item;
        _iOSAxis = iOSAxis;
    }
    return self;
}

- (SCIView *)createView {
    SCILabel *label = [SCILabel new];
    label.text = _labelText;
    
    SCIStackView *stackView = [SCIStackView new];
#if TARGET_OS_OSX
    stackView.axis = SCILayoutConstraintAxisVertical;
    stackView.alignment = NSLayoutAttributeLeft;
    stackView.spacing = 3;
#elif TARGET_OS_IOS
    label.textColor = SCIColor.whiteColor;
    stackView.axis = _iOSAxis;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.spacing = 10;
#endif
    [stackView addArrangedSubview:label];
    
    SCIView *secondView = [_item createView];
    [stackView addArrangedSubview:secondView];
#if TARGET_OS_IOS
    [secondView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    if ([_item isKindOfClass:SCDToolbarSliderItem.class])
    [NSLayoutConstraint activateConstraints:@[
        [secondView.widthAnchor constraintEqualToAnchor:label.widthAnchor]
    ]];
#endif
    
    return stackView;
}

@end
