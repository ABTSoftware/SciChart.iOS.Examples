//
//  OnboardingViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnboardingPageViewController.h"

@interface OnboardingViewController: UIViewController<UIPageViewControllerDataSource>

@property UIPageViewController * pageViewController;

@end

