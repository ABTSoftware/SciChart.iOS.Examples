//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCIStackView.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <TargetConditionals.h>

// -------------------- Imports ----------------------
#if TARGET_OS_OSX
    #import <AppKit/NSStackView.h>
    #import "NSStackView+UIStackView.h"
#elif TARGET_OS_IOS
    #import <UIKit/UIStackView.h>
#endif

// -------------------- SCIStackView ----------------------
#if TARGET_OS_OSX
    #define SCIStackView NSStackView
    #define SCILayoutConstraintAxis NSUserInterfaceLayoutOrientation
    #define SCILayoutConstraintAxisVertical NSUserInterfaceLayoutOrientationVertical
    #define SCILayoutConstraintAxisHorizontal NSUserInterfaceLayoutOrientationHorizontal
    #define SCIStackViewDistributionFillEqually NSStackViewDistributionFillEqually
#elif TARGET_OS_IOS
    #define SCIStackView UIStackView
    #define SCILayoutConstraintAxis UILayoutConstraintAxis
    #define SCILayoutConstraintAxisVertical UILayoutConstraintAxisVertical
    #define SCILayoutConstraintAxisHorizontal UILayoutConstraintAxisHorizontal
    #define SCIStackViewDistributionFillEqually UIStackViewDistributionFillEqually
#endif
