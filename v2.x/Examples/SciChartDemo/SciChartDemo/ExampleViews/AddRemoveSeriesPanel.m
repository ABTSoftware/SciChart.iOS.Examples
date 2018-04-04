//
//  AddRemoveSeriesPanel.m
//  SciChartDemo
//
//  Created by Admin on 25/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

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
