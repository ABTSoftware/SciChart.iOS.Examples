//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TouchCallback)(id sender);

/**
 * Defines a base class for example views in SciChartDemo.
 */
@interface ExampleViewBase : UIView

@property (nonatomic,copy) TouchCallback needsHideSideBarMenu;

@property (nonatomic, readonly) Class exampleViewType;

/**
 * Used to initialize common view things.
 */
- (void)commonInit;

/**
 * Used to initialize SciChart related stuff.
 */
- (void)initExample;

@end
