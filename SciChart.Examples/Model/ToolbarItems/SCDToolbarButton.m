//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarButton.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarButton.h"
#import <SciChart/SCIButton.h>
#import <SciChart/SCIColor.h>

#if TARGET_OS_IOS
#import <UIKit/NSLayoutAnchor.h>
#endif

@implementation SCDToolbarButton {
    BOOL _isSelected;
}

- (instancetype)initWithTitle:(NSString *)title image:(SCIImage *)image isSelected:(BOOL)isSelected andAction:(SCIAction)action {
    self = [super initWithTitle:title image:image andAction:action];
    if (self) {
        _isSelected = isSelected;
    }
    return self;
}

- (SCIView *)createView {
    SCIButton *button = self.image != nil
        ? [[SCIButton alloc] initWithImage:self.image action:self.action]
        : [[SCIButton alloc] initWithTitle:self.title action:self.action];
    
#if TARGET_OS_OSX
    if (button.image) {
        button.imagePosition = NSImageOnly;
    }
    button.bezelStyle = NSBezelStyleTexturedRounded;
    [button setButtonType:NSButtonTypeOnOff];
    button.state = _isSelected ? NSControlStateValueOn : NSControlStateValueOff;
#elif TARGET_OS_IOS
    [button setTintColor:SCIColor.whiteColor];
    
    [NSLayoutConstraint activateConstraints:@[
        [button.widthAnchor constraintEqualToConstant:50],
        [button.heightAnchor constraintEqualToConstant:50],
    ]];
#endif
    
    return button;
}

@end
