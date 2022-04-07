//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCD_ECGView.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDVitalSignsComponentView.h"
#import <SciChart/SCIImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCD_ECGView : SCDVitalSignsComponentView

@property (nonatomic) SCIImageView *heartImageView;
@property (nonatomic) SCILabel *bpmValueLabel;

@end

NS_ASSUME_NONNULL_END
