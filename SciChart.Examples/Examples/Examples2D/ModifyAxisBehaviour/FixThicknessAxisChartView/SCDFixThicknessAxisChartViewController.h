//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2024. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDFixThicknessAxisChartViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleBaseViewController.h"
#import "SCDSingleChartViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDFixThicknessAxisChartViewController: SCDSingleChartViewController<SCIChartSurface *>

@property (nonatomic, readonly) SCILabel *lblInfo;

@property (nonatomic) SCIAlignment xTopAxisTickLabelAlignment;
@property (nonatomic) SCIAlignment xBottomAxisTickLabelAlignment;
@property (nonatomic) SCIAlignment yRightAxisTickLabelAlignment;
@property (nonatomic) SCIAlignment yLeftAxisTickLabelAlignment;

@property (nonatomic) SCINumericAxis *xTopAxis;
@property (nonatomic) SCINumericAxis *xBottomAxis;
@property (nonatomic) SCINumericAxis *yRightAxis;
@property (nonatomic) SCINumericAxis *yLeftAxis;

@property (nonatomic) BOOL isShowXTopAxisTitle;
@property (nonatomic) BOOL isShowXBottomAxisTitle;
@property (nonatomic) BOOL isShowYRightAxisTitle;
@property (nonatomic) BOOL isShowYLeftAxisTitle;

@property (nonatomic) NSString *xTopAxisTitle;
@property (nonatomic) NSString *xBottomAxisTitle;
@property (nonatomic) NSString *yRightAxisTitle;
@property (nonatomic) NSString *yLeftAxisTitle;

@end

NS_ASSUME_NONNULL_END
