//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ExampleViewBase.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCIViewController.h"
#import <SciChart/SciChart.h>
#import <SciChart.Examples/ISCDToolbarItem.h>
#import "ISCDToolbarItem.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Defines a base class for example ViewControllers in SciChart Examples
 */
@interface SCDExampleBaseViewController : SCIViewController

/**
 * Provides the default style for axis tick labels.
 */
@property (class, nonatomic) SCIChartTheme chartTheme;

/**
 * Used to initialize common view things. Called right before `loadView`
 */
- (void)commonInit;

/**
 * Used to initialize SciChart related stuff.
 */
- (void)initExample;

/**
 * Defines if add modifiers to the example toolbar. Default is YES.
 */
@property (nonatomic, readonly) BOOL showDefaultModifiersInToolbar;

- (NSArray<id<ISCDToolbarItem>> *)generateToolbarItems;

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems;

- (void)tryUpdateChartTheme:(SCIChartTheme)theme;

/**
 * Creates default modifiers for 2D chart such as:
 * - SCIPinchZoomModifier
 * - SCIZoomPanModifier
 * - SCIZoomExtentsModifier
 */
+ (SCIModifierGroup *)createDefaultModifiers;

/**
 * Creates default modifiers for 2D chart such as:
 * - SCIPinchZoomModifier3D
 * - SCIOrbitModifier3D
 * - SCIFreeLookModifier3D in 2-finger mode
 * - SCIZoomExtentsModifier3D
 */
+ (SCIModifierGroup3D *)createDefaultModifiers3D;

@end

NS_ASSUME_NONNULL_END
