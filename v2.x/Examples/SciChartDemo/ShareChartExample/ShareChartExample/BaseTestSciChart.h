//
//  BaseTestSciChart.h
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 5/3/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeedTest.h"
#import "TestCase.h"

@interface BaseTestSciChart : UIView <SpeedTest>

@property (nonatomic) TestCase *testCase;

@end
