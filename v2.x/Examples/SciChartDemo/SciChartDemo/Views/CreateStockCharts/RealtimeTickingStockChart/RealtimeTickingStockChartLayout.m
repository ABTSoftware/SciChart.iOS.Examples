//
//  RealtimeTickingStockChartLayout.m
//  SciChartDemo
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 ABT. All rights reserved.
//

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
