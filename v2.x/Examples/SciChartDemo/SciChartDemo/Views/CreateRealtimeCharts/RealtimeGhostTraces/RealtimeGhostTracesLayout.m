//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeGhostTracesLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
