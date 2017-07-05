//
//  LinePerformanceControlPanelView.m
//  SciChartDemo
//
//  Created by Admin on 28.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "LinePerformanceControlPanelView.h"

@implementation LinePerformanceControlPanelView

- (IBAction)clearClicked:(id)sender {
    if (_onClearClicked) _onClearClicked();
}

- (IBAction)add100KClicked:(id)sender {
    if (_onAdd100KClicked) _onAdd100KClicked();
}

- (IBAction)add1KKClicked:(id)sender {
    if (_onAdd1KKClicked) _onAdd1KKClicked();
}

@end
