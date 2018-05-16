//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddRemoveSeriesPanel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AddRemoveSeriesPanel.h"

@implementation AddRemoveSeriesPanel

- (IBAction)addSeriesPressed:(UIButton *)sender {
    if (_onAddClicked) {
        _onAddClicked();
    }
}

- (IBAction)removeSeriesPressed:(UIButton *)sender {
    if (_onRemoveClicked) {
        _onRemoveClicked();
    }
}

- (IBAction)clearPressed:(UIButton *)sender {
    if (_onClearClicked) {
        _onClearClicked();
    }
}

@end
