//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToggleButtonsGroup.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToggleButtonsGroup.h"

@implementation SCDToggleButtonsGroup {
    NSArray<SCIButton *> *_buttons;
}

- (instancetype)initWithSelectableItems:(NSArray<SCDSelectableItem *> *)items {
    self = [super initWithItems:items];
    if (self) {
        self.stackView.axis = SCILayoutConstraintAxisVertical;
        _buttons = self.stackView.arrangedSubviews;
    }
    return self;
}

- (void)buttonSelectedWithIndex:(NSUInteger)index {
    for (NSUInteger i = 0; i < _buttons.count; i++) {
        _buttons[i].selected = i == index;
    }
}

@end
