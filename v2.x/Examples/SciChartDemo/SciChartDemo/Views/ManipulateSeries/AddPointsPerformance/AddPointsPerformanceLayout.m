//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddPointsPerformanceLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AddPointsPerformanceLayout.h"

@implementation AddPointsPerformanceLayout

- (IBAction)append10kPressed {
    if (_append10K) {
        _append10K();
    }
}

- (IBAction)append100KPressed {
    if (_append100K) {
        _append100K();
    }
}

- (IBAction)append1MlnPressed {
    if (_append1Mln) {
        _append1Mln();
    }
}

- (IBAction)clearPressed {
    if (_clear) {
        _clear();
    }
}

- (Class)exampleViewType {
    return [AddPointsPerformanceLayout class];
}

@end
