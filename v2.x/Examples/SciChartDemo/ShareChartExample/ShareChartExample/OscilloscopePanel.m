//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OscilloscopePanel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
