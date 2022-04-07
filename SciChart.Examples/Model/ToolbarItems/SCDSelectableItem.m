//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSelectableItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSelectableItem.h"
#import <SciChart/SCIEdgeInsets.h>
#import <SciChart/NSBundle+Extensions.h>
#if TARGET_OS_IOS
#import <UIKit/NSLayoutAnchor.h>
#endif

@implementation SCDSelectableItem

@synthesize checkBoxButton = _checkBoxButton;

- (SCIView *)createView {
#if TARGET_OS_OSX
    return [super createView];
#elif TARGET_OS_IOS
    SCIImage *normalImage = [SCIImage imageNamed:@"unchecked_checkbox.png" fromBundle:NSBundle.scichartBundle];
    SCIImage *selectedImage = [SCIImage imageNamed:@"checked_checkbox.png" fromBundle:NSBundle.scichartBundle];
    
    _checkBoxButton = [[SCISelectableButton alloc] initWithNormalStateImage:normalImage selectedStateImage:selectedImage];
    [_checkBoxButton setTitleCommon:self.title];
    _checkBoxButton.selected = self.isSelected;
    
    CGFloat titlePadding = 5;
    _checkBoxButton.titleEdgeInsets = (SCIEdgeInsets){.left = titlePadding, .top = 0, .right = 0, .bottom = 0};
    _checkBoxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeading;
    [_checkBoxButton addTarget:self action:@selector(onButtonSelect:)];
    [_checkBoxButton sizeToFit];
    [NSLayoutConstraint activateConstraints:@[
        [_checkBoxButton.widthAnchor constraintEqualToConstant:_checkBoxButton.frame.size.width + titlePadding * 8],
    ]];
    
    return _checkBoxButton;
#endif
}

- (void)onButtonSelect:(SCIButton *)sender {
    _checkBoxButton.selected = YES;
    self.action(_checkBoxButton.selected);
}

@end
