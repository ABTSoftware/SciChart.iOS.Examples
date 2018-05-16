//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeTickingStockChartLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealtimeTickingStockChartLayout.h"

@implementation RealtimeTickingStockChartLayout

- (IBAction)selsectSeriesType:(id)sender {
    if(_seriesTypeTouched) {
        _seriesTypeTouched();
    }
}

- (IBAction)pauseTicking:(id)sender {
    if(_pauseTickingTouched) {
        _pauseTickingTouched();
    }
}

- (IBAction)continueTicking:(id)sender {
    if (_continueTickingTouched) {
        _continueTickingTouched();
    }
}

- (Class)exampleViewType {
    return [RealtimeTickingStockChartLayout class];
}

@end
