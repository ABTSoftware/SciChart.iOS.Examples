//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RenderSurfaceSandboxLayout.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleBaseViewController.h"

@interface RenderSurfaceSandboxLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet UISlider *xSlider;
@property (weak, nonatomic) IBOutlet UISlider *ySlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

@property (weak, nonatomic) IBOutlet UIView *renderSurfacePlaceholder;

@property (nonatomic) SCIAction1 sliderValueChanged;
@property (nonatomic) SCIAction1 renderSurfaceChanged;

@end
