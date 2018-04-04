//
//  RealtimeChartLayout.m
//  SciChartDemo
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import "RealtimeChartLayout.h"

@implementation RealtimeChartLayout

- (IBAction)playPressed:(id)sender {
    if (_playCallback) {
        _playCallback();
    }
}

- (IBAction)pausePressed:(id)sender {
    if (_pauseCallback) {
        _pauseCallback();
    }
}

- (IBAction)stopPressed:(id)sender {
    if (_stopCallback) {
        _stopCallback();
    }
}

- (Class)exampleViewType {
    return [RealtimeChartLayout class];
}

@end
