//
//  HeatmapChartView.h
//  SciChartDemo
//
//  Created by admin on 3/15/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface HeatmapChartLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface * surface;
@property (weak, nonatomic) IBOutlet SCIChartHeatmapColourMap * heatmapColourMap;

@end
