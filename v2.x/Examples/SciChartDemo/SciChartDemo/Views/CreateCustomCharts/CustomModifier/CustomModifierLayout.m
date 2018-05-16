//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomModifierLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomModifierLayout.h"

@implementation CustomModifierLayout

- (IBAction)prevButtonClick:(id)sender {
    if (_onPrevClicked) _onPrevClicked();
}

- (IBAction)nextButtonClick:(id)sender {
    if (_onNextClicked) _onNextClicked();
}

- (IBAction)clearButtonClick:(id)sender {
    if (_onClearClicked) _onClearClicked();
}

- (Class)exampleViewType {
    return [CustomModifierLayout class];
}

@end
