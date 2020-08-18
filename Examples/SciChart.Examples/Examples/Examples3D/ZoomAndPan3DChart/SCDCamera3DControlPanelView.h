//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDCamera3DControlPanelView.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleBaseViewController.h"
#import "SCISegmentedControl.h"
#import "SCISlider.h"

@interface SCDCamera3DControlPanelView : SCIView

@property (nonatomic) SCISegmentedControl *projectionModeSegmentControl;
@property (nonatomic) SCISegmentedControl *coordinateSystemModeSegmentControl;

@property (nonatomic) SCILabel *postionLabel;
@property (nonatomic) SCISlider *pitchSlider;
@property (nonatomic) SCISlider *yawSlider;
@property (nonatomic) SCISlider *radiusSlider;
@property (nonatomic) SCISlider *fovSlider;
@property (nonatomic) SCISlider *orthoWidthSlider;
@property (nonatomic) SCISlider *orthoHeightSlider;

- (void)updateUI;

@end
