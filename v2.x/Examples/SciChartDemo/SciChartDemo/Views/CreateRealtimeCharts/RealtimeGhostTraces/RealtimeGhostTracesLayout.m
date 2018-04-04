//
//  RealtimeGhostTracesLayout.m
//  SciChartDemo
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import "RealtimeGhostTracesLayout.h"

@implementation RealtimeGhostTracesLayout
- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (_speedChanged) {
        _speedChanged(sender);
    }
    self.millisecondsLabel.text = [NSString stringWithFormat:@"%.0f ms", sender.value];
}

- (Class)exampleViewType {
    return [RealtimeGhostTracesLayout class];
}

@end
