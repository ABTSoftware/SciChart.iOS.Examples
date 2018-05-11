//
//  MultiPaneStockChartLayout.h
//  SciChartDemo
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "ExampleViewBase.h"

@interface MultiPaneStockChartLayout : ExampleViewBase

@property (weak, nonatomic) IBOutlet SCIChartSurface * priceSurface;
@property (weak, nonatomic) IBOutlet SCIChartSurface * macdSurface;
@property (weak, nonatomic) IBOutlet SCIChartSurface * rsiSurface;
@property (weak, nonatomic) IBOutlet SCIChartSurface * volumeSurface;

@end
