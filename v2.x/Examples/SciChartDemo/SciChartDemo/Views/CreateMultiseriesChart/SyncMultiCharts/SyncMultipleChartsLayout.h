//
//  SyncMultipleChartsLayout.h
//  SciChartDemo
//
//  Created by admin on 3/26/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface SyncMultipleChartsLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface1;
@property (weak, nonatomic) IBOutlet SCIChartSurface * surface2;

@end
