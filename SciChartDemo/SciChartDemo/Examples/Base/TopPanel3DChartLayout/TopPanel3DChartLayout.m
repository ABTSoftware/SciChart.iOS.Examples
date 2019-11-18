//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TopPanel3DChartLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "TopPanel3DChartLayout.h"

@interface TopPanel3DChartLayout()

@property (weak, nonatomic) IBOutlet UIView *panelContainer;

@end

@implementation TopPanel3DChartLayout

- (Class)exampleViewType {
    return TopPanel3DChartLayout.class;
}

- (void)setPanel:(UIView *)panel {
    if (panel == _panel) {
        return;
    }
    
    [_panel removeFromSuperview];
    
    _panel = panel;
    
    [self.panelContainer addSubview:panel];
    [self pinToContainer:panel];
}

- (void)pinToContainer:(UIView *)panel {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:panel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.panelContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:panel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.panelContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:panel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.panelContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:panel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.panelContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    
    [self.panelContainer addConstraints:@[top, left, bottom, right]];
    top.active = YES;
    left.active = YES;
    bottom.active = YES;
    right.active = YES;
}

@end
