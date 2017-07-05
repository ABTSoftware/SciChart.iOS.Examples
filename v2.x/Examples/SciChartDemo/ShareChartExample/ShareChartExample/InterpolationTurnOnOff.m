//
//  InterpolationTurnOnOff.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "InterpolationTurnOnOff.h"

@implementation InterpolationTurnOnOff

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)useInterpolationChanged:(id)sender {
    if (_onUseInterpolationClicked) _onUseInterpolationClicked();
}

@end
