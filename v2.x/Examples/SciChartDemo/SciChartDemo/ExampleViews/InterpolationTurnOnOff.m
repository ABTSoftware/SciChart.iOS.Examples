//
//  InterpolationTurnOnOff.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "InterpolationTurnOnOff.h"

@implementation InterpolationTurnOnOff

- (IBAction)useInterpolationChanged:(UISwitch *)sender {
    if (_onUseInterpolationClicked) {
        _onUseInterpolationClicked(sender.isOn);
    }
}

@end
