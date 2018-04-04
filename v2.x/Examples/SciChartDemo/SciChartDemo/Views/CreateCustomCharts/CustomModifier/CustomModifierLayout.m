//
//  CustomPanel.m
//  SciChartDemo
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 ABT. All rights reserved.
//

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
