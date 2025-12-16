//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DrawingModifier.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>
#import "SCDCustomModifierViewController.h"

@interface DrawingModifier : SCIGestureModifierBase

@property (nonatomic) DrawMode drawMode;
@property (weak, nonatomic) SCIChartSurface *surface;
@property (nonatomic, strong) SCIOhlcDataSeries *ohlcDataSeries;

- (instancetype)initWithSurface:(SCIChartSurface *)surface
                       drawMode:(DrawMode)drawMode
                 ohlcDataSeries:(SCIOhlcDataSeries *)ohlcDataSeries;

#if TARGET_OS_IOS
- (void)exitDeleteMode;
#else
/// Prevent drawing while editing annotations
@property (nonatomic) BOOL isEditMode;
#endif

@end
