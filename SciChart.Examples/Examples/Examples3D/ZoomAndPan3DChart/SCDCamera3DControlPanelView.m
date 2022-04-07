//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDCamera3DControlPanelView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDCamera3DControlPanelView.h"
#import "SCISegmentedControl.h"
#import "SCIStackView.h"

@implementation SCDCamera3DControlPanelView {
    SCISegmentedControl *_projectionModeSegmentControl;
    SCISegmentedControl *_coordinateSystemModeSegmentControl;
    
    SCILabel *_postionLabel;
    
    SCILabel *_pitchLabel;
    SCISlider *_pitchSlider;
    
    SCILabel *_yawLabel;
    SCISlider *_yawSlider;
    
    SCILabel *_radiusLabel;
    SCISlider *_radiusSlider;
    
    SCILabel *_fovLabel;
    SCISlider *_fovSlider;
    
    SCILabel *_orthoWidthLabel;
    SCISlider *_orthoWidthSlider;
    
    SCILabel *_orthoHeightLabel;
    SCISlider *_orthoHeightSlider;
    
    NSArray *_perspectiveViews;
    NSArray *_orthogonalViews;
}

@synthesize projectionModeSegmentControl = _projectionModeSegmentControl;
@synthesize coordinateSystemModeSegmentControl = _coordinateSystemModeSegmentControl;
@synthesize postionLabel = _postionLabel;
@synthesize pitchSlider = _pitchSlider;
@synthesize yawSlider = _yawSlider;
@synthesize radiusSlider = _radiusSlider;
@synthesize fovSlider = _fovSlider;
@synthesize orthoWidthSlider = _orthoWidthSlider;
@synthesize orthoHeightSlider = _orthoHeightSlider;

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self p_SCD_createViews];
    }
    return self;
}

- (void)updateUI {
    _radiusLabel.text = [NSString stringWithFormat:@"Radius: (%.1f)", _radiusSlider.doubleValue];
    _yawLabel.text = [NSString stringWithFormat:@"Yaw: (%.1f)", _yawSlider.doubleValue];
    _pitchLabel.text = [NSString stringWithFormat:@"Pitch: (%.1f)", _pitchSlider.doubleValue];
    _fovLabel.text = [NSString stringWithFormat:@"FOV: (%.1f)", _fovSlider.doubleValue];
    
    _orthoWidthLabel.text = [NSString stringWithFormat:@"Ortho Width: (%.1f)", _orthoWidthSlider.doubleValue];
    _orthoHeightLabel.text = [NSString stringWithFormat:@"Ortho Height: (%.1f)", self.orthoHeightSlider.doubleValue];

    for (SCIView *current in _orthogonalViews) {
        current.hidden = _projectionModeSegmentControl.selectedSegment == 0;
    }

    for (SCIView *current in _perspectiveViews) {
        current.hidden = _projectionModeSegmentControl.selectedSegment == 1;
    }
}

- (void)p_SCD_createViews {
    SCIStackView *mainStackView = [SCIStackView new];
    mainStackView.axis = SCILayoutConstraintAxisVertical;
    mainStackView.spacing = 10;
    mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:mainStackView];
    
    //SegmentedControls
    _coordinateSystemModeSegmentControl = [self p_SCD_createSegmentedControlWithItems:@[@"LHS", @"RHS"]];
    _coordinateSystemModeSegmentControl.selectedSegment = 0;
    _projectionModeSegmentControl = [self p_SCD_createSegmentedControlWithItems:@[@"Perspective", @"Orthogonal"]];
    _projectionModeSegmentControl.selectedSegment = 1;
    
    SCIStackView *segmentedControlsStackView = [SCIStackView new];
    segmentedControlsStackView.axis = SCILayoutConstraintAxisVertical;
    segmentedControlsStackView.spacing = 10;
    [segmentedControlsStackView addArrangedSubview:_coordinateSystemModeSegmentControl];
    [segmentedControlsStackView addArrangedSubview:_projectionModeSegmentControl];
    [mainStackView addArrangedSubview:segmentedControlsStackView];
#if TARGET_OS_OSX
    mainStackView.alignment = NSLayoutAttributeLeft;
    segmentedControlsStackView.alignment = NSLayoutAttributeLeft;
#endif
    
    //Position
    SCILabel *_positionTitleLabel = [self p_SCD_createLabelWithText:@"Position:"];
    _postionLabel = [self p_SCD_createLabelWithText:@"X:0 Y: 0 Z: 0"];
    NSLayoutConstraint *postionTextLabelHugging = [_positionTitleLabel.widthAnchor constraintLessThanOrEqualToConstant:_positionTitleLabel.intrinsicContentSize.width];
    [_positionTitleLabel contentHuggingPriorityForAxis:SCILayoutConstraintOrientationHorizontal];
    SCIStackView *positionStackView = [self p_SCD_createSubStackViewWithViews:@[_positionTitleLabel, _postionLabel]];
    [mainStackView addArrangedSubview:positionStackView];
    
    //Pitch
    _pitchLabel = [self p_SCD_createLabelWithText:@"Pitch:"];
    _pitchSlider = [self p_SCD_createSliderWithMaxValue:360];
    SCIStackView *pitchStackView = [self p_SCD_createSubStackViewWithViews:@[_pitchLabel, _pitchSlider]];
    [mainStackView addArrangedSubview:pitchStackView];
    
    //Yaw
    _yawLabel = [self p_SCD_createLabelWithText:@"Yaw:"];
    _yawSlider = [self p_SCD_createSliderWithMaxValue:360];
    SCIStackView *yawStackView = [self p_SCD_createSubStackViewWithViews:@[_yawLabel, _yawSlider]];
    [mainStackView addArrangedSubview:yawStackView];
    
    //Radius
    _radiusLabel = [self p_SCD_createLabelWithText:@"Radius:"];
    _radiusSlider = [self p_SCD_createSliderWithMaxValue:3000];
    SCIStackView *radiusStackView = [self p_SCD_createSubStackViewWithViews:@[_radiusLabel, _radiusSlider]];
    [mainStackView addArrangedSubview:radiusStackView];
    
    //FOV
    _fovLabel = [self p_SCD_createLabelWithText:@"FOV:"];
    _fovSlider = [self p_SCD_createSliderWithMaxValue:90];
    SCIStackView *fovStackView = [self p_SCD_createSubStackViewWithViews:@[_fovLabel, _fovSlider]];
    [mainStackView addArrangedSubview:fovStackView];
    
    //OrthoWidth
    _orthoWidthLabel = [self p_SCD_createLabelWithText:@"OrthoWidth:"];
    _orthoWidthSlider = [self p_SCD_createSliderWithMaxValue:1000];
    SCIStackView *orthoWidthStackView = [self p_SCD_createSubStackViewWithViews:@[_orthoWidthLabel, _orthoWidthSlider]];
    [mainStackView addArrangedSubview:orthoWidthStackView];
    
    //OrthoHeight
    _orthoHeightLabel = [self p_SCD_createLabelWithText:@"OrthoHeight:"];
    _orthoHeightSlider = [self p_SCD_createSliderWithMaxValue:3000];
    SCIStackView *orthoHeightStackView = [self p_SCD_createSubStackViewWithViews:@[_orthoHeightLabel, _orthoHeightSlider]];
    [mainStackView addArrangedSubview:orthoHeightStackView];
    
    _perspectiveViews = @[radiusStackView, fovStackView];
    _orthogonalViews = @[orthoWidthStackView, orthoHeightStackView];
    
    [self addConstraints:@[
        [mainStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:17],
        [mainStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-17],
        [mainStackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [mainStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
        postionTextLabelHugging
    ]];
}

- (SCILabel *)p_SCD_createLabelWithText:(NSString *)text {
    SCILabel *label = [SCILabel new];
    label.font = [SCIFont systemFontOfSize:17];
#if TARGET_OS_OSX
    label.textColor = SCIColor.labelColor;
#elif TARGET_OS_IOS
    label.textColor = SCIColor.whiteColor;
#endif
    label.text = text;
    
    return label;
}

- (SCIStackView *)p_SCD_createSubStackViewWithViews:(NSArray<SCIView *> *)views {
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisHorizontal;
    stackView.spacing = 2;
    for (SCIView *view in views) {
        [stackView addArrangedSubview:view];
    }
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return stackView;
}

- (SCISlider *)p_SCD_createSliderWithMaxValue:(double) maxValue {
    SCISlider *slider = [SCISlider new];
    slider.minValue = 0;
    slider.maxValue = maxValue;
    slider.continuous = YES;

    return slider;
}

- (SCISegmentedControl *)p_SCD_createSegmentedControlWithItems:(NSArray<NSString *> *)items {
    SCISegmentedControl *segmentedControl = [[SCISegmentedControl alloc] initWithItems:items];
#if TARGET_OS_IOS
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: SCIColor.whiteColor} forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) {
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: SCIColor.labelColor} forState:UIControlStateSelected];
    } else {
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: SCIColor.blackColor} forState:UIControlStateSelected];
    }
#endif
    return segmentedControl;
}

@end
