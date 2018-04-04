//
//  OscilloscopePanel.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/18/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "OscilloscopePanel.h"

@implementation OscilloscopePanel

- (IBAction)rotate:(UIButton *)sender {
    if(_rotateTouched){
        _rotateTouched(sender);
    }
}

- (IBAction)flipHorizontally:(UIButton *)sender {
    if(_flippedHorizontallyTouched){
        _flippedHorizontallyTouched(sender);
    }
}

- (IBAction)flipVertically:(UIButton *)sender {
    if(_flippedVerticallyTouched){
        _flippedVerticallyTouched(sender);
    }
}

- (IBAction)changeSeries:(UIButton *)sender {
    if(_seriesTypeTouched){
        _seriesTypeTouched(sender);
    }
}

@end
