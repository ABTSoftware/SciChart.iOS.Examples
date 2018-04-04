//
//  AddRemoveSeriesChartLayout.h
//  SciChartDemo
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import "ExampleViewBase.h"
#import <SciChart/SciChart.h>

@interface AddRemoveSeriesChartLayout : ExampleViewBase

@property (nonatomic, copy) SCIActionBlock addSeries;
@property (nonatomic, copy) SCIActionBlock removeSeries;
@property (nonatomic, copy) SCIActionBlock clearSeries;

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@end
