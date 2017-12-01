//
//  LineChartViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCIChartSurface;

@interface ChartView : UIView

@property (nonatomic, strong) SCIChartSurface * sciChartSurface;

@end
