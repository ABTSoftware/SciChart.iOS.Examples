//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeTickingStocksControlPanelView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealTimeTickingStocksControlPanelView.h"

@implementation RealTimeTickingStocksControlPanelView


- (IBAction)selsectSeriesType:(id)sender {
    if(_seriesTypeTouched){
        _seriesTypeTouched(sender);
    }
}

- (IBAction)pauseTicking:(id)sender {
    if(_pauseTickingTouched){
        _pauseTickingTouched(nil);
    }
}

- (IBAction)continueTicking:(id)sender {
    if(_continueTickingTouched){
        _continueTickingTouched(nil);
    }
}
@end
