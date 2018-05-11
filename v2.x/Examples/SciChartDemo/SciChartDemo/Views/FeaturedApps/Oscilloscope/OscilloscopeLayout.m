//
//  OscilloscoppeChartLayout.m
//  SciChartDemo
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import "OscilloscopeLayout.h"

@implementation OscilloscopeLayout

- (IBAction)rotate:(UIButton *)sender {
    if(_rotateTouched){
        _rotateTouched();
    }
}

- (IBAction)flipHorizontally:(UIButton *)sender {
    if(_flippedHorizontallyTouched){
        _flippedHorizontallyTouched();
    }
}

- (IBAction)flipVertically:(UIButton *)sender {
    if(_flippedVerticallyTouched){
        _flippedVerticallyTouched();
    }
}

- (IBAction)changeSeries:(UIButton *)sender {
    if(_seriesTypeTouched){
        _seriesTypeTouched();
    }
}

- (Class)exampleViewType {
    return [OscilloscopeLayout class];
}

@end
