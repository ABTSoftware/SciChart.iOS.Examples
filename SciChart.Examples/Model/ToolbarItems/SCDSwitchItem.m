//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSwitchItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSwitchItem.h"
#import <SciChart/SCILabel.h>
#import <SciChart/SCIColor.h>
#import "SCIStackView.h"

#if TARGET_OS_IOS
#import <UIKit/UISwitch.h>
#endif

@implementation SCDSwitchItem

@synthesize title = _title;
@synthesize isSelected = _isSelected;

- (instancetype)initWithTitle:(NSString *)title isSelected:(BOOL)isSelected andAction:(SCDSwitchItemAction)action {
    self = [super init];
    if (self) {
        _title = title;
        _isSelected = isSelected;
        _action = action;
    }
    return self;
}

- (SCIView *)createView {
#if TARGET_OS_OSX
    SCIButton *button = [[SCIButton alloc] initWithTitle:_title target:self selector:@selector(onButtonSelect:)];
    [button setButtonType:NSButtonTypeSwitch];
    button.state = _isSelected ? NSControlStateValueOn : NSControlStateValueOff;
    
    return button;
#elif TARGET_OS_IOS
    SCILabel *label = [SCILabel new];
    label.textColor = SCIColor.whiteColor;
    label.text = _title;
    
    UISwitch *switchView = [UISwitch new];
    switchView.on = _isSelected;
    [switchView addTarget:self action:@selector(p_SCD_onToggleSwitch:) forControlEvents:UIControlEventValueChanged];
    
    SCIStackView *stackView = [SCIStackView new];
    [stackView addArrangedSubview:label];
    [stackView addArrangedSubview:switchView];
    stackView.axis = SCILayoutConstraintAxisHorizontal;
    
    return stackView;
#endif
}

#if TARGET_OS_OSX
- (void)onButtonSelect:(SCIButton *)sender {
    self.action(sender.state == NSControlStateValueOn);
}
#elif TARGET_OS_IOS
- (void)p_SCD_onToggleSwitch:(UISwitch *)sender {
    self.action(sender.isOn);
}
#endif

@end
