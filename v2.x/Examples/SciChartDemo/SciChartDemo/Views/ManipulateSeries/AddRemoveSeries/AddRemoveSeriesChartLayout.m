//
//  AddRemoveSeriesChartLayout.m
//  SciChartDemo
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 ABT. All rights reserved.
//

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
    return [AddRemoveSeriesChartLayout class];
}

@end
