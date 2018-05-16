//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FifoScrollingPanel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "FifoScrollingPanel.h"

@implementation FifoScrollingPanel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
