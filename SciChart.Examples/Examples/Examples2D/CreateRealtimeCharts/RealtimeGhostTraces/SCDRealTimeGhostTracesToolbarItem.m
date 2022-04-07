//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRealTimeGhostTracesItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDRealTimeGhostTracesToolbarItem.h"
#import <SciChart/SCILabel.h>
#import <SciChart/SCIFont.h>
#import <SciChart/SCIColor.h>
#import "SCISlider.h"

#if TARGET_OS_IOS
#import <UIKit/NSLayoutAnchor.h>
#endif


@interface SCDRealTimeGhostTracesToolbarItem ()

@property (nonatomic, copy) void (^action)(double doubleValue);

@end

@implementation SCDRealTimeGhostTracesToolbarItem {
    SCILabel *_speedTitleLabel;
    SCISlider *_slider;
    SCILabel *_millisecondsLabel;
}

- (instancetype)initWithAction:(void (^)(double doubleValue))action {
    self = [super init];
    if (self) {
        self.action = action;
    }
    return self;
}

- (double)sliderValue {
    return _slider.doubleValue;
}

- (SCIView *)createView {
    SCIView *superView = [SCIView new];
    
    _speedTitleLabel = [SCILabel new];
    _speedTitleLabel.text = @"Speed";
    
    _millisecondsLabel = [SCILabel new];
    _millisecondsLabel.text = @"75 ms";
    
    for (SCILabel *label in @[_speedTitleLabel, _millisecondsLabel]) {
        #if TARGET_OS_IOS
        label.font = [SCIFont systemFontOfSize:17];
        label.textColor = SCIColor.whiteColor;
        #endif
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [superView addSubview:label];
    }
    
    _slider = [SCISlider new];
    _slider.minValue = 1;
    _slider.maxValue = 100;
    _slider.doubleValue = 75;
    [_slider addTarget:self valueChangeAction:@selector(onSliderValueChange:)];
    
    _slider.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:_slider];

    [superView addConstraints: @[
        #if TARGET_OS_OSX
        [superView.widthAnchor constraintEqualToConstant:250],
        #endif
        
        [_speedTitleLabel.leadingAnchor constraintEqualToAnchor:superView.leadingAnchor constant:8],
        [_speedTitleLabel.trailingAnchor constraintEqualToAnchor:_slider.leadingAnchor constant:-8],
        [_speedTitleLabel.centerYAnchor constraintEqualToAnchor:_slider.centerYAnchor],
        
        [_slider.topAnchor constraintEqualToAnchor:superView.topAnchor constant:8],
        [_slider.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor constant:-8],
        [_slider.trailingAnchor constraintEqualToAnchor:_millisecondsLabel.leadingAnchor constant:-8],
        
        [_millisecondsLabel.trailingAnchor constraintEqualToAnchor:superView.trailingAnchor constant:-8],
        [_millisecondsLabel.centerYAnchor constraintEqualToAnchor:_slider.centerYAnchor],
    ]];

    return superView;
}

- (void)onSliderValueChange:(SCISlider *)sender {
    double doubleValue = sender.doubleValue;
    self.action(doubleValue);
    _millisecondsLabel.text = [NSString stringWithFormat:@"%.0f ms", doubleValue];
}

@end
