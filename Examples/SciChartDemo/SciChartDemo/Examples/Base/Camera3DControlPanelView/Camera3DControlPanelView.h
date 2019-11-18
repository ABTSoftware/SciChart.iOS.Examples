//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Camera3DControlPanelView.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Camera3DControlPanelView : UIView

@property (weak, nonatomic) IBOutlet UISegmentedControl *projectionModeSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *coordinateSystemModeSegmentControl;

@property (weak, nonatomic) IBOutlet UILabel *postionLabel;
@property (weak, nonatomic) IBOutlet UISlider *pitchSlider;
@property (weak, nonatomic) IBOutlet UISlider *yawSlider;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UISlider *fovSlider;
@property (weak, nonatomic) IBOutlet UISlider *orthoWidthSlider;
@property (weak, nonatomic) IBOutlet UISlider *orthoHeightSlider;

- (void)updateUI;

@end

NS_ASSUME_NONNULL_END
