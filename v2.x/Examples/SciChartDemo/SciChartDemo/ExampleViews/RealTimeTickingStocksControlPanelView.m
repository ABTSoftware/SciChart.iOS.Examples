//
//  RealTimeTickingStocksControlPanelView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/20/16.
//  Copyright © 2016 ABT. All rights reserved.
//

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
