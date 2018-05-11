//
//  RealtimeTickingStockChartLayout.h
//  SciChartDemo
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface RealtimeTickingStockChartLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface * mainSurface;
@property (weak, nonatomic) IBOutlet SCIChartSurface * overviewSurface;

@property (nonatomic, copy) SCIActionBlock seriesTypeTouched;
@property (nonatomic, copy) SCIActionBlock pauseTickingTouched;
@property (nonatomic, copy) SCIActionBlock continueTickingTouched;

@end
