//
//  AddPointsPerformanceLayout.h
//  SciChartDemo
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface AddPointsPerformanceLayout : ExampleViewBase

@property (nonatomic, copy) SCIActionBlock append10K;
@property (nonatomic, copy) SCIActionBlock append100K;
@property (nonatomic, copy) SCIActionBlock append1Mln;
@property (nonatomic, copy) SCIActionBlock clear;

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@end
