//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDVitalSignsMonitorLayout.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ExampleViewBase.h"
#import "SCDStepProgressBar.h"

@interface SCDVitalSignsMonitorLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface *surface;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UILabel *bpmValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *bpValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *bvValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *spoClockValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *spoValueLabel;

@property (weak, nonatomic) IBOutlet SCDStepProgressBar *bpBar;
@property (weak, nonatomic) IBOutlet SCDStepProgressBar *svBar1;
@property (weak, nonatomic) IBOutlet SCDStepProgressBar *svBar2;

@end
