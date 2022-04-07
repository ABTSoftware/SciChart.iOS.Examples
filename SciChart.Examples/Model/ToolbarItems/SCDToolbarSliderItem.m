//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarSliderItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarSliderItem.h"
#import "SCISlider.h"

@interface SCDToolbarSliderItem ()

@property (nonatomic, copy) void (^action)(double sliderValue);

@end

@implementation SCDToolbarSliderItem {
    double _sliderValue;
    double _maxValue;
}

- (instancetype)initWithSliderValue:(double)sliderValue maxValue:(double)maxValue andAction:(void (^)(double))action {
    self = [super init];
    if (self) {
        _sliderValue = sliderValue;
        _maxValue = maxValue;
        self.action = action;
    }
    return self;
}

- (SCIView *)createView {
    SCISlider *slider = [SCISlider new];
    slider.minValue = 0;
    slider.maxValue = _maxValue;
    slider.doubleValue = _sliderValue;
    slider.continuous = YES;    
    [slider addTarget:self valueChangeAction:@selector(p_SCD_onValueChange:)];

    return slider;
}

- (void)p_SCD_onValueChange:(SCISlider *)slider {
    self.action(slider.doubleValue);
}

@end
