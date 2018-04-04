//
//  AddPointsPerformanceLayout.m
//  SciChartDemo
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 ABT. All rights reserved.
//

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
