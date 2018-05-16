//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeChartLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
