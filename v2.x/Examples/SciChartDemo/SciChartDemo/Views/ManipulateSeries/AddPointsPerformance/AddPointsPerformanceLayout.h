//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddPointsPerformanceLayout.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface AddPointsPerformanceLayout : ExampleViewBase

@property (nonatomic, copy) SCIActionBlock append10K;
@property (nonatomic, copy) SCIActionBlock append100K;
@property (nonatomic, copy) SCIActionBlock append1Mln;
@property (nonatomic, copy) SCIActionBlock clear;

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@end
