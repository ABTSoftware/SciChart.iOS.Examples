//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddRemoveSeriesChartLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AddRemoveSeriesChartLayout.h"

@implementation AddRemoveSeriesChartLayout

- (IBAction)addSeriesPressed {
    if (_addSeries) {
        _addSeries();
    }
}

- (IBAction)removeSeriesPressed {
    if (_removeSeries) {
        _removeSeries();
    }
}

- (IBAction)clearPressed {
    if (_clearSeries) {
        _clearSeries();
    }
}

- (Class)exampleViewType {
    return AddRemoveSeriesChartLayout.class;
}

@end
