//
//  ExampleSettingsTabBarController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/24/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SciChart/SciChart.h>

@interface ExampleSettingsTabBarController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic, strong) SCIChartSurface *Surface;

@end
