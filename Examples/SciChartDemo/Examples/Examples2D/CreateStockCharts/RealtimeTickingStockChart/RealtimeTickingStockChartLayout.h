//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeTickingStockChartLayout.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ExampleViewBase.h"

@interface RealtimeTickingStockChartLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface *mainSurface;
@property (weak, nonatomic) IBOutlet SCIChartSurface *overviewSurface;

@property (nonatomic, copy) SCIAction seriesTypeTouched;
@property (nonatomic, copy) SCIAction pauseTickingTouched;
@property (nonatomic, copy) SCIAction continueTickingTouched;

@end
