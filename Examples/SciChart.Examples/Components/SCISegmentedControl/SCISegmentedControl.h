//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCISegmentedControl.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

// -------------------- Imports ----------------------
#if TARGET_OS_OSX
    #import <AppKit/NSSegmentedControl.h>
    #import "NSSegmentedControl+UISegmentedControl.h"
#elif TARGET_OS_IOS
    #import <UIKit/UISegmentedControl.h>
    #import "UISegmentedControl+NSSegmentedControl.h"
#endif

// -------------------- SCISegmentedControl ----------------------
#if TARGET_OS_OSX
    #define SCISegmentedControl NSSegmentedControl
#elif TARGET_OS_IOS
    #define SCISegmentedControl UISegmentedControl
#endif

// -------------------- Constants --------------------
#if TARGET_OS_OSX
    #define SCISegmentSwitchTrackingSelectOne NSSegmentSwitchTrackingSelectOne
#elif TARGET_OS_IOS
    #define SCISegmentSwitchTrackingSelectOne 0
#endif
