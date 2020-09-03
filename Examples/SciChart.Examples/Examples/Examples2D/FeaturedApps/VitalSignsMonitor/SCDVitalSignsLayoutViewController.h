//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDVitalSignsLayoutViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleBaseViewController.h"
#import "SCD_ECGView.h"
#import "SCD_NIBPView.h"
#import "SCD_SVView.h"
#import "SCD_SPO2View.h"
#import "SCDStepProgressBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDVitalSignsLayoutViewController<TSurface: SCIView<ISCIChartSurfaceBase> *> : SCDExampleBaseViewController

@property (nonatomic, readonly) TSurface surface;

@property (nonatomic, readonly) Class associatedType;

@property (nonatomic, readonly) SCIImageView *heartImageView;
@property (nonatomic, readonly) SCILabel *bpmValueLabel;

@property (nonatomic, readonly) SCDStepProgressBar *bpBar;
@property (nonatomic, readonly) SCILabel *bpValueLabel;

@property (nonatomic, readonly) SCILabel *bvValueLabel;
@property (nonatomic, readonly) SCDStepProgressBar *svBar1;
@property (nonatomic, readonly) SCDStepProgressBar *svBar2;

@property (nonatomic, readonly) SCILabel *spoClockValueLabel;
@property (nonatomic, readonly) SCILabel *spoValueLabel;

@end

NS_ASSUME_NONNULL_END
