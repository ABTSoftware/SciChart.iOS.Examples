//
//  FifoScrollingPanel.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "FifoScrollingPanel.h"

@implementation FifoScrollingPanel

- (IBAction)playPressed:(UIButton *)sender {
    if (_playCallback) {
        _playCallback();
    }
}

- (IBAction)pausePressed:(UIButton *)sender {
    if (_pauseCallback) {
        _pauseCallback();
    }
}

- (IBAction)stopPressed:(UIButton *)sender {
    if (_stopCallback) {
        _stopCallback();
    }
}
@end
