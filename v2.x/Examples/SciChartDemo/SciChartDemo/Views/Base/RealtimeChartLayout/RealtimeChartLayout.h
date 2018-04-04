//
//  RealtimeChartLayout.h
//  SciChartDemo
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface RealtimeChartLayout : ExampleViewBase

@property (nonatomic, copy) SCIActionBlock playCallback;
@property (nonatomic, copy) SCIActionBlock pauseCallback;
@property (nonatomic, copy) SCIActionBlock stopCallback;

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;

@end
